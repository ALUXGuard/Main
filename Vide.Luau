local version = { major = 0, minor = 4, patch = 0 }

local function GetFlags()
    local function inline_test(): string
        return debug.info(1, "n")
    end

    local is_O2 = inline_test() ~= "inline_test"

    return {
        strict = not is_O2,
        defaults = true,
        defer_nested_properties = true,
        batch = false,
    }
end

local function GetGraph()
    local flags = GetFlags()

    export type SourceNode<T> = {
        cache: T,
        [number]: Node<T>
    }

    export type Node<T> =  {
        cache: T,
        effect:  ((T) -> T) | false,
        cleanups: { () -> () } | false,

        context: { [number]: unknown } | false,

        owned: { Node<T> } | false,
        owner: Node<T> | false,

        parents: { SourceNode<T> },
        [number]: Node<T> -- children
    }

    local scopes = { n = 0 } :: { [number]: Node<any>, n: number } -- scopes stack

    local function efn(err: string)
        local trace = debug.traceback(err, 2)

        if string.find(err, "^effect error stacktrace") then -- if effect error is nested
            trace = string.gsub("    " .. trace, "\n", function() -- indent entire error
                return "\n    "
            end)
        end

        trace ..= "\nsource update stacktrace:"
    return trace
    end

    local function ycall<T, U>(fn: (T) -> U, arg: T): (boolean, string|U)

        local thread = coroutine.create(xpcall)
        --local function efn(err: string) return debug.traceback(err, 3) end
        local resume_ok, run_ok, result = coroutine.resume(thread, fn, efn, arg)

        assert(resume_ok)
            
        if coroutine.status(thread) ~= "dead" then
            return false, debug.traceback(thread, "attempt to yield in reactive scope")
        end

        return run_ok, result
    end

    local function get_scope(): Node<unknown>?
        return scopes[scopes.n]
    end

    local function assert_stable_scope(): Node<unknown>
        local scope = get_scope()

        if not scope then
            local caller_name = debug.info(2, "n")
            return error(`cannot use {caller_name}() outside a stable or reactive scope`, 0)
        elseif scope.effect then
            error("cannot create a new reactive scope inside another reactive scope", 0)
        end

        return scope
    end

    local function push_child<T>(parent: SourceNode<any>, child: Node<any>)
        table.insert(parent, child)
        table.insert(child.parents, parent)
    end

    local function push_scope<T>(node: Node<T>)
        local n = scopes.n + 1
        scopes.n = n
        scopes[n] = node
    end

    local function pop_scope()
        local n = scopes.n
        scopes.n = n - 1
        scopes[n] = nil
    end

    local function push_cleanup<T>(node: Node<T>, cleanup: () -> ())
        if node.cleanups then
            table.insert(node.cleanups, cleanup)
        else
            node.cleanups = { cleanup }
        end
    end

    local function flush_cleanups<T>(node: Node<T>)
        if node.cleanups then
            for _, fn in node.cleanups do
                local ok, err: string? = xpcall(fn, debug.traceback)
                if not ok then error(`cleanup error: {err}`, 0) end
            end

            table.clear(node.cleanups)
        end
    end

    local function find_and_swap_pop<T>(t: { T }, v: T)
        local i = table.find(t, v) :: number
        local n = #t
        t[i] = t[n]
        t[n] = nil
    end

    local function unparent<T>(node: Node<T>)
        local parents = node.parents

        for i, parent in parents do
            find_and_swap_pop(parent, node)
            parents[i] = nil
        end
    end

    local function destroy<T>(node: Node<T>)
        if flags.strict and table.find(scopes, node) then
            error("attempt to destroy an active scope", 0)
        end

        flush_cleanups(node)
        unparent(node)
        
        if node.owner then
            find_and_swap_pop(node.owner.owned :: { Node<T> }, node)
            node.owner = false
        end

        if node.owned then
            local owned = node.owned
            while owned[1] do destroy(owned[1]) end
        end
    end

    local function destroy_owned<T>(node: Node<T>)
        if node.owned then
            local owned = node.owned
            while owned[1] do destroy(owned[1]) end
        end
    end

    local update_queue = { n = 0 } :: { n: number, [number]: Node<any> }

    local function evaluate_node<T>(node: Node<T>)
        if flags.strict then
            if table.find(scopes, node) then
                error("a scope, that should rerun due to the update of a source, is already active", 0)
            end

            local initial_value = node.cache

            for i = 1, 2 do
                local cur_value = node.cache

                flush_cleanups(node)
                destroy_owned(node)
        
                push_scope(node)
                local ok, new_value = ycall(node.effect :: (T) -> T, cur_value)
                pop_scope()
                
                if not ok then
                    table.clear(update_queue)
                    update_queue.n = 0
                    error(`effect error stacktrace\n{new_value :: string}`, 0)
                end

                node.cache = new_value :: T
            end

            return initial_value ~= node.cache
        else
            local cur_value = node.cache

            flush_cleanups(node)
            destroy_owned(node)

            push_scope(node)
            local ok, new_value = pcall(node.effect :: (T) -> T, node.cache)
            pop_scope()

            if not ok then
                table.clear(update_queue)
                update_queue.n = 0
                error(`effect error:\n{new_value}\n`, 0)
            end
        
            node.cache = new_value
            return cur_value ~= new_value
        end
    end

    local function queue_children_for_update<T>(node: SourceNode<T>)
        local i = update_queue.n
        while node[1] do
            i += 1
            update_queue[i] = node[1]
            unparent(node[1])
        end
        update_queue.n = i
    end

    local function get_update_queue_length()
        return update_queue.n
    end

    local function flush_update_queue(from: number)
        local i = from + 1
        while i <= update_queue.n do
            local node = update_queue[i]
            --assert(node.effect)

            if node.owner and evaluate_node(node) then
                queue_children_for_update(node)
            end

            update_queue[i] = false :: any
            i += 1
        end
        
        update_queue.n = from
    end

    local function update_descendants<T>(root: SourceNode<T>)
        local n0 = update_queue.n
        queue_children_for_update(root)

        if flags.batch then return end

        local i = n0 + 1
        while i <= update_queue.n do
            local node = update_queue[i]
            --assert(node.effect)

            -- check if node is still owned in case destroyed after queued
            if node.owner and evaluate_node(node) then
                queue_children_for_update(node)
            end

            update_queue[i] = false :: any -- false instead of nil to avoid sparse
            i += 1
        end

        update_queue.n = n0
    end

    local function push_scope_as_child_of<T>(node: SourceNode<T>)
        local scope = get_scope()
        if scope and scope.effect then -- do not track nodes with no effect
            push_child(node, scope)
        end
    end

    local function create_node<T>(owner: false | Node<any>, effect: false | (T) -> T, value: T): Node<T>
        local node: Node<T> = {
            cache = value,
            effect = effect,
            cleanups = false,

            context = false,

            owner = owner,
            owned = false,

            parents = {},
        }

        if owner then
            if owner.owned then
                table.insert(owner.owned, node)
            else
                owner.owned = { node }
            end
        end

        return node
    end

    local function create_source_node<T>(value: T): SourceNode<T>
        return { cache = value }
    end

    local function get_children<T>(node: Node<T>): { Node<unknown> }
        return { unpack(node) } :: { Node<any> }
    end

    local function set_context<T>(node: Node<T>, key: number, value: unknown)
        if node.context then
            node.context[key] = value
        else
            node.context = { [key] = value }
        end
    end

    return table.freeze {
        push_scope = push_scope,
        pop_scope = pop_scope,
        evaluate_node = evaluate_node,
        get_scope = get_scope,
        assert_stable_scope = assert_stable_scope,
        push_cleanup = push_cleanup,
        destroy = destroy,
        flush_cleanups = flush_cleanups,
        push_scope_as_child_of = push_scope_as_child_of,
        update_descendants = update_descendants,
        push_child = push_child,
        create_node = create_node,
        create_source_node = create_source_node,
        get_children = get_children,
        flush_update_queue = flush_update_queue,
        get_update_queue_length = get_update_queue_length,
        set_context = set_context,
        scopes = scopes,

        q = update_queue
    }
