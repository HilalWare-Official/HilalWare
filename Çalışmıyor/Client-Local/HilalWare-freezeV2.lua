--// Anchored Fake Walk System - F ile Aç/Kapa
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local run = game:GetService("RunService")
local cam = workspace.CurrentCamera

-- Karakteri sabitle
hrp.Anchored = true

-- Durum değişkeni
local isMoving = false
local moveDir = Vector3.zero

-- F tuşu ile aç/kapa
UIS.InputBegan:Connect(function(input, isTyping)
	if isTyping then return end
	if input.KeyCode == Enum.KeyCode.F then
		isMoving = not isMoving
	end
end)

-- Hareket yönü W-A-S-D ile
UIS.InputBegan:Connect(function(input, isTyping)
	if isTyping then return end
	if input.KeyCode == Enum.KeyCode.W then moveDir = Vector3.new(0, 0, -1) end
	if input.KeyCode == Enum.KeyCode.S then moveDir = Vector3.new(0, 0, 1) end
	if input.KeyCode == Enum.KeyCode.A then moveDir = Vector3.new(-1, 0, 0) end
	if input.KeyCode == Enum.KeyCode.D then moveDir = Vector3.new(1, 0, 0) end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
		moveDir = Vector3.zero
	end
end)

-- Hareket simülasyonu
run.RenderStepped:Connect(function(dt)
	if isMoving and moveDir.Magnitude > 0 then
		local speed = 16
		local look = cam.CFrame
		local direction = (look.RightVector * moveDir.X + look.LookVector * moveDir.Z).Unit
		hrp.CFrame = hrp.CFrame + direction * speed * dt
	end
end)
