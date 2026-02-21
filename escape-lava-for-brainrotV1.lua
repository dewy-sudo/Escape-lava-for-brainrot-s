local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- EREDETI CONFIG (Változatlanul)
local CONFIG = {
speed = 18,
jumpPower = 129,
maxHealth = 174,
respawnTime = 10,
debugMode = false
}

-- GUI LÉTREHOZÁSA (Széles vízszintes Solara design)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotSolaraHU"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 500, 0, 100) -- Széles vízszintes forma
Main.Position = UDim2.new(0.5, -250, 0.8, -50)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 120) -- Neon zöld
UIStroke.Thickness = 2
UIStroke.Parent = Main

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "BRAINROT HUB - MAGYAR"
Title.TextColor3 = Color3.fromRGB(0, 255, 120)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = Main
Instance.new("UICorner").Parent = Title

-- GOMB FUNKCIÓK (Sima magyarítás)
local function createBtn(name, text, pos)
local btn = Instance.new("TextButton")
btn.Name = name
btn.Size = UDim2.new(0, 140, 0, 40)
btn.Position = pos
btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
btn.Text = text
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamSemibold
btn.TextSize = 12
btn.Parent = Main
Instance.new("UICorner").Parent = btn

end

local autoCeleBtn = createBtn("CeleBtn", "Auto Celestial: KI", UDim2.new(0, 20, 0, 45))
local autoSecretBtn = createBtn("SecretBtn", "Auto Secret: KI", UDim2.new(0, 180, 0, 45))
local speedBtn = createBtn("SpeedBtn", "Gyorsítás: KI", UDim2.new(0, 340, 0, 45))

-- Állapot változók
local celeOn = false
local secretOn = false
local speedOn = false

-- GOMB MŰKÖDÉS (Csak a kapcsolgatás és az eredeti logika hívása)
autoCeleBtn.MouseButton1Click:Connect(function()
celeOn = not celeOn
autoCeleBtn.Text = "Auto Celestial: " .. (celeOn and "BE" or "KI")
autoCeleBtn.TextColor3 = celeOn and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 255, 255)
end)

autoSecretBtn.MouseButton1Click:Connect(function()
secretOn = not secretOn
autoSecretBtn.Text = "Auto Secret: " .. (secretOn and "BE" or "KI")
autoSecretBtn.TextColor3 = secretOn and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 255, 255)
end)

speedBtn.MouseButton1Click:Connect(function()
speedOn = not speedOn
speedBtn.Text = "Gyorsítás: " .. (speedOn and "BE" or "KI")
speedBtn.TextColor3 = speedOn and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 255, 255)
if player.Character and player.Character:FindFirstChild("Humanoid") then
player.Character.Humanoid.WalkSpeed = speedOn and 50 or CONFIG.speed
end
end)

-- AZ EREDETI FARM LOGIKA (Csak akkor fut ha bekapcsolod a gombot)
task.spawn(function()
while task.wait(0.5) do
if celeOn or secretOn then
local targetRarity = celeOn and "Celestial" or "Secret"
for _, v in pairs(workspace:GetDescendants()) do
if (v:IsA("StringValue") and v.Value == targetRarity) or (v:IsA("TextLabel") and v.Text == targetRarity) then
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
end
end)

-- INSERT REJTÉS
UserInputService.InputBegan:Connect(function(input, processed)
if not processed and input.KeyCode == Enum.KeyCode.Insert then
Main.Visible = not Main.Visible
end
end)

-- EREDETI PLAYER SETUP (Amit küldtél)
local function setupPlayer(p)
local char = p.Character or p.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
hum.WalkSpeed = CONFIG.speed
hum.JumpPower = CONFIG.jumpPower
end

for _, p in ipairs(Players:GetPlayers()) do setupPlayer(p) end
Players.PlayerAdded:Connect(setupPlayer)
