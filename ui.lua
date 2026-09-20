local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local C = _G.LLUHA.C
local RC = _G.LLUHA.RC
local ADMIN_PASS = "67lluhasigma"
local AdminMode = false

local sg = Instance.new("ScreenGui")
sg.Name = "LLUHA_HUB"
sg.ResetOnSpawn = false
sg.Parent = CoreGui
_G.LLUHA.SG = sg

local logoFrame = Instance.new("Frame")
logoFrame.Size = UDim2.new(0, 45, 0, 45)
logoFrame.Position = UDim2.new(0.5, -22, 0, 30)
logoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
logoFrame.BorderSizePixel = 0
logoFrame.Parent = sg
local logoC = Instance.new("UICorner", logoFrame)
logoC.CornerRadius = UDim.new(1, 0)
local logoS = Instance.new("UIStroke", logoFrame)
logoS.Color = Color3.fromRGB(150, 50, 255)
logoS.Thickness = 2
local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "🔥"
logoText.TextScaled = true
logoText.Parent = logoFrame

local nameTag = Instance.new("TextLabel")
nameTag.Size = UDim2.new(0, 130, 0, 26)
nameTag.Position = UDim2.new(0.5, -65, 0, 5)
nameTag.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
nameTag.BackgroundTransparency = 0.2
nameTag.BorderSizePixel = 0
nameTag.Text = "🔥 LLUHA HUB"
nameTag.TextColor3 = Color3.new(1, 1, 1)
nameTag.Font = Enum.Font.GothamBold
nameTag.TextSize = 13
nameTag.Parent = sg
local ntC = Instance.new("UICorner", nameTag)
ntC.CornerRadius = UDim.new(0, 13)
local ntS = Instance.new("UIStroke", nameTag)
ntS.Color = Color3.fromRGB(150, 50, 255)
ntS.Thickness = 1.5

local roleCenter = Instance.new("TextLabel")
roleCenter.Size = UDim2.new(0, 300, 0, 30)
roleCenter.Position = UDim2.new(0.5, -150, 0.5, -60)
roleCenter.BackgroundTransparency = 1
roleCenter.Text = "You Are Innocent"
roleCenter.TextColor3 = Color3.fromRGB(0, 255, 0)
roleCenter.Font = Enum.Font.GothamBlack
roleCenter.TextSize = 24
roleCenter.TextStrokeTransparency = 0
roleCenter.TextStrokeColor3 = Color3.new(0, 0, 0)
roleCenter.Visible = false
roleCenter.Parent = sg

task.spawn(function()
    while task.wait(0.5) do
        local myRole = _G.LLUHA.GetMyRole and _G.LLUHA.GetMyRole() or "Innocent"
        roleCenter.Text = "You Are " .. myRole
        roleCenter.TextColor3 = RC[myRole] or Color3.fromRGB(255, 255, 255)
    end
end)

local shootBtn = Instance.new("TextButton")
shootBtn.Size = UDim2.new(0, 130, 0, 130)
shootBtn.Position = UDim2.new(0, 60, 0, 120)
shootBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
shootBtn.BackgroundTransparency = 0.4
shootBtn.BorderSizePixel = 0
shootBtn.Text = "⨁\n\nSHOOT"
shootBtn.TextColor3 = Color3.new(1, 1, 1)
shootBtn.Font = Enum.Font.GothamBlack
shootBtn.TextSize = 16
shootBtn.Active = true
shootBtn.Parent = sg
local sbC = Instance.new("UICorner", shootBtn)
sbC.CornerRadius = UDim.new(0, 14)
local sbS = Instance.new("UIStroke", shootBtn)
sbS.Color = Color3.fromRGB(255, 50, 50)
sbS.Thickness = 3

shootBtn.MouseButton1Click:Connect(function()
    C.AShoot = true
    C.FOV = true
    shootBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    sbS.Color = Color3.fromRGB(50, 255, 50)
end)

local skullBtn = Instance.new("TextButton")
skullBtn.Size = UDim2.new(0, 45, 0, 45)
skullBtn.Position = UDim2.new(0.5, -22, 0, 5)
skullBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
skullBtn.BackgroundTransparency = 0.3
skullBtn.Text = "💀"
skullBtn.TextColor3 = Color3.new(1, 1, 1)
skullBtn.TextScaled = true
skullBtn.Font = Enum.Font.GothamBlack
skullBtn.Parent = sg
local skC = Instance.new("UICorner", skullBtn)
skC.CornerRadius = UDim.new(1, 0)
local skS = Instance.new("UIStroke", skullBtn)
skS.Color = Color3.fromRGB(100, 50, 255)
skS.Thickness = 2

