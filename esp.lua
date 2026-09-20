local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

_G.LLUHA = _G.LLUHA or {}
_G.LLUHA.C = _G.LLUHA.C or {
    ESP = true, ESPNames = true, ESPRoles = true, ESPHealth = true,
    ESPDist = false, ESPTracers = false, FOV = true, FOVSize = 200,
    Farm = false, FarmSafe = false, AutoCollect = false, CoinMagnet = false,
    FarmSpeed = 1.5, AutoRespawn = false, FullBag = 50,
    Speed = false, SpeedVal = 22, DefSpeed = 16,
    Jump = false, JumpVal = 50, DefJump = 50, InfJ = false, NoClip = false,
    AShoot = false, AKill = false, KAura = false, ADodge = false, AutoKnife = false,
    AutoKnifeRange = 15, AutoFling = false, AutoFlingRange = 20, Fling = false, Freeze = false,
    Fly = false, FlySp = 60, Invis = false, Ghost = false, Godmode = false,
    AFling = true, AntiAFK = true, TPK = false, BJ = true, CTP = false,
    Fullbright = false, NoFog = false, FPSBoost = false,
}
local C = _G.LLUHA.C

_G.LLUHA.RC = {Murderer = Color3.fromRGB(255,0,0), Sheriff = Color3.fromRGB(0,100,255), Innocent = Color3.fromRGB(0,255,0)}
local RC = _G.LLUHA.RC

local MyRole = "Innocent"
local Cache = {}
local WCache = {}
_G.LLUHA.RoundTime = 0
_G.LLUHA.GetMyRole = function() return MyRole end
_G.LLUHA.GetCache = function() return Cache end

local function Match(s)
    if not s then return nil end
    s = tostring(s):lower()
    if s:find("murder") or s:find("убий") or s:find("killer") then return "Murderer" end
    if s:find("sheriff") or s:find("шериф") or s:find("cop") then return "Sheriff" end
    if s:find("innocent") or s:find("невин") then return "Innocent" end
    return nil
end

