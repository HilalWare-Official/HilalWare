local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

-- Ayarlanabilir vücut parçaları
local parts = {
	char:WaitForChild("Head"),
	char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm"),
	char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm"),
	char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg"),
	char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg"),
}

-- Motor6D’leri bul
local function getMotorFor(part)
	for _, motor in ipairs(char:GetDescendants()) do
		if motor:IsA("Motor6D") and motor.Part1 == part then
			return motor
		end
	end
end

-- Rastgele küçük bir dönüş oluştur
local function randomCFrame()
	local rx = math.rad(math.random(-15, 15))
	local ry = math.rad(math.random(-15, 15))
	local rz = math.rad(math.random(-15, 15))
	return CFrame.Angles(rx, ry, rz)
end

-- Belirli parçaya geçici glitch uygula
local function glitchPart(part)
	local motor = getMotorFor(part)
	if not motor then return end

	local original = motor.C0
	local glitch = original * randomCFrame()

	motor.C0 = glitch
	task.delay(0.2, function()
		if motor then
			motor.C0 = original
		end
	end)
end

-- Ana loop: parçaları sırayla bozar, her biri 2 saniye arayla
task.spawn(function()
	while true do
		for _, part in ipairs(parts) do
			glitchPart(part)
			task.wait(2 + math.random() * 1) -- 2–3 sn arası rastgele
		end
	end
end)
