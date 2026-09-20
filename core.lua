local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")

local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

_G.LLUHA = _G.LLUHA or {}
local C = _G.LLUHA.C or {
    ESP = true, ESPNames = true, ESPRoles = true, ESPHealth = true, ESPDist = false, ESPTracers = false,
    Farm = false, FarmSafe = false, SafeRange = 20, AutoCollect = false, CoinMagnet = false,
    FarmSpeed = 1.5, AutoRespawn = false, FullBag = 50,
    Speed = false, SpeedVal = 22, DefSpeed = 16,
    Jump = false, JumpVal = 50, DefJump = 50,
    InfJ = false, Fly = false, FlySp = 60, NoClip = false, CTP = false,
    AShoot = false, AKill = false, KAura = false, ADodge = false, DodgeR = 30,
    Invis = false, AFling = true, Fling = false, FlingR = 15, Freeze = false,
    Ghost = false, AntiAFK = true, Godmode = false,
    TPK = false, BJ = true, Fullbright = false, NoFog = false, FPSBoost = false,
    FOV = true, FOVSize = 200, CustomSound = false, SoundVolume = 3,
    AutoFling = false, AutoFlingRange = 20,
    AutoKnife = false, AutoKnifeRange = 15,
}
_G.LLUHA.C = C

local RC = {
    Murderer = Color3.fromRGB(255, 0, 0),
    Sheriff = Color3.fromRGB(0, 100, 255),
    Innocent = Color3.fromRGB(0, 255, 0),
}
_G.LLUHA.RC = RC

local MyRole = "Innocent"
local Cache = {}
local WCache = {}
local SpawnPoint = nil

_G.LLUHA.GetCache = function() return Cache end
_G.LLUHA.GetMyRole = function() return MyRole end
_G.LLUHA.RoundTime = 0

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
            if n:find("knife") or n:find("нож") or n:find("dagger") then k = true end
            if n:find("gun") or n:find("пистолет") or n:find("revolver") then g = true end
        end
    end
    if k then MyRole = "Murderer"
    elseif g then MyRole = "Sheriff"
    else MyRole = "Innocent" end
end

task.spawn(function() while task.wait(0.3) do ScanMe() end end)

