local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local function setupCharacter(char)
	local humanoid = char:WaitForChild("Humanoid")
	local root = char:WaitForChild("HumanoidRootPart")

	-- Otomatik rotasyonu kapatıyoruz ki biz yön verelim
	humanoid.AutoRotate = false

	RunService.RenderStepped:Connect(function()
		local moveDir = humanoid.MoveDirection
		if moveDir.Magnitude > 0 then
			-- Normal hareket yönünü al
			local lookVector = moveDir.Unit

			-- TERS yön: baktığı yönün tam arkası
			local backwards = -lookVector

			-- HumanoidRootPart pozisyonunu koruyarak TERS yöne döndür
			local newCFrame = CFrame.lookAt(root.Position, root.Position + Vector3.new(backwards.X, 0, backwards.Z))

			-- Yeni dönüşü ayarla
			root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.atan2(backwards.X, backwards.Z), 0)
		end
	end)
end

-- İlk yüklenen karakter için çalıştır
if player.Character then
	setupCharacter(player.Character)
end

-- Ölünce yeniden çalışması için
player.CharacterAdded:Connect(setupCharacter)
