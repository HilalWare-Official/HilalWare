local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- 🎒 Couch Tool'u bul
local couchTool = char:FindFirstChild("Couch") or plr.Backpack:FindFirstChild("Couch")
if not couchTool then
	warn("❌ Couch tool bulunamadı.")
	return
end

local teleported = false
local returned = false

-- 🔁 SeatWeld kontrolcüsü
local function checkSeatsForSeatWeld()
	for _, seat in pairs(couchTool:GetDescendants()) do
		if seat:IsA("Seat") and (seat.Name == "Seat1" or seat.Name == "Seat2") then
			if seat:FindFirstChild("SeatWeld") and not teleported then
				teleported = true
				print("🎯 SeatWeld tespit edildi! SEN ışınlanıyorsun.")
				hrp.Position = Vector3.new(0, 100000000, 0)
			end
		end
	end
end

-- ⏱️ SeatWeld’i sürekli kontrol et
RunService.Heartbeat:Connect(function()
	if not teleported then
		checkSeatsForSeatWeld()
	end
end)

-- 🗑️ Couch silinirse geri ışınla
couchTool.AncestryChanged:Connect(function(_, parent)
	if not parent and teleported and not returned then
		returned = true
		wait(0.5)
		print("↩️ Couch silindi. Geri ışınlanıyorsun.")
		hrp.Position = Vector3.new(0, -100000000, 0)
	end
end)
