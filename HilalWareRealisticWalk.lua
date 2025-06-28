local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- Ayar
local tiltAmount = math.rad(5) -- 5 derece

-- Hedef eğim açıları (pitch, yaw, roll)
local targetTilt = Vector3.new(0, 0, 0)
local currentTilt = Vector3.new(0, 0, 0)

-- Tuş kontrolü
local keysDown = {}

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	keysDown[input.KeyCode] = true
end)

UIS.InputEnded:Connect(function(input, gpe)
	if gpe then return end
	keysDown[input.KeyCode] = false
end)

RunService.RenderStepped:Connect(function()
	-- Shift Lock kontrolü
	if not plr.DevEnableMouseLock or not UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then
		targetTilt = Vector3.new(0, 0, 0)
	else
		-- Tuşlara göre hedef eğim
		local pitch = 0 -- öne/arkaya (X)
		local yaw = 0   -- yok, kullanılmayacak
		local roll = 0  -- sağa/sola (Z)

		if keysDown[Enum.KeyCode.W] then pitch = pitch - tiltAmount end
		if keysDown[Enum.KeyCode.S] then pitch = pitch + tiltAmount end
		if keysDown[Enum.KeyCode.A] then roll = roll + tiltAmount end
		if keysDown[Enum.KeyCode.D] then roll = roll - tiltAmount end

		targetTilt = Vector3.new(pitch, yaw, roll)
	end

	-- Lerp ile geçiş
	currentTilt = currentTilt:Lerp(targetTilt, 0.1)

	-- Yeni CFrame oluştur
	local look = hrp.CFrame.LookVector
	local pos = hrp.Position
	local cf = CFrame.lookAt(pos, pos + look) 
	cf = cf * CFrame.Angles(currentTilt.X, 0, currentTilt.Z)

	hrp.CFrame = cf
end)
