local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local guiVisible = false
local gui = nil

-- GUI Hazırla ama gizli dursun
function createGUI()
	gui = Instance.new("ScreenGui")
	gui.Name = "FlyGui"
	gui.ResetOnSpawn = false
	gui.Enabled = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0, 300, 0, 200)
	frame.Position = UDim2.new(0.5, -150, 0.5, -100)
	frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	frame.Active = true
	frame.Draggable = true

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	title.Text = "HilalWare - Fly System"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 20

	local button = Instance.new("TextButton", frame)
	button.Size = UDim2.new(0.8, 0, 0.25, 0)
	button.Position = UDim2.new(0.1, 0, 0.5, 0)
	button.Text = "Uçmayı Başlat"
	button.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.Gotham
	button.TextSize = 18

	-- Fly ayarları
	local torso = nil
	local flying = false
	local ctrl = {f = 0, b = 0, l = 0, r = 0}
	local lastctrl = {f = 0, b = 0, l = 0, r = 0}
	local maxspeed = 50
	local speed = 0
	local bg = nil
	local bv = nil

	local function Fly()
		torso = player.Character:WaitForChild("Torso")
		bg = Instance.new("BodyGyro", torso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = torso.CFrame

		bv = Instance.new("BodyVelocity", torso)
		bv.velocity = Vector3.new(0, 0.1, 0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

		player.Character.Humanoid.PlatformStand = true

		while flying do
			wait()
			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed += 0.5 + (speed / maxspeed)
				if speed > maxspeed then speed = maxspeed end
			elseif speed ~= 0 then
				speed -= 1
				if speed < 0 then speed = 0 end
			end

			local cam = workspace.CurrentCamera
			local direction = ((cam.CFrame.LookVector * (ctrl.f + ctrl.b)) +
				((cam.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * .2, 0).p) - cam.CFrame.p)) * speed

			bv.velocity = direction
			bg.cframe = cam.CFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)
		end

		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0

		bg:Destroy()
		bv:Destroy()
		player.Character.Humanoid.PlatformStand = false
	end

	mouse.KeyDown:Connect(function(key)
		if not flying then return end
		key = key:lower()
		if key == "w" then ctrl.f = 1 end
		if key == "s" then ctrl.b = -1 end
		if key == "a" then ctrl.l = -1 end
		if key == "d" then ctrl.r = 1 end
	end)

	mouse.KeyUp:Connect(function(key)
		key = key:lower()
		if key == "w" then ctrl.f = 0 end
		if key == "s" then ctrl.b = 0 end
		if key == "a" then ctrl.l = 0 end
		if key == "d" then ctrl.r = 0 end
	end)

	button.MouseButton1Click:Connect(function()
		if not flying then
			flying = true
			button.Text = "Uçmayı Durdur"
			Fly()
		else
			flying = false
			button.Text = "Uçmayı Başlat"
		end
	end)
end

-- Sohbetten kod dinleyici
player.Chatted:Connect(function(msg)
	if msg:lower() == "code.fly" then
		if not gui then
			createGUI()
		end
		gui.Enabled = true
	end
end)
