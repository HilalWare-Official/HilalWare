local Workspace = game:GetService("Workspace")
local structureFolder = Workspace:WaitForChild("Structure")

-- Harita isimleri listesi
local allowedMapNames = {
	"Happy Home", "Sky Tower", "Trailer Park", "Fort Indestructible", "Glass Office",
	"Surf Central", "Rakish Refinery", "Sunny Ranch", "Arch Park", "Raving Raceway",
	"Coastal Quickstop", "Lucky Mart", "Party Palace", "Heights School", "Furious Station",
	"Launch Land", "Prison Panic", "Safety Second", "Rainbow Ride", "Modest Headquarters",
	"Manic Mansion", "Factory Frenzy"
}

-- Listeyi set gibi kullanmak için dönüştür
local allowedMapSet = {}
for _, name in ipairs(allowedMapNames) do
	allowedMapSet[name] = true
end

-- Harita parçalarını her 1 saniyede bir tarayıp içinden geçilebilir yap
while true do
	for _, mapModel in ipairs(structureFolder:GetChildren()) do
		if mapModel:IsA("Model") and allowedMapSet[mapModel.Name] then
			for _, item in ipairs(mapModel:GetDescendants()) do
				if item:IsA("BasePart") then
					item.CanCollide = false
				end
			end
		end
	end
	wait(1)
end
