local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local C = _G.LLUHA.C
local RC = _G.LLUHA.RC

local ESPo = {}

local function Mk(p)
    if p == LP or ESPo[p] then return end
    local ch = p.Character
    if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
    local h = Instance.new("Highlight")
    h.Adornee = ch
    h.FillTransparency = 0.5
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.FillColor = RC.Enemy
    h.OutlineColor = RC.Enemy
    h.Parent = CoreGui
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Parent = CoreGui
    local n = Instance.new("TextLabel")
    n.Size = UDim2.new(1, 0, 0.5, 0)
    n.BackgroundTransparency = 1
    n.TextColor3 = Color3.new(1, 1, 1)
    n.TextStrokeTransparency = 0
    n.TextScaled = true
    n.Font = Enum.Font.GothamBold
    n.Parent = bb
    local hp = Instance.new("TextLabel")
    hp.Size = UDim2.new(1, 0, 0.5, 0)
    hp.Position = UDim2.new(0, 0, 0.5, 0)
    hp.BackgroundTransparency = 1
    hp.TextColor3 = Color3.fromRGB(255, 200, 50)
    hp.TextStrokeTransparency = 0
    hp.TextScaled = true
    hp.Font = Enum.Font.GothamBold
    hp.Parent = bb
    ESPo[p] = {h=h, bb=bb, n=n, hp=hp}
end

for _, p in pairs(Players:GetPlayers()) do
    Mk(p)
    p.CharacterAdded:Connect(function() task.wait(0.5) Mk(p) end)
end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() task.wait(0.5) Mk(p) end)
end)
Players.PlayerRemoving:Connect(function(p)
    local d = ESPo[p]
    if d then d.h:Destroy(); d.bb:Destroy(); ESPo[p] = nil end
end)

RunService.RenderStepped:Connect(function()
    for p, d in pairs(ESPo) do
        local ch = p.Character
        if ch and ch:FindFirstChild("HumanoidRootPart") and C.ESP then
            d.h.Enabled = true
            d.bb.Enabled = true
            d.h.Adornee = ch
            d.bb.Adornee = ch:FindFirstChild("Head") or ch.HumanoidRootPart
            d.n.Text = C.ESPNames and p.Name or ""
            local hum = ch:FindFirstChildOfClass("Humanoid")
            d.hp.Text = C.ESPHealth and hum and string.format("%d HP", math.floor(hum.Health)) or ""
        else
            d.h.Enabled = false
            d.bb.Enabled = false
        end
    end
end)

print("[LLUHA] esp loaded ✅")
