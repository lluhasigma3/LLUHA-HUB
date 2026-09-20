local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer

local C = _G.LLUHA and _G.LLUHA.C or {}
local RC = _G.LLUHA and _G.LLUHA.RC or {
    Murderer = Color3.fromRGB(255, 0, 0),
    Sheriff = Color3.fromRGB(0, 100, 255),
    Innocent = Color3.fromRGB(0, 255, 0),
}

local ADMIN_PASS = "67lluhasigma"
local AdminMode = false

local sg = Instance.new("ScreenGui")
sg.Name = "LLUHA_HUB_V12"
sg.ResetOnSpawn = false
sg.Parent = CoreGui
_G.LLUHA.SG = sg

-- FOV-круг
local fovCircle = Instance.new("Frame")
fovCircle.Size = UDim2.new(0, C.FOVSize or 200, 0, C.FOVSize or 200)
fovCircle.Position = UDim2.new(0.5, -(C.FOVSize or 200)/2, 0.5, -(C.FOVSize or 200)/2)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.Visible = false
fovCircle.ZIndex = 999
fovCircle.Parent = sg

local fovCorner = Instance.new("UICorner", fovCircle)
fovCorner.CornerRadius = UDim.new(1, 0)

local fovStroke = Instance.new("UIStroke", fovCircle)
fovStroke.Color = Color3.fromRGB(255, 50, 50)
fovStroke.Thickness = 1.5
fovStroke.Transparency = 0.3

_G.LLUHA.FOVCircle = fovCircle
_G.LLUHA.FOVStroke = fovStroke

task.spawn(function()
    while task.wait(0.05) do
        local fov = _G.LLUHA.FOVCircle
        local fovS = _G.LLUHA.FOVStroke
        if not fov then continue end
        local myRole = _G.LLUHA.GetMyRole and _G.LLUHA.GetMyRole() or "Innocent"
        local showFOV = false
        if C.FOV then
            if C.AShoot then showFOV = true
            elseif myRole == "Murderer" or myRole == "Sheriff" then showFOV = true
            else
                local ch = LP.Character
                if ch and ch:FindFirstChildOfClass("Tool") then showFOV = true end
            end
        end
        if showFOV then
            fov.Visible = true
            if fovS then
                if myRole == "Sheriff" then fovS.Color = Color3.fromRGB(0, 150, 255)
                elseif myRole == "Murderer" then fovS.Color = Color3.fromRGB(255, 50, 50)
                else fovS.Color = Color3.fromRGB(255, 200, 50) end
            end
        else
            fov.Visible = false
        end
    end
end)

-- Кнопка открытия
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 110, 0, 38)
openBtn.Position = UDim2.new(0, 20, 0.5, -19)
openBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
openBtn.Text = "🔥 LLUHA HUB"
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 13
openBtn.Active = true
openBtn.Draggable = true
openBtn.Parent = sg
local oc = Instance.new("UICorner", openBtn)
oc.CornerRadius = UDim.new(0, 8)
local os = Instance.new("UIStroke", openBtn)
os.Color = Color3.fromRGB(220, 100, 255)
os.Thickness = 2

-- Главное окно
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

-- Заголовок
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
tl.Text = "🔥 LLUHA HUB v12"
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

-- Инфо-панель
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
        local r = _G.LLUHA and _G.LLUHA.GetMyRole and _G.LLUHA.GetMyRole() or "Innocent"
        roleL.Text = "Роль: " .. r
        roleL.TextColor3 = RC[r] or Color3.fromRGB(255, 255, 255)
        adminL.Text = AdminMode and "Админ: ВКЛ" or "Админ: ВЫКЛ"
        adminL.TextColor3 = AdminMode and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        local t = _G.LLUHA.RoundTime or 0
        timerL.Text = string.format("⏱ %02d:%02d  |  FOV: %d", math.floor(t/60), t%60, C.FOVSize or 200)
    end
end)

