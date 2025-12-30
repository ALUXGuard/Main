type Setting = {
    -- toggle function
    AutoFarm:               boolean,
    AutoStats:              boolean,
    AutoHaki:               boolean,
    AutoAttack:             boolean,
    FlyToPlayer:            boolean,
    AutoEnablePvp:          boolean,
    WalkOnWater:            boolean,
    FlyToIsland:            boolean,
    AutoRejoin:             boolean,
    AutoExecute:            boolean,

    -- v4 toggle
    AutoTranform:           boolean,
    AutoBuyTier:            boolean,
    AutoFollowHostAbility:  boolean,
    AutoResetCharTrial:     boolean,
    AutoKillTrial:          boolean,
    AutoRaceDoor:           boolean,
    AutoCompleteTrial:      boolean,
    AutoChoseGear:          boolean,

    -- data
    PriorityFarming:        boolean,
    SelectWeapon:           string,
    SelectPlayer:           string,
    SelectRaceHost:         string,
    SelectIsland:           number,
    FarmMethod:             string,
    TweenSpeed:             number,
    YPos:                   number,
    TeleportAtDistance:     number,
    SelectedStats:          {},
    Priority:               {},
    PlayerDropdown:         {},
}

type RaceInfo = {
    Race:           string,
    Version:        number,
    Tier:           number,
    QuestStatus:    string,
    PullLever:      boolean,
}

local self = {}
self.Settings = {} :: Setting

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

-----------------------------------------------
---- 🔑 KEY SYSTEM 🔑
-----------------------------------------------
function self.MakeKeyPopup(): BindableEvent
    local keyendevent = Instance.new("BindableEvent")
	local JunkieKeySystem = loadstring(game:HttpGet("https://junkie-development.de/sdk/JunkieKeySystem.lua"))()

	local API_KEY = "2383bf96-9085-4015-b6f9-476b19ffe24d"
	local SERVICE = "GenKey"
	local PROVIDER = "GetKey"

    if not isfile("Apex Hub Script/Key.txt") then
        writefile("Apex Hub Script/Key.txt", "")
    end

    if JunkieKeySystem.verifyKey(API_KEY, readfile("Apex Hub Script/Key.txt"), SERVICE) then
        return
    end

	local KeyPopup = Instance.new("ScreenGui")
	local Body = Instance.new("Frame")
	local ContentBody = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local Toolbar = Instance.new("Frame")
	local WindowControls = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local UIPadding = Instance.new("UIPadding")
	local Exit = Instance.new("ImageButton")
	local Stroke = Instance.new("ImageLabel")
	local Icon = Instance.new("ImageLabel")
	local Form = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local TextBox = Instance.new("TextBox")
	local CheckKey = Instance.new("TextButton")
	local UICorner_3 = Instance.new("UICorner")
	local GetKey = Instance.new("TextButton")
	local UICorner_4 = Instance.new("UICorner")
	local Dropshadow = Instance.new("ImageLabel")

	KeyPopup.Name = "KeyPopup"
	KeyPopup.Parent = game:GetService("CoreGui")
	KeyPopup.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	KeyPopup.DisplayOrder = 200
	KeyPopup.ResetOnSpawn = false

	Body.Name = "Body"
	Body.Parent = KeyPopup
	Body.AnchorPoint = Vector2.new(0.5, 0.5)
	Body.BackgroundColor3 = Color3.fromRGB(32, 32, 35)
	Body.BackgroundTransparency = 1.000
	Body.BorderSizePixel = 0
	Body.Position = UDim2.new(0.499187052, 0, 0.498972088, 0)
	Body.Size = UDim2.new(0, 314, 0, 141)

	ContentBody.Name = "ContentBody"
	ContentBody.Parent = Body
	ContentBody.AnchorPoint = Vector2.new(0.5, 0.5)
	ContentBody.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
	ContentBody.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ContentBody.BorderSizePixel = 0
	ContentBody.ClipsDescendants = true
	ContentBody.LayoutOrder = 2
	ContentBody.Position = UDim2.new(0.5, 0, 0.5, 0)
	ContentBody.Size = UDim2.new(1, 0, 1, 0)

	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = ContentBody

	Toolbar.Name = "Toolbar"
	Toolbar.Parent = ContentBody
	Toolbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Toolbar.BackgroundTransparency = 1.000
	Toolbar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Toolbar.BorderSizePixel = 0
	Toolbar.Size = UDim2.new(1, 0, -0.160460994, 52)

	WindowControls.Name = "WindowControls"
	WindowControls.Parent = Toolbar
	WindowControls.AnchorPoint = Vector2.new(0, 0.5)
	WindowControls.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	WindowControls.BackgroundTransparency = 1.000
	WindowControls.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowControls.BorderSizePixel = 0
	WindowControls.Position = UDim2.new(0, 0, 0.5, 0)
	WindowControls.Size = UDim2.new(0, 69, 0, 38)

	UIListLayout.Parent = WindowControls
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 8)

	UIPadding.Parent = WindowControls
	UIPadding.PaddingLeft = UDim.new(0, 10)
	UIPadding.PaddingRight = UDim.new(0, 20)

	Exit.Name = "Exit"
	Exit.Parent = WindowControls
	Exit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Exit.BackgroundTransparency = 1.000
	Exit.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Exit.BorderSizePixel = 0
	Exit.Size = UDim2.new(0, 12, 0, 12)
	Exit.AutoButtonColor = false
	Exit.Image = "rbxassetid://132228700346004"
	Exit.ImageColor3 = Color3.fromRGB(255, 95, 87)

	Stroke.Name = "Stroke"
	Stroke.Parent = Exit
	Stroke.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Stroke.BackgroundTransparency = 1.000
	Stroke.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Stroke.BorderSizePixel = 0
	Stroke.Size = UDim2.new(1, 0, 1, 0)
	Stroke.Image = "rbxassetid://94763505860483"
	Stroke.ImageTransparency = 0.900

	Icon.Name = "Icon"
	Icon.Parent = Exit
	Icon.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Icon.BackgroundTransparency = 1.000
	Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Icon.BorderSizePixel = 0
	Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
	Icon.Size = UDim2.new(1, 0, 1, 0)
	Icon.Visible = false
	Icon.Image = "rbxassetid://94781753558308"
	Icon.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Icon.ImageTransparency = 0.500

	Form.Name = "Form"
	Form.Parent = ContentBody
	Form.BackgroundColor3 = Color3.fromRGB(31, 31, 33)
	Form.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Form.BorderSizePixel = 0
	Form.Position = UDim2.new(0.0500000007, 0, 0.208333328, 0)
	Form.Size = UDim2.new(0.899999976, 0, 0.241134748, 0)
	Form.ZIndex = 0

	UICorner_2.CornerRadius = UDim.new(0, 6)
	UICorner_2.Parent = Form

	TextBox.Parent = Form
	TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.BackgroundTransparency = 1.000
	TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextBox.BorderSizePixel = 0
	TextBox.Position = UDim2.new(0.05, 0, 0.25, 0)
	TextBox.Size = UDim2.new(0.9, 0, 0.5, 0)
	TextBox.Font = Enum.Font.Unknown
	TextBox.PlaceholderColor3 = Color3.fromRGB(159, 159, 159)
	TextBox.PlaceholderText = "key..."
	TextBox.Text = ""
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.TextSize = 15.000
	TextBox.TextScaled = true

	CheckKey.Name = "CheckKey"
	CheckKey.Parent = ContentBody
	CheckKey.Active = false
	CheckKey.BackgroundColor3 = Color3.fromRGB(31, 31, 33)
	CheckKey.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CheckKey.BorderSizePixel = 0
	CheckKey.Position = UDim2.new(0.540012062, 0, 0.589538991, 0)
	CheckKey.Selectable = false
	CheckKey.Size = UDim2.new(0.407000005, 0, 0.298000008, 0)
	CheckKey.Font = Enum.Font.Unknown
	CheckKey.Text = "Submit"
	CheckKey.TextColor3 = Color3.fromRGB(255, 255, 255)
	CheckKey.TextSize = 15.000
	CheckKey.TextTransparency = 0.450

	UICorner_3.CornerRadius = UDim.new(0, 6)
	UICorner_3.Parent = CheckKey

	GetKey.Name = "GetKey"
	GetKey.Parent = ContentBody
	GetKey.Active = false
	GetKey.BackgroundColor3 = Color3.fromRGB(31, 31, 33)
	GetKey.BorderColor3 = Color3.fromRGB(0, 0, 0)
	GetKey.BorderSizePixel = 0
	GetKey.Position = UDim2.new(0.0495661832, 0, 0.589538991, 0)
	GetKey.Selectable = false
	GetKey.Size = UDim2.new(0.407141238, 0, 0.297872335, 0)
	GetKey.Font = Enum.Font.Unknown
	GetKey.Text = "GetKey"
	GetKey.TextColor3 = Color3.fromRGB(255, 255, 255)
	GetKey.TextSize = 15.000
	GetKey.TextTransparency = 0.450

	UICorner_4.CornerRadius = UDim.new(0, 6)
	UICorner_4.Parent = GetKey

	Dropshadow.Name = "Dropshadow"
	Dropshadow.Parent = Body
	Dropshadow.AnchorPoint = Vector2.new(0.5, 0.5)
	Dropshadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Dropshadow.BackgroundTransparency = 1.000
	Dropshadow.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Dropshadow.BorderSizePixel = 0
	Dropshadow.Position = UDim2.new(0.5, 0, 0.5, 3)
	Dropshadow.Size = UDim2.new(1, 24, 1, 24)
	Dropshadow.ZIndex = 0
	Dropshadow.Image = "rbxassetid://138260268144845"
	Dropshadow.ImageTransparency = 0.650
	Dropshadow.ScaleType = Enum.ScaleType.Slice
	Dropshadow.SliceCenter = Rect.new(28, 26, 96, 94)

	local connects = {}
	local function EndPopupKey()
        KeyPopup:Destroy()

		for _, v in connects do
			v:Disconnect()
		end
	end

	local getcon = GetKey.MouseButton1Click:Connect(function()
		local link = JunkieKeySystem.getLink(API_KEY, PROVIDER, SERVICE)
		setclipboard(link)
	end)

	local checkcon = CheckKey.MouseButton1Click:Connect(function()
        local key = TextBox.Text
		local isValid = JunkieKeySystem.verifyKey(API_KEY, key, SERVICE)
		
		if isValid then
            writefile("Apex Hub Script/Key.txt", key)
            EndPopupKey()
            keyendevent:Fire()
        end
	end)

	local exitcon = Exit.MouseButton1Click:Connect(function()
		EndPopupKey()
		
		keyendevent:Fire("Close")
	end)

	table.insert(connects, getcon)
	table.insert(connects, checkcon)
	table.insert(connects, exitcon)

    local keyresponse = keyendevent.Event:Wait()
    return keyresponse
