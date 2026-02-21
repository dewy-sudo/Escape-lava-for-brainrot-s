-- CELESTIAL HUB - FIX & MERGED VERSION
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Előző verziók takarítása
if CoreGui:FindFirstChild("CelestialCheat") then
    CoreGui.CelestialCheat:Destroy()
end

-- Fő UI létrehozása (A te kódod alapján)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CelestialCheat"
ScreenGui.Parent = CoreGui
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 380)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Parent = ScreenGui

local MCorner = Instance.new("UICorner")
MCorner.CornerRadius = UDim.new(0, 10)
MCorner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.Parent = MainFrame

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.Padding = UDim.new(0, 8)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- GOMB FUNKCIÓ
local function AddCheatButton(hu, en, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.95, 0, 0, 50)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Btn.Text = hu .. " / " .. en
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 15
    Btn.Parent = Container

    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 6)
    BC.Parent = Btn

    local toggled = false
    Btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        callback(toggled)
        local targetColor = toggled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(35, 35, 35)
        TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()
    end)
end

-- INTEGRÁLT FUNKCIÓK (A haverod értékeivel: 18 speed, 129 jump)
AddCheatButton("Szuper Sebesség", "Speed Hack", function(state)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = state and 18 or 16
    end
end)

AddCheatButton("Szuper Ugrás", "Super Jump", function(state)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = state and 129 or 50
    end
end)

-- DRAG (Mozgatás - A te kódod)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