local function ScanMe()
    local ch = LP.Character
    if not ch then return end
    for _, a in ipairs({"Role","role","RoleName","Team"}) do
        local ok, v = pcall(function() return LP:GetAttribute(a) end)
        if ok and v then
            local s = tostring(v):lower()
            if s:find("murder") or s:find("убий") then MyRole = "Murderer"; return end
            if s:find("sheriff") or s:find("шериф") then MyRole = "Sheriff"; return end
        end
    end
    local k, g = false, false
    for _, t in pairs(ch:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("knife") or n:find("нож") then k = true end
            if n:find("gun") or n:find("пистолет") then g = true end
        end
    end
    if k then MyRole = "Murderer" elseif g then MyRole = "Sheriff" else MyRole = "Innocent" end
end

task.spawn(function() while task.wait(0.3) do ScanMe() end end)

local function Scan(p)
    if p == LP then return end
    local fr = nil
    for _, a in ipairs({"Role","role","RoleName","Team"}) do
        local ok, v = pcall(function() return p:GetAttribute(a) end)
        if ok and v then local r = Match(v); if r then fr = r; break end end
    end
    for _, v in pairs(p:GetChildren()) do
        if v:IsA("StringValue") or v:IsA("ObjectValue") then
            local r = Match(v.Name); if r then fr = r end
            local ok, val = pcall(function() return v.Value end)
            if ok and val then local r2 = Match(val); if r2 then fr = r2 end end
        end
    end
    local ls = p:FindFirstChild("leaderstats")
    if ls then
        for _, v in pairs(ls:GetChildren()) do
            local r = Match(v.Name); if r then fr = r end
        end
    end
    local ch = p.Character
    if ch then
        for _, t in pairs(ch:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("knife") or n:find("нож") then WCache[p] = "Murderer"
                elseif n:find("gun") or n:find("пистолет") then WCache[p] = "Sheriff" end
            end
        end
    end
    if fr then Cache[p] = fr
    elseif WCache[p] then Cache[p] = WCache[p]
    elseif not Cache[p] then Cache[p] = "Innocent" end
end

task.spawn(function()
    while task.wait(0.15) do
        for _, p in pairs(Players:GetPlayers()) do pcall(Scan, p) end
    end
end)

LP.CharacterAdded:Connect(function()
    task.wait(2)
    for k in pairs(Cache) do Cache[k] = nil end
    for k in pairs(WCache) do WCache[k] = nil end
    MyRole = "Innocent"
    _G.LLUHA.RoundTime = 0
end)

LP:SetAttribute("LLUHA_User", true)
task.spawn(function() while task.wait(1) do _G.LLUHA.RoundTime = _G.LLUHA.RoundTime + 1 end end)

-- FindMurderer (нужен для combat.lua)
_G.LLUHA.FindM = function()
    local cl, ds = nil, math.huge
    local mc = LP.Character
    if not mc or not mc:FindFirstChild("HumanoidRootPart") then return nil, math.huge end
    local mp = mc.HumanoidRootPart.Position
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and Cache[p] == "Murderer" then
            local ch = p.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - mp).Magnitude
                if d < ds then cl, ds = p, d end
            end
        end
    end
    return cl, ds
end

local ESPo = {}

local function MkESP(p)
    if p == LP or ESPo[p] then return end
    local ch = p.Character
    if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
    local h = Instance.new("Highlight")
    h.Adornee = ch
    h.FillTransparency = 0.6
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = CoreGui
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Parent = CoreGui
    local nl = Instance.new("TextLabel")
    nl.Size = UDim2.new(1, 0, 0.33, 0)
    nl.BackgroundTransparency = 1
    nl.TextColor3 = Color3.new(1, 1, 1)
    nl.TextStrokeTransparency = 0
    nl.TextScaled = true
    nl.Font = Enum.Font.GothamBold
    nl.Parent = bb
    local rl = Instance.new("TextLabel")
    rl.Size = UDim2.new(1, 0, 0.33, 0)
    rl.Position = UDim2.new(0, 0, 0.33, 0)
    rl.BackgroundTransparency = 1
    rl.TextStrokeTransparency = 0
    rl.TextScaled = true
    rl.Font = Enum.Font.GothamBold
    rl.Parent = bb
    local hl = Instance.new("TextLabel")
    hl.Size = UDim2.new(1, 0, 0.33, 0)
    hl.Position = UDim2.new(0, 0, 0.66, 0)
    hl.BackgroundTransparency = 1
    hl.TextColor3 = Color3.fromRGB(255, 200, 50)
    hl.TextStrokeTransparency = 0
    hl.TextScaled = true
    hl.Font = Enum.Font.GothamBold
    hl.Parent = bb
    local tr = Instance.new("LineHandleAdornment")
    tr.Adornee = ch:FindFirstChild("HumanoidRootPart")
    tr.Length = 0
    tr.Thickness = 2
    tr.Transparency = 0.5
    tr.Parent = CoreGui
    ESPo[p] = {h=h, bb=bb, nl=nl, rl=rl, hl=hl, tr=tr}
end

local function UpESP(p)
    local d = ESPo[p]
    if not d then return end
    local ch = p.Character
    if not ch or not ch:FindFirstChild("HumanoidRootPart") then
        d.bb.Adornee = nil
        d.tr.Adornee = nil
        return
    end
    d.h.Adornee = ch
    d.bb.Adornee = ch:FindFirstChild("Head") or ch.HumanoidRootPart
    local role = Cache[p] or "Innocent"
    local col = RC[role] or RC.Innocent
    d.h.FillColor = col
    d.h.OutlineColor = col
    local nameText = C.ESPNames and p.Name or ""
    if p:GetAttribute("LLUHA_User") then
        nameText = "[LLUHA] " .. nameText
    end
    d.nl.Text = nameText
    d.rl.Text = C.ESPRoles and role or ""
    d.rl.TextColor3 = col
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if hum and C.ESPHealth then
        d.hl.Text = string.format("%d HP", math.floor(hum.Health))
    else d.hl.Text = "" end
    if C.ESPDist then
        local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if myHRP then
            local dist = (ch.HumanoidRootPart.Position - myHRP.Position).Magnitude
            d.hl.Text = d.hl.Text .. " | " .. math.floor(dist) .. "m"
        end
    end
    if C.ESPTracers then
        d.tr.Visible = true
        d.tr.Adornee = ch:FindFirstChild("HumanoidRootPart")
        d.tr.Color3 = col
        d.tr.Length = (Cam.CFrame.Position - ch.HumanoidRootPart.Position).Magnitude * 0.15
        local mid = (Cam.CFrame.Position + ch.HumanoidRootPart.Position) / 2
        d.tr.CFrame = CFrame.lookAt(mid, ch.HumanoidRootPart.Position)
    else d.tr.Visible = false end
end

local function RmESP(p)
    local d = ESPo[p]
    if d then d.h:Destroy(); d.bb:Destroy(); d.tr:Destroy(); ESPo[p] = nil end
    Cache[p] = nil
    WCache[p] = nil
end

for _, p in pairs(Players:GetPlayers()) do
    MkESP(p)
    p.CharacterAdded:Connect(function() task.wait(0.5) MkESP(p) end)
end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() task.wait(0.5) MkESP(p) end)
end)
Players.PlayerRemoving:Connect(RmESP)

RunService.RenderStepped:Connect(function()
    for p, d in pairs(ESPo) do
        d.h.Enabled = C.ESP
        d.bb.Enabled = C.ESP
        if C.ESP then UpESP(p) end
    end
end)

print("[LLUHA] esp loaded ✅")
