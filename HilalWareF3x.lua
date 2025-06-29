-- Telekinesis V5 (Geliştirilmiş RGB ESP + Ok Tuşlarıyla Taşıma)
-- Orijinal koddan geliştirilmiştir

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local mouse = LocalPlayer:GetMouse()

local tool = Instance.new("Tool")
tool.Name = "Telekinesis V5"
tool.RequiresHandle = true
tool.Parent = LocalPlayer.Backpack

local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(1, 1, 1)
handle.Transparency = 1
handle.Anchored = false
handle.CanCollide = false
handle.BrickColor = BrickColor.new("Institutional white")
handle.Parent = tool

local selectionBox = Instance.new("SelectionBox")
selectionBox.LineThickness = 0.3
selectionBox.Color3 = Color3.new(1, 1, 1)
selectionBox.Adornee = nil
selectionBox.Parent = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- RGB ESP Highlight
local highlight = Instance.new("Highlight")
highlight.FillTransparency = 0.6
highlight.OutlineTransparency = 0
highlight.OutlineColor = Color3.new(1, 1, 1)
highlight.FillColor = Color3.new(1, 0, 0)
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.Parent = game.CoreGui -- not visible in Explorer, avoid deletion

-- RGB Loop
coroutine.wrap(function()
	while true do
		if highlight.Adornee then
			local t = tick()
			local r = math.abs(math.sin(t))
			local g = math.abs(math.sin(t + 2))
			local b = math.abs(math.sin(t + 4))
			highlight.FillColor = Color3.new(r, g, b)
			highlight.OutlineColor = Color3.new(1 - r, 1 - g, 1 - b)
		end
		wait(0.1)
	end
end)()

local object = nil
local dist = 20
local moveStep = 1

-- Mouse control
local function onButton1Down()
	if not mouse.Target or mouse.Target.Anchored then return end
	object = mouse.Target
	highlight.Adornee = object
	selectionBox.Adornee = object
	object:SetNetworkOwner(LocalPlayer)
	dist = (object.Position - handle.Position).Magnitude

	local BP = Instance.new("BodyPosition")
	BP.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	BP.P = 3000
	BP.D = 100
	BP.Position = object.Position
	BP.Parent = object

	RunService.RenderStepped:Connect(function()
		if object and mouse and BP.Parent then
			local cf = CFrame.new(handle.Position, mouse.Hit.p)
			BP.Position = handle.Position + cf.LookVector * dist
		end
	end)

	mouse.Button1Up:Connect(function()
		if BP then BP:Destroy() end
		object = nil
		highlight.Adornee = nil
		selectionBox.Adornee = nil
	end)
end

-- Keyboard move
UserInputService.InputBegan:Connect(function(input, gpe)
	if not object or gpe then return end

	local offset = Vector3.zero

	if input.KeyCode == Enum.KeyCode.Up then
		offset = Vector3.new(0, moveStep, 0)
	elseif input.KeyCode == Enum.KeyCode.Down then
		offset = Vector3.new(0, -moveStep, 0)
	elseif input.KeyCode == Enum.KeyCode.Left then
		offset = Vector3.new(-moveStep, 0, 0)
	elseif input.KeyCode == Enum.KeyCode.Right then
		offset = Vector3.new(moveStep, 0, 0)
	elseif input.KeyCode == Enum.KeyCode.W then
		offset = Vector3.new(0, 0, -moveStep)
	elseif input.KeyCode == Enum.KeyCode.S then
		offset = Vector3.new(0, 0, moveStep)
	end

	if offset ~= Vector3.zero then
		object.Position += offset
	end
end)

-- Equip handler
tool.Equipped:Connect(function()
	mouse.Icon = "rbxasset://textures/GunCursor.png"
	mouse.Button1Down:Connect(onButton1Down)
end)

tool.Unequipped:Connect(function()
	highlight.Adornee = nil
	selectionBox.Adornee = nil
	object = nil
end)