end

local function GetAction()
    type Action = {
        priority: number,
        callback: (Instance) -> ()
    }

    local ActionMT = table.freeze {}

    local function is_action(v: any)
        return getmetatable(v) == ActionMT
    end

    local function action(callback: (Instance) -> (), priority: number?): Action
        local a = {
            priority = priority or 1,
            callback = callback
        }

        setmetatable(a :: any, ActionMT)

        return table.freeze(a)
    end

    return function()
        return action, is_action
    end
end

local function GetImplicitEffect()
    local graph = GetGraph()
    type Node<T> = graph.Node<T>
    local create_node = graph.create_node
    local assert_stable_scope = graph.assert_stable_scope
    local get_scope = graph.get_scope
    local evaluate_node = graph.evaluate_node
    local push_cleanup = graph.push_cleanup

    local function update_property_effect(p: {
        instance: Instance,
        property: string,
        source: () -> unknown  
    })
        (p.instance :: any)[p.property] = p.source()
        return p
    end

    local function update_parent_effect(p: {
        instance: Instance,
        source: () -> Instance
    })
        p.instance.Parent = p.source()
        return p
    end

    -- todo: investigate if "count" method used in indexes() and values() can improve performance here
    local function update_children_effect(p: {
        instance: Instance,
        cur_children_set: { [Instance]: true },
        new_children_set: { [Instance]: true },
        source: () -> Instance | { Instance }
    })
        local cur_children_set: { [Instance]: true } = p.cur_children_set -- cache of all children parented before update
        local new_children_set: { [Instance]: true } = p.new_children_set -- cache of all children parented after update

        local new_children = p.source() -- all (and only) children that should be parented after this update
        
        local function process_child(child: Instance | { Instance })
            if type(child) == "userdata" then
                if new_children_set[child] then return end -- stops redundant reparenting

                new_children_set[child] = true -- record child set from this update
                
                if not cur_children_set[child] then
                    child.Parent = p.instance -- if child wasn't already parented then parent it
                else 
                    cur_children_set[child] = nil -- remove child from cache if it was already in cache
                end  
            elseif type(child) == "table" then
                for _, child in child do
                    process_child(child)
                end
            elseif type(child) == "function" then
                local node = create_node(assert(get_scope()), update_children_effect, {
                    instance = p.instance,
                    cur_children_set = {},
                    new_children_set = {},
                    source = child   
                })
        
                evaluate_node(node)

                push_cleanup(assert(get_scope()), function()
                    for child in node.cache.cur_children_set do
                        child.Parent = nil
                    end
                end)
            end
        end

        process_child(new_children)

        for child in cur_children_set do
            child.Parent = nil -- unparent all children that weren't in the new children set
        end

        table.clear(cur_children_set) -- clear cache, preserve capacity
        p.cur_children_set, p.new_children_set = new_children_set, cur_children_set

        return p
    end

    return {
        property = function(instance, property, source)
            local node = create_node(assert_stable_scope(), update_property_effect, {
                instance = instance,
                property = property,
                source = source
            })

            evaluate_node(node)

            return node
        end,

        parent = function(instance, parent)
            local node = create_node(assert_stable_scope(), update_parent_effect, {
                instance = instance,
                source = parent
            })

            evaluate_node(node)
            
            return node
        end,

        children = function(instance, children)
            local node = create_node(assert_stable_scope(), update_children_effect, {
                instance = instance,
                cur_children_set = {},
                new_children_set = {},
                source = children
            })

            evaluate_node(node)

            push_cleanup(assert_stable_scope(), function()
                for child in node.cache.cur_children_set do
                    child.Parent = nil
                end
            end)

            return node
        end
    }
end

