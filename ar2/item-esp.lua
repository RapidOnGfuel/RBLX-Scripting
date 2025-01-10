
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local lootDirectory = game.Workspace:FindFirstChild("Loot")
local lootRange = 3000 


local function updateESP(container, lootItems, distance)
    local billboard = container:FindFirstChild("ContainerESP")
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "ContainerESP"
        billboard.Adornee = container:FindFirstChildWhichIsA("BasePart") or container.PrimaryPart
        billboard.Size = UDim2.new(0, 200, 0, 50 + (#lootItems * 20))
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextStrokeTransparency = 0
        textLabel.TextScaled = false
        textLabel.TextYAlignment = Enum.TextYAlignment.Top
        textLabel.Text = string.format("Distance: %d studs\n%s", math.ceil(distance), table.concat(lootItems, "\n"))
        textLabel.Parent = billboard

        billboard.Parent = container
    else
        billboard.TextLabel.Text = string.format("Distance: %d studs\n%s", math.ceil(distance), table.concat(lootItems, "\n"))
    end
end


local function getLootItems(container)
    local items = {}
    for _, item in ipairs(container:GetDescendants()) do
        if item:IsA("Part") or item:IsA("Model") then
            table.insert(items, item.Name) 
        end
    end
    return items
end


local function searchContainers(playerPosition)
    for _, container in ipairs(lootDirectory:GetChildren()) do
        if container:IsA("Model") and (container:FindFirstChildWhichIsA("BasePart") or container.PrimaryPart) then
            local containerPosition = container:GetModelCFrame().p
            local distance = (containerPosition - playerPosition).Magnitude
            if distance <= lootRange then

                local lootItems = getLootItems(container)
                if #lootItems > 0 then
                    updateESP(container, lootItems, distance)
                else
                    if container:FindFirstChild("ContainerESP") then
                        container.ContainerESP:Destroy()
                    end
                end
            else

                if container:FindFirstChild("ContainerESP") then
                    container.ContainerESP:Destroy()
                end
            end
        end
    end
end


while true do
    if lootDirectory then
        local playerPosition = rootPart.Position
        searchContainers(playerPosition)
    end
    wait(0.1)
end
