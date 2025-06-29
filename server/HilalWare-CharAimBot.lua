local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- En yakın hedefi bul
local function getClosestPlayer()
	local closest = nil
	local shortestDist = math.huge

	for _, other in ipairs(Players:GetPlayers()) do
		if other ~= plr and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (hrp.Position - other.Character.HumanoidRootPart.Position).Magnitude
			if dist < shortestDist then
				shortestDist = dist
				closest = other
			end
		end
	end

	return closest
end

-- Karakter yönünü hedefe çevir
RunService.RenderStepped:Connect(function()
	local target = getClosestPlayer()
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		local targetPos = target.Character.HumanoidRootPart.Position
		local myPos = hrp.Position

		-- Sadece Y (yön) ekseninde dön
		local look = CFrame.lookAt(myPos, Vector3.new(targetPos.X, myPos.Y, targetPos.Z))
		hrp.CFrame = look
	end
end)
