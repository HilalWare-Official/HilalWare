local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

-- Glitch uygulanacak parçalar (R15 ve R6 uyumlu)
local parts = {
	char:WaitForChild("Head"),
	char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm"),
	char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm"),
	char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg"),
	char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg"),
}

-- Motor6D bağlantısını bul
local function getMotorFor(part)
	for _, motor in ipairs(char:GetDescendants()) do
		if motor:IsA("Motor6D") and motor.Part1 == part then
			return motor
		end
	end
end

-- Geniş açıyla rastgele dönüş üret (10-180 derece arasında)
local function randomCFrame()
	local function randAngle()
		local deg = math.random(10, 180)
		if math.random(1, 2) == 1 then deg = -deg end
		return math.rad(deg)
	end

	local rx = randAngle()
	local ry = randAngle()
	local rz = randAngle()
	return CFrame.Angles(rx, ry, rz)
end

-- Bir parçaya 0.2 sn süren glitch uygula
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

-- Ana loop: her parçayı sırayla bozar, 2-3 saniyelik farklı zamanlamalarla
task.spawn(function()
	while true do
		for _, part in ipairs(parts) do
			glitchPart(part)
			task.wait(2 + math.random()) -- 2~3 sn arası
		end
	end
end)
