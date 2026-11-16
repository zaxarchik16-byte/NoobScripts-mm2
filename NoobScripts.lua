-- 1. Library Load
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. Window Creation
local Window = Rayfield:CreateWindow({
   Name = "NoodScript / mm2",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "By NoodScripts",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local TextChatService = game:GetService("TextChatService")

-- Variables
local ESPEnabled = false
local RoleCheckEnabled = false
local HighlightObjects = {}
local AutoFarmEnabled = false
local FarmSpeed = 16
local DelayEnabled = true
local PlayerSpeedEnabled = false
local PlayerJumpEnabled = false
local PlayerSpeedValue = 16
local PlayerJumpValue = 50
local NoclipEnabled = false
local FPSEnabled = false
local AutoRejoinEnabled = false
local AutoShootEnabled = false
local AutoKillAllEnabled = false
local AutoPickupGunEnabled = false
local AntiFlingEnabled = true
local AutoMode = "Teleport"
local ProcessedPlayers = {}
local KillButtonEnabled = false
local KillButtonSize = 10
local KillButtonShape = "Square"
local KillButtonRainbow = false
local KillButton = nil
local VisualKillAllCooldown = false

-- ==========================================
-- 100 KEY LIST
-- ==========================================
local KeyList = {
    "NOOB-dayKey_8472910", "NOOB-dayKey_3928471", "NOOB-dayKey_5610293", "NOOB-dayKey_7384910",
    "NOOB-dayKey_9182736", "NOOB-dayKey_1029384", "NOOB-dayKey_4756218", "NOOB-dayKey_8291047",
    "NOOB-dayKey_6473829", "NOOB-dayKey_3059182", "NOOB-dayKey_7583920", "NOOB-dayKey_2193847",
    "NOOB-dayKey_5849201", "NOOB-dayKey_9301827", "NOOB-dayKey_1638492", "NOOB-dayKey_7283910",
    "NOOB-dayKey_4910283", "NOOB-dayKey_8573921", "NOOB-dayKey_3048572", "NOOB-dayKey_6192834",
    "NOOB-dayKey_5839201", "NOOB-dayKey_9471028", "NOOB-dayKey_2748391", "NOOB-dayKey_8102937",
    "NOOB-dayKey_4657382", "NOOB-dayKey_1928374", "NOOB-dayKey_7382910", "NOOB-dayKey_5092831",
    "NOOB-dayKey_8472916", "NOOB-dayKey_3928475", "NOOB-dayKey_5610298", "NOOB-dayKey_7384915",
    "NOOB-dayKey_9182731", "NOOB-dayKey_1029389", "NOOB-dayKey_4756213", "NOOB-dayKey_8291042",
    "NOOB-dayKey_6473824", "NOOB-dayKey_3059187", "NOOB-dayKey_7583925", "NOOB-dayKey_2193842",
    "NOOB-dayKey_5849206", "NOOB-dayKey_9301822", "NOOB-dayKey_1638497", "NOOB-dayKey_7283915",
    "NOOB-dayKey_4910288", "NOOB-dayKey_8573926", "NOOB-dayKey_3048577", "NOOB-dayKey_6192839",
    "NOOB-dayKey_5839206", "NOOB-dayKey_9471023", "NOOB-dayKey_2748396", "NOOB-dayKey_8102932",
    "NOOB-dayKey_4657387", "NOOB-dayKey_1928379", "NOOB-dayKey_7382915", "NOOB-dayKey_5092836",
    "NOOB-dayKey_8472911", "NOOB-dayKey_3928476", "NOOB-dayKey_5610299", "NOOB-dayKey_7384916",
    "NOOB-dayKey_9182732", "NOOB-dayKey_1029380", "NOOB-dayKey_4756214", "NOOB-dayKey_8291043",
    "NOOB-dayKey_6473825", "NOOB-dayKey_3059188", "NOOB-dayKey_7583926", "NOOB-dayKey_2193843",
    "NOOB-dayKey_5849207", "NOOB-dayKey_9301823", "NOOB-dayKey_1638498", "NOOB-dayKey_7283916",
    "NOOB-dayKey_4910289", "NOOB-dayKey_8573927", "NOOB-dayKey_3048578", "NOOB-dayKey_6192840",
    "NOOB-dayKey_5839207", "NOOB-dayKey_9471024", "NOOB-dayKey_2748397", "NOOB-dayKey_8102933",
    "NOOB-dayKey_4657388", "NOOB-dayKey_1928380", "NOOB-dayKey_7382916", "NOOB-dayKey_5092837",
    "NOOB-dayKey_8472912", "NOOB-dayKey_3928477", "NOOB-dayKey_5610300", "NOOB-dayKey_7384917",
    "NOOB-dayKey_9182733", "NOOB-dayKey_1029381", "NOOB-dayKey_4756215", "NOOB-dayKey_8291044",
    "NOOB-dayKey_6473826", "NOOB-dayKey_3059189", "NOOB-dayKey_7583927", "NOOB-dayKey_2193844",
    "NOOB-dayKey_5849208", "NOOB-dayKey_9301824", "NOOB-dayKey_1638499", "NOOB-dayKey_7283917"
}

local KeyObtained = false
local SubscriptionEndTime = nil
local CurrentKey = nil
local mainStatusLabel = nil

-- Role Settings
local RoleSettings = {
    Murderer = { Name = "Murderer", Color = Color3.fromRGB(255, 0, 0) },
    Sheriff = { Name = "Sheriff", Color = Color3.fromRGB(0, 0, 255) },
    Innocent = { Name = "Innocent", Color = Color3.fromRGB(0, 255, 0) },
    Zombie = { Name = "Zombie", Color = Color3.fromRGB(100, 0, 0) }
}

-- Anti-Fling
task.spawn(function()
    while task.wait(0.1) do
        if AntiFlingEnabled and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, v in pairs(root:GetChildren()) do
                    if v:IsA("BodyVelocity") or v:IsA("BodyAngularVelocity") or v:IsA("BodyForce") then
                        v:Destroy()
                    end
                end
            end
        end
    end
end)

-- FPS Counter
local fpsGui = Instance.new("ScreenGui")
fpsGui.Name = "FPSGui"
fpsGui.ResetOnSpawn = false
fpsGui.Parent = game:GetService("CoreGui")
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 100, 0, 20)
fpsLabel.Position = UDim2.new(0.5, -50, 0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 0"
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextSize = 12
fpsLabel.Parent = fpsGui
local frames = 0
local lastTime = tick()
RunService.RenderStepped:Connect(function()
    frames = frames + 1
    local currentTime = tick()
    if currentTime - lastTime >= 1 then
        local fps = math.floor(frames / (currentTime - lastTime))
        fpsLabel.Text = "FPS: " .. fps
        frames = 0
        lastTime = currentTime
    end
end)

-- Auto Rejoin
GuiService.ErrorMessageChanged:Connect(function(errorMessage)
    if AutoRejoinEnabled and errorMessage and errorMessage ~= "" then
        task.wait(2)
        pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
    end
end)

-- Functions
local function GetPlayerRole(player)
    local char = player.Character
    local backpack = player:FindFirstChild("Backpack")
    local function hasTool(name)
        if char and char:FindFirstChild(name) then return true end
        if backpack and backpack:FindFirstChild(name) then return true end
        return false
    end
    if hasTool("Knife") then return "Murderer" end
    if hasTool("Gun") then return "Sheriff" end
    if char and (char.Name:lower():find("zombie") or (char:FindFirstChild("Zombie") ~= nil)) then return "Zombie" end
    return "Innocent"
end

local function UpdateESP()
    for _, obj in pairs(HighlightObjects) do if obj then obj:Destroy() end end
    table.clear(HighlightObjects)
    if not ESPEnabled then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = Instance.new("Highlight")
            highlight.Adornee = player.Character
            highlight.FillTransparency = 1
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = player.Character
            if RoleCheckEnabled then
                local roleKey = GetPlayerRole(player)
                highlight.OutlineColor = RoleSettings[roleKey].Color
            else
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
            table.insert(HighlightObjects, highlight)
        end
    end
end

-- Noclip
local function ApplyNoclip()
    local char = LocalPlayer.Character
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            if NoclipEnabled then v.CanCollide = false
            else if not AutoFarmEnabled and not AutoShootEnabled and not AutoKillAllEnabled then v.CanCollide = true end end
        end
    end
end
RunService.Stepped:Connect(ApplyNoclip)

-- Farm (Fly)
local function FindNearestCandy()
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local nearestCandy = nil
    local shortestDist = math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("candy") or obj.Name:lower():find("coin") or obj.Name:lower():find("sweet")) then
            if obj.Transparency < 0.9 then
                local dist = (root.Position - obj.Position).Magnitude
                if dist < shortestDist and dist < 80 then shortestDist = dist; nearestCandy = obj end
            end
        end
    end
    return nearestCandy
end

local flying = false
local savedGravity = workspace.Gravity
local bodyPos = nil
local bodyGyro = nil

local function EnableFly()
    if flying then return end
    flying = true
    local char = LocalPlayer.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if root and humanoid then
            savedGravity = workspace.Gravity
            workspace.Gravity = 0
            humanoid.PlatformStand = true
            bodyPos = Instance.new("BodyPosition")
            bodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyPos.P = 3000; bodyPos.D = 300
            bodyPos.Parent = root
            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyGyro.P = 1000; bodyGyro.D = 100
            bodyGyro.Parent = root
        end
    end
end

local function DisableFly()
    if not flying then return end
    flying = false
    local char = LocalPlayer.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if root and humanoid then
            workspace.Gravity = savedGravity
            humanoid.PlatformStand = false
            humanoid.WalkSpeed = 16
            if bodyPos then bodyPos:Destroy() bodyPos = nil end
            if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
            if not NoclipEnabled then
                for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = true end end
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.2) do
        if AutoFarmEnabled and KeyObtained then
            EnableFly()
            local candy = FindNearestCandy()
            if candy then
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root and bodyPos then
                    bodyPos.Position = candy.Position + Vector3.new(0, 3, 0)
                    bodyPos.P = 500 + (FarmSpeed * 100); bodyPos.D = 50 + (FarmSpeed * 10)
                    if (root.Position - candy.Position).Magnitude < 5 then if DelayEnabled then task.wait(1) end end
                end
            else if flying then DisableFly() end end
        else if flying then DisableFly() end end
    end
