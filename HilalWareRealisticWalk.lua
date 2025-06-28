local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- Hedef eğim (radyan cinsinden 10 derece ≈ 0.17)
local targetTilt = 0
local currentTilt = 0
local maxTilt = math.rad(5)  -- işte bu: 10 derece öne eğilme

RunService.RenderStepped:Connect(function()
    -- Hareket kontrolü
    if hum.MoveDirection.Magnitude > 0.1 then
        targetTilt = -maxTilt  -- ileri eğim (X rotasyon negatif)
    else
        targetTilt = 0  -- düz dur
    end

    -- Yumuşak geçiş (lerp)
    currentTilt = currentTilt + (targetTilt - currentTilt) * 0.1

    -- Karakterin yönünü bozmadan sadece eğim uygula
    local lookVector = hrp.CFrame.LookVector
    local upVector = Vector3.new(0, 1, 0)
    local position = hrp.Position
    local newCFrame = CFrame.lookAt(position, position + lookVector, upVector) * CFrame.Angles(currentTilt, 0, 0)
    hrp.CFrame = newCFrame
end)