local function GetApply()
    local typeof = game and typeof

    local flags = GetFlags()
    local implicit_effect = GetImplicitEffect()
    local _, is_action = GetAction()()
    local graph = GetGraph()
    type Node<T> = graph.Node<T>

    type Array<V> = { V }
    type ArrayOrV<V> = {ArrayOrV<V>} | V
    type Map<K, V> = { [K]: V }

    type Cache = {
        -- event listeners to connect after properties are set
        events: Array<
            | string -- 1. event name
            | () -> () -- 2. listener
        >,

        -- actions to run after events are connected
        actions: Map<
            number, -- priority
            Array<(Instance) -> ()> -- action callbacks
        >,

        -- what to parent the instance to after running actions
        parent: unknown,

        -- cache to detect duplicate property setting at same nesting depth
        nested_debug: Map<
            number, -- depth
            Map<string, true> -- set of property names
        >,

        -- each nested layer occupies two indexes: 1. table ref 2. nested depth
        -- e.g. { t1 = { t3 = {} }, t2 = {} } -> { t1, 1, t2, 1, t3, 2 }
        nested_stack: { {} | number }
    }

    local free_cache: Cache?

    local function borrow_cache(): Cache
        if free_cache then
            local cache = free_cache
            free_cache = nil
            return cache
        else
            return {
                events = {},
                actions = setmetatable({} :: any, { -- lazy init
                    __index = function(self, i) self[i] = {}; return self[i] end
                }),
                parent = nil,
                nested_debug = setmetatable({} :: any, {
                    __index = function(self, i: number) self[i] = {}; return self[i] end
                }),
                nested_stack = {}
            }
        end
    end

    local function return_cache(cache: Cache )
        free_cache = cache
    end

    local function process_properties(properties: Map<unknown, unknown>, instance: Instance, cache: Cache, depth: number)
        for property, value in properties do
            if type(property) == "string" then
                if flags.strict then -- check for duplicate property assignment at nesting depth
                    if cache.nested_debug[depth][property] then
                        error(`duplicate property {property} at depth {depth}`, 0)
                    end
                    cache.nested_debug[depth][property] = true
                end

                if property == "Parent" then
                    cache.parent = value
                    continue
                end

                if type(value) == "function" then 
                    if typeof((instance :: any)[property]) == "RBXScriptSignal" then
                        table.insert(cache.events, property) -- add event name to buffer
                        table.insert(cache.events, value :: () -> ()) -- add event listener to buffer
                    else
                        implicit_effect.property(instance, property, value :: () -> ()) -- create implicit effect for property
                    end
                else
                    (instance :: any)[property] = value -- set property
                end    
            elseif type(property) == "number" then
                if type(value) == "function" then
                    implicit_effect.children(instance, value :: () -> ArrayOrV<Instance>) -- bind children
                elseif type(value) == "table" then
                    if is_action(value) then
                        table.insert(cache.actions[(value :: any).priority], (value :: any).callback :: () -> ()) -- add action to buffer
                    elseif flags.defer_nested_properties then
                        table.insert(cache.nested_stack, value :: {})
                        table.insert(cache.nested_stack, depth + 1) -- push table to stack for later processing
                    else
                        process_properties(value :: Map<unknown, unknown>, instance, cache, depth + 1)
                    end
                elseif type(value) == "userdata" then
                    (value :: Instance).Parent = instance -- parent child
                end
            end
        end
    end

    -- applies table of nested properties to an instance using full vide semantics
    local function apply<T>(instance: T & Instance, properties: { [unknown]: unknown }): T
        if not properties then
            error "attempt to call a constructor returned by create() with no properties"
        end

        local caches = borrow_cache()
        local events = caches.events
        local actions = caches.actions
        local nested_debug = caches.nested_debug
        local nested_stack = caches.nested_stack

        -- process all properties
        local depth = 1
        repeat
            process_properties(properties, instance, caches, depth)
            depth = table.remove(nested_stack) :: number
            properties = table.remove(nested_stack) :: {}
        until not properties

        for i = 1, #events, 2 do
            local event_name = events[i]
            local event_listener = events[i + 1]
            ;(instance :: any)[event_name]:Connect(event_listener)
        end

        for _, queued in actions do
            for _, callback in queued do
                callback(instance)
            end
        end

        local parent = caches.parent
        if parent then
            if type(parent) == "function" then
                implicit_effect.parent(instance, parent :: () -> Instance)
            else
                instance.Parent = parent :: Instance
            end
        end

        table.clear(events)
        for _, queued in actions do table.clear(queued) end
        caches.parent = nil
        if flags.strict then table.clear(nested_debug) end
        table.clear(nested_stack)

        return_cache(caches)

        return instance
    end

    return apply
end

local function GetRoot()
    local graph = GetGraph()
    type Node<T> = graph.Node<T>
    local create_node = graph.create_node
    local push_scope = graph.push_scope
    local pop_scope = graph.pop_scope
    local destroy = graph.destroy

    local refs = {}

    local function root<T...>(fn: (destroy: () -> ()) -> T...): (() -> (), T...)
        local node = create_node(false, false, false)

        refs[node] = true -- prevent gc of root node

        local destroy = function()
            if not refs[node] then error "root already destroyed" end
            refs[node] = nil
            destroy(node)
        end

        push_scope(node)

        local result = { xpcall(fn, debug.traceback, destroy) }

        pop_scope()

        if not result[1] then
            destroy()
            error(`error while running root():\n\n{result[2]}`, 0)
        end

        return destroy, unpack(result :: any, 2)
    end

    return root :: <T...>(fn: (destroy: () -> ()) -> T...) -> (() -> (), T...)
end

local function GetBranch()
    local graph = GetGraph()
    type Node<T> = graph.Node<T>
    local create_node = graph.create_node
    local push_scope = graph.push_scope
    local pop_scope = graph.pop_scope
    local destroy = graph.destroy
    local get_scope = graph.get_scope

    local function branch<T>(fn: () -> T): (() -> (), T)
        local current = get_scope()
        if not current then
            error(`cannot use branch() outside a stable or reactive scope`, 0)
        end

        local parent = current.owner
        if not parent or parent.effect then
            error(`current scope is not owned by a stable scope`, 0)
        end

        local node = create_node(parent, false, false)

        local destroy = function()
            destroy(node)
        end

        push_scope(node)

        local ok, result = xpcall(fn, debug.traceback)

        pop_scope()

        if not ok then
            destroy()
            error(`error while running branch():\n\n{result}`, 0)
        end

        return destroy, result
    end

    return branch
end

local function GetMount()
    local root = GetRoot()
    local apply = GetApply()

    local function mount<T>(component: () -> T, target: Instance?): () -> ()
        return root(function()
            local result = component()
            if target then apply(target, { result }) end
        end)
    end

    return mount :: (<T>(component: () -> T, target: Instance) -> () -> ()) & ((component: () -> ()) -> () -> ())
end

local function GetDefault()
    local Enum = game and Enum
    local Color3 = game and Color3

    return {
        Part = {
            Material = Enum.Material.SmoothPlastic,
            Size = vector.create(1, 1, 1),
            Anchored = true
        },

        BillboardGui = {
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        },

        CanvasGroup = nil,

        Frame = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0
        },

        ImageButton = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            AutoButtonColor = false
        },

        ImageLabel = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
        },

        ScreenGui = {
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        },

        ScrollingFrame = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            ScrollBarImageColor3 = Color3.new(0, 0, 0)
        },
        
        SurfaceGui = {
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

            PixelsPerStud = 50,
            SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        },
        
        TextBox = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            ClearTextOnFocus = false,
            Font = Enum.Font.SourceSans,
            Text = "",
            TextColor3 = Color3.new(0, 0, 0)
        },

        TextButton = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Font = Enum.Font.SourceSans,
            Text = "",
            TextColor3 = Color3.new(0, 0, 0)
        },
        
        TextLabel = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            Font = Enum.Font.SourceSans,
            Text = "",
            TextColor3 = Color3.new(0, 0, 0)
        },
        
        UIListLayout = {
            SortOrder = Enum.SortOrder.LayoutOrder
        },
    
        UIGridLayout = {
            SortOrder = Enum.SortOrder.LayoutOrder
        },

        UITableLayout = {
            SortOrder = Enum.SortOrder.LayoutOrder
        },

        UIPageLayout = {
            SortOrder = Enum.SortOrder.LayoutOrder
        },
        
        VideoFrame = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0
        },
        
        ViewportFrame = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0
        }
    }