local quickBar = Instance.new("Frame")
quickBar.Size = UDim2.new(0, 60, 0, 490)
quickBar.Position = UDim2.new(0, 20, 0.5, -245)
quickBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
quickBar.BackgroundTransparency = 0.15
quickBar.BorderSizePixel = 0
quickBar.Active = true
quickBar.Draggable = true
quickBar.Parent = sg
local qbc = Instance.new("UICorner", quickBar)
qbc.CornerRadius = UDim.new(0, 10)
local qbs = Instance.new("UIStroke", quickBar)
qbs.Color = Color3.fromRGB(180, 0, 255)
qbs.Thickness = 1.5
local ql = Instance.new("UIListLayout", quickBar)
ql.Padding = UDim.new(0, 4)
ql.SortOrder = Enum.SortOrder.LayoutOrder
ql.HorizontalAlignment = Enum.HorizontalAlignment.Center
local qp = Instance.new("UIPadding", quickBar)
qp.PaddingTop = UDim.new(0, 6)

local function QBtn(text, key, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 50, 0, 28)
    b.BackgroundColor3 = C[key] and color or Color3.fromRGB(35, 35, 48)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.Parent = quickBar
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function()
        C[key] = not C[key]
        b.BackgroundColor3 = C[key] and color or Color3.fromRGB(35, 35, 48)
    end)
    return b
end

QBtn("ESP", "ESP", Color3.fromRGB(50, 100, 50))
QBtn("AIM", "AShoot", Color3.fromRGB(150, 30, 30))
QBtn("FOV", "FOV", Color3.fromRGB(100, 50, 150))
QBtn("FLY", "Fly", Color3.fromRGB(30, 80, 150))
QBtn("SPD", "Speed", Color3.fromRGB(150, 120, 30))
QBtn("FARM", "Farm", Color3.fromRGB(150, 90, 30))
QBtn("KNIF", "AutoKnife", Color3.fromRGB(200, 50, 50))
QBtn("FLNG", "AutoFling", Color3.fromRGB(180, 30, 80))
QBtn("KILL", "AKill", Color3.fromRGB(180, 30, 30))
QBtn("AURA", "KAura", Color3.fromRGB(150, 30, 150))
QBtn("NOCL", "NoClip", Color3.fromRGB(60, 60, 60))
QBtn("INVS", "Invis", Color3.fromRGB(80, 80, 120))
QBtn("TPK", "TPK", Color3.fromRGB(120, 30, 120))
QBtn("JUMP", "NormalJump", Color3.fromRGB(60, 130, 60))
QBtn("GOLD", "GoldenJump", Color3.fromRGB(200, 170, 30))

local menuBtn = Instance.new("TextButton")
menuBtn.Size = UDim2.new(0, 50, 0, 28)
menuBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
menuBtn.Text = "MENU"
menuBtn.TextColor3 = Color3.new(1, 1, 1)
menuBtn.Font = Enum.Font.GothamBold
menuBtn.TextSize = 10
menuBtn.Parent = quickBar
local mbc = Instance.new("UICorner", menuBtn)
mbc.CornerRadius = UDim.new(0, 6)

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 340, 0, 520)
main.Position = UDim2.new(0.5, -170, 0.5, -260)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Visible = false
main.Parent = sg
local mc = Instance.new("UICorner", main)
mc.CornerRadius = UDim.new(0, 12)
local ms = Instance.new("UIStroke", main)
ms.Color = Color3.fromRGB(180, 0, 255)
ms.Thickness = 2

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
titleBar.BackgroundTransparency = 0.15
titleBar.BorderSizePixel = 0
titleBar.Parent = main
local tbc = Instance.new("UICorner", titleBar)
tbc.CornerRadius = UDim.new(0, 12)

local tl = Instance.new("TextLabel")
tl.Size = UDim2.new(1, -70, 1, 0)
tl.Position = UDim2.new(0, 12, 0, 0)
tl.BackgroundTransparency = 1
tl.Text = "🔥 LLUHA HUB"
tl.TextColor3 = Color3.new(1, 1, 1)
tl.Font = Enum.Font.GothamBold
tl.TextSize = 15
tl.TextXAlignment = Enum.TextXAlignment.Left
tl.Parent = titleBar

local closeB = Instance.new("TextButton")
closeB.Size = UDim2.new(0, 26, 0, 26)
closeB.Position = UDim2.new(1, -32, 0, 6)
closeB.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
closeB.Text = "X"
closeB.TextColor3 = Color3.new(1, 1, 1)
closeB.Font = Enum.Font.GothamBold
closeB.TextSize = 14
closeB.Parent = titleBar
local cbc = Instance.new("UICorner", closeB)
cbc.CornerRadius = UDim.new(0, 6)

