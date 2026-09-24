local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")

local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local C = _G.LLUHA.C

local function FindNearest()
    local closest, dist = nil, math.huge
    local myCh = LP.Character
    if not myCh or not myCh:FindFirstChild("HumanoidRootPart") then return nil, math.huge end
    local myPos = myCh.HumanoidRootPart.Position
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - myPos).Magnitude
                if d < dist then closest, dist = p, d end
            end
        end
    end
    return closest, dist
end

-- Найти нож
local function GetKnife()
    local ch = LP.Character
    if not ch then return nil end
    for _, t in pairs(ch:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("knife") or n:find("нож") or n:find("sword") or n:find("blade") or n:find("dagger") then
                return t
            end
        end
    end
    return ch:FindFirstChildOfClass("Tool")
end

-- Удар ножом (несколько способов)
local function HitKnife(knife, target)
    if not knife or not target then return end
    local targetChar = target.Character
    if not targetChar then return end
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    local targetHead = targetChar:FindFirstChild("Head")
    local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
    if not targetHRP then return end

    -- Наводка камеры
    if targetHead then
        Cam.CFrame = CFrame.new(Cam.CFrame.Position, targetHead.Position)
    end

    -- Способ 1: Activate
    pcall(function() knife:Activate() end)

    -- Способ 2: FireServer на все RemoteEvent
    pcall(function()
        for _, c in pairs(knife:GetChildren()) do
            if c:IsA("RemoteEvent") then
                pcall(function() c:FireServer(targetChar) end)
                pcall(function() c:FireServer(targetHRP) end)
                pcall(function() c:FireServer(targetHead) end)
                pcall(function() c:FireServer(targetHum) end)
                pcall(function() c:FireServer() end)
            end
        end
    end)

    -- Способ 3: VirtualUser клик
    pcall(function()
        VU:CaptureController()
        VU:ClickButton1(Vector2.new(0, 0))
    end)

    -- Способ 4: Tool:Activate через humanoid
    pcall(function()
        local myHum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if myHum then
            myHum:EquipTool(knife)
        end
    end)
end

-- Aimbot
task.spawn(function()
    while task.wait(0.05) do
        if C.Aimbot then
            local m = FindNearest()
            if m and m.Character then
                local th = m.Character:FindFirstChild("Head")
                if th then
                    Cam.CFrame = CFrame.new(Cam.CFrame.Position, th.Position)
                end
            end
        end
    end
end)

-- Auto Hit
task.spawn(function()
    while task.wait(0.12) do
        if C.AutoHit then
            local knife = GetKnife()
            if knife then
                local m, dist = FindNearest()
                if m and dist and dist <= (C.Reach and C.ReachVal or 10) then
                    HitKnife(knife, m)
                end
            end
        end
    end
end)

-- Kill Aura (бьёт ВСЕХ в радиусе)
task.spawn(function()
    while task.wait(0.15) do
        if C.KillAura then
            local knife = GetKnife()
            local myCh = LP.Character
            if knife and myCh then
                local myHRP = myCh:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LP and p.Character then
                            local tHRP = p.Character:FindFirstChild("HumanoidRootPart")
                            if tHRP and (tHRP.Position - myHRP.Position).Magnitude <= 15 then
                                HitKnife(knife, p)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Block (блок)
task.spawn(function()
    while task.wait(0.1) do
        if C.AutoBlock then
            local knife = GetKnife()
            if knife then
                local myCh = LP.Character
                local myHRP = myCh and myCh:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LP and p.Character then
                            local tHRP = p.Character:FindFirstChild("HumanoidRootPart")
                            if tHRP and (tHRP.Position - myHRP.Position).Magnitude < 10 then
                                pcall(function()
                                    for _, c in pairs(knife:GetChildren()) do
                                        if c:IsA("RemoteEvent") then
                                            local n = c.Name:lower()
                                            if n:find("block") or n:find("guard") or n:find("parry") then
                                                c:FireServer()
                                            end
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

print("[LLUHA] combat loaded ✅")
