local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local function setupChar(char)
	local humanoid = char:WaitForChild("Humanoid")
	local root = char:WaitForChild("HumanoidRootPart")

	-- Otomatik dönüşü kapat
	humanoid.AutoRotate = false

	-- RenderStepped ile yönü tersle
	RunService.RenderStepped:Connect(function()
		local moveDir = humanoid.MoveDirection
		if moveDir.Magnitude > 0 then
			-- Normalde baktığı yönün tam tersine dön
			local lookVector = -moveDir
			local newCFrame = CFrame.lookAt(root.Position, root.Position + Vector3.new(lookVector.X, 0, lookVector.Z))
			root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.atan2(-moveDir.X, -moveDir.Z), 0)
		end
	end)
end

-- Karakter yüklendiğinde çalıştır
if player.Character then
	setupChar(player.Character)
end
player.CharacterAdded:Connect(setupChar)
