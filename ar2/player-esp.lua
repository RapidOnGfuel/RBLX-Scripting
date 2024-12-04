-- Variables
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local refreshRate = 0.5 -- Refresh every 0.5 seconds
local maxRange = 3000 -- Maximum distance to track players

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

-- Function to remove ESP if player is out of range
local function handlePlayerESP(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetCharacter = targetPlayer.Character
        local humanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
        local distance = (humanoidRootPart.Position - rootPart.Position).Magnitude

        if distance <= maxRange then
            createPlayerESP(targetPlayer)
            if targetCharacter:FindFirstChild("DistanceTracker") then
                local textLabel = targetCharacter.DistanceTracker:FindFirstChildOfClass("TextLabel")
                textLabel.Text = string.format("%s - %d studs", targetPlayer.Name, math.ceil(distance))
            end
        else
            -- Remove ESP if out of range
            if targetCharacter:FindFirstChild("PlayerChams") then
                targetCharacter.PlayerChams:Destroy()
            end
            if targetCharacter:FindFirstChild("DistanceTracker") then
                targetCharacter.DistanceTracker:Destroy()
            end
        end
    end
end

-- Update player ESP dynamically
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
    removePlayerESP(player)
end)

-- Main loop
while true do
    updatePlayerESP()
    wait(refreshRate)
end