local roleL = Instance.new("TextLabel")
roleL.Size = UDim2.new(0.5, 0, 0, 16)
roleL.Position = UDim2.new(0, 12, 0, 42)
roleL.BackgroundTransparency = 1
roleL.Text = "Роль: Innocent"
roleL.TextColor3 = Color3.fromRGB(0, 255, 0)
roleL.Font = Enum.Font.GothamBold
roleL.TextSize = 11
roleL.TextXAlignment = Enum.TextXAlignment.Left
roleL.Parent = main

local adminL = Instance.new("TextLabel")
adminL.Size = UDim2.new(0.5, -12, 0, 16)
adminL.Position = UDim2.new(0.5, 0, 0, 42)
adminL.BackgroundTransparency = 1
adminL.Text = "Админ: ВЫКЛ"
adminL.TextColor3 = Color3.fromRGB(255, 100, 100)
adminL.Font = Enum.Font.GothamBold
adminL.TextSize = 11
adminL.TextXAlignment = Enum.TextXAlignment.Right
adminL.Parent = main

local timerL = Instance.new("TextLabel")
timerL.Size = UDim2.new(1, -24, 0, 14)
timerL.Position = UDim2.new(0, 12, 0, 57)
timerL.BackgroundTransparency = 1
timerL.Text = "⏱ 00:00"
timerL.TextColor3 = Color3.fromRGB(255, 200, 50)
timerL.Font = Enum.Font.GothamBold
timerL.TextSize = 11
timerL.TextXAlignment = Enum.TextXAlignment.Left
timerL.Parent = main

task.spawn(function()
    while task.wait(0.4) do
        local r = _G.LLUHA.GetMyRole and _G.LLUHA.GetMyRole() or "Innocent"
        roleL.Text = "Роль: " .. r
        roleL.TextColor3 = RC[r] or Color3.fromRGB(255, 255, 255)
        adminL.Text = AdminMode and "Админ: ВКЛ" or "Админ: ВЫКЛ"
        adminL.TextColor3 = AdminMode and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        local t = _G.LLUHA.RoundTime or 0
        timerL.Text = string.format("⏱ %02d:%02d", math.floor(t/60), t%60)
    end
end)

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -16, 0, 28)
tabBar.Position = UDim2.new(0, 8, 0, 76)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main
local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 3)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 1, -115)
scroll.Position = UDim2.new(0, 8, 0, 108)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 5
scroll.ScrollBarImageColor3 = Color3.fromRGB(180, 0, 255)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = main
local grid = Instance.new("UIGridLayout", scroll)
grid.CellSize = UDim2.new(0, 150, 0, 30)
grid.CellPadding = UDim2.new(0, 5, 0, 5)
grid.SortOrder = Enum.SortOrder.LayoutOrder

local function Btn(text, cb)
    local b = Instance.new("TextButton")
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 11
    b.TextWrapped = true
    b.Parent = scroll
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function() cb(b) end)
    return b
end

local function Toggle(key, label)
    return Btn(label .. ": " .. (C[key] and "ВКЛ" or "ВЫКЛ"), function(b)
        C[key] = not C[key]
        b.Text = label .. ": " .. (C[key] and "ВКЛ" or "ВЫКЛ")
        b.BackgroundColor3 = C[key] and Color3.fromRGB(80, 30, 120) or Color3.fromRGB(35, 35, 48)
    end)
end

local currentTab = "combat"

