-- Grow a Garden ESP + Reroll GUI [with Sprout Egg added]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Egg-to-Pet mapping (unchanged) + Sprout Egg
local eggPets = {
    ["Common Egg"] = {"Bunny","Dog","Golden Lab"},
    ["Uncommon Egg"] = {"Black Bunny","Cat","Chicken","Deer"},
    ["Rare Egg"] = {"Orange Tabby","Spotted Deer","Pig","Rooster","Monkey"},
    ["Legendary Egg"] = {"Cow","Silver Monkey","Sea Otter","Turtle","Polar Bear"},
    ["Mythical Egg"] = {"Grey Mouse","Brown Mouse","Squirrel","Red Giant Ant","Red Fox"},
    ["Bug Egg"] = {"Snail","Giant Ant","Caterpillar","Praying Mantis","Dragonfly"},
    ["Anti Bee Egg"] = {"Disco Bee","Butterfly","Moth","Tarantula Hawk","Wasp"},
    ["Common Summer Egg"] = {"Starfish","Seagull","Crab"},
    ["Rare Summer Egg"] = {"Flamingo","Toucan","Sea Turtle","Orangutan","Seal"},
    ["Paradise Egg"] = {"Ostrich","Peacock","Capybara","Scarlet Macaw","Mimic Octopus"},
    ["Dinosaur Egg"] = {"Raptor","Triceratops","Stegosaurus","Pterodactyl","Brontosaurus","T-Rex"},
    ["Primal Egg"] = {"Parasaurolophus","Iguanodon","Pachycephalosaurus","Dilophosaurus","Ankylosaurus","Spinosaurus"},
    ["Zen Egg"] = {"Shiba Inu","Nihonzaru","Tanuki","Tanchozuru","Kappa","Kitsune"},
    ["Sprout Egg"] = {"Dairy Cow","Jackalope","Sapling","Golem","Golden Goose"}  -- New addition
}

local function getEggType(name)
    for k in pairs(eggPets) do
        if name:find(k) then return k end
    end
end

-- GUI Setup (remains the same as your last approved version)
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "EggRandomizerGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,240,0,190)
frame.Position = UDim2.new(0.5,-120,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0.2,0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Text = "🎲 EGG RANDOMIZER"
title.TextColor3 = Color3.fromRGB(0,200,255)

local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(0.8,0,0.2,0)
espBtn.Position = UDim2.new(0.1,0,0.25,0)
espBtn.Text = "ESP OFF"
espBtn.Font = Enum.Font.GothamBold
espBtn.TextScaled = true
espBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
espBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0,8)

local rerollBtn = Instance.new("TextButton", frame)
rerollBtn.Size = UDim2.new(0.8,0,0.2,0)
rerollBtn.Position = UDim2.new(0.1,0,0.5,0)
rerollBtn.Text = "REROLL"
rerollBtn.Font = Enum.Font.GothamBold
rerollBtn.TextScaled = true
rerollBtn.BackgroundColor3 = Color3.fromRGB(90,60,90)
rerollBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", rerollBtn).CornerRadius = UDim.new(0,8)

local cdLabel = Instance.new("TextLabel", frame)
cdLabel.Size = UDim2.new(1,0,0.15,0)
cdLabel.Position = UDim2.new(0,0,0.72,0)
cdLabel.BackgroundTransparency = 1
cdLabel.Font = Enum.Font.GothamBold
cdLabel.TextScaled = true
cdLabel.TextColor3 = Color3.fromRGB(255,255,120)

local credits = Instance.new("TextLabel", frame)
credits.Size = UDim2.new(1,0,0,20)
credits.Position = UDim2.new(0,0,1,-20)
credits.BackgroundTransparency = 1
credits.Font = Enum.Font.Gotham
credits.TextSize = 12
credits.Text = "👑 Made By KentNeedprofits"
credits.TextColor3 = Color3.fromRGB(180,180,180)