end)

-- Auto Shoot Murderer
task.spawn(function()
    while task.wait(0.5) do
        if AutoShootEnabled and KeyObtained then
            local char = LocalPlayer.Character
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local hasGun = (char and char:FindFirstChild("Gun")) or (backpack and backpack:FindFirstChild("Gun"))
            if hasGun then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local role = GetPlayerRole(player)
                        if role == "Murderer" then
                            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                            local myRoot = char and char:FindFirstChild("HumanoidRootPart")
                            if targetRoot and myRoot then
                                if AutoMode == "Teleport" then
                                    myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
                                    task.wait(0.1)
                                    local gun = (char and char:FindFirstChild("Gun")) or (backpack and backpack:FindFirstChild("Gun"))
                                    if gun then gun:Activate(); task.wait(0.5) end
                                else
                                    EnableFly()
                                    if bodyPos then
                                        bodyPos.Position = targetRoot.Position + Vector3.new(0, 3, 0)
                                        local gun = (char and char:FindFirstChild("Gun")) or (backpack and backpack:FindFirstChild("Gun"))
                                        if gun and (myRoot.Position - targetRoot.Position).Magnitude < 5 then gun:Activate() end
                                    end
                                end
                            end
                            break
                        end
                    end
                end
            else DisableFly() end
        end
    end
end)

