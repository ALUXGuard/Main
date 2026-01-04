type Setting = {
    -- toggle function
    AutoFarm:               boolean,
    AutoAttack:             boolean,
    AutoStats:              boolean,
    AutoBoss:               boolean,

    -- data
    PriorityFarming:        boolean,
    TweenSpeed:             number,
    YPos:                   number,
    TeleportAtDistance:     number,
    FarmMethod:             {},
    Priority:               {},
}

local self = {}
self.Settings = {} :: Setting

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Game = "KanomTokyo"

-----------------------------------------------
---- 🔑 KEY SYSTEM 🔑
-----------------------------------------------
function self.MakeKeyPopup()
	local JunkieKeySystem = loadstring(game:HttpGet("https://junkie-development.de/sdk/JunkieKeySystem.lua"))()

	local API_KEY = "2383bf96-9085-4015-b6f9-476b19ffe24d"
	local SERVICE = "GenKey"
	local PROVIDER = "GetKey"

    if not isfile("Apex Hub Script") then
        makefolder("Apex Hub Script")

        if not isfile(`Apex Hub Script/{Game} Key.txt`) then
            writefile(`Apex Hub Script/{Game} Key.txt`, "")
        end
    end

    if JunkieKeySystem.verifyKey(API_KEY, readfile(`Apex Hub Script/{Game} Key.txt`), SERVICE) == true then
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

    local keyendevent = Instance.new("BindableEvent")
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

		if isValid == true then
            writefile(`Apex Hub Script/{Game} Key.txt`, key)
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
    keyendevent:Destroy()

    return keyresponse
end

local keyresult = self.MakeKeyPopup()
if keyresult == "Close" then return end

-----------------------------------------------
---- 🚩 INIT FUNCTIONS 🚩
-----------------------------------------------
function self.LoadSave()
    if isfile(`Apex Hub Script/Settings/{Game}.json`) then
        local http = game:GetService("HttpService")

        makefolder("Apex Hub Script")
        makefolder("Apex Hub Script/Settings")
        self.Settings = http:JSONDecode(readfile(`Apex Hub Script/Settings/{Game}.json`))
    end
end

function self.InitConfig()
    if not getgenv().ApexConfig then
        getgenv().ApexConfig = {}
    end
end

function self.InitBodyType()
    local Character = Player.Character or Player.CharacterAdded:Wait()

    self.BodyType = Character:FindFirstChild("Torso") and "R6" or "R15"
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

    local priority_temlate = {"AutoBoss : 2", "AutoFarm : 1"}

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

function self.InitTeam()
    for _, v in workspace:GetChildren() do
        local Selection = v:FindFirstChild("Selection")
        
        if Selection then
            for i = 1, 5 do
                local pos = workspace.CurrentCamera:WorldToViewportPoint(Selection.GHOUL.Meat.Position)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
                
                task.wait(0.2)
            end
        end
    end
end

function self.InitComponent()
    -- quest remote
    local function GetRemotes()
        for _, v in getgc(true) do
            if type(v) == "function" then
                if debug.info(v, "s"):match(".Modules.Client.Game.Quest") then
                    for _, j in getupvalues(v) do
                        if typeof(j) == "Instance" and j.ClassName == "RemoteEvent" then
                            self.QuestRE = j
                        end
                    end
                elseif debug.info(v, "s"):match(".PlayerGui.Menu.Modules.PvPToggle") then
                    for _, j in getupvalues(v) do
                        if typeof(j) == "Instance" and j.ClassName == "RemoteFunction" then
                            self.PvptRF = j
                        end
                    end
                end
            end
        end

        local questRE = game:GetService("ReplicatedStorage"):WaitForChild("Network"):FindFirstChild("Quest")
        local pvpRF = game:GetService("ReplicatedStorage"):WaitForChild("Network"):FindFirstChild("Pvp Toggle")

        if questRE then self.QuestRE = questRE end
        if pvpRF then self.PvptRF = pvpRF end
    end

    local function GetQuestModules()
        self.quest_modules = {}

        for _, v in game:GetService("ReplicatedStorage").Modules.Client.TalkNpc.Quests:GetChildren() do
            local text = v.Name
            local minLv, maxLv = text:match("Lv%.?(%d+)%s*%-Lv%.?(%d+)")

            if minLv then
                table.insert(self.quest_modules, {Path = v.Quest, Min = tonumber(minLv), Max = tonumber(maxLv)})
            end
        end
    end

    GetRemotes()
    GetQuestModules()
end

-----------------------------------------------
---- 🏠 MAIN FUNCTIONS 🏠
-----------------------------------------------
function self.Fly(target: Vector3)
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

            self.Target = target

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

