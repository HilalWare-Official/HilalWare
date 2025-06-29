-- Freeze Durumu Gösterici (Label)
local FreezeStatus = Instance.new("TextLabel", MainFrame)
FreezeStatus.Size = UDim2.new(1, -20, 0, 25)
FreezeStatus.Position = UDim2.new(0, 10, 0, 190)
FreezeStatus.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
FreezeStatus.Text = "❄️ Freeze: Kapalı (F tuşuna bas)"
FreezeStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
FreezeStatus.Font = Enum.Font.Gotham
FreezeStatus.TextSize = 14
FreezeStatus.TextWrapped = true

-- Freeze Sistemi: F tuşu ile kontrol
local UserInputService = game:GetService("UserInputService")
local isFrozen = false

UserInputService.InputBegan:Connect(function(input, isTyping)
	if isTyping then return end  -- chat yazarken çalışmasın
	if input.KeyCode == Enum.KeyCode.F then
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			isFrozen = not isFrozen
			char.HumanoidRootPart.Anchored = isFrozen

			-- Durum metnini güncelle
			if isFrozen then
				FreezeStatus.Text = "✅ Freeze: Aktif (F ile kapat)"
				FreezeStatus.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
			else
				FreezeStatus.Text = "❄️ Freeze: Kapalı (F tuşuna bas)"
				FreezeStatus.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
			end
		end
	end
end)