-- Auto Kill All
task.spawn(function()
    while task.wait(0.5) do
        if AutoKillAllEnabled and KeyObtained then
            local char = LocalPlayer.Character
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local hasKnife = (char and char:FindFirstChild("Knife")) or (backpack and backpack:FindFirstChild("Knife"))
            if hasKnife then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and not ProcessedPlayers[player] then
                        local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if targetRoot and myRoot and humanoid and humanoid.Health > 0 then
                            if AutoMode == "Teleport" then
                                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
                                task.wait(0.1)
                                local knife = (char and char:FindFirstChild("Knife")) or (backpack and backpack:FindFirstChild("Knife"))
                                if knife then knife:Activate(); ProcessedPlayers[player] = true; task.wait(0.5) end
                            else
                                EnableFly()
                                if bodyPos then
                                    bodyPos.Position = targetRoot.Position + Vector3.new(0, 3, 0)
                                    local knife = (char and char:FindFirstChild("Knife")) or (backpack and backpack:FindFirstChild("Knife"))
                                    if knife and (myRoot.Position - targetRoot.Position).Magnitude < 5 then knife:Activate(); ProcessedPlayers[player] = true end
                                end
                            end
                            break
                        end
                    end
                end
            else DisableFly() end
        end
    end
end)

-- Auto Pickup Gun
task.spawn(function()
    while task.wait(0.1) do
        if AutoPickupGunEnabled and KeyObtained then
            local char = LocalPlayer.Character
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local myGun = (char and char:FindFirstChild("Gun")) or (backpack and backpack:FindFirstChild("Gun"))
            if not myGun then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name == "Gun" and (obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("BasePart")) then
                        local isHeld = false
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character then
                                if player.Character:FindFirstChild("Gun") then isHeld = true; break end
                            end
                        end
                        if not isHeld then
                            if obj:IsA("BasePart") or obj:IsA("Model") then
                                local part = obj:IsA("BasePart") and obj or obj.PrimaryPart
                                if part and char then
                                    local root = char:FindFirstChild("HumanoidRootPart")
                                    if root then part.CFrame = root.CFrame; task.wait(0.05) end
                                end
                            elseif obj:IsA("Tool") then obj.Parent = backpack or char end
                        end
                    end
                end
            end
        end
    end
end)

