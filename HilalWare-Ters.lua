local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local function setupCharacter(char)
	local humanoid = char:WaitForChild("Humanoid")
	local hrp = char:WaitForChild("HumanoidRootPart")

	-- AutoRotate kapatılıyor çünkü yönü biz kontrol edeceğiz
	humanoid.AutoRotate = false

	RunService.RenderStepped:Connect(function()
		local moveDir = humanoid.MoveDirection

		if moveDir.Magnitude > 0 then
			-- Normal yön (ileri yön)
			local moveDirection = moveDir.Unit

			-- 180 derece TERS yön = -MoveDirection
			local backwardDirection = -moveDirection

			-- HumanoidRootPart pozisyonu ve yönü
			local pos = hrp.Position
			local newLook = pos + Vector3.new(backwardDirection.X, 0, backwardDirection.Z)
			hrp.CFrame = CFrame.lookAt(pos, newLook)
		end
	end)
end

-- Karakter yüklenince çalıştır
if player.Character then
	setupCharacter(player.Character)
end
player.CharacterAdded:Connect(setupCharacter)
