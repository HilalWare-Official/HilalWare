local player = game.Players.LocalPlayer

-- GUI'yi oluştur
local function createAdminGui()
	local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	gui.Name = "MiniAdmin"
	gui.ResetOnSpawn = false

	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0, 350, 0, 100)
	frame.Position = UDim2.new(1, -10, 0, 50)
	frame.AnchorPoint = Vector2.new(1, 0)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	frame.BorderSizePixel = 0

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, -30, 0, 25)
	title.Position = UDim2.new(0, 10, 0, 5)
	title.Text = "HD Admin"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.BackgroundTransparency = 1
	title.TextXAlignment = Enum.TextXAlignment.Left

	local closeBtn = Instance.new("TextButton", frame)
	closeBtn.Size = UDim2.new(0, 20, 0, 20)
	closeBtn.Position = UDim2.new(1, -25, 0, 5)
	closeBtn.Text = "X"
	closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	closeBtn.TextColor3 = Color3.new(1, 1, 1)
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 14

	local message = Instance.new("TextLabel", frame)
	message.Size = UDim2.new(1, -20, 0, 50)
	message.Position = UDim2.new(0, 10, 0, 35)
	message.Text = "Your rank is 'Free Admin'! Click to view the commands. (12)"
	message.TextColor3 = Color3.new(1, 1, 1)
	message.Font = Enum.Font.Gotham
	message.TextSize = 14
	message.TextWrapped = true
	message.BackgroundTransparency = 1
	message.TextXAlignment = Enum.TextXAlignment.Left

	local tweenService = game:GetService("TweenService")

	-- Sağdan içeri kaydır
	frame.Position = UDim2.new(1, 310, 0, 50)
	local tweenIn = tweenService:Create(frame, TweenInfo.new(0.5), {
		Position = UDim2.new(1, -10, 0, 50)
	})
	tweenIn:Play()

	-- Kapat butonu
	closeBtn.MouseButton1Click:Connect(function()
		local tweenOut = tweenService:Create(frame, TweenInfo.new(0.5), {
			Position = UDim2.new(1, 310, 0, 50)
		})
		tweenOut:Play()
		tweenOut.Completed:Wait()
		gui:Destroy()
	end)
end

-- Sohbet dinleyici
player.Chatted:Connect(function(msg)
	if msg:lower() == ":admin" then
		createAdminGui()
	end
end)
