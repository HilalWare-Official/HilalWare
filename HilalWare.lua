local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

--  Yeni animasyon ID (kollar arkaya poz)
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://132305166420818"

local animTrack = nil
local animPlaying = false
local toolEquipped = false

--  Tool oluştur
local tool = Instance.new("Tool")
tool.Name = "HilalPose"
tool.RequiresHandle = false
tool.CanBeDropped = false
tool.Parent = player.Backpack

-- 🎮 Toggle fonksiyonu
local function toggleAnimation()
	if not animPlaying then
		animTrack = humanoid:LoadAnimation(animation)
		animTrack.Priority = Enum.AnimationPriority.Action
		animTrack:Play()
		animPlaying = true
	else
		if animTrack then
			animTrack:Stop()
			animTrack = nil
		end
		animPlaying = false
	end
end

--  Mouse kontrolü
tool.Equipped:Connect(function()
	toolEquipped = true

	local mouse = player:GetMouse()
	mouse.Button1Down:Connect(function()
		if toolEquipped then
			toggleAnimation()
		end
	end)
end)

tool.Unequipped:Connect(function()
	toolEquipped = false
end)
