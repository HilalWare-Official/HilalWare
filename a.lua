local Workspace = game:GetService("Workspace")

-- Bu dosyaya ait olmayan parçalar (muhtemelen exploitle gelenler)
local SAFE_PARENT = Workspace:WaitForChild("Structure")

-- Yeni gelen parçaları dinle
Workspace.DescendantAdded:Connect(function(descendant)
	if descendant:IsA("BasePart") then
		-- Eğer Structure içinde değilse ve anchored değilse = şüpheli
		if not descendant:IsDescendantOf(SAFE_PARENT) then
			-- exploitle geldiği düşünülen part
			descendant.CanCollide = false
			descendant.Anchored = false
			descendant.Transparency = 0.5
			descendant.Name = "EXLOIT_BLOCK"
			print("Anti-Troll: Şüpheli parça etkisizleştirildi ->", descendant:GetFullName())
		end
	end
end)
