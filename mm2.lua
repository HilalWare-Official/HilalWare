-- Murder Mystery 2 ESP (Real Roles)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local function getRoles()
	local roles = {}

	for _, func in pairs(getgc(true)) do
		if typeof(func) == "function" and islclosure(func) then
			local up = debug.getupvalues(func)
			if up and up.Role and type(up.Role) == "table" then
				for player, role in pairs(up.Role) do
					if typeof(player) == "Instance" and player:IsA("Player") then
						roles[player] = role
					end
				end
			end
		end
	end

	return roles
end

local auraParts = {}

local function createAura(player, color)
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local aura = Instance.new("Part")
	aura.Anchored = true
	aura.CanCollide = false
	aura.Shape = Enum.PartType.Ball
	aura.Material = Enum.Material.Neon
	aura.Size = Vector3.new(6, 6, 6)
	aura.Transparency = 0.5
	aura.Color = color
	aura.Parent = Workspace
	aura.Name = player.Name .. "_Aura"
	auraParts[player] = aura
end

local function getColorByRole(role)
	if role == "Murderer" then
		return Color3.fromRGB(255, 0, 0) -- Kırmızı
	elseif role == "Sheriff" then
		return Color3.fromRGB(0, 0, 255) -- Mavi
	elseif role == "Innocent" then
		return Color3.fromRGB(0, 255, 0) -- Yeşil
	else
		return Color3.fromRGB(255, 255, 255) -- Beyaz
	end
end

-- Güncelleme
game:GetService("RunService").RenderStepped:Connect(function()
	local roles = getRoles()
	for player, role in pairs(roles) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			if not auraParts[player] then
				createAura(player, getColorByRole(role))
			else
				auraParts[player].Position = player.Character.HumanoidRootPart.Position
				auraParts[player].Color = getColorByRole(role)
			end
		end
	end
end)

Players.PlayerRemoving:Connect(function(player)
	if auraParts[player] then
		auraParts[player]:Destroy()
		auraParts[player] = nil
	end
end)
