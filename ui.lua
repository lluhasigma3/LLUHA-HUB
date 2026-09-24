local Players = game:GetService("Players")

local LP = Players.LocalPlayer
local C = _G.LLUHA.C

local sg = Instance.new("ScreenGui")
sg.Name = "LLUHA_HUB"
sg.ResetOnSpawn = false
sg.Parent = LP:WaitForChild("PlayerGui")
_G.LLUHA.SG = sg

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 110, 0, 38)
openBtn.Position = UDim2.new(0, 20, 0.5, -19)
openBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
openBtn.Text = "🔪 LLUHA HUB"
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 13
openBtn.Active = true
openBtn.Draggable = true
openBtn.Parent = sg
local oc = Instance.new("UICorner", openBtn)
oc.CornerRadius = UDim.new(0, 8)

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 280, 0, 450)
main.Position = UDim2.new(0.5, -140, 0.5, -225)
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

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
title.Text = "🔪 LLUHA HUB | Knife Duels"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = main
local tc = Instance.new("UICorner", title)
tc.CornerRadius = UDim.new(0, 12)

local closeB = Instance.new("TextButton")
closeB.Size = UDim2.new(0, 26, 0, 26)
closeB.Position = UDim2.new(1, -32, 0, 5)
closeB.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
closeB.Text = "X"
closeB.TextColor3 = Color3.new(1, 1, 1)
closeB.Font = Enum.Font.GothamBold
closeB.TextSize = 14
closeB.Parent = main
local cbc = Instance.new("UICorner", closeB)
cbc.CornerRadius = UDim.new(0, 6)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 1, -50)
scroll.Position = UDim2.new(0, 8, 0, 42)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 5
scroll.ScrollBarImageColor3 = Color3.fromRGB(180, 0, 255)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = main

local ll = Instance.new("UIListLayout", scroll)
ll.Padding = UDim.new(0, 5)
ll.SortOrder = Enum.SortOrder.LayoutOrder

local function Btn(text, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -6, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
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

Toggle("ESP", "ESP")
Toggle("ESPNames", "Имена")
Toggle("ESPHealth", "HP")
Toggle("Aimbot", "Aimbot")
Toggle("AutoHit", "Auto Hit (удар)")
Toggle("AutoBlock", "Auto Block (блок)")
Toggle("KillAura", "Kill Aura")
Toggle("Reach", "Reach (дальность)")
Toggle("Speed", "SpeedHack")
Toggle("Fly", "Fly")
Toggle("Jump", "HighJump")
Toggle("NoClip", "Noclip")
Toggle("Invis", "Invisible")

closeB.MouseButton1Click:Connect(function() main.Visible = false; openBtn.Visible = true end)
openBtn.MouseButton1Click:Connect(function() main.Visible = true; openBtn.Visible = false end)

print("[LLUHA] ui loaded ✅")
