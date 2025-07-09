local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- Animasyon setup
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://13721445907" -- Kollar arkaya havalı animasyon

local animTrack = nil
local animPlaying = false
local toolEquipped = false

-- Tool oluştur
local tool = Instance.new("Tool")
tool.Name = "HilalPose"
tool.RequiresHandle = false
tool.CanBeDropped = false
tool.Parent = player.Backpack

-- Toggle fonksiyonu
local function toggleAnimation()
	if not animPlaying then
		-- Animasyon başlat
		animTrack = humanoid:LoadAnimation(animation)
		animTrack.Priority = Enum.AnimationPriority.Action
		animTrack:Play()
		animPlaying = true
	else
		-- Animasyonu durdur
		if animTrack then
			animTrack:Stop()
			animTrack = nil
		end
		animPlaying = false
	end
end

-- Giriş kontrol
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if toolEquipped and input.UserInputType == Enum.UserInputType.Keyboard then
		toggleAnimation()
	end
end)

-- Tool eldeyken flag aktif
tool.Equipped:Connect(function()
	toolEquipped = true
end)

tool.Unequipped:Connect(function()
	toolEquipped = false
end)
