local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

local tiltAmount = math.rad(5) -- 5 derece
local targetTilt = Vector3.new(0, 0, 0)
local currentTilt = Vector3.new(0, 0, 0)

local keysDown = {}

UIS.InputBegan:Connect(function(input, gpe)
	if not gpe then
		keysDown[input.KeyCode] = true
	end
end)

UIS.InputEnded:Connect(function(input, gpe)
	if not gpe then
		keysDown[input.KeyCode] = false
	end
end)

RunService.RenderStepped:Connect(function()
	local pitch, roll = 0, 0

	-- Shift Lock aktifse
	local shiftLockActive = UIS.MouseBehavior == Enum.MouseBehavior.LockCenter

	if shiftLockActive then
		if keysDown[Enum.KeyCode.W] then pitch = pitch - tiltAmount end
		if keysDown[Enum.KeyCode.S] then pitch = pitch + tiltAmount end
		if keysDown[Enum.KeyCode.A] then roll = roll + tiltAmount end
		if keysDown[Enum.KeyCode.D] then roll = roll - tiltAmount end
	else
		-- Shift Lock kapalıysa: sadece öne eğim (W)
		if hum.MoveDirection.Magnitude > 0.1 then
			pitch = -tiltAmount
		end
	end

	targetTilt = Vector3.new(pitch, 0, roll)
	currentTilt = currentTilt:Lerp(targetTilt, 0.1)

	local pos = hrp.Position
	local look = hrp.CFrame.LookVector
	local cf = CFrame.lookAt(pos, pos + look) * CFrame.Angles(currentTilt.X, 0, currentTilt.Z)
	hrp.CFrame = cf
end)
