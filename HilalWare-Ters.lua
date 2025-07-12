local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local function setupCharacter(char)
	local humanoid = char:WaitForChild("Humanoid")
	local hrp = char:WaitForChild("HumanoidRootPart")

	-- Otomatik rotasyon kapatılıyor, yönü biz kontrol edeceğiz
	humanoid.AutoRotate = false

	RunService.RenderStepped:Connect(function()
		-- Hareket yönü alınıyor
		local moveDir = humanoid.MoveDirection
		if moveDir.Magnitude > 0 then
			-- Yürüyüş yönü belirleniyor
			local walkDirection = moveDir.Unit

			-- Pozisyon korunarak 180 derece ters yöne bakılıyor
			local newLookVector = -walkDirection
			local newCF = CFrame.new(hrp.Position, hrp.Position + Vector3.new(newLookVector.X, 0, newLookVector.Z))

			-- CFrame'i ayarla (aynı konum, ters yön)
			hrp.CFrame = newCF
		end
	end)
end

-- Karakter ilk yüklendiğinde
if player.Character then
	setupCharacter(player.Character)
end

-- Karakter yeniden doğduğunda
player.CharacterAdded:Connect(function(char)
	char:WaitForChild("HumanoidRootPart")
	char:WaitForChild("Humanoid")
	setupCharacter(char)
end)
