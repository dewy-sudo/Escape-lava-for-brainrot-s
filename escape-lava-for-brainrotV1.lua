local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local Lang = {
HU = {Title = "Escape lava for brainrots (BY DEWY | V1)", Secret = "Auto Secret", Cele = "Auto Celestial", Speed = "Gyorsitas", Lang = "HU", Status = "Allapot: "},
EN = {Title = "SEscape lava for brainrots (BY DEWY | V1)", Secret = "Auto Secret", Cele = "Auto Celestial", Speed = "Speed Boost", Lang = "EN", Status = "Status: "}
}
local cur = "HU"

local autoSecret = false
local autoCele = false
local speedEnabled = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SolaraHorizontal"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- VÍZSZINTES SZÉLES PANEL
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 600, 0, 120)
Main.Position = UDim2.new(0.5, -300, 0.85, -60)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
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
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = Lang[cur].Title
Title.TextColor3 = Color3.fromRGB(0, 255, 120)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = Main
local TitleCorner = Instance.new("UICorner")
TitleCorner.Parent = Title

local function createButton(text, pos)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 130, 0, 40)
btn.Position = pos
btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
btn.Text = text
btn.TextColor3 = Color3.fromRGB(200, 200, 200)
btn.Font = Enum.Font.GothamSemibold
btn.TextSize = 12
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
return btn
end

-- GOMBOK ELHELYEZÉSE EGY SORBAN
local secretBtn = createButton(Lang[cur].Secret, UDim2.new(0, 15, 0, 50))
local celeBtn = createButton(Lang[cur].Cele, UDim2.new(0, 160, 0, 50))
local speedBtn = createButton(Lang[cur].Speed, UDim2.new(0, 305, 0, 50))
local langBtn = createButton("Nyelv: " .. Lang[cur].Lang, UDim2.new(0, 450, 0, 50))

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 95)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = Lang[cur].Status .. "IDLE"
statusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.Parent = Main

local function updateUI()
local function getCol(v) return v and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 200, 200) end
secretBtn.TextColor3 = getCol(autoSecret)
celeBtn.TextColor3 = getCol(autoCele)
speedBtn.TextColor3 = getCol(speedEnabled)
langBtn.Text = (cur == "HU" and "Nyelv: " or "Lang: ") .. Lang[cur].Lang
Title.Text = Lang[cur].Title
statusLabel.Text = Lang[cur].Status .. (autoSecret and "SEARCHING SECRET..." or autoCele and "SEARCHING CELESTIAL..." or "READY")
end

-- LOGIKA A DEOBFUSCATED KÓD ALAPJÁN
local function collect(rarity)
for _, v in pairs(workspace:GetDescendants()) do
if (v:IsA("StringValue") and v.Value == rarity) or (v:IsA("TextLabel") and v.Text == rarity) then
local target = v.Parent
if target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
player.Character.HumanoidRootPart.CFrame = target:GetModelCFrame() or target.CFrame
task.wait(0.1)
local prompt = target:FindFirstChildOfClass("ProximityPrompt")
if prompt then fireproximityprompt(prompt) end
break
end
end
end
end

secretBtn.MouseButton1Click:Connect(function() autoSecret = not autoSecret if autoSecret then autoCele = false end updateUI() end)
celeBtn.MouseButton1Click:Connect(function() autoCele = not autoCele if autoCele then autoSecret = false end updateUI() end)
speedBtn.MouseButton1Click:Connect(function()
speedEnabled = not speedEnabled
if player.Character and player.Character:FindFirstChild("Humanoid") then
player.Character.Humanoid.WalkSpeed = speedEnabled and 50 or 18
end
updateUI()
end)
langBtn.MouseButton1Click:Connect(function() cur = (cur == "HU") and "EN" or "HU" updateUI() end)

task.spawn(function()
while task.wait(0.5) do
if autoSecret then collect("Secret") end
if autoCele then collect("Celestial") end
end
end)