end

local function GetCreate()
    local typeof = game and typeof
    local Instance = game and Instance or

    local defaults = GetDefault()
    local apply = GetApply()
    local flags = GetFlags()

    local ctor_cache = {} :: { [string]: (AnyProps) -> Instance }
    local function lazy_init(_, class: string)
        local function ctor(properties: AnyProps): Instance
            local ok, instance: Instance = pcall(Instance.new, class :: any)
            if not ok then error(`invalid class name { class }`, 0) end

            if flags.defaults then
                local default: { [string]: unknown }? = defaults[class]
                if default then
                    for i, v in default do
                        (instance :: any)[i] = v
                    end
                end
            end

            return apply(instance, properties)
        end

        ctor_cache[class] = ctor
        return ctor
    end
    setmetatable(ctor_cache, { __index = lazy_init })

    -- todo: remove support for different overloads
    local function create(class_or_instance: string|Instance, properties: AnyProps?): ((AnyProps) -> Instance) | Instance
        if type(class_or_instance) ~= "string" and typeof(class_or_instance) ~= "Instance" then
            error("bad argument #1, expected string or instance, got " .. typeof(class_or_instance), 0)
        end

        local ctor = if type(class_or_instance) == "string"
            then ctor_cache[class_or_instance]
            else function(properties)
                local clone = class_or_instance:Clone()
                if not clone then error "attempt to clone a non-archivable instance" end
                return apply(clone, properties)
            end

        return if properties
            then ctor(properties)
            else ctor
    end

    type Instances = {
        Folder: Folder,
        BillboardGui: BillboardGui,
        CanvasGroup: CanvasGroup,
        Frame: Frame,
        ImageButton: ImageButton,
        ImageLabel: ImageLabel,
        ScreenGui: ScreenGui,
        ScrollingFrame: ScrollingFrame,
        SurfaceGui: SurfaceGui,
        TextBox: TextBox,
        TextButton: TextButton,
        TextLabel: TextLabel,
        UIAspectRatioConstraint: UIAspectRatioConstraint,
        UICorner: UICorner,
        UIGradient: UIGradient,
        UIGridLayout: UIGridLayout,
        UIListLayout: UIListLayout,
        Camera: Camera,
        WorldModel: WorldModel,
    }

    type function Properties(instance: type?)
        local properties = types.newtable()

        while instance do
            for i, v in instance:properties() do
                local connector = v.read and v.read.tag == "table" and v.read:readproperty(types.singleton("Connect"))
                if connector then
                    local params = connector:parameters().head
                    if not params then continue end
                    local listener = params[2]
                    if not listener then continue end
                    properties:setproperty(i, types.optional(listener))
                elseif v.write then
                    properties:setproperty(i, types.optional(types.unionof(
                        v.write,
                        types.newfunction({}, { head = { v.write } })
                    )))
                end
            end

            instance = instance:readparent()
        end

        properties:setindexer(types.number, types.any)

        return properties
    end

    type AnyProps = { [any]: any }
    type Create = (
        (Instance) -> (AnyProps) -> Instance
    ) & (
        (string, AnyProps) -> Instance
    ) & (
        <Name>(Name|keyof<Instances>) -> (Properties<index<Instances, Name>>) -> index<Instances, Name>
    )

    return (create :: any) :: Create
end

local function GetSource()
    local graph = GetGraph()
    type Node<T> = graph.Node<T>
    local create_source_node = graph.create_source_node
    local push_scope_as_child_of = graph.push_scope_as_child_of
    local update_descendants = graph.update_descendants

    export type Source<T> = (() -> T) & ((value: T) -> T)

    local function source<T>(initial_value: T): Source<T>
        local node = create_source_node(initial_value)

        local function update_source(...): T
            if select("#", ...) == 0 then -- no args were given
                push_scope_as_child_of(node)
                return node.cache
            end

            local v = ... :: T
            if node.cache == v and (type(v) ~= "table" or table.isfrozen(v)) then 
                return v
            end

            node.cache = v
            update_descendants(node)
            return v
        end

        return update_source
    end

    return source :: (<T>(initial_value: T) -> Source<T>) & (<T>() -> Source<T>)
end

local function GetEffect()
    local graph = GetGraph()
    local create_node = graph.create_node
    local assert_stable_scope = graph.assert_stable_scope
    local evaluate_node = graph.evaluate_node

    local function effect<T>(callback: (T) -> T, initial_value: T)
        local node = create_node(assert_stable_scope(), callback, initial_value)

        evaluate_node(node)
    end

    return effect :: (<T>(callback: (T) -> T, initial_value: T) -> ()) & ((callback: () -> ()) -> ())
end

local function GetDerive()
    local graph = GetGraph()
    local create_node = graph.create_node
    local push_scope_as_child_of = graph.push_scope_as_child_of
    local assert_stable_scope = graph.assert_stable_scope
    local evaluate_node = graph.evaluate_node

    local function derive<T>(source: () -> T): () -> T
        local node = create_node(assert_stable_scope(), source, false :: any)

        evaluate_node(node)

        return function()
            push_scope_as_child_of(node)
            return node.cache
        end
    end

    return derive
end

local function GetCleanUp()
    local typeof = game and typeof

    local graph = GetGraph()
    local get_scope = graph.get_scope
    local push_cleanup = graph.push_cleanup

    local function helper(obj: any)
        return
            if typeof(obj) == "RBXScriptConnection" then function() obj:Disconnect() end
            elseif type(obj) == "thread" then function() task.cancel(obj) end
            elseif typeof(obj) == "Instance" then function() obj:Destroy() end
            elseif obj.destroy then function() obj:destroy() end
            elseif obj.disconnect then function() obj:disconnect() end
            elseif obj.Destroy then function() obj:Destroy() end
            elseif obj.Disconnect then function() obj:Disconnect() end
            else error "cannot cleanup given object"
    end

    local function cleanup(value: unknown)
        local scope = get_scope()

        if not scope then
            error "cannot cleanup outside a stable or reactive scope"
        end; assert(scope)

        if type(value) == "function" then
            push_cleanup(scope, value :: () -> ())
        else
            push_cleanup(scope, helper(value))
        end
    end

    type Destroyable = { destroy: (any) -> () } | { Destroy: (any) -> () }
    type Disconnectable = { disconnect: (any) -> () } | { Disconnect: (any) -> () }

    return cleanup ::
        ( (callback: () -> ()) -> () ) &
        ( (thread: thread) -> () ) &
        ( (instance: Destroyable) -> () ) &
        ( (connection: Disconnectable) -> () ) &
        ( (instance: Instance) -> () ) &
        ( (connection: RBXScriptConnection) -> () )

