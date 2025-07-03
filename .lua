local Workspace = game:GetService("Workspace")

local structureFolder = Workspace:WaitForChild("Structure")
local islandModel = Workspace:FindFirstChild("Island")

-- 22 Haritanın isimleri
local allowedMapNames = {
	"Happy Home", "Sky Tower", "Trailer Park", "Fort Indestructible", "Glass Office",
	"Surf Central", "Rakish Refinery", "Sunny Ranch", "Arch Park", "Raving Raceway",
	"Coastal Quickstop", "Lucky Mart", "Party Palace", "Heights School", "Furious Station",
	"Launch Land", "Prison Panic", "Safety Second", "Rainbow Ride", "Modest Headquarters",
	"Manic Mansion", "Factory Frenzy"
}

local allowedMapSet = {}
for _, name in ipairs(allowedMapNames) do
	allowedMapSet[name] = true
end

while true do
	-- Structure içindeki haritalar
	for _, mapModel in ipairs(structureFolder:GetChildren()) do
		if mapModel:IsA("Model") and allowedMapSet[mapModel.Name] then
			for _, part in ipairs(mapModel:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end

	-- Island modeli ve içindeki LowerRocks parçaları
	if islandModel and islandModel:IsA("Model") then
		local lowerRocks = islandModel:FindFirstChild("LowerRocks")
		if lowerRocks and lowerRocks:IsA("Model") then
			for _, part in ipairs(lowerRocks:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end
	end

	wait(1)
end
