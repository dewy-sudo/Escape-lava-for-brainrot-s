local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local currentLang = "HU"
local autoEnabled = false

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotHub"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 250)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "BRAINROT MENU"
title.Parent = mainFrame

local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(0, 200, 0, 50)
autoBtn.Position = UDim2.new(0, 25, 0, 60)
autoBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
autoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoBtn.Text = "Auto Celestial: KI"
autoBtn.Parent = mainFrame

local langBtn = Instance.new("TextButton")
langBtn.Size = UDim2.new(0, 200, 0, 50)
langBtn.Position = UDim2.new(0, 25, 0, 130)
langBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 40)
langBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
langBtn.Text = "Nyelv: HU"
langBtn.Parent = mainFrame

local function updateUI()
if currentLang == "HU" then
title.Text = "BRAINROT MENÜ"
langBtn.Text = "Nyelv: HU"
autoBtn.Text = "Auto Celestial: " .. (autoEnabled and "BE" or "KI")
else
title.Text = "BRAINROT MENU"
langBtn.Text = "Lang: EN"
autoBtn.Text = "Auto Celestial: " .. (autoEnabled and "ON" or "OFF")
end
autoBtn.BackgroundColor3 = autoEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
end

langBtn.MouseButton1Click:Connect(function()
currentLang = (currentLang == "HU") and "EN" or "HU"
updateUI()
end)

autoBtn.MouseButton1Click:Connect(function()
autoEnabled = not autoEnabled
updateUI()
end)

task.spawn(function()
while task.wait(0.5) do
if autoEnabled then
for _, v in pairs(game.Workspace:GetDescendants()) do
if v:IsA("StringValue") and v.Value == "Celestial" then
local target = v.Parent
if target and target:IsA("BasePart") then
player.Character.HumanoidRootPart.CFrame = target.CFrame
task.wait(0.1)
local prompt = target:FindFirstChildOfClass("ProximityPrompt")
if prompt then fireproximityprompt(prompt) end
end
end
end
end
end
end)

UserInputService.InputBegan:Connect(function(input)
if input.KeyCode == Enum.KeyCode.Insert then
mainFrame.Visible = not mainFrame.Visible
end
end)