-- Вкладки
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
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(80, 40, 120)
    s.Thickness = 1
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
        Toggle("ESPTracers", "Линии")
        Toggle("AShoot", "Aimbot")
        Btn("FOV: " .. (C.FOV and "ВКЛ" or "ВЫКЛ"), function(b)
            C.FOV = not C.FOV
            b.Text = "FOV: " .. (C.FOV and "ВКЛ" or "ВЫКЛ")
            b.BackgroundColor3 = C.FOV and Color3.fromRGB(80, 30, 120) or Color3.fromRGB(35, 35, 48)
        end)
        Btn("FOV Размер: " .. (C.FOVSize or 200), function(b)
            local sizes = {100, 150, 200, 250, 300, 400}
            local idx = 1
            for i, s in ipairs(sizes) do if s == C.FOVSize then idx = i; break end end
            idx = idx % #sizes + 1
            C.FOVSize = sizes[idx]
            b.Text = "FOV Размер: " .. C.FOVSize
            if _G.LLUHA.FOVCircle then
                _G.LLUHA.FOVCircle.Size = UDim2.new(0, C.FOVSize, 0, C.FOVSize)
                _G.LLUHA.FOVCircle.Position = UDim2.new(0.5, -C.FOVSize/2, 0.5, -C.FOVSize/2)
            end
        end)
        Toggle("AKill", "AutoKill")
        Toggle("KAura", "KillAura")
        Toggle("ADodge", "AutoDodge")
        Toggle("Fling", "Fling")
        Toggle("Freeze", "Freeze")
    elseif currentTab == "farm" then
        Toggle("Farm", "Farm Coins")
        Toggle("FarmSafe", "Farm Safe")
        Toggle("AutoRespawn", "Авто-респавн")
        Toggle("AutoCollect", "Auto Collect")
        Toggle("CoinMagnet", "Coin Magnet")
        Btn("Скорость: " .. string.format("%.1f", C.FarmSpeed or 1.5), function(b)
            local speeds = {0.5, 1, 1.5, 2, 3, 5}
            local idx = 1
            for i, s in ipairs(speeds) do if math.abs(s - C.FarmSpeed) < 0.1 then idx = i; break end end
            idx = idx % #speeds + 1
            C.FarmSpeed = speeds[idx]
            b.Text = "Скорость: " .. string.format("%.1f", C.FarmSpeed)
        end)
        Btn("Сумка: " .. (C.FullBag or 50), function(b)
            local vals = {30, 50, 100, 200}
            local idx = 1
            for i, v in ipairs(vals) do if v == C.FullBag then idx = i; break end end
            idx = idx % #vals + 1
            C.FullBag = vals[idx]
            b.Text = "Сумка: " .. C.FullBag
        end)
    elseif currentTab == "move" then
        Toggle("Speed", "SpeedHack")
        Btn("Speed Значение: " .. (C.SpeedVal or 22), function(b)
            local vals = {22, 30, 40, 50, 75, 100}
            local idx = 1
            for i, v in ipairs(vals) do if v == C.SpeedVal then idx = i; break end end
            idx = idx % #vals + 1
            C.SpeedVal = vals[idx]
            b.Text = "Speed Значение: " .. C.SpeedVal
        end)
        Toggle("Jump", "HighJump")
        Toggle("InfJ", "InfiniteJump")
        Toggle("Fly", "Fly")
        Btn("Fly Speed: " .. (C.FlySp or 60), function(b)
            local vals = {30, 60, 100, 150, 250, 400}
            local idx = 1
            for i, v in ipairs(vals) do if v == C.FlySp then idx = i; break end end
            idx = idx % #vals + 1
            C.FlySp = vals[idx]
            b.Text = "Fly Speed: " .. C.FlySp
        end)
        Toggle("NoClip", "Noclip")
        Toggle("CTP", "ClickTP")
        Toggle("BJ", "BombJump")
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
        Toggle("CustomSound", "Свой звук")
        Btn("Громкость: " .. (C.SoundVolume or 3), function(b)
            C.SoundVolume = (C.SoundVolume or 3) % 10 + 1
            b.Text = "Громкость: " .. C.SoundVolume
        end)
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
            local iss = Instance.new("UIStroke", input)
            iss.Color = Color3.fromRGB(180, 0, 255)
            input:CaptureFocus()
            input.FocusLost:Connect(function()
                if input.Text == ADMIN_PASS then
                    AdminMode = true
                    b.Text = "✅ Админ активен"
                    b.BackgroundColor3 = Color3.fromRGB(30, 100, 30)
                else
                    b.Text = "❌ Неверный пароль"
                    b.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
                    task.wait(1.5)
                    b.Text = "🔐 Ввести пароль"
                    b.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
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
            Btn("⚡ Speed 50", function(b) C.Speed = true; C.SpeedVal = 50 end)
            Btn("🚶 Speed Обычная", function(b) C.Speed = false end)
            Btn("🦘 Jump 200", function(b) C.Jump = true; C.JumpVal = 200 end)
            Btn("🦘 Jump 100", function(b) C.Jump = true; C.JumpVal = 100 end)
            Btn("✈ Fly Speed 150", function(b) C.FlySp = 150 end)
            Btn("✈ Fly Speed 300", function(b) C.FlySp = 300 end)
            Btn("🛡 God ON", function(b) C.Godmode = true end)
            Btn("🛡 God OFF", function(b) C.Godmode = false end)
            Btn("👻 Invis ON", function(b) C.Invis = true end)
            Btn("👻 Invis OFF", function(b) C.Invis = false end)
            Btn("💥 KillAura ON", function(b) C.KAura = true end)
            Btn("💥 KillAura OFF", function(b) C.KAura = false end)
            Btn("🤖 AutoKill ON", function(b) C.AKill = true end)
            Btn("🤖 AutoKill OFF", function(b) C.AKill = false end)
            Btn("🚀 Fly ON", function(b) C.Fly = true end)
            Btn("🚀 Fly OFF", function(b) C.Fly = false end)
            Btn("🎯 Aimbot ON", function(b) C.AShoot = true end)
            Btn("🎯 Aimbot OFF", function(b) C.AShoot = false end)
            Btn("📦 Farm ON", function(b) C.Farm = true end)
            Btn("📦 Farm OFF", function(b) C.Farm = false end)
            Btn("👥 Игроков: " .. #Players:GetPlayers(), function(b)
                b.Text = "👥 Игроков: " .. #Players:GetPlayers()
            end)
        else
            Btn("🔒 Заблокировано", function(b)
                b.Text = "Введи пароль"
            end)
            Btn("🔒 Функция скрыта", function(b)
                b.Text = "🔒"
            end)
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
        for _, b in pairs(tabBtns) do
            b.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
        end
        tb.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
        Refresh()
    end)
    table.insert(tabBtns, tb)
end

tabBtns[1].BackgroundColor3 = Color3.fromRGB(180, 0, 255)
Refresh()

openBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    openBtn.Visible = false
end)

closeB.MouseButton1Click:Connect(function()
    main.Visible = false
    openBtn.Visible = true
end)

print("[LLUHA HUB] UI loaded ✅")