end

local keyresult = self.MakeKeyPopup()
if keyresult == "Close" then return end

-----------------------------------------------
---- 🚩 INIT FUNCTIONS 🚩
-----------------------------------------------
function self.LoadSave()
    if isfile("Apex Hub Script/Settings/Bloxfruit.json") then
        makefolder("Apex Hub Script")
        makefolder("Apex Hub Script/Settings")

        local http = game:GetService("HttpService")
        self.Settings = http:JSONDecode(readfile("Apex Hub Script/Settings/Bloxfruit.json"))
    end
end

function self.InitConfig()
    if not getgenv().ApexConfig then
        getgenv().ApexConfig = {}
    end
end

function self.InitQuestDatas()
    type QuestData = {
        InternalQuestName: string,
        Levels: {{Level: number, Enemy: string, KillRequire: number}},
        NPCName: string,
        Position: Vector3,
    }

    local success, result = pcall(function()
        self.QuestDatas = {} :: {QuestData}

        local GuideModule = require(game:GetService("ReplicatedStorage").GuideModule)
        local QuestData =  require(game:GetService("ReplicatedStorage").Quests)
        
        for _, questdata in GuideModule.Data.NPCList do
            local http = game:GetService("HttpService")
            local new_quest_data = http:JSONEncode(questdata)
            new_quest_data = http:JSONDecode(new_quest_data)
            new_quest_data.Position = questdata.Position

            if new_quest_data.NPCName == "Mole" and new_quest_data.Position.Y < 1000 then continue end
            
            for i, level in new_quest_data.Levels do
                for _, choice in QuestData[new_quest_data.InternalQuestName] do
                    local monname
                    local killrequire

                    for name, kill_require in choice.Task do
                        monname = name
                        killrequire = kill_require
                    end

                    if choice.LevelReq == level then
                        new_quest_data.Levels[i] = {Level = level, Enemy = monname, KillRequire = killrequire}
                    end

                end
            end

            new_quest_data[1] = nil
            new_quest_data[2] = nil
            new_quest_data[3] = nil

            table.insert(self.QuestDatas, new_quest_data)
        end

        table.sort(self.QuestDatas, function(a, b)
            return a.Levels[1].Level < b.Levels[1].Level
        end)

        self.CommF_ = game:GetService("ReplicatedStorage").Remotes.CommF_
    end)

    if not success then
        self.InitQuestDatas()
    end
end

function self.InitSea()
    if game.PlaceId == 2753915549 then
        self.Sea = 1

    elseif game.PlaceId == 4442272183 then
        self.Sea = 2

    elseif game.PlaceId == 100117331123089 then
        self.Sea = 3
    end

    self.Sea = tonumber(workspace:GetAttribute("MAP"):sub(4))
end

function self.AntiAFK()
    local VirtualUser = game:GetService('VirtualUser')

    game:GetService('Players').LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

function self.SetPriority(func: string, priority: number)
    if not self.Settings.Priority then
        self.Settings.Priority = {}
    end

    local priority_temlate = {"AutoCompleteTrial : 6", "AutoKillTrial : 5", "AutoRaceDoor : 4", "FlyToPlayer : 3", "FlyToIsland : 2", "AutoFarm : 1"}

    for _, pri in priority_temlate do
        local funcname = pri:match("^(.-)%s*%:")
        local found

        for _, exist in self.Settings.Priority do
            if exist:match("^(.-)%s*%:") == funcname then
                found = true

                break
            end
        end

        if not found then
            table.insert(self.Settings.Priority, pri)
        end

        table.sort(self.Settings.Priority, function(a, b)
            return tonumber(a:split(" : ")[2]) > tonumber(b:split(" : ")[2])
        end)
    end
        
    if not func or not priority then
        return self.Settings.Priority
        
    else
        for i, pri in self.Settings.Priority do 
            if pri:match(func) then
                self.Settings.Priority[i] = func .. " : " .. priority

                break
            end
        end

        table.sort(self.Settings.Priority, function(a, b)
            return tonumber(a:split(" : ")[2]) > tonumber(b:split(" : ")[2])
        end)
    end

    return self.Settings.Priority
end

function self.InitTempleOfTime()
    if self.Sea ~= 3 then return end

    local temple_stash = game:GetService("ReplicatedStorage"):WaitForChild("MapStash"):FindFirstChild("Temple of Time")

    if temple_stash then
        temple_stash.Parent = workspace:WaitForChild("Map")
    end

    task.delay(1, self.PullLever)
end

function self.InitRaceAbility()
    self.RaceAbility ={
        "Last Resort",
        "Agility",
        "Water Body",
        "Heavenly Blood",
        "Heightened Senses",
        "Energy Core",
        "Primordial Reign"
    }
end

function self.InitTrialName()
    self.TrialName = {
        Human = "HumanTrial",
        Mink = "MinkTrial",
        Fishman = "",
        Skypiea = "SkyTrial",
        Cyborg = ""
    }
end

function self.InitBodyType()
    local Character = Player.Character or Player.CharacterAdded:Wait()

    self.BodyType = Character:FindFirstChild("Torso") and "R6" or "R15"
end

function self.PullLever()
    local temple_of_time = workspace.Map:FindFirstChild("Temple of Time")
    local lever_prompt = temple_of_time and temple_of_time.Lever.Prompt:FindFirstChild("ProximityPrompt")

    if lever_prompt then
        fireproximityprompt(workspace.Map["Temple of Time"].Lever.Prompt.ProximityPrompt)
    end

    if temple_of_time and not lever_prompt then
        self.IsPullLever = true
    end
end

function self.InitTeam()
    if Player.Neutral then
        self.CommF_:InvokeServer("SetTeam", getgenv().ApexConfig.Team == "Marines" and "Marines" or "Pirates")
    end
end

function self.InitIsland()
    self.Islands = {
        [1] = {

        },

        [2] = {
            {Name = "Dressrosa",        Position = Vector3.new(-381.31109619140625, 373.7752990722656, 712.6630859375)},
            {Name = "Mini2",            Position = Vector3.new(-5162.13720703125, 259.2460021972656, 2390.263671875)},
            {Name = "GraveIsland",      Position = Vector3.new(-5620.77587890625, 492.51043701171875, -778.916015625)},
            {Name = "GhostShipInterior",Position = Vector3.new(-6496.89794921875, 89.03500366210938, -116.50900268554688)},
            {Name = "GreenBit",         Position = Vector3.new(-2413.85693359375, 199.2963409423828, -3343.087158203125)},
            {Name = "CircleIsland",     Position = Vector3.new(-5688.5244140625, 161.68051147460938, -5059.83349609375)},
            {Name = "ForgottenIsland",  Position = Vector3.new(-3121.372802734375, 339.6866149902344, -10349.1767578125)},
            {Name = "IceCastle",        Position = Vector3.new(5598.82958984375, 362.0080261230469, -6688.6298828125)},
            {Name = "SnowMountain",     Position = Vector3.new(838.9915161132812, 492.3343505859375, -5379.8388671875)},
            {Name = "DarkbeardArena",   Position = Vector3.new(3664.618896484375, 137.927734375, -3665.089111328125)},
            {Name = "Mini1",            Position = Vector3.new(4791.00146484375, 253.58216857910156, 2851.848388671875)},
        },

        [3] = {
            {Name = "Boat Castle",      Position = Vector3.new(-5492.04052734375, 385.2581481933594, -2828.29052734375)},
            {Name = "Turtle",           Position = Vector3.new(-11985.8427734375, 757.1024169921875, -8613.4814453125)},
            {Name = "Peanut Island",    Position = Vector3.new(-2294.951171875, 154.9969940185547, -10224.1396484375)},
            {Name = "CakeLoaf",         Position = Vector3.new(-1963.7318115234375, 213.3590850830078, -11983.99609375)},
            {Name = "Ice Cream Island", Position = Vector3.new(-976.6080322265625, 203.37655639648438, -11077.5078125)},
            {Name = "ChocolateIsland",  Position = Vector3.new(129.6009063720703, 166.99302673339844, -12425.2392578125)},
            {Name = "CandyCane",        Position = Vector3.new(-1020.7692260742188, 198.7365264892578, -14120.1328125)},
            {Name = "Great Tree",       Position = Vector3.new(2421.17724609375, 606.0411376953125, -7495.4775390625)},
            {Name = "Waterfall",        Position = Vector3.new(5270.4619140625, 1005.5440063476562, 379.91900634765625)},
            {Name = "Port",             Position = Vector3.new(-351.6431579589844, 271.8161315917969, 5548.1591796875)},
            {Name = "Haunted Castle",   Position = Vector3.new(-9481.134765625, 537.8112182617188, 5438.03759765625)},
            {Name = "TikiOutpost",      Position = Vector3.new(-15892.3642578125, 265.3287048339844, 385.8984069824219)},
        }
    }
