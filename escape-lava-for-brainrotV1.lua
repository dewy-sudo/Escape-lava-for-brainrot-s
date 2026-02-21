local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local baseSpeed = 18
local fastSpeed = 50

-- ÖSSZEKÖTÉS AZ IDEGEN RENDSZERREL
-- Megkeressük azokat a csatornákat, amiket az idegen script használ
local remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
local damageEvent = remotes and remotes:FindFirstChild("DamageEvent")

-- GUI LÉTREHOZÁSA (Marad a stílusod, de stabilabb alapokon)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotV3_Pro"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 500, 0, 110)
Main.Position = UDim2.new(0.5, -250, 0.8, -55)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.Draggable = true
Main.Active = true
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.Parent = Main

-- GOMB KÉSZÍTŐ (Gyorsabb és tisztább)
local function makeBtn(txt, pos)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 140, 0, 45)
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.Parent = Main
    Instance.new("UICorner").Parent = b
    return b
end

local btnCele = makeBtn("Celestial Farm: KI", UDim2.new(0, 20, 0, 45))
local btnSecret = makeBtn("Secret Farm: KI", UDim2.new(0, 180, 0, 45))
local btnSpeed = makeBtn("Speed Hack: KI", UDim2.new(0, 340, 0, 45))

local celeOn, secretOn, speedOn = false, false, false

-- FUNKCIÓK ÖSSZEKÖTÉSE
btnCele.MouseButton1Click:Connect(function()
    celeOn = not celeOn
    btnCele.Text = "Celestial: " .. (celeOn and "BE" or "KI")
    btnCele.BackgroundColor3 = celeOn and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 40, 60)
end)

btnSpeed.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    btnSpeed.Text = "Speed: " .. (speedOn and "BE" or "KI")
end)

-- OPTIMALIZÁLT SEBESSÉG (Kikerüli az idegen script lassítását)
RunService.Heartbeat:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        if speedOn then
            hum.WalkSpeed = fastSpeed
        end
    end
end)

-- PROFESSZIONÁLIS FARMER LOGIKA
-- Nem nézzük át az egész mapot, csak a fontos dolgokat
task.spawn(function()
    while task.wait(0.1) do
        if celeOn or secretOn then
            local targetRarity = celeOn and "Celestial" or "Secret"
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                -- Hatékonyabb keresés: csak a Workspace-ben lévő modellekre
                for _, obj in pairs(workspace:GetChildren()) do
                    -- Megnézzük, hogy az objektumban van-e a keresett érték (ahogy az idegen kód várja)
                    local val = obj:FindFirstChildOfClass("StringValue") or obj:FindFirstChildOfClass("TextLabel")
                    
                    if val and (val.Value == targetRarity or (val:IsA("TextLabel") and val.Text == targetRarity)) then
                        -- TELEPORT ÉS INTERAKCIÓ
                        hrp.CFrame = obj:GetPivot()
                        
                        -- Megpróbáljuk aktiválni a ProximityPromptot (Exploit funkcióval)
                        local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
                        if prompt and fireproximityprompt then
                            fireproximityprompt(prompt)
                        end
                        
                        -- HA VAN DAMAGE EVENT (Összekötés az idegen kóddal)
                        -- Ha a farmoláshoz ütni is kell, itt küldjük el a jelet a szervernek
                        if damageEvent then
                            damageEvent:FireServer(obj, 100, 1) -- Megütjük a tárgyat a szerveren keresztül
                        end
                        
                        break -- Találtunk egyet, ne keressünk tovább ebben a körben
                    end
                end
            end
        end
    end
end)

-- INSERT REJTÉS
UserInputService.InputBegan:Connect(function(k, p)
    if not p and k.KeyCode == Enum.KeyCode.Insert then Main.Visible = not Main.Visible end
end)