-- Visual Kill All
local function VisualKillAll()
    if VisualKillAllCooldown then return end
    if not LocalPlayer.Character then return end
    local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    VisualKillAllCooldown = true
    local savedPositions = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                savedPositions[player] = root.CFrame
                root.CFrame = myRoot.CFrame * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5))
            end
        end
    end
    task.wait(1)
    for player, cframe in pairs(savedPositions) do
        if player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then root.CFrame = cframe end
        end
    end
    VisualKillAllCooldown = false
end

-- Kill Button
local function CreateKillButton()
    if KillButton then KillButton:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "KillAllGUI"
    gui.ResetOnSpawn = false
    gui.Parent = game:GetService("CoreGui")
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50 + (KillButtonSize * 2), 0, 50 + (KillButtonSize * 2))
    btn.Position = UDim2.new(0.5, -25, 0.8, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.5
    btn.Text = "KILL ALL"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = gui
    if KillButtonShape == "Circle" then
        btn.BorderSizePixel = 0
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = btn
    elseif KillButtonShape == "Rounded" then
        btn.BorderSizePixel = 0
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = btn
    else
        btn.BorderSizePixel = 2
        btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    end
    local dragging, dragInput, dragStart, startPos
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = btn.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    btn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    btn.MouseButton1Click:Connect(VisualKillAll)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Q and KillButtonEnabled then VisualKillAll() end
    end)
    KillButton = gui
    if KillButtonRainbow then
        task.spawn(function()
            while KillButton do
                for i = 0, 1, 0.01 do
                    if not KillButton then break end
                    btn.BackgroundColor3 = Color3.fromHSV(i, 1, 1)
                    task.wait(0.05)
                end
            end
        end)
    end
end

local function UpdateKillButton()
    if KillButton then KillButton:Destroy() KillButton = nil end
    if KillButtonEnabled then CreateKillButton() end
end

-- ==========================================
-- TAB 1: BUY
-- ==========================================
local BuyTab = Window:CreateTab("Buy", nil)
BuyTab:CreateSection("Free Version")
BuyTab:CreateLabel("Your version: Free. To unlock full access, complete the tasks below:")

local adDone = false
local tgDone = false

BuyTab:CreateButton({
   Name = "Watch Ad (5 sec)",
   Callback = function()
       Rayfield:Notify({Title = "Advertisement", Content = "Watching ad for 5 seconds...", Duration = 5})
       task.wait(5)
       adDone = true
       Rayfield:Notify({Title = "Advertisement", Content = "Task completed!", Duration = 3})
   end,
})

BuyTab:CreateButton({
   Name = "Copy Telegram (1 sec)",
   Callback = function()
       setclipboard("https://t.me/BaconScripts")
       task.wait(1)
       tgDone = true
       Rayfield:Notify({Title = "Telegram", Content = "Task completed!", Duration = 3})
   end,
})