end

function self.InitRejoin()
    game.CoreGui.DescendantAdded:Connect(function(d)
        if d.Name == "ErrorPrompt" and self.Settings.AutoRejoin then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
        end
    end)
end

function self.InitAutoExecute()
    local queueteleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)

    Player.OnTeleport:Connect(function(State)
        if not getgenv().ApexHubAutoExecute and self.Settings.AutoExecute and queueteleport then
            getgenv().ApexHubAutoExecute = true
            queueteleport('repeat task.wait(1) until game:GetService("Players").LocalPlayer:FindFirstChild("Data"); loadstring(game:HttpGet("https://raw.githubusercontent.com/1makam1/Main/refs/heads/main/BloxFruit.lua"))()')
        end
    end)
end

-----------------------------------------------
---- 🏠 MAIN FUNCTIONS 🏠
-----------------------------------------------
function self.Fly(target: Instance | Vector3)
    if self.FlyThread then self.FlyThread = task.cancel(self.FlyThread) end

    local Character = Player.Character
    local hrp = Character:FindFirstChild("HumanoidRootPart")

    local function SetPlayerCollision(cancollide: boolean)
        if self.BodyType == "R15" then
            Character.LowerTorso.CanCollide = cancollide
            Character.UpperTorso.CanCollide = cancollide
        else
            Character.Torso.CanCollide = cancollide
        end

        Character.HumanoidRootPart.CanCollide = cancollide
    end

    if target and hrp then
        self.FlyThread = task.spawn(function()
            local startPos

            self.Target = typeof(target) == "Instance" and target:GetPivot().Position or target

            while task.wait() do
                local hum = Player.Character:FindFirstChildOfClass("Humanoid")

                hrp.AssemblyLinearVelocity = Vector3.zero

                if not hum or hum.Health <= 0 then
                    if hum and hum.Health <= 0 then
                        startPos = nil
                    end

                    continue
                end

                pcall(function()
                    if not startPos then
                        startPos = hrp.Position
                    end

                    local des = typeof(target) == "Instance" and target:GetPivot().Position or target
                    local dir = (des - startPos).Unit

                    local newPos = startPos + dir * (self.Settings.TweenSpeed or 3)
                    hrp.Parent:PivotTo((des - hrp.Position).Magnitude > (self.Settings.TeleportAtDistance or 200) and CFrame.new(newPos) or CFrame.new(des))
                    startPos = newPos

                    SetPlayerCollision(false)
                end)
            end
        end)

    else
        SetPlayerCollision(true)
    end
end

function self.IsReachTarget(): boolean
    local isreach

    if self.Target then
        local distance = (Player.Character.HumanoidRootPart.Position - self.Target).Magnitude

        if distance < 2 then
            isreach = true

            self.Target = nil
        end
    end

    return isreach
end

function self.Equip(weaponType: "Melee" | "Sword" | "Demon Fruit")
    local hum = Player.Character:WaitForChild("Humanoid")

    local equiped = Player.Character:FindFirstChildOfClass("Tool")

    if equiped and equiped:GetAttribute("WeaponType") == weaponType then
        return
    end

    if hum then
        hum:UnequipTools()

        for _, tool in pairs(Player.Backpack:GetChildren()) do
            if tool:GetAttribute("WeaponType") == weaponType then
                hum:EquipTool(tool)

                break
            end
        end
    end
end

function self.GetClosetMon(monname: string)
    local closetmon
    local closetdistance = math.huge

    local function CheckChildren(path)
        for _, mon in path:GetChildren() do
            local distance = (mon:GetPivot().Position - Player.Character.HumanoidRootPart.Position).Magnitude
            local hum = mon:FindFirstChild("Humanoid")

            if (mon.Name:match("^(.-)%s*%[") or mon.Name) == monname and distance < closetdistance and (hum and  hum.Health > 0 or hum == nil) then
                closetmon = mon
                closetdistance = distance
            end
        end
    end

    CheckChildren(workspace.Enemies)
    CheckChildren(workspace._WorldOrigin.EnemySpawns)

    return closetmon
end

function self.BringMon(closetmon: Instance)
    local monPositions = {}
    local mons = {}

    local function SetPlayerCollision(mon: Model, cancollide: boolean)
        mon.LowerTorso.CanCollide = cancollide
        mon.UpperTorso.CanCollide = cancollide
        mon.HumanoidRootPart.CanCollide = cancollide
    end

    local function getMiddleVector3(vectors)
        local sum = Vector3.new(0, 0, 0)
        local count = #vectors

        for _, v in ipairs(vectors) do
            sum += v
        end

        return sum / count
    end

    local function CheckChildren(path)
        for _, mon in path:GetChildren() do
            local hum = mon:FindFirstChild("Humanoid")

            if (mon.Name:match("^(.-)%s*%[") or mon.Name) == closetmon.name and hum and hum.Health > 0 then
                table.insert(monPositions, mon.HumanoidRootPart.Position)
                table.insert(mons, mon)

                hum.WalkSpeed = 0

                pcall(SetPlayerCollision, mon, false)
            end
        end
    end

    CheckChildren(workspace.Enemies)
    CheckChildren(workspace._WorldOrigin.EnemySpawns)

    if #monPositions == 0 then return closetmon:GetPivot().Position end

    local middlePos = getMiddleVector3(monPositions)

    if not self.LastBringMonPos then self.LastBringMonPos = Vector3.zero end
    if (middlePos - self.LastBringMonPos).Magnitude > 50 then self.LastBringMonPos = middlePos end

    for _, mon in mons do
        local distance = (mon:GetPivot().Position - Player.Character.HumanoidRootPart.Position).Magnitude

        TweenService:Create(mon.HumanoidRootPart, TweenInfo.new(distance/500, Enum.EasingStyle.Linear), {CFrame = CFrame.new(self.LastBringMonPos)}):Play()
    end

    return self.LastBringMonPos
end

