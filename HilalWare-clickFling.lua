-- RootPart Fling v1.0 by ChatGPT
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local RunService = game:GetService("RunService")

-- Kendi karakterin
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- Ayarlar
local flingSpeed = 100 -- Daha yüksek = daha güçlü
local flingTime = 0.2   -- Saniye olarak fling süresi

mouse.Button1Down:Connect(function()
	local target = mouse.Target
	if not target then return end

	-- Tıklanan karakteri bul
	local targetChar = target:FindFirstAncestorOfClass("Model")
	if not targetChar or targetChar == character then return end

	local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
	if not targetRoot then return end

	-- Karakterin rootpart'ını hedefe doğru fırlat
	local direction = (targetRoot.Position - root.Position).Unit
	local velocity = direction * flingSpeed

	-- RootPart'ı fiziksel olarak fırlat
	local originalCFrame = root.CFrame
	local conn

	-- Sabit velocity uygula birkaç frame boyunca
	local startTime = tick()
	conn = RunService.Heartbeat:Connect(function()
		if tick() - startTime > flingTime then
			conn:Disconnect()
			-- RootPart geri alınabilir (isteğe bağlı)
			root.Velocity = Vector3.zero
			root.CFrame = originalCFrame
			return
		end
		root.Velocity = velocity
	end)
end)