function self.GetClosetMon(monnames: {string})
    local closetmon
    local closetdistance

    local function CheckChildren(path, boss: boolean?)
        for _, v in path:GetChildren() do
            if v.ClassName == "Folder" then continue end

            local distance = (v:GetPivot().Position - Player.Character.HumanoidRootPart.Position).Magnitude
            local hum = v:FindFirstChild("Humanoid")
            local found

            if boss then
                for _, j in monnames do
                    if v.Name:match(j) then
                        found = true

                        break
                    end
                end
            end

            if (boss and found or table.find(monnames, v.Name)) and (not closetdistance or distance < closetdistance) and (hum and hum.Health > 0) and v:GetAttribute("isNpc") then
                closetmon = v
                closetdistance = distance
            end
        end
    end

    CheckChildren(workspace["AI/Player"])
    CheckChildren(workspace["AI/Player"].Boss)

    return closetmon
end

function self.GetProperQuest()
    local plr_lv = Player.Data.Level.Value
    local proper_quest

    for _, v in self.quest_modules do
        if v.Min <= plr_lv then
            proper_quest = v
        end
    end

    return proper_quest
end

function self.GetCurrentQuest()
    if not self._LastGetCurrentQuest then
        self._LastGetCurrentQuest = 0
    end

    if tick() - self._LastGetCurrentQuest < 1 then return self._CurrentQuest end
    self._LastGetCurrentQuest = tick()

    for _, v in getgc(true) do
        if type(v) == "function" then
            if debug.info(v, "s"):match(".Modules.Client.Game.Quest") and getfunctionhash(v) == "a75343cae3b355101ce8094ee80fb35a03f0d4bf127ff9d672874607e69d43daa205b772bf6b67959aa653ada92d253f" then
                for _, j in getupvalues(v) do
                    if type(j) == "table" and type(j[1]) ~= "userdata" then
                        for k, s in j do
                            for x, y in s do
                                self._CurrentQuest = s
                                return self._CurrentQuest
                            end
                        end
                    end
                end
            end
        end
    end
end

function self.GetQuest()
    if not self.QuestRE then return end

    self.QuestRE:FireServer("RemoveQuest")
    self.QuestRE:FireServer("RequestQuest", self.GetProperQuest().Path)
end

function self.IsWeaponEquip()
    return Player.Character.Weapon:FindFirstChildOfClass("Model"):FindFirstChildOfClass("MeshPart").Transparency == 0
end

function self.EquipWeapon()
    if not self.IsWeaponEquip() then
        getrenv()._G.ToggleWeapon()
    end
end

function self.Attack()
    if not self._LastAttack then
        self._LastAttack = 0
    end

    if tick() - self._LastAttack < 0.1 then return end
    self._LastAttack = tick()

    game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer({"NormalAttack", "	"})
end

function self.TpToPlayer()
    if self.Settings.SelectPlayer then
        local target = Players:FindFirstChild(self.Settings.SelectPlayer)

        if target and target.Character then
            Player.Character:PivotTo(target.Character:GetPivot())
        end
    end
end

-----------------------------------------------
---- ⭐ PRIORITY FUNCTIONS ⭐
-----------------------------------------------
local PriorityFunctions = {}
function PriorityFunctions.AutoFarm()
    self.PriorityFarming = true

    if self.Settings.FarmMethod == "Level" then
        local current_quest = self.GetCurrentQuest()

        if (not current_quest or current_quest.LevelRequired ~= self.GetProperQuest().Min) or not Player.PlayerGui:WaitForChild("HUD"):FindFirstChild("Quest") then
            self.GetQuest()
            task.wait(0.1)

        else
            local closet_mon = self.GetClosetMon(current_quest.Target)

            if closet_mon then
                local monhrp = closet_mon.HumanoidRootPart
                local monpos = monhrp.Position

                Player.Character:PivotTo(CFrame.lookAt(monpos + Vector3.new(0, -(self.Settings.YPos or 8), 0), monpos))
                Player.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero

                self.EquipWeapon()
            else
                local plr_pos = Player.Character.HumanoidRootPart.Position
                self.Fly(Vector3.new(plr_pos.X, -5, plr_pos.Z))
            end
        end

    elseif self.Settings.FarmMethod == "Material" then
        local m = self.Settings.SelectedMaterials
    end
end

function PriorityFunctions.AutoBoss()
    local closet_boss = self.GetClosetMon(self.Settings.SelectedBosses)

    if closet_boss then
        self.PriorityFarming = true

        local monhrp = closet_boss.HumanoidRootPart
        local monpos = monhrp.Position

        Player.Character:PivotTo(CFrame.lookAt(monpos + Vector3.new(0, -(self.Settings.YPos or 10), 0), monpos))
        Player.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero

        self.EquipWeapon()
    end
end

