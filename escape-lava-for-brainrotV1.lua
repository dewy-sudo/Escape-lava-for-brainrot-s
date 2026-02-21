local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local Lang = {
HU = {Title = "SOLARA BRAINROT V2", Secret = "Auto Secret: ", Cele = "Auto Celestial: ", Speed = "Gyorsitas: ", Lang = "Nyelv: HU"},
EN = {Title = "SOLARA BRAINROT V2", Secret = "Auto Secret: ", Cele = "Auto Celestial: ", Speed = "Speed Boost: ", Lang = "Lang: EN"}
}
local cur = "HU"

local autoSecret = false
local autoCele = false
local speedEnabled = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SolaraProV2"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 320, 0, 400)
Main.Position = UDim2.new(0.5, -160, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 120)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.4
UIStroke.Parent = Main

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Title.Text = Lang[cur].Title
Title.TextColor3 = Color3.fromRGB(0, 255, 120)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.Parent = Main
local TitleCorner = Instance.new("UICorner")
TitleCorner.Parent = Title

local function createButton(text, pos, isMain)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 280, 0, 48)
btn.Position = pos
btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
btn.Text = text
btn.TextColor3 = Color3.fromRGB(200, 200, 200)
btn.Font = Enum.Font.GothamSemibold
btn.TextSize = 14
btn.AutoButtonColor = false
btn.Parent = Main
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = btn
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 255, 120)
stroke.Thickness = 1
stroke.Transparency = 0.8
stroke.Parent = btn

btn.MouseEnter:Connect(function()
TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 30), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0.2, Thickness = 1.5}):Play()
end)
btn.MouseLeave:Connect(function()
TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(22, 22, 22), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0.8, Thickness = 1}):Play()
end)
return btn
end

local secretBtn = createButton(Lang[cur].Secret .. "KI", UDim2.new(0, 20, 0, 80))
local celeBtn = createButton(Lang[cur].Cele .. "KI", UDim2.new(0, 20, 0, 140))
local speedBtn = createButton(Lang[cur].Speed .. "KI", UDim2.new(0, 20, 0, 200))
local langBtn = createButton(Lang[cur].Lang, UDim2.new(0, 20, 0, 330))
langBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 15)

local function update()
local function getStatus(val) return val and (cur == "HU" and "BE" or "ON") or (cur == "HU" and "KI" or "OFF") end
secretBtn.Text = Lang[cur].Secret .. getStatus(autoSecret)
secretBtn.TextColor3 = autoSecret and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 200, 200)
celeBtn.Text = Lang[cur].Cele .. getStatus(autoCele)
celeBtn.TextColor3 = autoCele and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 200, 200)
speedBtn.Text = Lang[cur].Speed .. getStatus(speedEnabled)
speedBtn.TextColor3 = speedEnabled and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 200, 200)
Title.Text = Lang[cur].Title
langBtn.Text = Lang[cur].Lang
end

local function farm(rarity)
for _, obj in pairs(workspace:GetDescendants()) do
if obj:IsA("StringValue") and obj.Value == rarity then
local target = obj.Parent
if target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
player.Character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, 3, 0)
task.wait(0.2)
local prompt = target:FindFirstChildOfClass("ProximityPrompt")
if prompt then fireproximityprompt(prompt) end
break
end
end
end
end

secretBtn.MouseButton1Click:Connect(function() autoSecret = not autoSecret if autoSecret then autoCele = false end update() end)
celeBtn.MouseButton1Click:Connect(function() autoCele = not autoCele if autoCele then autoSecret = false end update() end)
speedBtn.MouseButton1Click:Connect(function()
speedEnabled = not speedEnabled
if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.WalkSpeed = speedEnabled and 60 or 16 end
update()
end)
langBtn.MouseButton1Click:Connect(function() cur = (cur == "HU") and "EN" or "HU" update() end)

task.spawn(function()
while task.wait(0.5) do
if autoSecret then farm("Secret") end
if autoCele then farm("Celestial") end
end
end)

UserInputService.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.Insert then Main.Visible = not Main.Visible end end)

update()
