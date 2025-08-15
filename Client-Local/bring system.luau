-- // Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- // Başlangıç koruma listesi
local ProtectedList = {"q692q", "HilalWare_Lua", "muhammet_bekir2004"}

-- // GUI oluşturma
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "FrontRightAlignGui"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Position = UDim2.new(0.35, 0, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 170, 255)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "Sağ Ön Çapraz - Koruma Listesi"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

-- Aç/Kapa Butonu
local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(1, -20, 0, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0, 35)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.Text = "Aç"

local BtnCorner = Instance.new("UICorner", ToggleBtn)
BtnCorner.CornerRadius = UDim.new(0, 8)

-- Liste kutusu
local ListBox = Instance.new("ScrollingFrame", MainFrame)
ListBox.Size = UDim2.new(1, -20, 0, 80)
ListBox.Position = UDim2.new(0, 10, 0, 70)
ListBox.CanvasSize = UDim2.new(0, 0, 0, 0)
ListBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ListBox.ScrollBarThickness = 4

local ListCorner = Instance.new("UICorner", ListBox)
ListCorner.CornerRadius = UDim.new(0, 6)

-- İsim ekleme kutusu
local NameBox = Instance.new("TextBox", MainFrame)
NameBox.Size = UDim2.new(1, -20, 0, 25)
NameBox.Position = UDim2.new(0, 10, 0, 155)
NameBox.PlaceholderText = "İsim yaz..."
NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
NameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NameBox.Font = Enum.Font.Gotham
NameBox.TextSize = 14

local NameCorner = Instance.new("UICorner", NameBox)
NameCorner.CornerRadius = UDim.new(0, 6)

-- İsim ekleme butonu
local AddBtn = Instance.new("TextButton", MainFrame)
AddBtn.Size = UDim2.new(0, 60, 0, 25)
AddBtn.Position = UDim2.new(1, -70, 0, 155)
AddBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
AddBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AddBtn.Font = Enum.Font.GothamBold
AddBtn.TextSize = 14
AddBtn.Text = "Ekle"

local AddCorner = Instance.new("UICorner", AddBtn)
AddCorner.CornerRadius = UDim.new(0, 6)

-- Liste yenileme fonksiyonu
local function RefreshList()
	ListBox:ClearAllChildren()
	local y = 0
	for _, name in ipairs(ProtectedList) do
		local lbl = Instance.new("TextLabel", ListBox)
		lbl.Size = UDim2.new(1, 0, 0, 20)
		lbl.Position = UDim2.new(0, 0, 0, y)
		lbl.BackgroundTransparency = 1
		lbl.Text = name
		lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
		lbl.Font = Enum.Font.Gotham
		lbl.TextSize = 14
		y = y + 20
	end
	ListBox.CanvasSize = UDim2.new(0, 0, 0, y)
end

-- Başlangıçta listeyi yükle
RefreshList()

-- Buton fonksiyonları
AddBtn.MouseButton1Click:Connect(function()
	local name = NameBox.Text
	if name ~= "" and not table.find(ProtectedList, name) then
		table.insert(ProtectedList, name)
		RefreshList()
		NameBox.Text = ""
	end
end)

-- Sürükleme sistemi
local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)
MainFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Sağ ön çapraz sistemi
local enabled = false
ToggleBtn.MouseButton1Click:Connect(function()
	enabled = not enabled
	ToggleBtn.Text = enabled and "Kapat" or "Aç"
end)

RunService.RenderStepped:Connect(function()
	if enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local myPos = LocalPlayer.Character.HumanoidRootPart.Position
		local myLook = LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector
		local rightVec = LocalPlayer.Character.HumanoidRootPart.CFrame.RightVector

		for _,plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and not table.find(ProtectedList, plr.Name) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local targetPos = myPos + (myLook * 3) + (rightVec * 3)
				plr.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos, myPos)
			end
		end
	end
end)