-- ESP and reroll logic (unchanged with optimized shuffle)
local espOn, espConn = false, nil
local function updateESP()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not (espOn and hrp) then return end
    for _, egg in ipairs(workspace:GetDescendants()) do
        if egg:IsA("Model") and egg.Name:find("Egg") then
            local typ = getEggType(egg.Name)
            local part = egg:FindFirstChildWhichIsA("BasePart") or egg.PrimaryPart
            if typ and part then
                local dist = (part.Position - hrp.Position).Magnitude
                if dist <= 25 then
                    local petVal = egg:FindFirstChild("AssignedPet") or Instance.new("StringValue", egg)
                    petVal.Name = "AssignedPet"
                    petVal.Value = petVal.Value or eggPets[typ][math.random(#eggPets[typ])]
                    local guiEl = egg:FindFirstChild("ESPLabel") or Instance.new("BillboardGui", egg)
                    guiEl.Name = "ESPLabel"
                    guiEl.Adornee = part
                    guiEl.Size = UDim2.new(0,140,0,30)
                    guiEl.StudsOffset = Vector3.new(0,3,0)
                    guiEl.AlwaysOnTop = true
                    local lbl = guiEl:FindFirstChildOfClass("TextLabel") or Instance.new("TextLabel", guiEl)
                    lbl.Size = UDim2.new(1,0,1,0)
                    lbl.BackgroundTransparency = 1
                    lbl.Font = Enum.Font.FredokaOne
                    lbl.TextScaled = true
                    lbl.TextColor3 = Color3.fromRGB(255,255,100)
                    lbl.Text = petVal.Value
                    guiEl.Enabled = true
                else
                    local guiEl = egg:FindFirstChild("ESPLabel")
                    if guiEl then guiEl.Enabled = false end
                end
            end
        end
    end
end

espBtn.MouseButton1Click:Connect(function()
    espOn = not espOn
    espBtn.Text = espOn and "ESP ON" or "ESP OFF"
    espBtn.BackgroundColor3 = espOn and Color3.fromRGB(0,200,0) or Color3.fromRGB(50,50,50)
    if espOn then
        updateESP()
        espConn = RunService.RenderStepped:Connect(updateESP)
    else
        if espConn then espConn:Disconnect() end
        for _, egg in ipairs(workspace:GetDescendants()) do
            local guiEl = egg:FindFirstChild("ESPLabel")
            if guiEl then guiEl:Destroy() end
        end
    end
end)

rerollBtn.MouseButton1Click:Connect(function()
    if not espOn then return end
    cdLabel.Text = ""
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local valid = {}
    for _, egg in ipairs(workspace:GetDescendants()) do
        if egg:IsA("Model") and egg.Name:find("Egg") then
            local typ = getEggType(egg.Name)
            local part = egg:FindFirstChildWhichIsA("BasePart") or egg.PrimaryPart
            local guiEl = egg:FindFirstChild("ESPLabel")
            local lbl = guiEl and guiEl:FindFirstChildOfClass("TextLabel")
            if typ and part and lbl and (part.Position - hrp.Position).Magnitude <= 25 then
                table.insert(valid, {label=lbl, list=eggPets[typ], egg=egg})
            end
        end
    end

    local running, speed = true, 0.1
    task.spawn(function()
        while running do
            for _, data in ipairs(valid) do
                data.label.Text = data.list[math.random(#data.list)]
            end
            wait(speed)
        end
    end)

    for i = 10, 0, -1 do
        cdLabel.Text = "🎰 Shuffling: "..i
        if i <= 5 then speed = speed + 0.02 end
        wait(1)
    end

    running = false
    cdLabel.Text = ""
    for _, data in ipairs(valid) do
        local final = data.list[math.random(#data.list)]
        local petVal = data.egg:FindFirstChild("AssignedPet")
        if petVal then petVal.Value = final end
        data.label.Text = final
    end
end)
