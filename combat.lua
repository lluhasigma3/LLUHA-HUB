local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")

local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local C = _G.LLUHA.C
local Cache = _G.LLUHA.GetCache()
local GetRole = _G.LLUHA.GetMyRole
local FindM = _G.LLUHA.FindM

-- Aimbot V3 (Pulse-style)
local aimbotTime = 0
task.spawn(function()
    while task.wait(0.02) do
        if C.AShoot and FindM then
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

-- Auto Knife (кидание ножа)
task.spawn(function()
    while task.wait(0.1) do
        if C.AutoKnife and GetRole() == "Murderer" then
            local myCh = LP.Character
            if myCh then
                local knife = myCh:FindFirstChildOfClass("Tool")
                if knife then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LP and Cache[p] ~= "Murderer" and p.Character then
                            local tHRP = p.Character:FindFirstChild("HumanoidRootPart")
                            local myHRP = myCh:FindFirstChild("HumanoidRootPart")
                            if tHRP and myHRP then
                                if (tHRP.Position - myHRP.Position).Magnitude <= (C.AutoKnifeRange or 15) then
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

-- AutoKill
task.spawn(function()
    while task.wait(0.15) do
        if C.AKill and GetRole() == "Murderer" then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and Cache[p] == "Sheriff" then
                    local th = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    local mh = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    if th and mh and (th.Position - mh.Position).Magnitude <= 10 then
                        mh.CFrame = th.CFrame * CFrame.new(0, 0, 2)
                        local k = LP.Character:FindFirstChildOfClass("Tool")
                        if k then
                            pcall(function()
                                for _, c in pairs(k:GetChildren()) do
                                    if c:IsA("RemoteEvent") then c:FireServer(p.Character) end
                                end
                                k:Activate()
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- KillAura
task.spawn(function()
    while task.wait(0.2) do
        if C.KAura and GetRole() == "Murderer" then
            local mc = LP.Character
            local mh = mc and mc:FindFirstChild("HumanoidRootPart")
            if mh then
                local k = mc:FindFirstChildOfClass("Tool")
                if k then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LP and Cache[p] ~= "Murderer" then
                            local th = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                            if th and (th.Position - mh.Position).Magnitude <= 12 then
                                pcall(function()
                                    for _, c in pairs(k:GetChildren()) do
                                        if c:IsA("RemoteEvent") then c:FireServer(p.Character) end
                                    end
                                    k:Activate()
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- AutoDodge
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
                            if df.Magnitude < (C.DodgeR or 30) then
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

-- Fling (ручной)
task.spawn(function()
    while task.wait(0.1) do
        if C.Fling then
            local mc = LP.Character
            local mh = mc and mc:FindFirstChild("HumanoidRootPart")
            if mh then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local th = p.Character:FindFirstChild("HumanoidRootPart")
                        if th and (th.Position - mh.Position).Magnitude <= (C.FlingR or 15) then
                            pcall(function()
                                th.Velocity = Vector3.new(math.random(-1,1)*250, math.random(-1,1)*250, math.random(-1,1)*250)
                                th.RotVelocity = Vector3.new(math.random(-100,100), math.random(-100,100), math.random(-100,100))
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- AutoFling
task.spawn(function()
    while task.wait(0.15) do
        if C.AutoFling then
            local mc = LP.Character
            local mh = mc and mc:FindFirstChild("HumanoidRootPart")
            if mh then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local th = p.Character:FindFirstChild("HumanoidRootPart")
                        if th and (th.Position - mh.Position).Magnitude <= (C.AutoFlingRange or 20) then
                            pcall(function()
                                th.Velocity = Vector3.new(math.random(-1,1)*500, math.random(200,500), math.random(-1,1)*500)
                                th.RotVelocity = Vector3.new(math.random(-500,500), math.random(-500,500), math.random(-500,500))
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- Freeze
task.spawn(function()
    while task.wait(0.15) do
        if C.Freeze then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local th = p.Character:FindFirstChild("HumanoidRootPart")
                    if th then th.Anchored = true end
                end
            end
        end
    end
end)

-- TP Killer (G)
UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if C.TPK and i.KeyCode == Enum.KeyCode.G then
        if FindM then
            local m = FindM()
            if m and m.Character then
                local th = m.Character:FindFirstChild("HumanoidRootPart")
                local mh = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if th and mh then mh.CFrame = th.CFrame * CFrame.new(0, 0, 3) end
            end
        end
    end
end)

print("[LLUHA] combat loaded ✅")