end

local function GetUntrack()
    local graph = GetGraph()
    type Node<T> = graph.Node<T>
    local get_scope = graph.get_scope

    local function untrack<T>(source: () -> T): T
        local scope = get_scope()
        
        if scope then
            -- sources are only tracked if the node in scope has an effect
            local effect = scope.effect
            scope.effect = false

            local ok, result = xpcall(source, debug.traceback)

            scope.effect = effect :: () -> ()

            if not ok then error(result, 0) end

            return result :: T
        else
            return source()
        end
    end

    return untrack :: ( <T>(fn: () -> T) -> T ) & ( (fn: () -> ()) -> () )
end

local function GetRead()
    local function read<T>(value: T | () -> T): T
        return if type(value) == "function" then value() else value
    end

    return read
end

local function GetBatch()
    local flags = GetFlags()
    local graph = GetGraph()

    local function batch(setter: () -> ())
        local already_batching = flags.batch
        local from

        if not already_batching then
            flags.batch = true
            from = graph.get_update_queue_length()
        end

        local ok, err: string? = xpcall(setter, debug.traceback)

        if not already_batching then
            flags.batch = false
            graph.flush_update_queue(from)
        end

        if not ok then error(`error occured while batching updates: {err}`, 0) end
    end

    return batch
end

local function GetContext()
    local graph = GetGraph()
    type Node<T> = graph.Node<T>
    local create_node = graph.create_node
    local get_scope = graph.get_scope
    local push_scope = graph.push_scope
    local pop_scope = graph.pop_scope
    local set_context = graph.set_context

    export type Context<T> = (() -> T) & (<U>(T, () -> U) -> U)

    local nil_symbol = newproxy()
    local count = 0

    local function context<T>(...: T): Context<T>
        count += 1
        local id = count

        local has_default = select("#", ...) > 0
        local default_value = ...

        return function<T>(...): any -- todo: fix type error
            local scope: Node<unknown>? | false = get_scope()

            if select("#", ...) == 0 then -- get
                while scope do
                    local ctx = scope.context
        
                    if not ctx then
                        scope = scope.owner
                        continue
                    end

                    local value = (ctx :: { unknown })[id]

                    if value == nil then
                        scope = scope.owner
                        continue
                    end
                    
                    return (if value ~= nil_symbol then value else nil) :: T
                end

                if has_default ~= nil then
                    return default_value
                else
                    error("attempt to get context when no context is set and no default context is set", 0)
                end
            else -- set
                if not scope then return error("attempt to set context outside of a vide scope", 0) end

                local value, component = ...
                
                local new_scope = create_node(scope, false, false)
                set_context(new_scope, id, if value == nil then nil_symbol else value)

                push_scope(new_scope)

                local function efn(err: string) return debug.traceback(err, 3) end
                local ok, result = xpcall(component, efn)

                pop_scope()

                if not ok then
                    error(`error while running context:\n\n{result}`, 0)
                end

                return result
            end

            return nil :: any
        end
    end

    return context
end

