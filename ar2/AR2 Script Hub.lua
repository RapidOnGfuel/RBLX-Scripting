loadstring(game:HttpGet('https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/Yun%20V2%20Lib/Yun%20V2%20Lib%20Source.lua'))()

local Library = initLibrary()
local Window = Library:Load({name = "xan", sizeX = 425, sizeY = 512, color = Color3.fromRGB(255, 255, 255)})

local Tab = Window:Tab("Aiming")
local Tab2 = Window:Tab("Visuals")

local Aimingsec1 = Tab:Section{name = "Aim Assist", column = 1}
local Aimingsec2 = Tab:Section{name = "Silent Aimbot", column = 2}
local Visualssec1 = Tab2:Section{name = "Wallhacks", column = 1}
local Visualssec2 = Tab2:Section{name = "Loot ESP", column = 2}

-- Variables for Player ESP
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local refreshRate = 0.2 -- Refresh every 0.2 seconds
local playerESPEnabled = false
local playerESPRange = 3000 -- Default range for Player ESP

-- Function to create chams and distance tracker
local function createPlayerESP(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetCharacter = targetPlayer.Character

        -- Add "Highlight" (chams effect) if not already present
        if not targetCharacter:FindFirstChild("PlayerChams") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "PlayerChams"
            highlight.Adornee = targetCharacter
            highlight.FillColor = Color3.new(1, 0, 0) -- Red fill
            highlight.OutlineColor = Color3.new(1, 1, 1) -- White outline
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = targetCharacter
        end

        -- Add BillboardGui for distance tracking
        if not targetCharacter:FindFirstChild("DistanceTracker") then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "DistanceTracker"
            billboard.Adornee = targetCharacter:FindFirstChild("HumanoidRootPart")
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.new(1, 1, 1) -- White text
            textLabel.TextStrokeTransparency = 0
            textLabel.TextScaled = true
            textLabel.Text = "Calculating..."
            textLabel.Parent = billboard

            billboard.Parent = targetCharacter
        end
    end
end

-- Function to handle ESP for a player
local function handlePlayerESP(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetCharacter = targetPlayer.Character
        local humanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
        local distance = (humanoidRootPart.Position - rootPart.Position).Magnitude

        if playerESPEnabled and distance <= playerESPRange then
            createPlayerESP(targetPlayer)
            if targetCharacter:FindFirstChild("DistanceTracker") then
                local textLabel = targetCharacter.DistanceTracker:FindFirstChildOfClass("TextLabel")
                textLabel.Text = string.format("%s - %d studs", targetPlayer.Name, math.ceil(distance))
            end
        else
            -- Remove ESP if out of range or disabled
            if targetCharacter:FindFirstChild("PlayerChams") then
                targetCharacter.PlayerChams:Destroy()
            end
            if targetCharacter:FindFirstChild("DistanceTracker") then
                targetCharacter.DistanceTracker:Destroy()
            end
        end
    end
end

-- Function to update player ESP dynamically
local function updatePlayerESP()
    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer then
            handlePlayerESP(player)
        end
    end
end

-- Handle player joins and leaves
players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        handlePlayerESP(player)
    end)
end)

players.PlayerRemoving:Connect(function(player)
    if player.Character then
        if player.Character:FindFirstChild("PlayerChams") then
            player.Character.PlayerChams:Destroy()
        end
        if player.Character:FindFirstChild("DistanceTracker") then
            player.Character.DistanceTracker:Destroy()
        end
    end
end)

-- GUI Elements for Player ESP
Visualssec1:Toggle {
    Name = "Player ESP",
    flag = "playerESPEnabled", 
    callback = function(enabled)
        playerESPEnabled = enabled
        print("Player ESP is now: " .. tostring(enabled))
        if not playerESPEnabled then
            -- Remove all ESP elements when disabled
            for _, player in ipairs(players:GetPlayers()) do
                if player.Character then
                    if player.Character:FindFirstChild("PlayerChams") then
                        player.Character.PlayerChams:Destroy()
                    end
                    if player.Character:FindFirstChild("DistanceTracker") then
                        player.Character.DistanceTracker:Destroy()
                    end
                end
            end
        end
    end
}

Visualssec1:Slider {
    Name = "Player ESP Distance",
    Default = playerESPRange,
    Min = 100,
    Max = 5000,
    Decimals = 0,
    Flag = "playerESPRange",
    callback = function(distance)
        playerESPRange = distance
        print("Player ESP Distance is now: " .. playerESPRange)
    end
}

-- Main loop to update ESP
game:GetService("RunService").RenderStepped:Connect(function()
    if playerESPEnabled then
        updatePlayerESP()
    end
end)

-- GUI Elements for Loot ESP
Visualssec2:Toggle {
    Name = "Loot ESP",
    flag = "lootESPEnabled", 
    callback = function(enabled)
        lootESPEnabled = enabled
        print("Loot ESP is now: " .. tostring(enabled))
    end
}

Visualssec2:Slider {
    Name = "Loot ESP Distance",
    Default = 3000,
    Min = 100,
    Max = 5000,
    Decimals = 0,
    Flag = "lootRange",
    callback = function(distance)
        lootRange = distance
        print("Loot ESP Distance is now: " .. lootRange)
    end
}

-- Other GUI Elements
Aimingsec1:Toggle {
    Name = "Enabled",
    flag = "ooolol", 
    callback = function(bool)
    end
}

Aimingsec1:Slider {
    Name = "Smoothing",
    Default = 0,
    Min = 0,
    Max = 30,
    Decimals = 1,
    Flag = "moooooo",
    callback = function(bool)
    end
}

Aimingsec1:dropdown {
    name = "Aim",
    content = {"Head", "Torso", "HumanoidRootPart", "Right Arm", "Left Arm"},
    multichoice = true,
    callback = function(bool)
    end
}

Aimingsec2:Toggle {
    Name = "Enabled",
    flag = "ooolol", 
    callback = function(bool)
    end
}

Visualssec1:Toggle {
    Name = "Enabled",
    flag = "ooolol", 
    callback = function(bool)
    end
}
