local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

local targetTilt = 0
local currentTilt = 0

RunService.RenderStepped:Connect(function(dt)
    if hum.MoveDirection.Magnitude > 0.1 then
        targetTilt = -math.rad(20)  -- ileri eğim (negatif Z)
    else
        targetTilt = 0  -- dik duruş
    end

    -- Yumuşak geçiş (lerp)
    currentTilt = currentTilt + (targetTilt - currentTilt) * 0.1

    -- Rotasyonu uygula (sadece pitch = X ekseninde eğim)
    local lookVector = hrp.CFrame.LookVector
    local position = hrp.Position
    hrp.CFrame = CFrame.new(position, position + lookVector) * CFrame.Angles(currentTilt, 0, 0)
end)
