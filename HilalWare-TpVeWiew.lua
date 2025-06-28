loadstring([[
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local cam = workspace.CurrentCamera
local isSpectating = false

-- GUI oluştur
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "TP_GUI"
ScreenGui.ResetOnSpawn = false

-- Frame (taşınabilir panel)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 240)
Frame.Position = UDim2.new(0.5, -150, 0.4, -120)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true -- SÜRÜKLENEBİLİR!

-- Başlık
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "👑 TP & Spectate (HilalWare Style)"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1

-- Oyuncu seçme dropdown
local DropDown = Instance.new("TextButton", Frame)
DropDown.Size = UDim2.new(1, -20, 0, 30)
DropDown.Position = UDim2.new(0, 10, 0, 40)
DropDown.Text = "Oyuncu Seç"
DropDown.TextColor3 = Color3.new(1, 1, 1)
DropDown.Font = Enum.Font.Gotham
DropDown.TextSize = 16
DropDown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local Scroll = Instance.new("ScrollingFrame", Frame)
Scroll.Size = UDim2.new(1, -20, 0, 100)
Scroll.Position = UDim2.new(0, 10, 0, 75)
Scroll.BackgroundColor3 = Color3.fromRGB(45,45,45)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 4
Scroll.Visible = false

local selectedName = nil

DropDown.MouseButton1Click:Connect(function()
	Scroll.Visible = not Scroll.Visible
end)

-- Oyuncuları listele
local function refreshList()
	Scroll:ClearAllChildren()
	local y = 0
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local Btn = Instance.new("TextButton", Scroll)
			Btn.Size = UDim2.new(1, 0, 0, 25)
			Btn.Position = UDim2.new(0, 0, 0, y)
			Btn.Text = plr.Name
			Btn.Font = Enum.Font.Gotham
			Btn.TextSize = 14
			Btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
			Btn.TextColor3 = Color3.new(1,1,1)

			Btn.MouseButton1Click:Connect(function()
				selectedName = plr.Name
				DropDown.Text = "🎯 " .. plr.Name
				Scroll.Visible = false
			end)
			y = y + 28
		end
	end
	Scroll.CanvasSize = UDim2.new(0, 0, 0, y)
end

refreshList()
Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)

-- Işınlan Butonu
local TP = Instance.new("TextButton", Frame)
TP.Size = UDim2.new(0.5, -15, 0, 30)
TP.Position = UDim2.new(0, 10, 0, 190)
TP.Text = "💫 Işınlan"
TP.Font = Enum.Font.GothamBold
TP.TextSize = 16
TP.TextColor3 = Color3.new(1,1,1)
TP.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

-- İzle Butonu
local SPEC = Instance.new("TextButton", Frame)
SPEC.Size = UDim2.new(0.5, -15, 0, 30)
SPEC.Position = UDim2.new(0.5, 5, 0, 190)
SPEC.Text = "👁 İzle"
SPEC.Font = Enum.Font.GothamBold
SPEC.TextSize = 16
SPEC.TextColor3 = Color3.new(1,1,1)
SPEC.BackgroundColor3 = Color3.fromRGB(255, 170, 0)

-- Durdur Butonu
local STOP = Instance.new("TextButton", Frame)
STOP.Size = UDim2.new(1, -20, 0, 25)
STOP.Position = UDim2.new(0, 10, 0, 160)
STOP.Text = "❌ İzlemeyi Durdur"
STOP.Font = Enum.Font.Gotham
STOP.TextSize = 14
STOP.TextColor3 = Color3.new(1,1,1)
STOP.BackgroundColor3 = Color3.fromRGB(200, 0, 0)

-- Fonksiyonlar
TP.MouseButton1Click:Connect(function()
	local target = Players:FindFirstChild(selectedName)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(2, 0, 2))
	end
end)

SPEC.MouseButton1Click:Connect(function()
	local target = Players:FindFirstChild(selectedName)
	if target and target.Character and target.Character:FindFirstChild("Humanoid") then
		cam.CameraSubject = target.Character:FindFirstChild("Humanoid")
		isSpectating = true
	end
end)

STOP.MouseButton1Click:Connect(function()
	if isSpectating then
		cam.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
		isSpectating = false
	end
end)
]])()
