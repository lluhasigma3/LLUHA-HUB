local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local C = _G.LLUHA.C

local function FindNearest()
    local closest, dist = nil, math.huge
    local myCh = LP.Character
    if not myCh or not myCh:FindFirstChild("HumanoidRootPart") then return nil end
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

-- Auto Hit (авто-удар ножом)
task.spawn(function()
    while task.wait(0.15) do
        if C.AutoHit then
            local myCh = LP.Character
            if myCh then
                local knife = myCh:FindFirstChildOfClass("Tool")
                if knife then
                    local m, dist = FindNearest()
                    if m and dist and dist <= (C.Reach and C.ReachVal or 10) then
                        local th = m.Character and m.Character:FindFirstChild("Head")
                        if th then
                            Cam.CFrame = CFrame.new(Cam.CFrame.Position, th.Position)
                            pcall(function()
                                for _, c in pairs(knife:GetChildren()) do
                                    if c:IsA("RemoteEvent") then c:FireServer(m.Character) end
                                end
                                knife:Activate()
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- Kill Aura (бьёт всех вокруг)
task.spawn(function()
    while task.wait(0.2) do
        if C.KillAura then
            local myCh = LP.Character
            if myCh then
                local knife = myCh:FindFirstChildOfClass("Tool")
                local myHRP = myCh:FindFirstChild("HumanoidRootPart")
                if knife and myHRP then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LP and p.Character then
                            local tHRP = p.Character:FindFirstChild("HumanoidRootPart")
                            if tHRP and (tHRP.Position - myHRP.Position).Magnitude <= 12 then
                                pcall(function()
                                    for _, c in pairs(knife:GetChildren()) do
                                        if c:IsA("RemoteEvent") then c:FireServer(p.Character) end
                                    end
                                    knife:Activate()
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Block (авто-блок)
task.spawn(function()
    while task.wait(0.1) do
        if C.AutoBlock then
            local myCh = LP.Character
            if myCh then
                local knife = myCh:FindFirstChildOfClass("Tool")
                if knife then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LP and p.Character then
                            local myHRP = myCh:FindFirstChild("HumanoidRootPart")
                            local tHRP = p.Character:FindFirstChild("HumanoidRootPart")
                            if myHRP and tHRP and (tHRP.Position - myHRP.Position).Magnitude < 10 then
                                pcall(function()
                                    for _, c in pairs(knife:GetChildren()) do
                                        if c:IsA("RemoteEvent") and (c.Name:lower():find("block") or c.Name:lower():find("guard")) then
                                            c:FireServer()
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