BuyTab:CreateButton({
   Name = "Get Key",
   Callback = function()
       if not adDone or not tgDone then
           Rayfield:Notify({Title = "Error", Content = "Complete both tasks first!", Duration = 3})
           return
       end
       Rayfield:Notify({Title = "Connecting", Content = "Connecting to servers...", Duration = 3})
       task.wait(2)
       CurrentKey = KeyList[math.random(1, #KeyList)]
       setclipboard(CurrentKey)
       Rayfield:Notify({Title = "Success", Content = "Key copied: " .. CurrentKey, Duration = 5})
   end,
})

-- Activation Key Input
BuyTab:CreateSection("Activate Key")
local keyInput = BuyTab:CreateInput({
   Name = "Enter Key",
   PlaceholderText = "NOOB-dayKey_XXXXXXX",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
       -- Just store it
   end,
})

BuyTab:CreateButton({
   Name = "Activate Key",
   Callback = function()
       if keyInput and keyInput.Text then
           local found = false
           for _, key in pairs(KeyList) do
               if key == keyInput.Text then
                   found = true
                   break
               end
           end
           if found then
               KeyObtained = true
               SubscriptionEndTime = os.date("%d.%m.%Y %H:%M", os.time() + 86400)
               Rayfield:Notify({Title = "Success", Content = "Key activated!", Duration = 3})
               if mainStatusLabel then
                   mainStatusLabel:Set("Subscription active until: " .. SubscriptionEndTime)
               end
           else
               Rayfield:Notify({Title = "Error", Content = "Invalid key!", Duration = 3})
           end
       end
   end,
})

-- ==========================================
-- TAB 2: MAIN
-- ==========================================
local MainTab = Window:CreateTab("Main", nil)
MainTab:CreateSection("Information")

MainTab:CreateButton({
   Name = "Copy Telegram",
   Callback = function() setclipboard("https://t.me/BaconScripts"); Rayfield:Notify({Title = "Success", Content = "Link copied", Duration = 3}) end,
})
MainTab:CreateButton({
   Name = "Copy Version 1.3F",
   Callback = function() setclipboard("1.3F"); Rayfield:Notify({Title = "Success", Content = "Version copied", Duration = 3}) end,
})
MainTab:CreateButton({
   Name = "Copy Creator Command",
   Callback = function() setclipboard("NoodScripts"); Rayfield:Notify({Title = "Success", Content = "Command copied", Duration = 3}) end,
})

mainStatusLabel = MainTab:CreateLabel("Subscription inactive")

-- ==========================================
-- TAB 3: VISUAL
-- ==========================================
local VisualTab = Window:CreateTab("Visual", nil)
VisualTab:CreateSection("ESP & Roles")
VisualTab:CreateToggle({ Name = "Enable ESP", CurrentValue = false, Flag = "ESP_Toggle", Callback = function(Value) ESPEnabled = Value; UpdateESP() end })
VisualTab:CreateToggle({ Name = "Detect Roles", CurrentValue = false, Flag = "Role_Toggle", Callback = function(Value) RoleCheckEnabled = Value; UpdateESP() end })
VisualTab:CreateColorPicker({ Name = "Murderer Color", Color = RoleSettings.Murderer.Color, Flag = "Color_Murderer", Callback = function(Value) RoleSettings.Murderer.Color = Value; UpdateESP() end })
VisualTab:CreateColorPicker({ Name = "Sheriff Color", Color = RoleSettings.Sheriff.Color, Flag = "Color_Sheriff", Callback = function(Value) RoleSettings.Sheriff.Color = Value; UpdateESP() end })
VisualTab:CreateColorPicker({ Name = "Innocent Color", Color = RoleSettings.Innocent.Color, Flag = "Color_Innocent", Callback = function(Value) RoleSettings.Innocent.Color = Value; UpdateESP() end })

-- ==========================================
-- TAB 4: AUTO FARM
-- ==========================================
local FarmTab = Window:CreateTab("Auto Farm", nil)
FarmTab:CreateSection("Farm Settings")
FarmTab:CreateToggle({ Name = "Enable Farm (Fly)", CurrentValue = false, Flag = "AutoFarmToggle", Callback = function(Value) 
    if not KeyObtained then Rayfield:Notify({Title = "Error", Content = "Key required!", Duration = 3}) return end
    AutoFarmEnabled = Value; if not Value then DisableFly() end 
end })
FarmTab:CreateSlider({ Name = "Speed", Range = {9, 25}, Increment = 1, Suffix = " speed", CurrentValue = 16, Flag = "FarmSpeedSlider", Callback = function(Value) FarmSpeed = Value end })
FarmTab:CreateToggle({ Name = "Pause after pickup", CurrentValue = true, Flag = "DelayToggle", Callback = function(Value) DelayEnabled = Value end })

-- ==========================================
-- TAB 5: AUTO
-- ==========================================
local AutoTab = Window:CreateTab("Auto", nil)
AutoTab:CreateSection("Auto Actions")
AutoTab:CreateDropdown({
   Name = "Mode",
   Options = {"Teleport", "Move"},
   CurrentOption = {"Teleport"},
   Flag = "AutoModeDropdown",
   Callback = function(Option) AutoMode = Option end,
})
AutoTab:CreateToggle({ Name = "Auto Shoot Murderer", CurrentValue = false, Flag = "AutoShootToggle", Callback = function(Value) 
    if not KeyObtained then Rayfield:Notify({Title = "Error", Content = "Key required!", Duration = 3}) return end
    AutoShootEnabled = Value; if not Value then DisableFly() end 
end })
AutoTab:CreateToggle({ Name = "Auto Kill All", CurrentValue = false, Flag = "AutoKillAllToggle", Callback = function(Value) 
    if not KeyObtained then Rayfield:Notify({Title = "Error", Content = "Key required!", Duration = 3}) return end
    AutoKillAllEnabled = Value; if not Value then DisableFly() end 
end })
AutoTab:CreateToggle({ Name = "Auto Pickup Gun", CurrentValue = false, Flag = "AutoPickupGunToggle", Callback = function(Value) 
    if not KeyObtained then Rayfield:Notify({Title = "Error", Content = "Key required!", Duration = 3}) return end
    AutoPickupGunEnabled = Value 
end })

-- ==========================================
-- TAB 6: PLAYER
-- ==========================================
local PlayerTab = Window:CreateTab("Player", nil)
PlayerTab:CreateSection("Settings")
PlayerTab:CreateToggle({ Name = "Speed", CurrentValue = false, Flag = "SpeedToggle", Callback = function(Value) PlayerSpeedEnabled = Value end })
PlayerTab:CreateSlider({ Name = "Speed Value", Range = {16, 40}, Increment = 1, Suffix = " speed", CurrentValue = 16, Flag = "SpeedSlider", Callback = function(Value) PlayerSpeedValue = Value end })
PlayerTab:CreateToggle({ Name = "Jump", CurrentValue = false, Flag = "JumpToggle", Callback = function(Value) PlayerJumpEnabled = Value end })
PlayerTab:CreateSlider({ Name = "Jump Value", Range = {50, 50}, Increment = 1, Suffix = " power", CurrentValue = 50, Flag = "JumpSlider", Callback = function(Value) PlayerJumpValue = Value end })
PlayerTab:CreateSection("Noclip")
PlayerTab:CreateToggle({ Name = "Noclip", CurrentValue = false, Flag = "NoclipToggle", Callback = function(Value) NoclipEnabled = Value; if not Value then local char = LocalPlayer.Character; if char then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = true end end end end end })

PlayerTab:CreateSection("Anti-Fling")
PlayerTab:CreateLabel("Anti-Fling protection (always on)")

task.spawn(function()
    while task.wait(0.1) do
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if PlayerSpeedEnabled then humanoid.WalkSpeed = PlayerSpeedValue else humanoid.WalkSpeed = 16 end
            if PlayerJumpEnabled then humanoid.JumpPower = PlayerJumpValue else humanoid.JumpPower = 50 end
        end
    end
end)

-- ==========================================
-- TAB 7: SETTINGS GUI
-- ==========================================
local SettingsGUITab = Window:CreateTab("Settings GUI", nil)
SettingsGUITab:CreateSection("Kill All Button")
SettingsGUITab:CreateToggle({ Name = "Enable", CurrentValue = false, Flag = "KillButtonToggle", Callback = function(Value) KillButtonEnabled = Value; UpdateKillButton() end })
SettingsGUITab:CreateSlider({ Name = "Size", Range = {5, 25}, Increment = 1, Suffix = " size", CurrentValue = 10, Flag = "KillButtonSizeSlider", Callback = function(Value) KillButtonSize = Value; UpdateKillButton() end })
SettingsGUITab:CreateDropdown({ Name = "Shape", Options = {"Square", "Rounded", "Circle"}, CurrentOption = {"Square"}, Flag = "KillButtonShapeDropdown", Callback = function(Option) KillButtonShape = Option; UpdateKillButton() end })
SettingsGUITab:CreateToggle({ Name = "Rainbow Mode", CurrentValue = false, Flag = "KillButtonRainbowToggle", Callback = function(Value) KillButtonRainbow = Value; UpdateKillButton() end })

-- ==========================================
-- TAB 8: MM2 HUBS
-- ==========================================
local HubsTab = Window:CreateTab("MM2 Hubs", nil)
HubsTab:CreateSection("Working Hubs")
HubsTab:CreateButton({ Name = "Rattex", Callback = function() loadstring(game:HttpGet("https://scriptblox.com/raw/Murder-Mystery-2-rattex-KEYLESS-231977"))() end })
HubsTab:CreateButton({ Name = "SP Hub", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/as6cd0/SP_Hub/refs/heads/main/Loader"))() end })
HubsTab:CreateButton({ Name = "Vetrex", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/klaya21n/script/refs/heads/main/VETREX%20MM2"))() end })
HubsTab:CreateButton({ Name = "DFS (no name)", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/thunderXhub/ThunderXHUB/refs/heads/main/loader'))() end })

HubsTab:CreateSection("Other Hubs (copy name)")
HubsTab:CreateButton({ Name = "Dark Hub", Callback = function() setclipboard("Dark Hub MM2"); Rayfield:Notify({Title = "Dark Hub", Content = "Name copied", Duration = 3}) end })
HubsTab:CreateButton({ Name = "Void Hub", Callback = function() setclipboard("Void Hub MM2"); Rayfield:Notify({Title = "Void Hub", Content = "Name copied", Duration = 3}) end })
HubsTab:CreateButton({ Name = "Kavo", Callback = function() setclipboard("Kavo MM2"); Rayfield:Notify({Title = "Kavo", Content = "Name copied", Duration = 3}) end })
HubsTab:CreateButton({ Name = "Matrix", Callback = function() setclipboard("Matrix Hub MM2"); Rayfield:Notify({Title = "Matrix", Content = "Name copied", Duration = 3}) end })
HubsTab:CreateButton({ Name = "Owl Hub", Callback = function() setclipboard("Owl Hub MM2"); Rayfield:Notify({Title = "Owl Hub", Content = "Name copied", Duration = 3}) end })
HubsTab:CreateButton({ Name = "Haze", Callback = function() setclipboard("Haze MM2"); Rayfield:Notify({Title = "Haze", Content = "Name copied", Duration = 3}) end })
HubsTab:CreateButton({ Name = "ThunderX", Callback = function() setclipboard("ThunderX MM2"); Rayfield:Notify({Title = "ThunderX", Content = "Name copied", Duration = 3}) end })
HubsTab:CreateButton({ Name = "SP Moonlight", Callback = function() setclipboard("SP Moonlight MM2"); Rayfield:Notify({Title = "SP Moonlight", Content = "Name copied", Duration = 3}) end })
HubsTab:CreateButton({ Name = "KITI HUB", Callback = function() setclipboard("KITI HUB MM2"); Rayfield:Notify({Title = "KITI HUB", Content = "Name copied", Duration = 3}) end })
HubsTab:CreateButton({ Name = "Project Syns", Callback = function() setclipboard("Project Syns MM2"); Rayfield:Notify({Title = "Project Syns", Content = "Name copied", Duration = 3}) end })

-- ==========================================
-- END
-- ==========================================
Rayfield:Notify({Title = "NoodScript / mm2", Content = "Script loaded successfully!", Duration = 5})
