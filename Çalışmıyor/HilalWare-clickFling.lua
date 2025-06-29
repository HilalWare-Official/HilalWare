local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local character = player.Character or player.CharacterAdded:Wait()
local realRoot = character:WaitForChild("HumanoidRootPart")

-- ✅ Sahte root part oluştur
local fakeRoot = Instance.new("Part")
fakeRoot.Size = Vector3.new(2, 2, 1)
fakeRoot.Name = "FakeRoot"
fakeRoot.Anchored = false
fakeRoot.CanCollide = true
fakeRoot.Position = realRoot.Position + Vector3.new(3, 0, 0)
fakeRoot.Material = Enum.Material.Neon
fakeRoot.BrickColor = BrickColor.new("White")
fakeRoot.Parent = workspace

-- 🌈 RGB ESP kutusu
local espBox = Instance.new("BoxHandleAdornment")
espBox.Name = "RGB_ESP"
espBox.Adornee = fakeRoot
espBox.Size = fakeRoot.Size + Vector3.new(0.1, 0.1, 0.1)
espBox.AlwaysOnTop = true
espBox.ZIndex = 10
espBox.Transparency = 0.2
espBox.Parent = game:GetService("CoreGui")

-- 🔁 RGB animasyonu
local hue = 0
RunService.RenderStepped:Connect(function()
	hue = (hue + 0.01) % 1
	espBox.Color3 = Color3.fromHSV(hue, 1, 1)
end)

-- 🚀 Click Fling mekanizması
local flingPower = 150 -- ne kadar hızlı fırlasın
local flingTime = 0.2  -- saniye cinsinden

mouse.Button1Down:Connect(function()
	local target = mouse.Target
	if not target then return end

	local targetChar = target:FindFirstAncestorOfClass("Model")
	if not targetChar or targetChar == character then return end

	local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
	if not targetRoot then return end

	-- Fırlatma yönünü hesapla
	local direction = (targetRoot.Position - fakeRoot.Position).Unit
	local velocity = direction * flingPower

	-- Fling başlat
	local startTime = tick()
	local flingConn
	flingConn = RunService.Heartbeat:Connect(function()
		if tick() - startTime > flingTime then
			flingConn:Disconnect()
			fakeRoot.Velocity = Vector3.zero
			return
		end
		fakeRoot.Velocity = velocity
	end)
end)
