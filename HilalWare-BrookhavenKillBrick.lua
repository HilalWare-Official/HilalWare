local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- 🎒 Couch Tool'u bul
local function getCouch()
	return plr.Character:FindFirstChild("Couch") or plr.Backpack:FindFirstChild("Couch")
end

local teleported = false
local returned = false

-- 🔁 SeatWeld kontrolü
local function checkSeats()
	local couchTool = getCouch()
	if not couchTool or teleported then return end

	for _, seat in pairs(couchTool:GetDescendants()) do
		if seat:IsA("Seat") and (seat.Name == "Seat1" or seat.Name == "Seat2") then
			if seat:FindFirstChild("SeatWeld") then
				teleported = true
				print("🎯 SeatWeld tespit edildi! SEN uçuyorsun.")
				hrp.Position = Vector3.new(0, 100000000, 0)
			end
		end
	end
end

-- 🧠 Couch silinirse geri getir
local function monitorCouchRemoval()
	local couchTool = getCouch()
	if not couchTool then return end

	couchTool.AncestryChanged:Connect(function(_, parent)
		if not parent and teleported and not returned then
			returned = true
			wait(0.5)
			print("↩️ Couch yok oldu. SEN geri gidiyorsun.")
			hrp.Position = Vector3.new(0, -100000000, 0)
		end
	end)
end

-- 🔁 Sürekli kontrol
RunService.Heartbeat:Connect(function()
	if not teleported then
		checkSeats()
	end
end)

monitorCouchRemoval()

-- 📺 GUI (sadece görünüm, aç/kapa yok)
local gui = Instance.new("ScreenGui")
gui.Name = "TuzakBilgi"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 220, 0, 30)
label.Position = UDim2.new(0, 20, 0, 100)
label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
label.TextColor3 = Color3.fromRGB(255, 80, 80)
label.Text = "☠️ Koltuk tuzağı aktif!"
label.Font = Enum.Font.SourceSansBold
label.TextSize = 18
label.Parent = gui
