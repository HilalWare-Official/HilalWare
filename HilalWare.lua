local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- 🔥 ANİMASYON ID (kollar arkaya, sen verdin)
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://132305166420818"

-- Animasyon değişkenleri
local animTrack = nil
local animPlaying = false
local toolEquipped = false

-- 🧰 TOOL oluştur
local tool = Instance.new("Tool")
tool.Name = "HilalPose"
tool.RequiresHandle = false
tool.CanBeDropped = false
tool.Parent = player.Backpack

-- 🖱️ Mouse bağlantısını düzgün kurmak için dışarıdan bağla
local function setupMouseClickToggle()
	local mouse = player:GetMouse()
	local clickConn

	clickConn = mouse.Button1Down:Connect(function()
		if not toolEquipped then return end

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
	end)

	-- Tool bırakıldığında mouse bağlantısını kes
	tool.Unequipped:Connect(function()
		toolEquipped = false
	end)
end

-- Tool takıldığında tetikle
tool.Equipped:Connect(function()
	toolEquipped = true
	setupMouseClickToggle()
end)