-----------------------------------------------
---- 🤖 AUTOMATION FUNCTIONS 🤖
-----------------------------------------------
local AutomationFunctions = {}
function AutomationFunctions.SaveSetting()
    if not self.LastSave then
        self.LastSave = 0
    end

    if tick() - self.LastSave < 3 then return end

    self.LastSave = tick()

    local http = game:GetService("HttpService")

    makefolder("Apex Hub Script")
    makefolder("Apex Hub Script/Settings")
    writefile(`Apex Hub Script/Settings/{Game}.json`, http:JSONEncode(self.Settings))
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

function AutomationFunctions.AutoAttack()
    if self.IsWeaponEquip() then
        self.Attack()
    end
end

function AutomationFunctions.AutoStats()
    local select_stat_values = {}
    local point = PlayerGui.Menu.MenuFrames.Stats["Remain Point"].Point.Text:gsub("Remain Point%(s%): ", "")
    point = tonumber(point)

    for _, stat in Player.Stat:GetChildren() do
        if table.find(self.Settings.SelectedStats, stat.Name) then
            table.insert(select_stat_values, {Stat = stat.Name, Level = stat.Value})
        end
    end

    table.sort(select_stat_values, function(a, b)
        return a.Level < b.Level
    end)

    if point > 0 and select_stat_values[1] then
        game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer({{select_stat_values[1].Stat, 1}, utf8.char(3)})
    end
end

function AutomationFunctions.AutoEnablePvp()
    if not Player:GetAttribute("PvPOn") and self.PvptRF then
        self.PvptRF:InvokeServer(true)
    end
end


-----------------------------------------------
---- 🔰 INIT 🔰
-----------------------------------------------
repeat task.wait() until game:IsLoaded()
self.LoadSave()
self.InitConfig()
self.AntiAFK()
self.SetPriority()
self.InitBodyType()
self.InitTeam()
self.InitComponent()

