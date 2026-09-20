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
sg.Name = "LLUHA_HUB_V11"
sg.ResetOnSpawn = false
sg.Parent = CoreGui
_G.LLUHA.SG = sg

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

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 470)
main.Position = UDim2.new(0.5, -160, 0.5, -235)
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
tl.Text = "LLUHA HUB v11"
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
roleL.Size = UDim2.new(0.5, 0, 0, 18)
roleL.Position = UDim2.new(0, 12, 0, 42)
roleL.BackgroundTransparency = 1
roleL.Text = "Роль: Innocent"
roleL.TextColor3 = Color3.fromRGB(0, 255, 0)
roleL.Font = Enum.Font.GothamBold
roleL.TextSize = 11
roleL.TextXAlignment = Enum.TextXAlignment.Left
roleL.Parent = main

local adminL = Instance.new("TextLabel")
adminL.Size = UDim2.new(0.5, -12, 0, 18)
adminL.Position = UDim2.new(0.5, 0, 0, 42)
adminL.BackgroundTransparency = 1
adminL.Text = "Админ: ВЫКЛ"
adminL.TextColor3 = Color3.fromRGB(255, 100, 100)
adminL.Font = Enum.Font.GothamBold
adminL.TextSize = 11
adminL.TextXAlignment = Enum.TextXAlignment.Right
adminL.Parent = main

task.spawn(function()
    while task.wait(0.4) do
        local r = _G.LLUHA and _G.LLUHA.GetMyRole and _G.LLUHA.GetMyRole() or "Innocent"
        roleL.Text = "Роль: " .. r
        roleL.TextColor3 = RC[r] or Color3.fromRGB(255, 255, 255)
        adminL.Text = AdminMode and "Админ: ВКЛ" or "Админ: ВЫКЛ"
        adminL.TextColor3 = AdminMode and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    end
end)

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -16, 0, 28)
tabBar.Position = UDim2.new(0, 8, 0, 64)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 3)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 1, -105)
scroll.Position = UDim2.new(0, 8, 0, 96)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 5
scroll.ScrollBarImageColor3 = Color3.fromRGB(180, 0, 255)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = main

local grid = Instance.new("UIGridLayout", scroll)
grid.CellSize = UDim2.new(0, 145, 0, 30)
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
        Toggle("AShoot", "Aimbot V3")
        Btn("FOV Круг: " .. (C.FOV and "ВКЛ" or "ВЫКЛ"), function(b)
            C.FOV = not C.FOV
            b.Text = "FOV Круг: " .. (C.FOV and "ВКЛ" or "ВЫКЛ")
            b.BackgroundColor3 = C.FOV and Color3.fromRGB(80, 30, 120) or Color3.fromRGB(35, 35, 48)
        end)
        Toggle("AKill", "AutoKill")
        Toggle("KAura", "KillAura")
        Toggle("ADodge", "AutoDodge")
        Toggle("Fling", "Fling")
        Toggle("Freeze", "Freeze")
    elseif currentTab == "farm" then
        Toggle("Farm", "Farm Coins")
        Toggle("FarmSafe", "Farm Safe")
        Toggle("AutoCollect", "Auto Collect")
        Toggle("CoinMagnet", "Coin Magnet")
    elseif currentTab == "move" then
        Toggle("Speed", "SpeedHack")
        Toggle("Jump", "HighJump")
        Toggle("InfJ", "InfiniteJump")
        Toggle("Fly", "Fly")
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
            Btn("Heal (HP)", function(b)
                local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                if h then h.Health = h.MaxHealth end
            end)
            Btn("Rejoin", function(b)
                game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
            end)
            Btn("Reset", function(b)
                LP.Character:BreakJoints()
            end)
            Btn("Fullbright ON", function(b) C.Fullbright = true end)
            Btn("Fullbright OFF", function(b) C.Fullbright = false end)
            Btn("Speed 100", function(b) C.Speed = true; C.SpeedVal = 100 end)
            Btn("Speed 50", function(b) C.Speed = true; C.SpeedVal = 50 end)
            Btn("Speed обычная", function(b) C.Speed = false end)
            Btn("Jump 200", function(b) C.Jump = true; C.JumpVal = 200 end)
            Btn("Fly Speed 150", function(b) C.FlySp = 150 end)
            Btn("Fly Speed 300", function(b) C.FlySp = 300 end)
        else
            Btn("🔒 Заблокировано", function(b)
                b.Text = "Введи пароль"
            end)
        end
    end
end

local tabNames = {
    {id = "combat", name = "⚔ Бой"},
    {id = "farm", name = "💰 Фарм"},
    {id = "move", name = "🏃 Движ"},
    {id = "player", name = "👤 Игрок"},
    {id = "admin", name = "🔐 Адм"},
}

local tabBtns = {}

for _, t in ipairs(tabNames) do
    local tb = Instance.new("TextButton")
    tb.Size = UDim2.new(0, 56, 1, 0)
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
