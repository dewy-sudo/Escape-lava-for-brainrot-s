local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- EREDETI SEBESSÉG BEÁLLÍTÁS
local baseSpeed = 18

-- GUI LÉTREHOZÁSA (SZÉLES, MODERN DESIGN)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotV3"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 500, 0, 110)
Main.Position = UDim2.new(0.5, -250, 0.8, -55)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35) -- Sötétkék/lila árnyalat a képed alapján
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(80, 80, 255)
Stroke.Thickness = 2
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "BRAINROT HUB - MAGYAROSÍTOTT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
Title.Font = Enum.Font.GothamBold
Title.Parent = Main
Instance.new("UICorner").Parent = Title

-- GOMBOK LÉTREHOZÁSA (Fix nevekkel, hogy ne legyen 'nil' hiba)
local function makeBtn(txt, pos)
local b = Instance.new("TextButton")
b.Size = UDim2.new(0, 140, 0, 45)
b.Position = pos
b.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
b.Text = txt
b.TextColor3 = Color3.fromRGB(255, 255, 255)
b.Font = Enum.Font.GothamSemibold
b.TextSize = 12
b.Parent = Main
Instance.new("UICorner").Parent = b
return b
end

local btnCele = makeBtn("Auto Celestial: KI", UDim2.new(0, 20, 0, 45))
local btnSecret = makeBtn("Auto Secret: KI", UDim2.new(0, 180, 0, 45))
local btnSpeed = makeBtn("Gyorsítás: KI", UDim2.new(0, 340, 0, 45))

-- ÁLLAPOTOK
local celeOn = false
local secretOn = false
local speedOn = false

-- GOMB FUNKCIÓK (Most már biztosan nem lesznek 'nil' értékek)
btnCele.MouseButton1Click:Connect(function()
celeOn = not celeOn
btnCele.Text = "Auto Celestial: " .. (celeOn and "BE" or "KI")
btnCele.BackgroundColor3 = celeOn and Color3.fromRGB(60, 180, 100) or Color3.fromRGB(45, 45, 65)
end)

btnSecret.MouseButton1Click:Connect(function()
secretOn = not secretOn
btnSecret.Text = "Auto Secret: " .. (secretOn and "BE" or "KI")
btnSecret.BackgroundColor3 = secretOn and Color3.fromRGB(60, 180, 100) or Color3.fromRGB(45, 45, 65)
end)

btnSpeed.MouseButton1Click:Connect(function()
speedOn = not speedOn
btnSpeed.Text = "Gyorsítás: " .. (speedOn and "BE" or "KI")
btnSpeed.BackgroundColor3 = speedOn and Color3.fromRGB(60, 180, 100) or Color3.fromRGB(45, 45, 65)
if player.Character and player.Character:FindFirstChild("Humanoid") then
player.Character.Humanoid.WalkSpeed = speedOn and 50 or baseSpeed
end
end)

-- AZ EREDETI FARMER LOGIKA (Változatlanul)
task.spawn(function()
while task.wait(0.5) do
if celeOn or secretOn then
local rar = celeOn and "Celestial" or "Secret"
for _, v in pairs(workspace:GetDescendants()) do
if (v:IsA("StringValue") and v.Value == rar) or (v:IsA("TextLabel") and v.Text == rar) then
local t = v.Parent
if t and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
player.Character.HumanoidRootPart.CFrame = (t:IsA("Model") and t:GetModelCFrame()) or t.CFrame
task.wait(0.1)
local p = t:FindFirstChildOfClass("ProximityPrompt")
if p then fireproximityprompt(p) end
break
end
end
end
end
end
end)

-- ELREJTÉS (INSERT)
UserInputService.InputBegan:Connect(function(key, proc)
if not proc and key.KeyCode == Enum.KeyCode.Insert then
Main.Visible = not Main.Visible
end
end)
