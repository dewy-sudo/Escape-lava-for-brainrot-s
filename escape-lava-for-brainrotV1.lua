-- ==========================================
-- A TE EREDETI RENDSZERED (ÉRINTETLEN)
-- ==========================================

local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Main configuration
local CONFIG = {
    speed = 18,
    jumpPower = 129,
    maxHealth = 174,
    respawnTime = 10,
    debugMode = false
}

-- Event connections
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local damageEvent = remotes:WaitForChild("DamageEvent")
local healEvent = remotes:WaitForChild("HealEvent")
local respawnEvent = remotes:WaitForChild("RespawnEvent")

-- Weapon definitions
local weapons = {
    { name = "Sword", damage = 15, cooldown = 0.8, range = 4 },
    { name = "Bow", damage = 10, cooldown = 1.2, range = 30 },
    { name = "Staff", damage = 25, cooldown = 2.5, range = 15 }
}

-- Utility functions
local function calculateDamage(baseDamage, distance, player)
    local character = player.Character
    if not character then return 0 end
    local modifier = 1
    if distance > 10 then
        modifier = modifier * (1 - (distance - 10) * 0.02)
    end
    modifier = modifier * (math.random() * 0.2 + 0.9)
    return math.floor(baseDamage * modifier)
end

-- Player handling
local function setupPlayer(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid.WalkSpeed = CONFIG.speed
    humanoid.JumpPower = CONFIG.jumpPower
    humanoid.MaxHealth = CONFIG.maxHealth
    humanoid.Health = CONFIG.maxHealth
    
    damageEvent.OnServerEvent:Connect(function(playerWhoFired, targetPlayer, damageAmount, weaponIndex)
        if playerWhoFired ~= player then return end
        if not targetPlayer or not targetPlayer.Character then return end
        
        local weapon = weapons[weaponIndex or 1]
        if not weapon then return end
        
        local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
        if targetHumanoid then
            local playerPosition = player.Character.PrimaryPart.Position
            local targetPosition = targetPlayer.Character.PrimaryPart.Position
            local distance = (playerPosition - targetPosition).Magnitude
            
            if distance <= weapon.range then
                local finalDamage = calculateDamage(damageAmount or weapon.damage, distance, targetPlayer)
                targetHumanoid.Health = math.max(0, targetHumanoid.Health - finalDamage)
                remotes.DamageEffect:FireClient(targetPlayer, finalDamage)
            end
        end
    end)
end

for _, player in ipairs(Players:GetPlayers()) do setupPlayer(player) end
Players.PlayerAdded:Connect(setupPlayer)

RunService.Heartbeat:Connect(function(deltaTime)
    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid.Health <= 0 then
                if not character:FindFirstChild("Respawning") then
                    local respawning = Instance.new("BoolValue")
                    respawning.Name = "Respawning"
                    respawning.Parent = character
                    task.delay(CONFIG.respawnTime, function()
                        respawnEvent:FireClient(player)
                    end)
                end
            end
        end
    end
end)

-- ==========================================
-- ÚJ, ANIMÁLT MAGYAR GUI RÉSZ
-- ==========================================

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernExecutorGUI"
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 220)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 160, 255)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.5
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "  MAGYAR EXECUTOR V1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0.6, 0)
StatusLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Állapot: [ AKTÍV ]\n\nSebesség: " .. CONFIG.speed .. "\nUgrás: " .. CONFIG.jumpPower .. "\nÉleterő: " .. CONFIG.maxHealth .. "\nRespawn: " .. CONFIG.respawnTime .. " mp"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextSize = 14
StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
StatusLabel.Parent = MainFrame

-- Húzható funkció
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

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Beúszó Animáció
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame:TweenSize(UDim2.new(0, 350, 0, 220), "Out", "Back", 0.6, true)

print("Rendszer és GUI sikeresen betöltve!")