local function GetTimeOut()
    local queue = {} :: {
        { t: number, fn: () -> (), cancel: boolean }
    }

    local function timeout(t: number, fn: () -> ())
        local handle = { t = t, fn = fn, cancel = false }
        table.insert(queue, handle)
        return handle
    end

    local function update_timeouts(dt: number)
        for i = #queue, 1, -1 do
            local handle = queue[i]
            handle.t -= dt
            
            if handle.cancel or handle.t <= 0 then
                queue[i] = queue[#queue]
                queue[#queue] = nil

                if not handle.cancel then
                    handle.fn()
                end
            end
        end
    end

    return function() return timeout, update_timeouts end
end

local function GetSwitch()
    local branch = GetBranch()
    local source = GetSource()
    local effect = GetEffect()
    local timeout = GetTimeOut()()

    type Array<T> = { T }
    type Map<K, V> = { [K]: V }
    type Source<T> = () -> T
    type Component<T> = (Source<boolean>) -> (T, ...number)

    local function switch_map<K, Obj>(
        input: Source<K>,
        map: Map<K, Component<Obj>>
    ): Source<nil | Obj | Array<Obj>>
        local scopes = {} :: Map<K, {
            destroy: () -> (),
            object: Obj,
            delay: number,
            present: (boolean?) -> boolean,
            timeout: { cancel: boolean }?
        }>

        local output = source(nil :: nil | Obj | Array<Obj>)
        local function update_output()
            local objects = {}

            for _, scope in scopes do
                table.insert(objects, scope.object)
            end

            output(
                if objects[2] then objects
                elseif objects[1] then objects[1]
                else nil
            )
        end

        effect(function()
            local key: K? = input()

            -- destroy (or queue destroy) all scopes not associated with the input key
            for k, scope in scopes do
                if k == key then continue end

                scope.present(false)

                if scope.delay == 0 then
                    scope.destroy()
                    scopes[k] = nil
                else
                    if scope.timeout == nil then
                        scope.timeout = timeout(scope.delay, function()
                            scope.destroy()
                            scopes[k] = nil
                            update_output()
                        end)
                    end
                end
            end

            -- create new scope or abort destruction of existing scope if key exists
            if key ~= nil then
                local scope = scopes[key]

                if scope then
                    scope.present(true)

                    if scope.timeout then
                        scope.timeout.cancel = true
                        scope.timeout = nil
                    end
                else
                    local component = map[key]

                    if component ~= nil then
                        if type(component) ~= "function" then
                            error("map must map a value to a function", 0)
                        end

                        local present = source(false)

                        local delay = nil :: number?
                        local destroy, object = branch(function()
                            local object, t = component(present)
                            delay = t
                            return object
                        end)

                        present(true)

                        scopes[key] = {
                            destroy = destroy,
                            object = object,
                            delay = delay or 0,
                            present = present,
                            timeout = nil
                        }
                    end
                end
            end

            update_output()
        end)

        return output
    end

    local function switch<K, Obj>(input: Source<K>): (map: Map<K, Component<Obj>>) -> Source<nil | Obj | Array<Obj>>
        return function(map)
            return switch_map(input, map)
        end
    end

    return switch
end

local function GetShow()
    local source = GetSource()
    local derive = GetDerive()
    local effect = GetEffect()
    local untrack = GetUntrack()
    local switch = GetSwitch()

    type Array<T> = { T }
    type Source<T> = () -> T

    local function show<T, Obj>(
        input: Source<T?>,
        component: (Source<T>, Source<boolean>) -> (Obj, ...number),
        fallback: ((Source<boolean>) -> (Obj, ...number))?
    ): Source<nil | Obj | Array<Obj>>
        local filtered_input = source()

        effect(function()
            local v = input() 
            if v then
                filtered_input(v)
            end
        end)

        local input_is_truthy = derive(function()
            return not not input()
        end)

        return switch(input_is_truthy) {
            [true] = function(present)
                return component(filtered_input, present)
            end,
            [false] = fallback
        }
    end

    return show
end

local function GetIndexes()
    local flags = GetFlags()
    local branch = GetBranch()
    local source = GetSource()
    local effect = GetEffect()
    local timeout = GetTimeout()()

    type Array<T> = { T }
    type Map<K, V> = { [K]: V }
    type Source<T> = () -> T

    local function indexes<K, V, Obj>(
        input: Source<Map<K, V>>,
        component: (Source<V>, K, Source<boolean>) -> (Obj, ...number)
    ): Source<Array<Obj>>
        local update_count = 0
        local scopes = {} :: Map<K, {
            destroy: () -> (),
            object: Obj,
            value: V?,
            value_source: (V?) -> V,
            count: number,
            delay: number,
            present: (boolean?) -> boolean,
            timeout: { cancel: boolean }?,
        }>

        local output = source({} :: Array<Obj>)
        local function update_output()
            local objects = table.create(4)

            for _, scope in scopes do
                table.insert(objects, scope.object)
            end

            output(objects)
        end

        effect(function()
            local data = input()

            local count = update_count
            update_count += 1

            local children_need_update = false -- set to true if a scope is created or destroyed

            -- create or update scopes
            for i, v in data do
                local scope = scopes[i]

                if scope == nil then -- create new scope and create component
                    local value_source = source(v)
                    local present = source(false)

                    local delay = nil :: number?
                    local destroy, object = branch(function()
                        local object, t = component(value_source, i, present)
                        delay = t
                        return object
                    end)

                    present(true)
                    
                    children_need_update = true

                    scopes[i] = {
                        destroy = destroy,
                        object = object,
                        value = v,
                        value_source = value_source,
                        count = count,
                        delay = delay or 0,
                        present = present,
                        timeout = nil,
                    }
                else -- update scope
                    scope.count = count

                    if scope.value ~= v then
                        if scope.timeout then -- index is in input table again; cancel destruction
                            scope.timeout.cancel = true
                            scope.timeout = nil
                            scope.present(true)
                        end
                        
                        scope.value = v
                        scope.value_source(v)
                    end
                end
            end

            -- destroy scopes
            for i, scope in scopes do
                if scope.count < count then -- if count is not latest then index is no longer in the input table
                    scope.present(false)

                    if scope.delay == 0 then
                        scope.destroy()
                        scopes[i] = nil
                        children_need_update = true
                    else
                        scope.value = nil -- set to nil for the `scope.value ~= v` check
                        if scope.timeout == nil then
                            scope.timeout = timeout(scope.delay, function() -- todo: possible redundant updates
                                scope.destroy()
                                scopes[i] = nil
                                update_output()
                            end)
                        end
                    end
                end
            end

            if children_need_update then
                update_output()
            end
        end)

        return output
    end

    return indexes
end

local function GetValues()
    local flags = GetFlags()
    local branch = GetBranch()
    local source = GetSource()
    local effect = GetEffect()
    local timeout = GetTimeout()()

    type Array<T> = { T }
    type Map<K, V> = { [K]: V }
    type Source<T> = () -> T

    local function values<K, V, Obj>(
        input: Source<Map<K, V>>,
        component: (V, Source<K>, Source<boolean>) -> (Obj, ...number)
    ): Source<Array<Obj>>
        local update_count = 0
        local scopes = {} :: Map<V, {
            destroy: () -> (),
            object: Obj,
            index: K?,
            index_source: (K?) -> K,
            count: number,
            delay: number,
            present: (boolean?) -> boolean,
            timeout: { cancel: boolean }?,
        }>

        local output = source({} :: Array<Obj>)
        local function update_output()
            local objects = table.create(4)

            for _, scope in scopes do
                table.insert(objects, scope.object)
            end

            output(objects)
        end

        effect(function()
            local data = input()

            local count = update_count
            update_count += 1

            local children_need_update = false -- set to true if a scope is created or destroyed

            if flags.strict then -- check for duplicate values
                local map = {}
                for _, v in data do
                    if map[v] then
                        error("table source passed to `values()` contains duplicate values", 0)
                    end
                    map[v] = true
                end
            end

            -- create or update scopes
            for i, v in data do
                local scope = scopes[v]

                if scope == nil then -- create new scope and create component
                    local index_source = source(i)
                    local present = source(false)

                    local delay = nil :: number?
                    local destroy, object = branch(function()
                        local object, t = component(v, index_source, present)
                        delay = t
                        return object
                    end)

                    present(true)
                    
                    children_need_update = true

                    scopes[v] = {
                        destroy = destroy,
                        object = object,
                        index = i,
                        index_source = index_source,
                        count = count,
                        delay = delay or 0,
                        present = present,
                        timeout = nil,
                    }
                else -- update scope
                    scope.count = count

                    if scope.index ~= i then
                        if scope.timeout then -- value is in input table again; cancel destruction
                            scope.timeout.cancel = true
                            scope.timeout = nil
                            scope.present(true)
                        end
                        
                        scope.index = i
                        scope.index_source(i)
                    end
                end
            end

            -- destroy scopes
            for v, scope in scopes do
                if scope.count < count then -- if count is not latest then value is no longer in the input table
                    scope.present(false)

                    if scope.delay == 0 then
                        scope.destroy()
                        scopes[v] = nil
                        children_need_update = true
                    else
                        scope.index = nil -- set to nil for the `scope.index ~= i` check
                        if scope.timeout == nil then
                            scope.timeout = timeout(scope.delay, function() -- todo: possible redundant updates
                                scope.destroy()
                                scopes[v] = nil
                                update_output()
                            end)
                        end
                    end
                end
            end

            if children_need_update then
                update_output()
            end
        end)

        return output
    end

    return values
end

local function GetSpring()
    local graph = GetGraph()
    type Node<T> = graph.Node<T>
    type SourceNode<T> = graph.SourceNode<T>
    local create_node = graph.create_node
    local create_source_node = graph.create_source_node
    local assert_stable_scope = graph.assert_stable_scope
    local evaluate_node = graph.evaluate_node
    local update_descendants = graph.update_descendants
    local push_scope_as_child_of = graph.push_scope_as_child_of

    local UPDATE_RATE = 120
    local TOLERANCE_FACTOR = 10_000

    type Animatable = number | CFrame | Color3 | UDim | UDim2 | Vector2 | Vector3

    --[[
    Unsupported datatypes:
    - bool
    - Vector2int16
    - Vector3int16
    - EnumItem
    ]]

    type SpringState<T> = {
        k: number, -- spring constant
        c: number, -- damping coeff

        x0_123: vector, x0_456: vector, -- initial position
        x_123: vector, x_456: vector, -- current position
        x1_123: vector, x1_456: vector, -- target position
        v_123: vector, v_456: vector, -- current velocity

        source_value: T -- current value of spring input source
    }

    type SpringSettings<T> = ({
        position: T?,
        velocity: T?,
        impulse: T?
    }) -> ()

    type TypeToVec6<T> = (T) -> (vector, vector)
    type Vec6ToType<T> = (vector, vector) -> T

    local type_to_vec6 = {
        number = function(v)
            return vector.create(v, 0, 0), vector.zero
        end :: TypeToVec6<number>,

        CFrame = function(v)
            return v.Position, vector.create(v:ToEulerAnglesXYZ())
        end :: TypeToVec6<CFrame>,

        Color3 = function(v)
            -- todo: hsv, oklab?
            return vector.create(v.R, v.G, v.B), vector.zero
        end :: TypeToVec6<Color3>,

        UDim = function(v)
            return vector.create(v.Scale, v.Offset, 0), vector.zero
        end :: TypeToVec6<UDim>,
        
        UDim2 = function(v)
            return vector.create(v.X.Scale, v.X.Offset, v.Y.Scale), vector.create(v.Y.Offset, 0, 0)
        end :: TypeToVec6<UDim2>,

        Vector2 = function(v)
            return vector.create(v.X, v.Y, 0), vector.zero
        end :: TypeToVec6<Vector2>,

        Vector3 = function(v)
            return v, vector.zero
        end :: TypeToVec6<Vector3>,

        Rect = function(v)
            return vector.create(v.Min.X, v.Min.Y, v.Max.X), vector.create(v.Max.Y, 0, 0)
        end :: TypeToVec6<Rect>,

        table = function(v)
            return vector.create(v[1] or 0, v[2] or 0, v[3] or 0), vector.create(v[4] or 0, 0, 0)
        end :: TypeToVec6<{ number }>
    }

    local vec6_to_type = {
        number = function(a, b)
            return a.X
        end :: Vec6ToType<number>,

        CFrame = function(a, b)
            return CFrame.new(a) * CFrame.fromEulerAnglesXYZ(b.X, b.Y, b.Z)
        end :: Vec6ToType<CFrame>,

        Color3 = function(v)
            return Color3.new(math.clamp(v.X, 0, 1), math.clamp(v.Y, 0, 1), math.clamp(v.Z, 0, 1))
        end :: Vec6ToType<Color3>,

        UDim = function(v)
            return UDim.new(v.X, math.round(v.Y))
        end :: Vec6ToType<UDim>,
        
        UDim2 = function(a, b)
            return UDim2.new(a.X, math.round(a.Y), a.Z, math.round(b.X))
        end :: Vec6ToType<UDim2>,

        Vector2 = function(v)
            return Vector2.new(v.X, v.Y)
        end :: Vec6ToType<Vector2>,

        Vector3 = function(v)
            return v
        end :: Vec6ToType<Vector3>,

        Rect = function(a, b)
            return Rect.new(a.X, a.Y, a.Z, b.X)
        end :: Vec6ToType<Rect>,

        table = function(a, b)
            return { a.X, a.Y, a.Z, b.X }
        end :: Vec6ToType<{ number }>
    }

    local invalid_type = {
        __index = function(_, t: string)
            error(`cannot spring type {t}`, 0)
        end
    }

    setmetatable(type_to_vec6, invalid_type)
    setmetatable(vec6_to_type, invalid_type)

    -- maps spring data to its corresponding output node
    -- lifetime of spring data is tied to output node
    local springs: { [SpringState<unknown>]: SourceNode<unknown> } = {}
    setmetatable(springs :: any, { __mode = "v" })

    local function spring<T>(source: () -> T, period: number?, damping_ratio: number?): (() -> T, SpringSettings<T>)
        local owner = assert_stable_scope()

        -- https://en.wikipedia.org/wiki/Damping
        local w_n = 2*math.pi / (period or 1)
        local z = damping_ratio or 1
        local k = w_n^2
        local c_c = 2*w_n
        local c = z * c_c

        -- todo: is there a solution other than reducing step size?
        -- todo: this does not catch all solver exploding cases
        if c > UPDATE_RATE*2 then -- solver will explode if this is true
            error("spring damping too high, consider reducing damping or increasing period", 0)
        end

        local data: SpringState<T> = {
            k = k,
            c = c,

            x0_123 = vector.zero,
            x_123 = vector.zero,
            x1_123 = vector.zero,
            v_123 = vector.zero,

            x0_456 = vector.zero,
            x_456 = vector.zero,
            x1_456 = vector.zero,
            v_456 = vector.zero,

            source_value = false :: any,
        }
        
        local output = create_source_node(false :: any)

        local function updater_effect()
            local value = source()
            data.x1_123, data.x1_456 = type_to_vec6[typeof(value)](value)
            data.source_value = value
            springs[data] = output
            return value
        end

        local updater = create_node(owner, updater_effect, false :: any)
        evaluate_node(updater)

        -- set initial position to goal
        data.x_123, data.x_456 = data.x1_123, data.x1_456

        -- set output to goal
        output.cache = data.source_value

        local config = function(p)
            local x = p.position
            local v = p.velocity
            local dv = p.impulse

            if x then
                local x_123, x_456 = type_to_vec6[typeof(x)](x)
                data.x_123, data.x_456 = x_123, x_456
                data.x0_123, data.x0_456 = x_123, x_456
            end

            if v then
                data.v_123, data.v_456 = type_to_vec6[typeof(v)](v)
            end

            if dv then
                local dv_123, dv_456 = type_to_vec6[typeof(dv)](dv)
                data.v_123 += dv_123
                data.v_456 += dv_456
            end

            -- schedule spring
            springs[data] = output
        end :: SpringSettings<T>

        return function(...)
            if select("#", ...) == 0 then -- no args were given
                push_scope_as_child_of(output)
                return output.cache
            end

            -- set current position to value
            local v = ... :: T
            data.x_123, data.x_456 = type_to_vec6[typeof(v)](v)

            -- reset velocity
            data.v_123 = vector.zero
            data.v_456 = vector.zero

            -- schedule spring
            springs[data] = output

            -- set output to value
            output.cache = v

            return v
        end, config
    end

    -- calculates a float tolerance, based on the magnitude of the float
    local function get_min_step(x: number): number
        return x/TOLERANCE_FACTOR
    end
    local function get_min_vector_step(direction: vector): vector
        return vector.create(
            get_min_step(direction.x),
            get_min_step(direction.y),
            get_min_step(direction.z)
        )
    end

    local function step_springs(dt: number)
        for s in springs do
            local k = s.k
            local c = s.c
            local x_123, x_456 = s.x_123, s.x_456
            local x1_123, x1_456 = s.x1_123, s.x1_456
            local u_123, u_456 = s.v_123, s.v_456

            -- calculate displacement from target
            local dx_123 = x_123 - x1_123
            local dx_456 = x_456 - x1_456

            -- calculate spring force
            local fs_123 = dx_123*-k
            local fs_456 = dx_456*-k

            -- calculate friction force
            local ff_123 = u_123*-c
            local ff_456 = u_456*-c

            -- calculate acceleration
            local a_123 = (fs_123 + ff_123)
            local a_456 = (fs_456 + ff_456)

            -- step acceleration
            local v_123 = u_123 + a_123*dt
            local v_456 = u_456 + a_456*dt

            -- step velocity
            local y_123 = x_123 + v_123*dt
            local y_456 = x_456 + v_456*dt

            s.x_123, s.x_456 = y_123, y_456
            s.v_123, s.v_456 = v_123, v_456
        end
    end

    local function update_spring_sources()
        for data, output in springs do
            local x0_123, x0_456 = data.x0_123, data.x0_456
            local x_123, x_456 = data.x_123, data.x_456
            local x1_123, x1_456 = data.x1_123, data.x1_456
            local v_123, v_456 = data.v_123, data.v_456

            local tol_123 = vector.abs(get_min_vector_step(x0_123 - x1_123))
            local tol_456 = vector.abs(get_min_vector_step(x0_456 - x1_456))

            if
                -- position is at goal (within tolerance)
                vector.max(vector.abs(x_123 - x1_123), tol_123) == tol_123
                and vector.max(vector.abs(x_456 - x1_456), tol_456) == tol_456

                -- velocity is at 0 (within tolerance)
                and vector.max(vector.abs(v_123/10), tol_123) == tol_123
                and vector.max(vector.abs(v_456/10), tol_456) == tol_456
            then
                springs[data] = nil
                output.cache = data.source_value
            else
                output.cache = vec6_to_type[typeof(data.source_value)](x_123, x_456)
            end

            update_descendants(output)
        end
    end

    return function()
        local time_elapsed = 0

        return spring, function(dt: number)
            time_elapsed += dt

            while time_elapsed > 1 / UPDATE_RATE do
                time_elapsed -= 1 / UPDATE_RATE
                step_springs(1 / UPDATE_RATE)
            end

            update_spring_sources()
        end
    end
end

local function GetChanged()
    local action = GetAction()()
    local cleanup = GetCleanUp()

    local function changed<T>(property: string, callback: (T) -> ())
        return action(function(instance)
            local con = instance:GetPropertyChangedSignal(property):Connect(function()
                callback((instance :: any)[property])
            end)

            cleanup(function()
                con:Disconnect()
            end)

            callback((instance :: any)[property])
        end)
    end

    return changed
end

local root = GetRoot()
local branch = GetBranch()
local mount = GetMount()
local create = GetCreate()
local apply = GetApply()
local source = GetSource()
local effect = GetEffect()
local derive = GetDerive()
local cleanup = GetCleanUp()
local untrack = GetUntrack()
local read = GetRead()
local batch = GetBatch()
local context = GetContext()
local switch = GetSwitch()
local show = GetShow()
local indexes = GetIndexes()
local values = GetValues()
local spring, update_springs = GetSpring()()
local action = GetAction()()
local changed = GetChanged()
local timeout, update_timeouts = GetTimeOut()()
local flags = GetFlags()

export type Source<T> = source.Source<T>
export type source<T> = Source<T>
export type Context<T> = context.Context<T>
export type context<T> = Context<T>

local function step(dt: number)
    if game then debug.profilebegin("VIDE STEP") end

    if game then debug.profilebegin("VIDE SPRING") end
    update_springs(dt)
    if game then debug.profileend() end

    if game then debug.profilebegin("VIDE SCHEDULER") end
    update_timeouts(dt)
    if game then debug.profileend() end

    if game then debug.profileend() end
end

local stepped = game and game:GetService("RunService").Heartbeat:Connect(function(dt: number)
    task.defer(step, dt)
end)

local vide = {
    version = version,

    -- core
    root = root,
    --branch = branch,
    mount = mount,
    create = create,
    source = source,
    effect = effect,
    derive = derive,
    switch = switch,
    show = show,
    indexes = indexes,
    values = values,

    -- util
    cleanup = cleanup,
    untrack = untrack,
    read = read,
    batch = batch,
    context = context,

    -- animations
    spring = spring,

    -- actions
    action = action,
    changed = changed,

    -- flags
    strict = (nil :: any) :: boolean,
    defaults = (nil :: any) :: boolean,
    defer_nested_properties = (nil :: any) :: boolean,

    -- temporary
    apply = function(instance: Instance)
        return function(props: { [any]: any })
            apply(instance, props)
            return instance
        end
    end,

    -- runtime
    step = function(dt: number)
        if stepped then
            stepped:Disconnect()
            stepped = nil
        end
        step(dt)
    end
}

setmetatable(vide :: any, {
    __index = function(_, index: unknown): ()
        if flags[index] == nil then
            error(`{tostring(index)} is not a valid member of vide`, 0)
        else
            return flags[index]
        end
    end,

    __newindex = function(_, index: unknown, value: unknown)
        if flags[index] == nil then
            error(`{tostring(index)} is not a valid member of vide, 0`)
        else
            flags[index] = value
        end
    end
})

return vide