function self.Attack()
    local Net = game:GetService("ReplicatedStorage").Modules.Net
    local RegisterHit = Net["RE/RegisterAttack"]
    local RE_RegisterHit = Net:WaitForChild("RE/RegisterHit")

    local Closetmon = {}
    local success = pcall(function()
        local closetrange = 60
        
        local enemy = {}
        for i,v in workspace.Enemies:GetChildren()do
            if v:FindFirstChild("HumanoidRootPart") then
                table.insert(enemy, v)
            end
        end
        for i,v in workspace.Characters:GetChildren()do
            if v:FindFirstChild("HumanoidRootPart") then
                table.insert(enemy, v)
            end
        end
        
        local char = Player.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")

        for i,v in enemy do
            local target_hrp = v:FindFirstChild("HumanoidRootPart")

            if char and v ~= char and target_hrp and hrp then
                local range = (target_hrp.Position - hrp.Position).Magnitude

                if range < closetrange then
                    table.insert(Closetmon, v)
                end
            end
        end
    end)
    
    if success and Closetmon[1] then
        local limbs = {"LeftHand", "LeftLowerArm", "LeftUpperArm", "RightHand", "RightLowerArm", "RightUpperArm"}
        
        local montable = {}
        for i, mon in Closetmon do
            local limb_exist = mon:FindFirstChild(limbs[math.random(1, #limbs)])

            if limb_exist then
                montable[i] = {}
                table.insert(montable[i], mon)
                table.insert(montable[i], mon.LeftHand)
                
                local mon_hum = mon:FindFirstChild("Humanoid")

                if mon_hum then
                    mon_hum.WalkSpeed = 0
                end
            end
        end

        RegisterHit:FireServer(0.3)
        RE_RegisterHit:FireServer(Closetmon[1]:FindFirstChild(limbs[math.random(1, #limbs)]), montable)
        getrenv()._G.SendHitsToServer(Closetmon[1]:FindFirstChild(limbs[math.random(1, #limbs)]), montable)
    end
end

function self.UseSkill(skill: string, holdDuration: number, target: Vector3)
    local VIM = game:GetService("VirtualInputManager")

    VIM:SendKeyEvent(true, skill, false, game)

    local function ChangeHitCF()
        local p, onScreen = workspace.CurrentCamera:WorldToViewportPoint(target)

        if not onScreen then
            workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, target)

            ChangeHitCF()
            return
        end

        VIM:SendMouseButtonEvent(p.X, p.Y, 0, true, game, 0)
        VIM:SendMouseButtonEvent(p.X, p.Y, 0, false, game, 0)

        require(game.ReplicatedStorage.Mouse).Hit = CFrame.new(target)
    end

    ChangeHitCF()

    local ib = game:GetService("UserInputService").InputBegan:Connect(ChangeHitCF)
    local ic = game:GetService("UserInputService").InputChanged:Connect(ChangeHitCF)

    task.wait(holdDuration)
    VIM:SendKeyEvent(false, skill, false, game)
    ib:Disconnect()
    ic:Disconnect()
end

function self.GetCurrentQuest()
    local quest_gui = PlayerGui.Main.Quest
    local guide_gui = PlayerGui.Main.Guide
    local quest_text = quest_gui.Container.QuestTitle.Title.Text
    local guide_text = guide_gui.TopFrame.Subtitle1.Text

    quest_text = quest_text:match("Defeat%s+%d*%s*(.-)%s*%(%d+/%d+%)") or quest_text:match("Defeat%s+%d*%s*(.+)")
    guide_text = guide_text:match("Defeat%s+%d*%s*(.-)%s*%(%d+/%d+%)") or guide_text:match("Defeat%s+%d*%s*(.+)")

    if quest_text and quest_text:sub(#quest_text) == "s" then quest_text = quest_text:sub(1, #quest_text - 1) end
    if guide_text and guide_text:sub(#guide_text) == "s" then guide_text = guide_text:sub(1, #guide_text - 1) end

    if quest_text == guide_text then
        return quest_text
    end
end

function self.GetProperQuest()
    local plr_lv = Player.Data.Level.Value
    local quest
    local Choice
    local index

    for i, questdata in self.QuestDatas do
        if not questdata or not questdata.Levels then self.InitQuestDatas() return end

        for choice, lv_detail in questdata.Levels do
            if lv_detail.Level > plr_lv then break end

            index = i

            quest = questdata
            Choice = choice
        end
    end

    return quest, Choice, index
end

function self.GetQuest(quest: string, choice: number)
    self.CommF_:InvokeServer("StartQuest", quest, choice)
end

function self.GetRaceInfo(): RaceInfo
    if not self.LastGetRace then
        self.LastGetRace = 0
    end

    if tick() - self.LastGetRace < 2 then return self.RaceInfo end

    local info = {Race = "Human", Version = 1, Tier = 0, QuestStatus = "N/A", PullLever = false}
    local race_data = Player:WaitForChild("Data"):WaitForChild("Race")

    local evolved = race_data:FindFirstChild("Evolved")
    local awakening = Player.Backpack:FindFirstChild("Awakening") or Player.Character:FindFirstChild("Awakening")
    local ability

    for _, v in self.RaceAbility do
        if Player.Backpack:FindFirstChild(v) or Player.Character:FindFirstChild(v) then
            ability = v

            break
        end
    end

    info.Race = race_data.Value
    info.PullLever = self.IsPullLever or false

    if awakening then
        info.Version = 4
        info.Tier = race_data:WaitForChild("C").Value

    elseif ability then
        info.Version = 3

    elseif evolved then
        info.Version = 2
    end

    if info.Version >= 3 and info.PullLever then
        local Require, current = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("UpgradeRace", "Check")

        if Require == 2 or Require == 4 or Require == 7 then
            info.QuestStatus = "Done"

        elseif Require == 1 or Require == 3 or Require == 6 or Require == 8 then
            info.QuestStatus = "On Quest"

        elseif Require == nil or Require == 0 or Require == 5 then
            info.QuestStatus = "Ready"
        end

    else
        if info.Version < 3 and not info.PullLever then
            info.QuestStatus = "Require Race V3 & Gear"

        elseif info.Version >= 3 and not info.PullLever then
            info.QuestStatus = "Require Gear"

        elseif info.Version < 3 and info.PullLever then
            info.QuestStatus = "Require Race V3"
        end
    end

    --[[    > v4 quest response <

        tier   noquest   doing   done
        0       nil      1,0    2,0
        1       0,1      3,1    4,1
        2       0,2      6,2    7,2
        3       N/A      6,3    7,3
        4       N/A      6,4    7,4
        5       0,5      8,5    7,5
        6       N/A      8,6    7,6
        7       N/A      8,7    7,7
        8       N/A      8,8    7,8
        9       N/A      8,9    7,9
        10      5,10     N/A    N/A

    ]]

    self.RaceInfo = info

    return info
end

function self.GetTrialPvpPlayers()
    local FFABorder = workspace.Map["Temple of Time"].FFABorder.Forcefield
    local FFAPos = FFABorder.Position
    local FFASize = FFABorder.Size/2

    local trial_plrs = {}

    if FFABorder.Transparency == 1 then return trial_plrs end

    for _, plr in Players:GetPlayers() do
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local pos = hrp and hrp.Position

        if char and char:GetAttribute("CharTrialId") and hrp and (pos.X > FFAPos.X - FFASize.X and pos.X < FFAPos.X + FFASize.X) and (pos.Y > FFAPos.Y - FFASize.Y and pos.Y < FFAPos.Y + FFASize.Y) and (pos.Z > FFAPos.Z - FFASize.Z and pos.Z < FFAPos.Z + FFASize.Z) then
            table.insert(trial_plrs, plr)
        end
    end

    return trial_plrs
end

function self.IsInTemple()
    local hrp = Player.Character:FindFirstChild("HumanoidRootPart")

    if not hrp then return end
    if (hrp.Position - Vector3.new(28286.35546875, 14896.544921875, 102.625)).Magnitude < 1500 and hrp.Position.Y > 14860 and hrp.Position.Y < 15139 then return true end
end

function self.TpTempleOfTime()
    if self.TempleTpConnect then return end

    self.TempleTpConnect = game:GetService("RunService").PreRender:Connect(function()
        pcall(function()
            self.CommF_:InvokeServer("RaceV4Progress", "Teleport")
            Player.Character:PivotTo(CFrame.new(28286.35546875, 14896.544921875, 102.625))
        end)
    end)

    task.delay(2, function()
        self.TempleTpConnect = self.TempleTpConnect:Disconnect()
    end)
end

function self.TpRaceDoor()
    local race_data = self.GetRaceInfo()
    local race_door = workspace.Map:WaitForChild("Temple of Time"):FindFirstChild(race_data.Race.."Corridor")

    if race_door then
        local is_in_temple = self.IsInTemple()

        if not is_in_temple then
           self.TpTempleOfTime()
           
           task.wait(2)
        end

        if not PlayerGui.Main.BottomHUDList.SafeZone.Visible then
            self.Fly()

            return

        else
            self.Fly(race_door.Door:GetPivot().Position)
        end

        self.PriorityFarming = true
    end
end

function self.isFullMoon(): boolean
    -- end clocktime = 5 time of day = 05:00:00
    -- change phase clocktime = 12 time of day = 12:00:00
    -- start clocktime = 17.8 time of day = 17:50:00
    local lighting = game:GetService("Lighting")

    return lighting:GetAttribute("MoonPhase") == 5 and (lighting.ClockTime > 12 and lighting.ClockTime > 17.8 or lighting.ClockTime < 5)
end

function self.Reroll()
    self.CommF_:InvokeServer("BlackbeardReward", "Reroll", "2")
end

function self.ReStats()
    self.CommF_:InvokeServer("BlackbeardReward", "Refund", "2")
end

-----------------------------------------------
---- ⭐ PRIORITY FUNCTIONS ⭐
-----------------------------------------------
local PriorityFunctions = {}
function PriorityFunctions.AutoFarm()
    self.PriorityFarming = true

    local Character = Player.Character
    local hrp = Character.HumanoidRootPart

    if self.Settings.FarmMethod == "Level" then
        self.Equip(self.Settings.SelectWeapon)

        local quest, Choice, index = self.GetProperQuest()

        if not quest then self.InitQuestDatas() return end

        local enemy = quest.Levels[Choice].Enemy

        local function CheckBossExist()

            local function PreviousChoice()
                Choice -= 1

                if Choice <= 0 then
                    local new_quest = self.QuestDatas[index - 1]

                    if quest.Levels[1].Level == new_quest.Levels[1].Level then
                        quest = new_quest

                        PreviousChoice()
                    else
                        quest = new_quest
                        Choice = #quest.Levels
                        index -= 1
                    end
                end

                enemy = quest.Levels[Choice].Enemy

                CheckBossExist()
            end

            local is_boss_quest = quest.Levels[Choice].KillRequire == 1

            if is_boss_quest then
                local boss_exist = self.GetClosetMon(enemy)
                
                if boss_exist then return end

                PreviousChoice()

            elseif quest.InternalQuestName:match("SkyExp1Quest") and Choice == 1 then
                PreviousChoice()
            end
        end

        CheckBossExist()

        index = table.find(self.QuestDatas, quest)

        if self.GetCurrentQuest() ~= enemy then -- got to quest giver
            local distance = (hrp.Position - quest.Position).Magnitude

            -- if quest giver too far find warp method else normal tween
            if distance > 5000 then
                if quest.InternalQuestName:match("SubmergedQuest") then
                    self.Fly(Vector3.new(-16269.408203125, 23.979995727539062, 1371.662353515625))

                    if not self.IsReachTarget() then return end

                    self.Fly()

                    task.wait(0.2)
                    game:GetService("ReplicatedStorage").Modules.Net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")

                elseif quest.InternalQuestName:match("FishmanQuest") then
                   self.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.68000793457, 1819.7840576172))

                elseif quest.InternalQuestName:match("SkyExp1Quest") then
                    self.CommF_:InvokeServer("requestEntrance", Vector3.new(-7894.6181640625, 5547.1420898438, -380.29098510742))

                else
                    local submarine_distance = (hrp.Position - Vector3.new(61180.984375, 18.731725692749023, 1618.0526123046875)).Magnitude
                    local sky2_distance = (hrp.Position - Vector3.new(-7894.6181640625, 5547.1420898438, -380.29098510742)).Magnitude

                    if self.Sea == 3 and submarine_distance < 5000 and submarine_distance < (hrp.Position - quest.Position).Magnitude then -- water go out
                        self.CommF_:InvokeServer("requestEntrance", Vector3.new(3864.6879882812, 6.7369995117188, -1926.2139892578))

                    elseif self.Sea == 1 and sky2_distance < 5000 and sky2_distance < (hrp.Position - quest.Position).Magnitude then -- sky2 go out
                        self.CommF_:InvokeServer("requestEntrance", Vector3.new(-4607.8232421875, 874.39099121094, -1667.5570068359))

                    elseif self.Sea == 3 and self.IsInTemple() then
                        if not Player.Character:FindFirstChild("TempSafeZone") then
                            self.CommF_:InvokeServer("TeleportToSpawn")
                        end

                    else
                        self.Fly(quest.Position)
                    end
                end

                task.wait(0.5)

            else
                self.Fly(quest.Position)
            end
        
            -- get quest
            if self.IsReachTarget() then
                self.Fly(hrp.Position)

                task.wait(0.2)
                
                print(quest.InternalQuestName, enemy, Choice)
                self.GetQuest(quest.InternalQuestName, Choice)
            end
        
        else -- go to mon
            local closet_mon = self.GetClosetMon(enemy)

            if closet_mon then
                local middlepos = self.BringMon(closet_mon)

                self.Fly(middlepos + Vector3.new(0, self.Settings.YPos, 0))
            else
                self.Fly(hrp.Position)
            end
        end

    elseif self.Settings.FarmMethod == "Chest" then
        if not getgenv().ChestLocation then getgenv().ChestLocation = {} end

        local function InsertIslandChestLoaction(island)
            if not getgenv().ChestLocation[island] then
                getgenv().ChestLocation[island] = {}

                for _, v in workspace:WaitForChild("Map")[island]:GetDescendants() do
                    if string.find(v.Name, "Chest") and v:IsA("BasePart") then
                        table.insert(getgenv().ChestLocation[island], v)
                    end
                end
            end
        end

        local function IsChestExist(chestLoaction)
            for _, v in workspace:WaitForChild("ChestModels"):GetChildren() do
                if (v:GetPivot().Position - chestLoaction.Position).Magnitude < 10 then
                    return true
                end
            end
        end

        local function NextChest(chestLocates)
            self._ChestNumber += 1

            if self._ChestNumber > #chestLocates then
                self._IslandNumber += 1
                self._ChestNumber = 1
                self._chest_IsInIsland = false

                if self._IslandNumber > #self.Islands[self.Sea] then
                    self._IslandNumber = 1
                end
            end
        end

        -- island
        if not self._IslandNumber then self._IslandNumber = 1 end
        if not self._ChestNumber then self._ChestNumber = 1 end

        local islandInfo = self.Islands[self.Sea][self._IslandNumber]
        local island = islandInfo.Name
        local islandPos = islandInfo.Position

        self.Fly(islandPos)

        if island == "GhostShipInterior" then
            self.Fly()

            firetouchinterest(workspace.Map.GhostShip.Teleport, Character.UpperTorso, 1)
            firetouchinterest(workspace.Map.GhostShip.Teleport, Character.UpperTorso, 0)

            task.wait(2)
        end

        if self.IsReachTarget() and not self._chest_IsInIsland then
            self._chest_IsInIsland = true

            if not getgenv().ChestLocation[island] then
                InsertIslandChestLoaction(island)
            end
        end

        if not self._chest_IsInIsland then return end

        -- chest
        local chestLocates = getgenv().ChestLocation[island]
        local chestLoacte = chestLocates[self._ChestNumber]
        local chestPos = chestLoacte and chestLoacte.Position

        if not chestLoacte then NextChest(chestLocates) return end

        self.Fly(chestPos)

        if (hrp.Position - chestPos).Magnitude > 1300 then return end

        if IsChestExist(chestLoacte) then
            if (hrp.Position - chestPos).Magnitude > 20 then return end

            task.wait(0.2)

            firetouchinterest(chestLoacte, Character.UpperTorso, 1)
            firetouchinterest(chestLoacte, Character.UpperTorso, 0)

            NextChest(chestLocates)

        else
            NextChest(chestLocates)
        end

        if island == "GhostShipInterior" and self._ChestNumber >= #chestLocates then
            firetouchinterest(workspace.Map.GhostShipInterior.Teleport, Character.UpperTorso, 1)
            firetouchinterest(workspace.Map.GhostShipInterior.Teleport, Character.UpperTorso, 0)

            task.wait(2)
        end
    end
end

function PriorityFunctions.FlyToPlayer()
    if not self.Settings.SelectPlayer then return end

    local target_plr = Players:FindFirstChild(self.Settings.SelectPlayer)
    local target_hrp = target_plr and target_plr.Character:FindFirstChild("HumanoidRootPart")

    if target_hrp then
        self.PriorityFarming = true

        self.Fly(target_hrp.Position + Vector3.new(0, self.Settings.YPos, 0))
    end
end

function PriorityFunctions.AutoRaceDoor()
    local race_info = self.GetRaceInfo()
    local race_door = workspace.Map:WaitForChild("Temple of Time"):FindFirstChild(race_info.Race.."Corridor")
    local trail_pvp_plrs = self.GetTrialPvpPlayers()

    if race_door and race_door.Door:GetAttribute("State") == "Open" then
        if self.Target == race_door.Door:GetPivot().Position then
            self.Fly()
        end

        return

    elseif race_info.QuestStatus == "Ready" or race_info.Tier >= 5 and not table.find(trail_pvp_plrs, Player) then
        self.TpRaceDoor()
    end
end

function PriorityFunctions.AutoKillTrial()
    local trail_pvp_plrs = self.GetTrialPvpPlayers()

    local closet_plr
    local closet_distance

    for _, plr in trail_pvp_plrs do
        local target_char = plr.Character
        local distance = target_char.HumanoidRootPart.Position

        if plr ~= Player and target_char.Humanoid.Health > 0 and (not closet_distance or distance < closet_distance) then
            closet_plr = plr
            closet_distance = distance
        end
    end

    if closet_plr then
        local target_htp = closet_plr.Character:FindFirstChild("HumanoidRootPart")

        if target_htp then
            self.PriorityFarming = true
            self.Fly(target_htp.Position + Vector3.new(0, self.Settings.YPos, 0))
            self.Attack()

            if target_htp.Parent.Humanoid.Health <= 0 then
                self.Fly()
            end

        else
            self.Fly()
        end
    end
end

function PriorityFunctions.AutoCompleteTrial() -- incomplete
    local Character = Player.Character
    local race = Player.Data.Race.Value

    local trial_map = workspace.Map:FindFirstChild(self.TrialName[race])

    if trial_map and Character:GetAttribute("CharTrialId") and (trial_map:GetPivot().Position - Character:GetPivot().Position).Magnitude < (Vector3.new(28286.35546875, 14896.544921875, 102.625) - Character:GetPivot().Position).Magnitude then

        self.PriorityFarming = true

        self.Fly()

        if race == "Skypiea" then
            Character:PivotTo(workspace.Map.SkyTrial.Model.FinishPart:GetPivot())

        elseif race == "Mink" then
            Character:PivotTo(workspace.StartPoint:GetPivot())

        elseif race == "Human" then
            local boss = workspace.Enemies:GetChildren()[1]

            if boss then
                self.Fly(boss.HumanoidRootPart.Position + Vector3.new(0, self.Settings.YPos, 0))
            end

            self.Equip(self.Settings.SelectWeapon)
        end
    end
end

function PriorityFunctions.FlyToIsland()
    if not self.Settings.SelectIsland then return end

    self.PriorityFarming = true

    self.Fly(self.Islands[self.Sea][self.Settings.SelectIsland].Position)
end

-----------------------------------------------
---- 🤖 AUTOMATION FUNCTIONS 🤖
-----------------------------------------------
local AutomationFunctions = {}
function AutomationFunctions.SaveSetting()
    if not self.LastSave then
        self.LastSave = 0
    end

    if tick() - self.LastSave < 1 then return end

    self.LastSave = tick()

    local http = game:GetService("HttpService")

    makefolder("Apex Hub Script")
    makefolder("Apex Hub Script/Settings")
    writefile("Apex Hub Script/Settings/Bloxfruit.json", http:JSONEncode(self.Settings))
end

function AutomationFunctions.WalkOnWater()
    local water_part = workspace.Map:FindFirstChild("WaterBase-Plane") or workspace._WorldOrigin:FindFirstChild("WaterBase-Plane")

    if water_part then
        water_part.Size = self.Settings.WalkOnWater and Vector3.new(1000, 112, 1000) or Vector3.new(1000, 80, 1000)
    end
end

function AutomationFunctions.AutoStats()
    local select_stat_values = {}

    for _, stat in Player.Data.Stats:GetChildren() do
        if table.find(self.Settings.SelectedStats, stat.Name) then
            table.insert(select_stat_values, {Stat = stat.Name, Level = stat.Level.Value})
        end
    end

    table.sort(select_stat_values, function(a, b)
        return a.Level < b.Level
    end)

    if Player.Data.Points.Value > 0 and select_stat_values[1] then
        self.CommF_:InvokeServer("AddPoint", select_stat_values[1].Stat, 1) 
    end
end

function AutomationFunctions.AutoHaki()
    if not Player.Character:GetAttribute("BusoEnabled") then
       self.CommF_:InvokeServer("Buso")
    end
end

function AutomationFunctions.AutoAttack()
    self.Attack()
end

function AutomationFunctions.AutoTranform()
    if not Player.Character:FindFirstChild("RaceEnergy") then return end

    if Player.Character.RaceEnergy.Value == 1 then
        if not Player.Character.RaceTransformed.Value then
            game:GetService("ReplicatedStorage").Events.ActivateRaceV4:Fire()
        end
    end
end

function AutomationFunctions.AutoEnablePvp()
    if Player:GetAttribute("PvpDisabled") then
        self.CommF_:InvokeServer("EnablePvp")
    end
end

function AutomationFunctions.AutoFollowHostAbility()
    if not self.Settings.SelectRaceHost then return end

    local host_plr = Players:FindFirstChild(self.Settings.SelectRaceHost)
    local host_hrp = host_plr and host_plr.Character:FindFirstChild("HumanoidRootPart")

    if host_hrp then
        for _, ability in self.RaceAbility do
            if host_hrp:FindFirstChild(ability) then
                game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")

                return
            end
        end
    end
end

function AutomationFunctions.AutoBuyTier()
    local race_info = self.GetRaceInfo()

    if not self.LastTierBuy then
        self.LastTierBuy = 0
    end

    if race_info.QuestStatus == "Done" and tick() - self.LastTierBuy > 1 then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("UpgradeRace", "Buy")

        self.LastTierBuy = tick()
    end
end

function AutomationFunctions.AutoChoseGear()
    local gears = {"Alpha", "Omega"}

    if not self.LastGearBuy then
        self.LastGearBuy = 0
    end

    if tick() - self.LastGearBuy < 1 then return end

    self.LastGearBuy = tick()

    --[[
        -- tier 1 gear remote
        self.CommF_:InvokeServer("TempleClock", "SpendPoint")

        -- tier 2 gear remote
        Event:InvokeServer(
            "TempleClock",
            "SpendPoint",
            "Gear2",
            "Alpha"
        )

        -- tier 3-5 gear remote
        Event:InvokeServer(
            "TempleClock",
            "SpendPoint",
            "Gear3",
            "Alpha"
        )

        -- tier 5-10
        Event:InvokeServer(
            "TempleClock",
            "SpendPoint",
            "Gear4",
            "Omega"
        )
    ]]

    local race_info = self.GetRaceInfo()
    local gear
    local tier = Player.Data.Race.C.Value

    if tier == 0 then
        self.CommF_:InvokeServer("TempleClock", "SpendPoint")
        return

    elseif tier == 1 then
        gear = "Gear2"
    elseif tier == 2 then
        gear = "Gear3"
    elseif tier == 5 then
        gear = "Gear4"
    end

    self.CommF_:InvokeServer("TempleClock", "SpendPoint", (race_info.Tier > 5 and "Gear"..math.random(2, 4) or gear), gears[math.random(1, #gears)])
end

function AutomationFunctions.AutoResetCharTrial()
    local trail_pvp_plrs = self.GetTrialPvpPlayers()

    if #trail_pvp_plrs > 1 and table.find(trail_pvp_plrs, Player) and not PlayerGui.Main.BottomHUDList.SafeZone.Visible then
        task.wait(1)
        Player.Character.Humanoid.Health = 0
    end
end

function AutomationFunctions.UpdatePlayerDropdowns()
    for _, dropdown in self.PlayerDropdown do

        local Dropdown = dropdown.Dropdown
        local select_plr = self.Settings[dropdown.SelectVar]
        local AllPlayer = {}

        for _, plr in Players:GetPlayers() do
            if plr == Player then continue end

            table.insert(AllPlayer, plr.Name)
        end

        if select_plr and not table.find(AllPlayer, select_plr) then
            table.insert(AllPlayer, select_plr)
        end

        if #Dropdown.Options ~= #AllPlayer then
            for i = #Dropdown.Options, 1 do
                Dropdown:Remove(i)
            end

            for _, plr in AllPlayer do
                Dropdown:Option(plr)
            end

            Dropdown.Options = AllPlayer
        end
    end
end

function AutomationFunctions.UpdateRaceStatus()
    if not self.V4Status then return end

    local race_info = self.GetRaceInfo()
    local quest_status = race_info.QuestStatus

    self.V4Status.Race.Text         = race_info.Race
    self.V4Status.Version.Text      = race_info.Version
    self.V4Status.Tier.Text         = race_info.Tier
    self.V4Status.QuestStatus.Text  = quest_status

    self.V4Status.Race.TextColor3         = Color3.fromRGB(255, 255, 0)
    self.V4Status.Version.TextColor3      = Color3.fromRGB(255, 255, 0)
    self.V4Status.Tier.TextColor3         = Color3.fromRGB(255, 255, 0)
    self.V4Status.QuestStatus.TextColor3  = ((quest_status == "Ready" or quest_status == "Done") and Color3.fromRGB(0, 255, 0)) or (quest_status == "On Quest" and Color3.fromRGB(255, 170, 0)) or Color3.fromRGB(255, 0, 0)

    if race_info.Tier >= 5 and quest_status ~= "Ready" then
        self.V4Status.QuestStatus.RichText = true
        self.V4Status.QuestStatus.Text = `<font color='#00ff00'>Ready</font> , {quest_status}`
    end

    self.V4Status.Race.TextTransparency         = 0
    self.V4Status.Version.TextTransparency      = 0
    self.V4Status.Tier.TextTransparency         = 0
    self.V4Status.QuestStatus.TextTransparency  = 0
end

function AutomationFunctions.UpdateQuestDatas()
    if not self._LastQuestDataUpdate then
        self._LastQuestDataUpdate = 0
    end

    if tick() - self._LastQuestDataUpdate < 1 then return end
    self._LastQuestDataUpdate = tick()

    local plr_lv = Player.Data.Level.Value
    local quest, choice, index = self.GetProperQuest()

    if plr_lv - quest.Levels[choice].Level > 75 then
        self.InitQuestDatas()

    else
        self._LastQuestDataUpdate = tick() + 5
    end
end

-----------------------------------------------
---- 🔰 INIT 🔰
-----------------------------------------------
repeat task.wait() until game:IsLoaded() and workspace:GetAttribute("MAP")
self.LoadSave()
self.InitConfig()
self.AntiAFK()
self.InitSea()
self.InitQuestDatas()
self.InitTeam()
self.InitBodyType()
self.SetPriority()
self.InitTempleOfTime()
self.InitRaceAbility()
self.InitTrialName()
self.InitIsland()
self.InitRejoin()
self.InitAutoExecute()

-----------------------------------------------
---- 🪟 CREATE GUI 🪟
-----------------------------------------------
do
    local cascade = loadstring(game:HttpGet("https://raw.githubusercontent.com/1makam1/Main/refs/heads/main/dist.luau"))()
    local userInputService = cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
    local minimizeKeybind = Enum.KeyCode.RightControl

    self.app = cascade.New({WindowPill = true, Theme = cascade.Themes.Dark})

    local window = self.app:Window({Title = "Blox Fruit", Subtitle = "Apex Hub", Size = userInputService.TouchEnabled and UDim2.fromOffset(550, 325) or UDim2.fromOffset(850, 530)})

    local function titledRow(parent: any, title: string, subtitle: string?) -- You can use this to automate the process of creating similar rows.
        local row = parent:Row({SearchIndex = title})
        
        row:Left():TitleStack({Title = title, Subtitle = subtitle})

        return row
    end

    do -- set window
        --// minimize
        userInputService.InputEnded:Connect(function(input, gameProcessedEvent)
            if input.KeyCode == minimizeKeybind and not gameProcessedEvent then
                window.Minimized = not window.Minimized
            end
        end)
        
        self.CloseConnect = window.Destroying:Connect(function() if getgenv().CleanUpApexHub then getgenv().CleanUpApexHub() end end)

        -- set sidebar size
        window.Sidebar.Size = UDim2.new(0, 215, 1, 0)
        window.Sidebar.Margins.Size = UDim2.new(1, 0, 1, 0)

        self.PlayerDropdown = {}
    end

    do -- Main window
        do-- Main Functions section
            local section = window:Section({Disclosure = false, Title = "Main Functions"})

            do -- Auto farm tab
                local tab = section:Tab({Selected = true, Title = "Auto farm", Icon = cascade.Symbols.house})

                do -- Settings Form
                    local form = tab:PageSection({Title = "Auto Farm Settings"}):Form()

                    do -- slect weapon
                        local weapons = {"Melee", "Sword", "Demon Fruit"}

                        local row = titledRow(form, "Select Weapon", "select farm weapon type.")
                        local popUpButton = row:Right():PopUpButton({
                            Options = weapons,
                            Value = self.Settings.SelectWeapon and table.find(weapons, self.Settings.SelectWeapon) or 1,
                            ValueChanged = function(_self, value: number)
                                self.Settings.SelectWeapon = _self.Options[value]
                            end,
                        })
                    end

                    do -- farm method
                        local farm_method =  {"Level", "Chest"}

                        local row = titledRow(form, "Farm Method", "select auto farm method.")
                        local popUpButton = row:Right():PopUpButton({
                            Options = farm_method,
                            Value = self.Settings.FarmMethod and table.find(farm_method, self.Settings.FarmMethod) or 1,
                            ValueChanged = function(_self, value: number)
                                self.Settings.FarmMethod = _self.Options[value]
                            end,
                        })
                    end

                    do -- auto attack
                        local row = titledRow(
                            form,
                            "Auto Attack",
                            "auto attack close mon and player."
                        )

                        row:Right():Toggle({
                            Value = self.Settings.AutoAttack or false,
                            ValueChanged = function(_self, value: boolean)
                                self.Settings.AutoAttack = value
                            end,
                        })
                    end

                    do -- tween speed
                        local row = titledRow(
                            form,
                            "Tween Speed",
                            "change how fast you fly."
                        )
                        
                        local lb = row:Right():Label({Text = math.round(self.Settings.TweenSpeed) or 3})

                        row:Right():Slider({
                            Value = self.Settings.TweenSpeed and self.Settings.TweenSpeed/10 or 0.3,
                            ValueChanged = function(_self, value: number)
                                self.Settings.TweenSpeed = value * 10
                                lb.Text = math.round(self.Settings.TweenSpeed)
                            end,
                        })
                    end

                    do -- Y Pos
                        local row = titledRow(
                            form,
                            "Y position",
                            "farm y distance."
                        )

                        local lb = row:Right():Label({Text = math.round(self.Settings.YPos) or 15})

                        row:Right():Slider({
                            Value = self.Settings.YPos and self.Settings.YPos/30 or 0.5,
                            ValueChanged = function(_self, value: number)
                                self.Settings.YPos = value * 30
                                lb.Text = math.round(self.Settings.YPos)
                            end,
                        })
                    end

                    do -- teleport distance
                        local row = titledRow(
                            form,
                            "Teleport distance",
                            "teleport when distance lower than this."
                        )

                        local lb = row:Right():Label({Text = math.round(self.Settings.TeleportAtDistance) or 200})

                        row:Right():Slider({
                            Value = self.Settings.TeleportAtDistance and self.Settings.TeleportAtDistance/500 or 0.4,

                            ValueChanged = function(_self, value: number)
                                self.Settings.TeleportAtDistance = value * 500
                                lb.Text = math.round(self.Settings.TeleportAtDistance)
                            end,
                        })
                    end
                end

                do -- stats Form
                    local form = tab:PageSection({Title = "Stats"}):Form()

                    do -- select stats
                        local statsloaded = false
                        local row = titledRow(form, "Select Stats", "select multiple will make selected stats balance.")
                        local popUpButton = row:Right():PopUpButton({
                            Options = {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"},
                            Maximum = 5,
                            Value = {},
                            ValueChanged = function(_self, value)
                                if statsloaded then self.Settings.SelectedStats = {} end

                                for _, v in value do
                                    table.insert(self.Settings.SelectedStats, _self.Options[v])
                                end
                            end
                        })

                        local selected_stats = {}

                        if not self.Settings.SelectedStats then
                            self.Settings.SelectedStats = {}
                        end

                        for _, v in self.Settings.SelectedStats do
                            table.insert(selected_stats, table.find(popUpButton.Options, v))
                        end

                        popUpButton.Value = selected_stats

                        statsloaded = true
                    end

                    do -- auto farm
                        local row = titledRow(
                            form,
                            "Auto Stats",
                            "auto up selected stats."
                        )

                        row:Right():Toggle({
                            Value = self.Settings.AutoStats or false,
                            ValueChanged = function(_self, value: boolean)
                                self.Settings.AutoStats = value
                            end,
                        })
                    end
                end

                do -- Priority Form
                    local form = tab:PageSection({Title = "Priority"}):Form()
                    local PriorityDropdown
                    local selected_function
                    local selected_priority

                    do -- view priority
                        local row = titledRow(form, "Priority", "script will do the top priority first.")
                        local popUpButton = row:Right():PopUpButton({
                            Options = self.Settings.Priority,
                            ValueChanged = function(_self, value: number)
                                if value == 0 then
                                    selected_function = nil
                                else
                                    selected_function = _self.Options[value]:split(" : ")[1]
                                end
                            end
                        })

                        PriorityDropdown = popUpButton
                    end

                    do -- select priority
                        local row = titledRow(form, "Select Priority", "select priority to change.")
                        local popUpButton = row:Right():PopUpButton({
                            Options = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"},
                            ValueChanged = function(_self, value: number)
                                selected_priority = value
                            end
                        })
                    end

                    do -- change priority
                        local row = titledRow(form, "Change Priority", "change function priority.")

                        row:Right():Button({
                            Label = "Set Priority",
                            State = "Primary",
                            Pushed = function(_self)
                                PriorityDropdown.Options = self.SetPriority(selected_function, selected_priority)

                                PriorityDropdown.Value = 0
                            end
                        })
                    end
                end

                do -- Auto Farm Form
                    local form = tab:PageSection({Title = "Farm"}):Form()

                    do -- auto farm
                        local row = titledRow(
                            form,
                            "Auto Farm",
                            "auto farm selected method."
                        )

                        row:Right():Toggle({
                            Value = self.Settings.AutoFarm or false,
                            ValueChanged = function(_self, value: boolean)
                                self.Settings.AutoFarm = value

                                if not value then
                                    self.Fly()
                                end
                            end,
                        })
                    end
                end
                
            end

            do -- Player tab
                local tab = section:Tab({Selected = false, Title = "Players", Icon = "rbxassetid://16781409545"})

                do -- Players Form
                    local form = tab:PageSection({Title = "Players"}):Form()

                    do -- slect player
                        local row = titledRow(form, "Select Player")
                        local popUpButton = row:Right():PopUpButton({
                            Options = self.Settings.SelectPlayer and {self.Settings.SelectPlayer} or {},
                            Value = 1,
                            ValueChanged = function(_self, value: number)
                                self.Settings.SelectPlayer = _self.Options[value]
                            end,
                        })

                        table.insert(self.PlayerDropdown, {Dropdown = popUpButton, SelectVar = "SelectPlayer"})
                    end
                end

                do -- Actions Form
                    local form = tab:PageSection({Title = "Action"}):Form()

                    do -- fly to player
                        local row = titledRow(form, "Fly To Player", "fly to selected player.")

                        row:Right():Toggle({
                            Value = self.Settings.FlyToPlayer or false,
                            ValueChanged = function(_self, value: boolean)
                                self.Settings.FlyToPlayer = value

                                if not value then
                                    self.Fly()
                                end
                            end
                        })
                    end

                    do -- auto eneble pvp
                        local row = titledRow(form, "Auto Eneble Pvp")

                        row:Right():Toggle({
                            Value = self.Settings.AutoEnablePvp or false,
                            ValueChanged = function(_self, value: boolean)
                                self.Settings.AutoEnablePvp = value
                            end,
                        })
                    end
                end
            end

            do -- race tab

                local tab = section:Tab({Selected = false, Title = "Race", Icon = cascade.Symbols.eyeTrianglebadgeExclamationmark})

                do -- status
                    local form = tab:PageSection({Title = "Status"}):Form()

                    self.V4Status = {}

                    self.V4Status.Race = titledRow(form, "Race :"):Left():Label({Text = "N/A"})
                    self.V4Status.Version = titledRow(form, "Version :"):Left():Label({Text = "N/A"})
                    self.V4Status.Tier = titledRow(form, "Tier :"):Left():Label({Text = "N/A"})
                    self.V4Status.QuestStatus = titledRow(form, "Trial Status :"):Left():Label({Text = "N/A"})
                end

                do -- V4 Group
                    local form = tab:PageSection({Title = "V4 Group"}):Form()

                    do -- slect host
                        local row = titledRow(form, "Select Group Host")
                        local popUpButton = row:Right():PopUpButton({
                            Options = self.Settings.SelectRaceHost and {self.Settings.SelectRaceHost} or {},
                            Value = 1,
                            ValueChanged = function(_self, value: number)
                                self.Settings.SelectRaceHost = _self.Options[value]
                            end,
                        })

                        table.insert(self.PlayerDropdown, {Dropdown = popUpButton, SelectVar = "SelectRaceHost"})
                    end

                    titledRow(form, "Auto Follow Host Ability"):Right():Toggle({Value = self.Settings.AutoFollowHostAbility or false, ValueChanged = function(_self, value: boolean) self.Settings.AutoFollowHostAbility = value end})
                end

                do -- Automation Form
                    local form = tab:PageSection({Title = "Automation (Incomplete 🔴)"}):Form()

                    titledRow(form, "Auto Complete Trial"):Right():Toggle({Value = self.Settings.AutoCompleteTrial or false, ValueChanged = function(_self, value: boolean) self.Settings.AutoCompleteTrial = value end})
                    titledRow(form, "Auto Reset Character"):Right():Toggle({Value = self.Settings.AutoResetCharTrial or false, ValueChanged = function(_self, value: boolean) self.Settings.AutoResetCharTrial = value end})
                    titledRow(form, "Auto Kill Trial Players"):Right():Toggle({Value = self.Settings.AutoKillTrial or false, ValueChanged = function(_self, value: boolean) self.Settings.AutoKillTrial = value end})
                    titledRow(form, "Auto Race Door", "Tp to race door when ready."):Right():Toggle({Value = self.Settings.AutoRaceDoor or false, ValueChanged = function(_self, value: boolean)self.Settings.AutoRaceDoor = value if not value then for i = 1, 10 do self.Fly() task.wait(0.1) end end end})
                    titledRow(form, "Auto Buy Tier"):Right():Toggle({Value = self.Settings.AutoBuyTier or false, ValueChanged = function(_self, value: boolean) self.Settings.AutoBuyTier = value end})
                    titledRow(form, "Auto Chose Gear"):Right():Toggle({Value = self.Settings.AutoChoseGear or false, ValueChanged = function(_self, value: boolean) self.Settings.AutoChoseGear = value end})
                    titledRow(form, "Auto Awakening Tranform"):Right():Toggle({Value = self.Settings.AutoTranform or false, ValueChanged = function(_self, value: boolean) self.Settings.AutoTranform = value end})
                end

                do -- teleport Form
                    local form = tab:PageSection({Title = "Teleport"}):Form()

                    titledRow(form, "Go To Temple Of Time"):Right():Button({Label = "  >  ", State = "Primary", Pushed = self.TpTempleOfTime})
                    titledRow(form, "Go To Race Door"):Right():Button({Label = "  >  ", State = "Primary", Pushed = function() self.TpRaceDoor() task.wait(3) self.Fly() end})
                end
            end

            do -- teleport tab

                local tab = section:Tab({Selected = false, Title = "Teleport", Icon = "rbxassetid://12941020168"})

                do -- Swa Form
                    local form = tab:PageSection({Title = "Sea"}):Form()

                    titledRow(form, "Sea1"):Right():Button({Label = "  >  ", State = "Primary", Pushed = function(_self) self.CommF_:InvokeServer("TravelMain") end})
                    titledRow(form, "Sea2"):Right():Button({Label = "  >  ", State = "Primary", Pushed = function(_self) self.CommF_:InvokeServer("TravelDressrosa") end})
                    titledRow(form, "Sea3"):Right():Button({Label = "  >  ", State = "Primary", Pushed = function(_self) self.CommF_:InvokeServer("TravelZou") end})
                end

                do -- Island Form
                    local form = tab:PageSection({Title = "Islands"}):Form()

                    do -- island dropdown
                        local row = titledRow(form, "Select Island")
                        local popUpButton = row:Right():PopUpButton({
                            Options = {},
                            Value = 0,
                            ValueChanged = function(_self, value: number)
                                self.Settings.SelectIsland = value
                            end,
                        })

                        for i, island in self.Islands[self.Sea] do
                            popUpButton:Option(island.Name)
                        end
                    end
                    
                    do -- Fly to island
                        local row = titledRow(form, "Fly to island")

                        row:Right():Toggle({
                            Value = false,
                            ValueChanged = function(_self, value: boolean)
                                self.Settings.FlyToIsland = value

                                if not value then
                                    self.Fly()
                                end
                            end,
                        })

                        self.Settings.FlyToIsland = false
                    end
                end
            end

            do -- Shop tab

                local tab = section:Tab({Selected = false, Title = "Shop", Icon = "http://www.roblox.com/asset/?id=11385419674"})

                do -- Ability Form
                    local form = tab:PageSection({Title = "Ability"}):Form()

                    titledRow(form, "Buy Sky Jump"):Right():Button({Label = "  >  ", State = "Primary", Pushed = function(_self) self.CommF_:InvokeServer("BuyHaki", "Geppo") end})
                    titledRow(form, "Buy Haki"):Right():Button({Label = "  >  ", State = "Primary", Pushed = function(_self) self.CommF_:InvokeServer("BuyHaki", "Buso") end})
                    titledRow(form, "Buy Flash Step"):Right():Button({Label = "  >  ", State = "Primary", Pushed = function(_self) self.CommF_:InvokeServer("BuyHaki", "Soru") end})
                end

                do -- reset Form
                    local form = tab:PageSection({Title = "Buy With Fragment"}):Form()

                    titledRow(form, "Stats Refund"):Right():Button({Label = "  >  ", State = "Primary", Pushed = self.ReStats})
                    titledRow(form, "Race Reroll"):Right():Button({Label = "  >  ", State = "Primary", Pushed = self.Reroll})
                end

                do -- Team Form
                    local form = tab:PageSection({Title = "Team"}):Form()

                    titledRow(form, "Join Pirate"):Right():Button({Label = "  >  ", State = "Primary", Pushed = function(_self) self.CommF_:InvokeServer("SetTeam", "Pirates") end})
                    titledRow(form, "Join Marine"):Right():Button({Label = "  >  ", State = "Primary", Pushed = function(_self) self.CommF_:InvokeServer("SetTeam", "Marines") end})
                end
            end

            do -- Miscellaneous tab

                local tab = section:Tab({Selected = false, Title = "Miscellaneous", Icon = cascade.Symbols.sparkles})

                do -- Ability Form
                    local form = tab:PageSection({Title = "Ability"}):Form()

                    titledRow(form, "Auto Haki"):Right():Toggle({Value = self.Settings.AutoHaki or false, ValueChanged = function(_self, value: boolean) self.Settings.AutoHaki = value end})
                end

                do -- Other Form
                    local form = tab:PageSection({Title = "Other"}):Form()

                    titledRow(form, "Walk on water"):Right():Toggle({Value = self.Settings.WalkOnWater or false, ValueChanged = function(_self, value: boolean) self.Settings.WalkOnWater = value end})
                    titledRow(form, "Auto Rejoin", "rejoin same server when got kicked."):Right():Toggle({Value = self.Settings.AutoRejoin or false, ValueChanged = function(_self, value: boolean) self.Settings.AutoRejoin = value end})
                    titledRow(form, "Auto Execute", "auto run script when change server."):Right():Toggle({Value = self.Settings.AutoExecute or false, ValueChanged = function(_self, value: boolean) self.Settings.AutoExecute = value end})
                end
            end

            do -- gui setting tab
                local tab = section:Tab({Title = "GUI Setting", Icon = "http://www.roblox.com/asset/?id=70542492197391"})

                do -- Appearance
                    local form = tab:PageSection({ Title = "Appearance" }):Form()

                    do -- Dark mode
                        local row = titledRow(
                            form,
                            "Dark mode",
                            "An application appearance setting that uses a dark color palette to provide a comfortable viewing experience tailored for low-light environments."
                        )

                        row:Right():Toggle({
                            Value = true,
                            ValueChanged = function(_self, value: boolean)
                                self.app.Theme = value and cascade.Themes.Dark or cascade.Themes.Light
                            end,
                        })
                    end
                end

                do -- Input
                    local form = tab:PageSection({ Title = "Input" }):Form()

                    do -- Minimize shortcut
                        local row = titledRow(form, "Minimize shortcut")

                        row:Right():KeybindField({
                            Value = minimizeKeybind,
                            ValueChanged = function(_self, value: Enum.KeyCode)
                                minimizeKeybind = value
                            end,
                        })
                    end

                    do -- Searching
                        local row = titledRow(
                            form,
                            "Searchable",
                            "Allows users to search for content in a page with a search-field in the titlebar."
                        )

                        row:Right():Toggle({
                            Value = window.Searching,
                            ValueChanged = function(_self, value: boolean)
                                window.Searching = value
                            end,
                        })
                    end

                    do -- Draggable
                        local row =
                            titledRow(form, "Draggable", "Allows users to move the window with a mouse or touch device.")

                        row:Right():Toggle({
                            Value = window.Draggable,
                            ValueChanged = function(_self, value: boolean)
                                window.Draggable = value
                            end,
                        })
                    end

                    do -- Resizable
                        local row =
                            titledRow(form, "Resizable", "Allows users to resize the window with a mouse or touch device.")

                        row:Right():Toggle({
                            Value = window.Resizable,
                            ValueChanged = function(_self, value: boolean)
                                window.Resizable = value
                            end,
                        })
                    end
                end

                do -- Effects
                    local form = tab:PageSection({
                        Title = "Effects",
                        Subtitle = "These effects may be resource intensive across different systems.",
                    }):Form()

                    do -- Dropshadow
                        local row = titledRow(form, "Dropshadow", "Enables a dropshadow effect on the window.")

                        row:Right():Toggle({
                            Value = window.Dropshadow,
                            ValueChanged = function(_self, value: boolean)
                                window.Dropshadow = value
                            end,
                        })
                    end

                    do -- UI Blur
                        local row = titledRow(
                            form,
                            "Background blur",
                            "Enables a UI background blur effect on the window. This can be detectable in some games."
                        )

                        row:Right():Toggle({
                            Value = window.UIBlur,
                            ValueChanged = function(_self, value: boolean)
                                window.UIBlur = value
                            end,
                        })
                    end
                end
            end
        end
    end
end

-----------------------------------------------
---- ♾️ MAIN LOOP ♾️
-----------------------------------------------
self.MainLoop = task.spawn(function()
    while task.wait() do
        local s, r

        self.PriorityFarming = false

        for funcname, func in AutomationFunctions do
            if self.Settings[funcname] or not funcname:match("Auto") then
                task.spawn(function() s, r = pcall(func); if not s then warn(r) end end)
            end
        end

        for _, funcname in self.Settings.Priority do
            funcname = funcname:match("^(.-)%s*%:")

            if not self.PriorityFarming and self.Settings[funcname] then
                s, r = pcall(PriorityFunctions[funcname]); if not s then warn(r) end
            end
        end
    end
end)

-----------------------------------------------
---- 🗑️ CLEAN UP 🗑️
-----------------------------------------------
if getgenv().CleanUpApexHub then
    getgenv().CleanUpApexHub()
end

getgenv().CleanUpApexHub = function()
    for _, v in self do
        if typeof(v) == "thread" then
            task.cancel(v)

        elseif typeof(v) == "RBXScriptConnection" then
            v:Disconnect()
        end
    end

    self.Fly()
    pcall(function() self.app:Destroy() end)

    self.Settings.WalkOnWater = false
    AutomationFunctions.WalkOnWater()
end

--[[

--v2 quest
self.CommF_:InvokeServer("Alchemist", "2")
-- v2 complete
self.CommF_:InvokeServer("Alchemist", "3")

-- v3 quest
self.CommF_:InvokeServer("Wenlocktoad", "2")
-- v3 complete
self.CommF_:InvokeServer("Wenlocktoad", "3")

]]
