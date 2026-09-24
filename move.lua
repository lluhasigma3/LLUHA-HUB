local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local C = _G.LLUHA.C

RunService.Heartbeat:Connect(function()
    local ch = LP.Character
    if not ch then return end
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if C.Speed then hum.WalkSpeed = C.SpeedVal
    elseif hum.WalkSpeed ~= 16 then hum.WalkSpeed = 16 end
    if C.Jump then hum.JumpPower = 60 end
end)

local flyAttach, flyLV, flyAlign
local function StopFly()
    if flyLV then flyLV:Destroy(); flyLV = nil end
    if flyAttach then flyAttach:Destroy(); flyAttach = nil end
    if flyAlign then flyAlign:Destroy(); flyAlign = nil end
end

task.spawn(function()
    while task.wait(0.05) do
        local ch = LP.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp then StopFly(); continue end
        if C.Fly then
            if not flyAttach then
                flyAttach = Instance.new("Attachment")
                flyAttach.Parent = hrp
                flyLV = Instance.new("LinearVelocity")
                flyLV.Attachment0 = flyAttach
                flyLV.MaxForce = 9e9
                flyLV.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
                flyLV.Parent = hrp
                flyAlign = Instance.new("AlignOrientation")
                flyAlign.Mode = Enum.OrientationAlignmentMode.OneAttachment
                flyAlign.Attachment0 = flyAttach
                flyAlign.MaxTorque = 9e9
                flyAlign.Parent = hrp
            end
            local md = Vector3.zero
            local cf = Cam.CFrame
            if UIS:IsKeyDown(Enum.KeyCode.W) then md = md + cf.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then md = md - cf.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then md = md - cf.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then md = md + cf.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then md = md + Vector3.new(0, 1, 0) end
            if flyLV then
                flyLV.VectorVelocity = md.Magnitude > 0 and md.Unit * C.FlySp or Vector3.zero
            end
            if flyAlign then flyAlign.CFrame = cf end
        else
            StopFly()
        end
    end
end)

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

task.spawn(function()
    while task.wait(0.5) do
        if C.Invis then
            local ch = LP.Character
            if ch then
                for _, pt in pairs(ch:GetDescendants()) do
                    if pt:IsA("BasePart") then pt.LocalTransparencyModifier = 1 end
                end
            end
        end
    end
end)

print("[LLUHA] move loaded ✅")