-----------------------------------------------
---- 🪟 CREATE GUI 🪟
-----------------------------------------------
do
    local function CreateApp() -- set window
        local cascade = loadstring(game:HttpGet("https://raw.githubusercontent.com/1makam1/Main/refs/heads/main/dist.luau"))()
        local userInputService = cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
        local minimizeKeybind = Enum.KeyCode.RightControl

        self.app = cascade.New({WindowPill = true, Theme = cascade.Themes.Dark})

        local window = self.app:Window({Title = Game, Subtitle = "Apex Hub", Size = userInputService.TouchEnabled and UDim2.fromOffset(550, 325) or UDim2.fromOffset(850, 530)})

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

        local function titledRow(parent: any, title: string, subtitle: string?) -- row create function
            local row = parent:Row({SearchIndex = title})
            
            row:Left():TitleStack({Title = title, Subtitle = subtitle})

            return row
        end

        return cascade, window, minimizeKeybind, titledRow
    end

    local cascade, window, minimizeKeybind, titledRow = CreateApp()

    do -- Main window
        do-- Main Functions section
            local section = window:Section({Disclosure = false, Title = ""})

            do -- Automation tab
                local tab = section:Tab({Selected = true, Title = "Auto Farm", Icon = cascade.Symbols.house})

                do -- Settings Form
                    local form = tab:PageSection({Title = "Auto Farm Settings"}):Form()

                    titledRow(form, "Auto Attack"):Right():Toggle({Value = self.Settings.AutoAttack or false, ValueChanged = function(_self, value: boolean) self.Settings.AutoAttack = value end})

                    do -- farm method
                        local row = titledRow(form, "Farm Method")
                        local farm_method =  {"Level", "Material"}
                        local elements = {}

                        local function clear_elements()
                            for i, v in elements do
                                elements[i] = v:Destroy()
                            end
                        end

                        local popUpButton = row:Right():PopUpButton({
                            Options = farm_method,
                            Value = self.Settings.FarmMethod and table.find(farm_method, self.Settings.FarmMethod) or 1,
                            ValueChanged = function(_self, Value: number)
                                self.Settings.FarmMethod = _self.Options[Value]

                                if self.Settings.FarmMethod == "Level" then
                                    clear_elements()

                                elseif self.Settings.FarmMethod == "Material" then
                                    clear_elements()

                                    local material = {"Kagune Crystal", "Quinque Shard", "Bulk Fragment", "Serpent Fragment", "Rin Fragment", "Rin Eye"}
                                    local popup_loaded = false
                                    local popUp = row:Right():PopUpButton({
                                        Options = material,
                                        Maximum = #material,
                                        Value = {},
                                        ValueChanged = function(__self, value)
                                            if popup_loaded then self.Settings.SelectedMaterials = {} end

                                            for _, v in value do
                                                table.insert(self.Settings.SelectedMaterials, __self.Options[v])
                                            end
                                        end
                                    })

                                    local selected_materials = {}

                                    if not self.Settings.SelectedMaterials then
                                        self.Settings.SelectedMaterials = {}
                                    end

                                    for _, v in self.Settings.SelectedMaterials do
                                        table.insert(selected_materials, table.find(popUp.Options, v))
                                    end

                                    popUp.Value = selected_materials

                                    popup_loaded = true

                                    table.insert(elements, popUp)
                                end
                            end
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

                    titledRow(form, "Auto Farm"):Right():Toggle({Value = self.Settings.AutoFarm or false, ValueChanged = function(_self, value: boolean) self.Settings.AutoFarm = value if not value then self.Fly() end end})

                    do -- auto boss
                        local popup_loaded = false
                        local row = titledRow(form, "Auto Boss")
                        local boss = {"Jason", "Kaneki", "Noro", "GiftBox"}

                        local popUpButton = row:Right():PopUpButton({
                            Options = boss,
                            Maximum = #boss,
                            Value = {},
                            ValueChanged = function(_self, value)
                                if popup_loaded then self.Settings.SelectedBosses = {} end

                                for _, v in value do
                                    table.insert(self.Settings.SelectedBosses, _self.Options[v])
                                end
                            end
                        })

                        local selected_bosses = {}

                        if not self.Settings.SelectedBosses then
                            self.Settings.SelectedBosses = {}
                        end

                        for _, v in self.Settings.SelectedBosses do
                            table.insert(selected_bosses, table.find(popUpButton.Options, v))
                        end

                        popUpButton.Value = selected_bosses

                        popup_loaded = true

                        row:Right():Toggle({
                            Value = self.Settings.AutoBoss or false,
                            ValueChanged = function(_self, value: boolean)
                                self.Settings.AutoBoss = value
                            end,
                        })
                    end

                    do -- auto stats
                        local popup_loaded = false
                        local row = titledRow(form, "Auto Stats", "auto up selected stats.")

                        local popUpButton = row:Right():PopUpButton({
                            Options = {"Damage", "Durability", "Stamina", "Speed"},
                            Maximum = 4,
                            Value = {},
                            ValueChanged = function(_self, value)
                                if popup_loaded then self.Settings.SelectedStats = {} end

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

                        popup_loaded = true

                        row:Right():Toggle({
                            Value = self.Settings.AutoStats or false,
                            ValueChanged = function(_self, value: boolean)
                                self.Settings.AutoStats = value
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

                    -- tp to player
                    titledRow(form, "TP To Player", "teleport to selected player."):Right():Button({Label = "  >  ", State = "Primary", Pushed = self.TpToPlayer})

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

            do -- teleport tab

            end

            do -- Shop tab
                local tab = section:Tab({Selected = false, Title = "Shop", Icon = "http://www.roblox.com/asset/?id=11385419674"})

                do -- Team Form
                    local form = tab:PageSection({Title = "Team"}):Form()

                    titledRow(form, "Ghoul"):Right():Button({Label = "  >  ", State = "Primary", Pushed = function(_self) game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack({{{"\001", "'\188\214\155\005\223A\251\132\216\153\231\017\129\167#", "GHOUL"}, "\r"}})) end})
                    titledRow(form, "CCG"):Right():Button({Label = "  >  ", State = "Primary", Pushed = function(_self) game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack({{{"\001", "'\188\214\155\005\223A\251\132\216\153\231\017\129\167#", "CCG"}, "\r"}})) end})
                end
            end

            do -- Miscellaneous tab

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
                            ValueChanged = function(self, value: Enum.KeyCode)
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
                            ValueChanged = function(self, value: boolean)
                                window.Searching = value
                            end,
                        })
                    end

                    do -- Draggable
                        local row =
                            titledRow(form, "Draggable", "Allows users to move the window with a mouse or touch device.")

                        row:Right():Toggle({
                            Value = window.Draggable,
                            ValueChanged = function(self, value: boolean)
                                window.Draggable = value
                            end,
                        })
                    end

                    do -- Resizable
                        local row =
                            titledRow(form, "Resizable", "Allows users to resize the window with a mouse or touch device.")

                        row:Right():Toggle({
                            Value = window.Resizable,
                            ValueChanged = function(self, value: boolean)
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
                            ValueChanged = function(self, value: boolean)
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
                            ValueChanged = function(self, value: boolean)
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
                s, r = pcall(func); if not s then warn(funcname, r) end
            end
        end

        for _, funcname in self.Settings.Priority do
            funcname = funcname:match("^(.-)%s*%:")

            if not self.PriorityFarming and self.Settings[funcname] then
                s, r = pcall(PriorityFunctions[funcname]); if not s then warn(funcname, r) end
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
end
