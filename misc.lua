local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")

local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local C = _G.LLUHA.C
local GetRole = _G.LLUHA.GetMyRole

-- Invisible
task.spawn(function()
    while task.wait(0.5) do
        local ch = LP.Character
        if ch then
            for _, pt in pairs(ch:GetDescendants()) do
                if pt:IsA("BasePart") and pt.Name ~= "HumanoidRootPart" then
                    pt.LocalTransparencyModifier = C.Invis and 1 or 0
                elseif pt:IsA("Decal") then
                    pt.Transparency = C.Invis and 1 or 0
                end
            end
        end
    end
end)

-- Ghost
task.spawn(function()
    while task.wait(0.3) do
        if C.Ghost then
            local ch = LP.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.Transparency = 1 end
            for _, pt in pairs(ch:GetDescendants()) do
                if pt:IsA("BasePart") then pt.CanCollide = false end
            end
        end
    end
end)

-- Godmode
task.spawn(function()
    while task.wait(0.3) do
        if C.Godmode then
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.MaxHealth = math.huge; hum.Health = math.huge end
        end
    end
end)

-- AntiFling
task.spawn(function()
    while task.wait(0.3) do
        if not C.AFling then continue end
        local ch = LP.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Velocity.Magnitude > 150 then
            hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
            hrp.RotVelocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- AntiAFK
if C.AntiAFK then
    LP.Idled:Connect(function()
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end)
end

-- Bomb Jump
local function HB()
    local ch = LP.Character
    if not ch then return false end
    for _, t in pairs(ch:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("bomb") or n:find("бомб") or n:find("prank") then return true end
        end
    end
    return false
end

UIS.JumpRequest:Connect(function()
    if C.BJ and HB() then
        local ch = LP.Character
        if ch then
            local hum = ch:FindFirstChildOfClass("Humanoid")
            if hum and hum:GetState() == Enum.HumanoidStateType.Freefall then
                local b = ch:FindFirstChildOfClass("Tool")
                if b then b:Activate(); task.wait(0.05); hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end
    end
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if C.InfJ then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Fly (LinearVelocity)
local flyAttach, flyLV, flyAO, flyAlign
local function StopFly()
    if flyLV then flyLV:Destroy(); flyLV = nil end
    if flyAO then flyAO:Destroy(); flyAO = nil end
    if flyAttach then flyAttach:Destroy(); flyAttach = nil end
    if flyAlign then flyAlign:Destroy(); flyAlign = nil end
end

local function StartFly(hrp)
    if flyLV then return end
    flyAttach = Instance.new("Attachment")
    flyAttach.Parent = hrp

    flyAlign = Instance.new("AlignOrientation")
    flyAlign.Mode = Enum.OrientationAlignmentMode.OneAttachment
    flyAlign.Attachment0 = flyAttach
    flyAlign.MaxTorque = 9e9
    flyAlign.Responsiveness = 200
    flyAlign.Parent = hrp

    flyLV = Instance.new("LinearVelocity")
    flyLV.Attachment0 = flyAttach
    flyLV.MaxForce = 9e9
    flyLV.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    flyLV.PrimaryTangentAxis = Enum.Vector3.X
    flyLV.SecondaryTangentAxis = Enum.Vector3.Y
    flyLV.Parent = hrp

    flyAO = Instance.new("AlignOrientation")
    flyAO.Mode = Enum.OrientationAlignmentMode.OneAttachment
    flyAO.Attachment0 = flyAttach
    flyAO.MaxTorque = 9e9
    flyAO.Responsiveness = 200
    flyAO.Parent = hrp
end

task.spawn(function()
    while task.wait(0.05) do
        local ch = LP.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp then StopFly(); continue end

        if C.Fly then
            local hum = ch:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.PlatformStand = false
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Physics) end)
            end
            StartFly(hrp)
            local md = Vector3.zero
            local cf = Cam.CFrame
            if UIS:IsKeyDown(Enum.KeyCode.W) then md = md + cf.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then md = md - cf.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then md = md - cf.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then md = md + cf.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then md = md + Vector3.new(0, 1, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then md = md - Vector3.new(0, 1, 0) end
            if flyLV then
                flyLV.VectorVelocity = md.Magnitude > 0 and md.Unit * (C.FlySp or 60) or Vector3.zero
            end
            if flyAlign then flyAlign.CFrame = cf end
        else
            StopFly()
        end
    end
end)

-- ClickTP
local function DoTP(ray)
    local ch = LP.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local pr = RaycastParams.new()
    pr.FilterType = Enum.RaycastFilterType.Exclude
    pr.FilterDescendantsInstances = {ch}
    local rs = workspace:Raycast(ray.Origin, ray.Direction * 1000, pr)
    if rs then hrp.CFrame = CFrame.new(rs.Position + Vector3.new(0, 3, 0))
    else hrp.CFrame = CFrame.new(ray.Origin + ray.Direction * 100 + Vector3.new(0, 3, 0)) end
end

UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if not C.CTP then return end
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        local ml = UIS:GetMouseLocation()
        DoTP(Cam:ViewportPointToRay(ml.X, ml.Y))
    elseif i.UserInputType == Enum.UserInputType.Touch then
        DoTP(Cam:ViewportPointToRay(i.Position.X, i.Position.Y))
    end
end)

-- NoClip
RunService.Stepped:Connect(function()
    if C.NoClip then
        local ch = LP.Character
        if ch then
            for _, p in pairs(ch:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
end)

-- Fullbright + NoFog
task.spawn(function()
    while task.wait(0.5) do
        if C.Fullbright then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 3
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
        end
        if C.NoFog then
            Lighting.FogEnd = 100000
            Lighting.FogStart = 100000
        end
    end
end)

-- FPS Boost
task.spawn(function()
    while task.wait(2) do
        if C.FPSBoost then
            for _, o in pairs(workspace:GetDescendants()) do
                if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Smoke") or o:IsA("Fire") then
                    o.Enabled = false
                end
            end
        end
    end
end)

print("[LLUHA] misc loaded ✅")
