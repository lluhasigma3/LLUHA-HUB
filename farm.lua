local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local C = _G.LLUHA.C
local Cache = _G.LLUHA.GetCache()

local SpawnPoint = nil

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

local function FindSpawn()
    if SpawnPoint then return SpawnPoint end
    for _, o in pairs(workspace:GetDescendants()) do
        if o:IsA("SpawnLocation") then SpawnPoint = o; return o end
    end
    return nil
end

-- Farm
task.spawn(function()
    while task.wait(C.FarmSpeed or 1.5) do
        if C.Farm then
            local ch = LP.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if hrp and hum then
                for _, cn in pairs(GetCoins()) do
                    if cn.Parent and C.Farm then
                        if C.FarmSafe and _G.LLUHA.FindM then
                            local _, d = _G.LLUHA.FindM()
                            if d and d <= (C.SafeRange or 20) then
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

-- Auto Respawn
task.spawn(function()
    while task.wait(2) do
        if C.AutoRespawn then
            local ls = LP:FindFirstChild("leaderstats")
            if ls then
                for _, v in pairs(ls:GetChildren()) do
                    if v:IsA("IntValue") or v:IsA("NumberValue") then
                        local n = v.Name:lower()
                        if n:find("coin") or n:find("bag") or n:find("сумк") then
                            if v.Value >= (C.FullBag or 50) then
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

-- Coin Magnet
task.spawn(function()
    while task.wait(0.1) do
        if C.CoinMagnet then
            local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
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

-- Speed + Jump
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

print("[LLUHA] farm loaded ✅")