local function Scan(p)
    if p == LP then return end
    local fr = nil
    for _, a in ipairs({"Role","role","RoleName","Team","Class"}) do
        local ok, v = pcall(function() return p:GetAttribute(a) end)
        if ok and v then local r = Match(v); if r then fr = r; break end end
    end
    for _, v in pairs(p:GetChildren()) do
        if v:IsA("StringValue") or v:IsA("ObjectValue") or v:IsA("BoolValue") or v:IsA("IntValue") then
            local r = Match(v.Name); if r then fr = r end
            local ok, val = pcall(function() return v.Value end)
            if ok and val then local r2 = Match(val); if r2 then fr = r2 end end
        end
    end
    local ls = p:FindFirstChild("leaderstats")
    if ls then
        for _, v in pairs(ls:GetChildren()) do
            local r = Match(v.Name); if r then fr = r end
            local ok, val = pcall(function() return v.Value end)
            if ok then local r2 = Match(val); if r2 then fr = r2 end end
        end
    end
    for _, obj in pairs(p:GetDescendants()) do
        local r = Match(obj.Name); if r then fr = r end
    end
    local ch = p.Character
    if ch then
        for _, t in pairs(ch:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("knife") or n:find("нож") or n:find("dagger") then WCache[p] = "Murderer"
                elseif n:find("gun") or n:find("пистолет") or n:find("revolver") then WCache[p] = "Sheriff" end
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

task.spawn(function()
    while task.wait(1) do
        _G.LLUHA.RoundTime = _G.LLUHA.RoundTime + 1
    end
end)

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
        local myCh = LP.Character
        local myHRP = myCh and myCh:FindFirstChild("HumanoidRootPart")
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

local function GetCoins()
    local c = {}
    local myCh = LP.Character
    local myHRP = myCh and myCh:FindFirstChild("HumanoidRootPart")
    if not myHRP then return c end
    for _, o in pairs(workspace:GetDescendants()) do
        if o:IsA("BasePart") then
            local n = o.Name:lower()
            if n:find("coin") or n:find("монет") or n:find("money") or n == "cash" then
                if (o.Position - myHRP.Position).Magnitude <= 60 then
                    table.insert(c, o)
                end
            end
        end
    end
    return c
end

local function FindM()
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

_G.LLUHA.FindM = FindM

local function FindSpawn()
    if SpawnPoint then return SpawnPoint end
    for _, o in pairs(workspace:GetDescendants()) do
        if o:IsA("SpawnLocation") then SpawnPoint = o; return o end
    end
    return nil
end

task.spawn(function()
    while task.wait(C.FarmSpeed) do
        if C.Farm then
            local ch = LP.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if hrp and hum then
                for _, cn in pairs(GetCoins()) do
                    if cn.Parent and C.Farm then
                        if C.FarmSafe then
                            local _, d = FindM()
                            if d <= C.SafeRange then
                                task.wait(0.5)
                                continue
                            end
                        end
                        local target = cn.Position
                        if (target - hrp.Position).Magnitude > 3 then
                            hum:MoveTo(target)
                            local timeout = 0
                            while (target - hrp.Position).Magnitude > 3 and timeout < 50 do
                                if not C.Farm then break end
                                task.wait(0.1)
                                timeout = timeout + 1
                            end
                        end
                        task.wait(0.4)
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        if C.AutoRespawn then
            local ls = LP:FindFirstChild("leaderstats")
            if ls then
                for _, v in pairs(ls:GetChildren()) do
                    if v:IsA("IntValue") or v:IsA("NumberValue") then
                        local n = v.Name:lower()
                        if n:find("coin") or n:find("bag") or n:find("сумк") then
                            if v.Value >= C.FullBag then
                                local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                                if hum then hum.Health = 0 end
                            end
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if C.CoinMagnet then
            local myCh = LP.Character
            local myHRP = myCh and myCh:FindFirstChild("HumanoidRootPart")
            if myHRP then
                for _, o in pairs(workspace:GetDescendants()) do
                    if o:IsA("BasePart") then
                        local n = o.Name:lower()
                        if n:find("coin") or n:find("монет") then
                            if (o.Position - myHRP.Position).Magnitude < 100 then
                                o.CFrame = CFrame.new(o.Position:Lerp(myHRP.Position, 0.3))
                            end
                        end
                    end
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local ch = LP.Character
    if not ch then return end
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if C.Speed then hum.WalkSpeed = C.SpeedVal
    elseif hum.WalkSpeed ~= C.DefSpeed then hum.WalkSpeed = C.DefSpeed end
    if C.Jump then hum.JumpPower = C.JumpVal
    elseif hum.JumpPower ~= C.DefJump then hum.JumpPower = C.DefJump end
end)

-- Aimbot V3
local aimbotTime = 0
task.spawn(function()
    while task.wait(0.02) do
        if C.AShoot then
            local m = FindM()
            if m and m.Character then
                local th = m.Character:FindFirstChild("HumanoidRootPart")
                if th then
                    local targetCF = CFrame.new(Cam.CFrame.Position, th.Position)
                    Cam.CFrame = Cam.CFrame:Lerp(targetCF, 0.35)
                    local screenPos, onScreen = Cam:WorldToViewportPoint(th.Position)
                    local cx = Cam.ViewportSize.X / 2
                    local cy = Cam.ViewportSize.Y / 2
                    local dist = math.sqrt((screenPos.X - cx)^2 + (screenPos.Y - cy)^2)
                    if dist <= (C.FOVSize or 200) / 2 and onScreen then
                        aimbotTime = aimbotTime + 0.02
                        if aimbotTime >= 0.05 then
                            aimbotTime = 0
                            local mc = LP.Character
                            if mc then
                                local g = mc:FindFirstChildOfClass("Tool")
                                if g then
                                    pcall(function()
                                        for _, c in pairs(g:GetChildren()) do
                                            if c:IsA("RemoteEvent") then c:FireServer(th.Position, th) end
                                        end
                                        g:Activate()
                                    end)
                                    pcall(function()
                                        VU:CaptureController()
                                        VU:ClickButton1(Vector2.new(0, 0))
                                    end)
                                end
                            end
                        end
                    else
                        aimbotTime = 0
                    end
                end
            end
        else
            aimbotTime = 0
        end
    end
end)

-- Auto Knife
task.spawn(function()
    while task.wait(0.1) do
        if C.AutoKnife and MyRole == "Murderer" then
            local myCh = LP.Character
            if myCh then
                local knife = myCh:FindFirstChildOfClass("Tool")
                if knife then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LP and Cache[p] ~= "Murderer" and p.Character then
                            local tHRP = p.Character:FindFirstChild("HumanoidRootPart")
                            local myHRP = myCh:FindFirstChild("HumanoidRootPart")
                            if tHRP and myHRP then
                                local dist = (tHRP.Position - myHRP.Position).Magnitude
                                if dist <= (C.AutoKnifeRange or 15) then
                                    Cam.CFrame = CFrame.new(Cam.CFrame.Position, tHRP.Position)
                                    pcall(function()
                                        for _, c in pairs(knife:GetChildren()) do
                                            if c:IsA("RemoteEvent") then c:FireServer(tHRP.Position, tHRP) end
                                        end
                                    end)
                                    pcall(function() knife:Activate() end)
                                    pcall(function()
                                        VU:CaptureController()
                                        VU:ClickButton1(Vector2.new(0, 0))
                                    end)
                                    task.wait(0.15)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Fling
task.spawn(function()
    while task.wait(0.15) do
        if C.AutoFling then
            local myCh = LP.Character
            local myHRP = myCh and myCh:FindFirstChild("HumanoidRootPart")
            if myHRP then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local tHRP = p.Character:FindFirstChild("HumanoidRootPart")
                        if tHRP and (tHRP.Position - myHRP.Position).Magnitude <= (C.AutoFlingRange or 20) then
                            pcall(function()
                                tHRP.Velocity = Vector3.new(math.random(-1,1)*500, math.random(200,500), math.random(-1,1)*500)
                                tHRP.RotVelocity = Vector3.new(math.random(-500,500), math.random(-500,500), math.random(-500,500))
                            end)
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if C.ADodge then
            local mc = LP.Character
            local mh = mc and mc:FindFirstChild("HumanoidRootPart")
            if mh then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and Cache[p] == "Murderer" then
                        local th = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                        if th then
                            local df = mh.Position - th.Position
                            if df.Magnitude < C.DodgeR then
                                local dr = df.Unit
                                mh.Velocity = Vector3.new(dr.X * 65, mh.Velocity.Y, dr.Z * 65)
                            end
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.15) do
        if C.A
                _G.LLUHA.Loaded = true
print("[LLUHA HUB] Core loaded ✅")
