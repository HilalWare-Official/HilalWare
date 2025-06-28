local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- 🎒 Couch Tool'u bul
local function getCouch()
	return plr.Character:FindFirstChild("Couch") or plr.Backpack:FindFirstChild("Couch")
end

local teleported = false
local returned = false
local trapEnabled = false

-- 🔁 SeatWeld kontrolü
local function checkSeats()
	local couchTool = getCouch()
	if not couchTool or not trapEnabled or teleported then return end

	for _, seat in pairs(couchTool:GetDescendants()) do
		if seat:IsA("Seat") and (seat.Name == "Seat1" or seat.Name == "Seat2") then
			if seat:FindFirstChild("SeatWeld") then
				teleported = true
				print("🎯 Tuzağa düşüldü, ışınlanıyorsun!")
				hrp.Position = Vector3.new(0, 100000000, 0)
			end
		end
	end
end

-- 🧠 Couch silinince geri dön
local function monitorCouchRemoval()
	local couchTool = getCouch()
	if not couchTool then return end

	couchTool.AncestryChanged:Connect(function(_, parent)
		if not parent and teleported and not returned then
			returned = true
			wait(0.5)
			print("↩️ Couch silindi. Geri ışınlanıyorsun.")
			hrp.Position = Vector3.new(0, -100000000, 0)
		end
	end)
end

-- ⏱️ Takip sistemi sürekli çalışır ama aktiflik kontrolü yapar
RunService.Heartbeat:Connect(function()
	if trapEnabled and not teleported then
		checkSeats()
	end
end)

-- 🔘 GUI Oluştur
local gui = Instance.new("ScreenGui")
gui.Name = "TrapControl"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 40)
button.Position = UDim2.new(0, 20, 0, 100)
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "Tuzağı Aç"
button.Parent = gui

-- 🔘 Buton Fonksiyonu
button.MouseButton1Click:Connect(function()
	trapEnabled = not trapEnabled
	button.Text = trapEnabled and "Tuzağı Kapat" or "Tuzağı Aç"
	print(trapEnabled and "✅ Tuzak aktif!" or "⛔ Tuzak kapalı!")

	if trapEnabled then
		-- Aktif olduğunda tool tekrar kontrol edilir
		teleported = false
		returned = false
		monitorCouchRemoval()
	end
end)
