local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

-- 🔁 1. Pozisyonu kaydet
local originalPos = char:WaitForChild("HumanoidRootPart").CFrame

-- 🔁 2. Kulüp koltuğunu bulup ışınla
local clubChair = nil
for _, v in pairs(workspace:GetDescendants()) do
	if v:IsA("Seat") and v.Name:lower():find("club") then
		clubChair = v
		break
	end
end

if clubChair then
	char:WaitForChild("HumanoidRootPart").CFrame = clubChair.CFrame + Vector3.new(0, 3, 0)
end

-- 🔁 3. GUI Kur
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "TrapGUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 300)
frame.Position = UDim2.new(0, 20, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 5)

-- 🔁 4. Oyuncu Seçme Butonları
local buyRemote = ReplicatedStorage:FindFirstChild("BuyItem")

for _, p in pairs(Players:GetPlayers()) do
	if p ~= plr then
		local btn = Instance.new("TextButton", frame)
		btn.Size = UDim2.new(1, -10, 0, 30)
		btn.Text = p.Name
		btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		btn.TextColor3 = Color3.new(1, 1, 1)

		btn.MouseButton1Click:Connect(function()
			-- 🔁 Koltuk spawnla
			if buyRemote then
				buyRemote:FireServer("Chair")
			end

			wait(0.5)

			local targetChar = p.Character
			if not targetChar then return end

			local spawnedSeat
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("Seat") and (v.Position - targetChar.HumanoidRootPart.Position).Magnitude < 15 then
					spawnedSeat = v
					break
				end
			end

			if spawnedSeat then
				spawnedSeat.CFrame = targetChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
				print("Trap koltuk yerleştirildi.")

				-- 🔁 Oturma kontrolü
				local conn
				conn = RunService.Heartbeat:Connect(function()
					if spawnedSeat.Occupant then
						local hum = spawnedSeat.Occupant
						local char = hum.Parent
						local hrp = char:FindFirstChild("HumanoidRootPart")
						if hrp then
							-- 🔥 5. Oyuncuyu aşağı gönder
							hrp.Position = Vector3.new(0, -100000000, 0)
							print("🔥", char.Name, "uçuruldu!")

							-- 🔁 6. Seni geri getir
							local myHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
							if myHRP then
								wait(0.3)
								myHRP.CFrame = originalPos
								print("↩️ Geri dönüldü")
							end
						end
						conn:Disconnect()
					end
				end)
			end
		end)
	end
end
