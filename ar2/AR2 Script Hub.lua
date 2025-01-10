loadstring(game:HttpGet('https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/Yun%20V2%20Lib/Yun%20V2%20Lib%20Source.lua'))()

local Library = initLibrary()
local Window = Library:Load({name = "xan", sizeX = 425, sizeY = 512, color = Color3.fromRGB(255, 255, 255)})

local Tab = Window:Tab("Aiming")
local Tab2 = Window:Tab("Visuals")

local Aimingsec1 = Tab:Section{name = "Aim Assist", column = 1}
local Aimingsec2 = Tab:Section{name = "Silent Aimbot", column = 2}
local Visualssec1 = Tab2:Section{name = "Wallhacks", column = 1}
local Visualssec2 = Tab2:Section{name = "Loot ESP", column = 2}

-- Loot ESP Variables
local lootESPEnabled = false
local lootRange = 600 -- Default range in studs to display loot
local Loot = workspace.Loot
local Drawings = {}

local function CreateDrawing(type, props)
    local drawing = Drawing.new(type)
    for prop, val in pairs(props) do
        drawing[prop] = val
    end
    return drawing
end

local function updateDrawings()
    if not lootESPEnabled then
        for _, drawing in pairs(Drawings) do
            drawing.Visible = false
        end
        return
    end

    local playerPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    for instance, drawing in pairs(Drawings) do
        if instance:IsA("CFrameValue") then
            local value = instance.Value.Position
            local distance = (value - playerPosition).Magnitude
            if distance <= lootRange then
                local screenPosition, onScreen = workspace.CurrentCamera:WorldToViewportPoint(value)
                if onScreen then
                    drawing.Position = Vector2.new(screenPosition.X, screenPosition.Y - 20) -- Offset to place above the item
                    drawing.Visible = true
                    drawing.Text = string.format("%s\n%d studs", instance.Name, math.ceil(distance))
                else
                    drawing.Visible = false
                end
            else
                drawing.Visible = false
            end
        end
    end
end

for _, instance in ipairs(Loot:GetDescendants()) do
    if instance:IsA("CFrameValue") then
        local value = instance.Value.Position
        local drawing = CreateDrawing("Text", {
            Text = tostring(instance.Name),
            Color = Color3.fromRGB(255, 255, 255),
            OutlineColor = Color3.fromRGB(0, 0, 0),
            Center = true,
            Outline = true,
            Position = Vector2.new(value.X, value.Y),
            Size = 15,
        })
        Drawings[instance] = drawing
    end
end

Loot.DescendantAdded:Connect(function(instance)
    if instance:IsA("CFrameValue") then
        local value = instance.Value.Position
        local drawing = CreateDrawing("Text", {
            Text = tostring(instance.Name),
            Color = Color3.fromRGB(255, 255, 255),
            OutlineColor = Color3.fromRGB(0, 0, 0),
            Center = true,
            Outline = true,
            Position = Vector2.new(value.X, value.Y),
            Size = 15,
        })
        Drawings[instance] = drawing
    end
end)

Loot.DescendantRemoving:Connect(function(instance)
    if instance:IsA("CFrameValue") and Drawings[instance] then
        Drawings[instance]:Remove()
        Drawings[instance] = nil
    end
end)

game:GetService("RunService").RenderStepped:Connect(updateDrawings)

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
    Default = lootRange,
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