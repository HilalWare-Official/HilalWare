local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- 💣 Tüm tuzak araçlarının isimleri
local toolNames = {
	"Couch",
	"ShoppingCart",
	"Stretcher",
	"Wagon",
	"LawnMower"
}

local teleported = false
local returned = false
local activeTool = nil

-- 🔍 Tool'u karakterde veya backpack'te bul
local function getTool(name)
	return plr.Character:FindFirstChild(name) or plr.Backpack:FindFirstChild(name)
end

-- 🎯 Trap kontrolü: Her araç, her koltuk
local function checkAllTools()
	if teleported then return end

	for _, toolName in pairs(toolNames) do
		local tool = getTool(toolName)
		if tool then
			for _, part in pairs(tool:GetDescendants()) do
				if part:IsA("Seat") then
					if part:FindFirstChild("SeatWeld") then
						teleported = true
						activeTool = tool
						print("🚨 SeatWeld bulundu! Tool: "..toolName)
						hrp.Position = Vector3.new(0, 999999999999999999999999999999, 0)
						return
					end
				end
			end
		end
	end
end

-- 🧹 Araç silinirse geri dön
local function monitorToolRemoval()
	RunService.Heartbeat:Connect(function()
		if activeTool and not activeTool:IsDescendantOf(game) and teleported and not returned then
			returned = true
			wait(0.5)
			print("↩️ Tool silindi: "..activeTool.Name)
			hrp.Position = Vector3.new(0, -100000000, 0)
		end
	end)
end

-- ⏱️ Sürekli çalış
RunService.Heartbeat:Connect(function()
	if not teleported then
		checkAllTools()
	end
end)

monitorToolRemoval()

-- 📺 GUI Oluştur
local gui = Instance.new("ScreenGui")
gui.Name = "TrapSystemUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 420, 0, 30)
label.Position = UDim2.new(0, 20, 0, 60)
label.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
label.TextColor3 = Color3.fromRGB(255, 255, 180)
label.Text = "⚠️ Koltuk tuzakları aktif! Araçlar: Couch, Cart, Stretcher, Wagon, LawnMower"
label.Font = Enum.Font.SourceSansBold
label.TextSize = 16
label.Parent = gui