local function Refresh()
    for _, v in pairs(scroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    if currentTab == "combat" then
        Toggle("ESP", "ESP")
        Toggle("ESPNames", "Имена")
        Toggle("ESPRoles", "Роли")
        Toggle("ESPHealth", "HP")
        Toggle("ESPDist", "Дистанция")
        Toggle("AShoot", "Aimbot")
        Toggle("FOV", "FOV")
        Toggle("AKill", "AutoKill")
        Toggle("KAura", "KillAura")
        Toggle("AutoKnife", "AutoKnife")
        Toggle("AutoFling", "AutoFling")
        Toggle("ADodge", "AutoDodge")
        Toggle("Fling", "Fling")
        Toggle("Freeze", "Freeze")
    elseif currentTab == "farm" then
        Toggle("Farm", "Farm Coins")
        Toggle("FarmSafe", "Farm Safe")
        Toggle("AutoRespawn", "Авто-респавн")
        Toggle("CoinMagnet", "Coin Magnet")
    elseif currentTab == "move" then
        Toggle("Speed", "SpeedHack")
        Toggle("Jump", "HighJump")
        Toggle("InfJ", "InfiniteJump")
        Toggle("Fly", "Fly")
        Toggle("NoClip", "Noclip")
        Toggle("CTP", "ClickTP")
        Toggle("BJ", "BombJump")
        Toggle("NormalJump", "Normal Jump")
        Toggle("GoldenJump", "Golden Jump")
        Toggle("TPK", "TP Killer (G)")
    elseif currentTab == "player" then
        Toggle("Invis", "Invisible")
        Toggle("Ghost", "Ghost")
        Toggle("Godmode", "God Mode")
        Toggle("AFling", "AntiFling")
        Toggle("AntiAFK", "AntiAFK")
        Toggle("Fullbright", "Fullbright")
        Toggle("NoFog", "No Fog")
        Toggle("FPSBoost", "FPS Boost")
    elseif currentTab == "admin" then
        Btn("🔐 Ввести пароль", function(b)
            local input = Instance.new("TextBox")
            input.Size = UDim2.new(0, 200, 0, 35)
            input.Position = UDim2.new(0.5, -100, 0.5, -17)
            input.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            input.TextColor3 = Color3.new(1, 1, 1)
            input.PlaceholderText = "Пароль..."
            input.Font = Enum.Font.Gotham
            input.TextSize = 14
            input.Parent = sg
            local ic = Instance.new("UICorner", input)
            ic.CornerRadius = UDim.new(0, 8)
            input:CaptureFocus()
            input.FocusLost:Connect(function()
                if input.Text == ADMIN_PASS then
                    AdminMode = true
                    b.Text = "✅ Админ активен"
                else
                    b.Text = "❌ Неверный пароль"
                    task.wait(1.5)
                    b.Text = "🔐 Ввести пароль"
                end
                input:Destroy()
            end)
        end)
        if AdminMode then
            Btn("💊 Heal", function(b)
                local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                if h then h.Health = h.MaxHealth end
            end)
            Btn("🔄 Rejoin", function(b)
                game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
            end)
            Btn("☠ Reset", function(b)
                LP.Character:BreakJoints()
            end)
            Btn("💡 Fullbright ON", function(b) C.Fullbright = true end)
            Btn("🌑 Fullbright OFF", function(b) C.Fullbright = false end)
            Btn("⚡ Speed 100", function(b) C.Speed = true; C.SpeedVal = 100 end)
            Btn("🚶 Speed Обычная", function(b) C.Speed = false end)
            Btn("🦘 Jump 200", function(b) C.Jump = true; C.JumpVal = 200 end)
            Btn("🛡 God ON", function(b) C.Godmode = true end)
            Btn("🛡 God OFF", function(b) C.Godmode = false end)
            Btn("👻 Invis ON", function(b) C.Invis = true end)
            Btn("👻 Invis OFF", function(b) C.Invis = false end)
            Btn("📦 Farm ON", function(b) C.Farm = true end)
            Btn("📦 Farm OFF", function(b) C.Farm = false end)
        else
            Btn("🔒 Заблокировано", function(b) b.Text = "Введи пароль" end)
        end
    end
end

local tabNames = {
    {id = "combat", name = "⚔ Бой"},
    {id = "farm", name = "💰 Фарм"},
    {id = "move", name = "🏃 Движ"},
    {id = "player", name = "👤 Я"},
    {id = "admin", name = "🔐 Адм"},
}

local tabBtns = {}
for _, t in ipairs(tabNames) do
    local tb = Instance.new("TextButton")
    tb.Size = UDim2.new(0, 60, 1, 0)
    tb.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    tb.Text = t.name
    tb.TextColor3 = Color3.new(1, 1, 1)
    tb.Font = Enum.Font.GothamBold
    tb.TextSize = 10
    tb.Parent = tabBar
    local tc = Instance.new("UICorner", tb)
    tc.CornerRadius = UDim.new(0, 6)
    tb.MouseButton1Click:Connect(function()
        currentTab = t.id
        for _, b in pairs(tabBtns) do b.BackgroundColor3 = Color3.fromRGB(35, 35, 48) end
        tb.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
        Refresh()
    end)
    table.insert(tabBtns, tb)
end
tabBtns[1].BackgroundColor3 = Color3.fromRGB(180, 0, 255)
Refresh()

closeB.MouseButton1Click:Connect(function() main.Visible = false end)
menuBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)
skullBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

print("[LLUHA] ui loaded ✅")
