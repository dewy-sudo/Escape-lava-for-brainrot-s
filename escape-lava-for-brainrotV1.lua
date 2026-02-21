local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local Lang = {
HU = {Title = "BRAINROT V1", Auto = "Auto Celestial: ", Speed = "Gyorsitas: ", Lang = "Nyelv: HU"},
EN = {Title = "BRAINROT V1", Auto = "Auto Celestial: ", Speed = "Speed Boost: ", Lang = "Lang: EN"}
}
local cur = "HU"

local autoEnabled = false
local speedEnabled = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SolaraPro"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 300, 0, 350)
Main.Position = UDim2.new(0.5, -150, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 120)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.5
UIStroke.Parent = Main

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = Lang[cur].Title
Title.TextColor3 = Color3.fromRGB(0, 255, 120)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.Parent = Main
local TitleCorner = Instance.new("UICorner")
TitleCorner.Parent = Title

local function createButton(text, pos)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 260, 0, 45)
btn.Position = pos
btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
btn.Text = text
btn.TextColor3 = Color3.fromRGB(200, 200, 200)
btn.Font = Enum.Font.GothamSemibold
btn.TextSize = 14
btn.AutoButtonColor = false
btn.Parent = Main
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = btn
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 255, 120)
stroke.Thickness = 1
stroke.Transparency = 0.8
stroke.Parent = btn
btn.MouseEnter:Connect(function()
TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 35), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0.3}):Play()
end)
btn.MouseLeave:Connect(function()
TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(25, 25, 25), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0.8}):Play()
end)
return btn
end

local autoBtn = createButton(Lang[cur].Auto .. "KI", UDim2.new(0, 20, 0, 70))
local speedBtn = createButton(Lang[cur].Speed .. "KI", UDim2.new(0, 20, 0, 130))
local langBtn = createButton(Lang[cur].Lang, UDim2.new(0, 20, 0, 280))

local function update()
autoBtn.Text = Lang[cur].Auto .. (autoEnabled and (cur == "HU" and "BE" or "ON") or (cur == "HU" and "KI" or "OFF"))
autoBtn.TextColor3 = autoEnabled and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 200, 200)
speedBtn.Text = Lang[cur].Speed .. (speedEnabled and (cur == "HU" and "BE" or "ON") or (cur == "HU" and "KI" or "OFF"))
speedBtn.TextColor3 = speedEnabled and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 200, 200)
Title.Text = Lang[cur].Title
langBtn.Text = Lang[cur].Lang
end

autoBtn.MouseButton1Click:Connect(function()
autoEnabled = not autoEnabled
update()
end)

task.spawn(function()
while task.wait(0.1) do
if autoEnabled then
for _, obj in pairs(workspace:GetDescendants()) do
if obj:IsA("StringValue") and obj.Value == "Celestial" then
local target = obj.Parent
if target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
player.Character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, 3, 0)
task.wait(0.2)
local prompt = target:FindFirstChildOfClass("ProximityPrompt")
if prompt then fireproximityprompt(prompt) end
end
end
end
end
end
end)

speedBtn.MouseButton1Click:Connect(function()
speedEnabled = not speedEnabled
if player.Character and player.Character:FindFirstChild("Humanoid") then
player.Character.Humanoid.WalkSpeed = speedEnabled and 50 or 16
end
update()
end)

langBtn.MouseButton1Click:Connect(function()
cur = (cur == "HU") and "EN" or "HU"
update()
end)

UserInputService.InputBegan:Connect(function(i, p)
if not p and i.KeyCode == Enum.KeyCode.Insert then
Main.Visible = not Main.Visible
end
end)

update()
