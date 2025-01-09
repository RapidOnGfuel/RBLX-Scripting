-- struggling to do certain things like parsing through containers, will be listed as "Unknown" until I do so.. 
-- open source so feel free to modify anything as your own as long as u keep my name in there at the top (just "Rapid") will do

-- Variables
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local lootDirectory = game.Workspace:FindFirstChild("Loot")
local lootRange = 3000 -- Range in studs to find loot

-- Function to create ESP marker
local function createESP(container, lootName, distance)
    if not container:FindFirstChild("ContainerESP") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ContainerESP"
        billboard.Adornee = container.PrimaryPart or container:FindFirstChildWhichIsA("BasePart")
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextStrokeTransparency = 0
        textLabel.TextScaled = true
        textLabel.Text = string.format("%s - %d studs", lootName, math.ceil(distance))
        textLabel.Parent = billboard

        billboard.Parent = container
    end
end

-- Recursive function to search for loot containers
local function searchContainers(playerPosition)
    for _, container in ipairs(lootDirectory:GetDescendants()) do
        if container:IsA("Model") and container:FindFirstChild("PrimaryPart") or container:FindFirstChildWhichIsA("BasePart") then
            local containerPosition = container:GetModelCFrame().p -- Get container's position
            local distance = (containerPosition - playerPosition).Magnitude
            if distance <= lootRange then
                -- Extract loot data
                local lootData = container:FindFirstChild("LootData")
                if lootData and lootData:IsA("StringValue") then
                    createESP(container, lootData.Value, distance)
                else
                    createESP(container, "Unknown Loot", distance)
                end
            else
                -- Clear ESP if out of range
                if container:FindFirstChild("ContainerESP") then
                    container.ContainerESP:Destroy()
                end
            end
        end
    end
end

-- Main loop
while true do
    if lootDirectory then
        local playerPosition = rootPart.Position -- Get current player location
        searchContainers(playerPosition) -- Cross-check containers with player position
    end
    wait(0.5) -- Refresh every 0.5 seconds
end
