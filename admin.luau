v2

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local allowedUsers = {
    ["q692q"] = true,
    ["muhammet_bekir2004"] = true,
    ["HilalWare_Lua"] = true,
    ["Muhammet_bekir2003"] = true
}

local frozen = false

local function setAnchoredAllParts(char, anchored)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = anchored
        end
    end
end

local function addAdminTag(player)
    local function onCharacterAdded(character)
        local head = character:WaitForChild("Head", 5)
        if head then
            local billboard = Instance.new("BillboardGui")
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            billboard.Adornee = head
            billboard.AlwaysOnTop = true
            billboard.Parent = head

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = "Admin"
            textLabel.TextScaled = true
            textLabel.Font = Enum.Font.GothamBold
            textLabel.Parent = billboard

            -- HSV → RGB fonksiyonu
            local function HSVtoRGB(h, s, v)
                local c = v * s
                local x = c * (1 - math.abs((h * 6) % 2 - 1))
                local m = v - c
                local r, g, b = 0, 0, 0

                if 0 <= h and h < 1/6 then
                    r, g, b = c, x, 0
                elseif 1/6 <= h and h < 2/6 then
                    r, g, b = x, c, 0
                elseif 2/6 <= h and h < 3/6 then
                    r, g, b = 0, c, x
                elseif 3/6 <= h and h < 4/6 then
                    r, g, b = 0, x, c
                elseif 4/6 <= h and h < 5/6 then
                    r, g, b = x, 0, c
                elseif 5/6 <= h and h < 1 then
                    r, g, b = c, 0, x
                end

                return Color3.new(r + m, g + m, b + m)
            end

            -- Renk geçişi ayarları
            local hue = 0
            local speed = 0.1 -- geçiş hızı (düşük değer = yavaş)

            local connection
            connection = RunService.RenderStepped:Connect(function(dt)
                hue = (hue + dt * speed) % 1
                textLabel.TextColor3 = HSVtoRGB(hue, 1, 1)
            end)

            character.AncestryChanged:Connect(function()
                if not character:IsDescendantOf(game) then
                    connection:Disconnect()
                end
            end)
        end
    end

    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

local function setupCommands(player)
    player.Chatted:Connect(function(message)
        message = string.lower(message)

        if message == "/kill" then
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.Health = 0
            end

        elseif message == "/kick" then
            player:Kick("Yetkili tarafından oyundan atıldınız.")

        elseif message == "/freeze" then
            if player.Character then
                frozen = true
                setAnchoredAllParts(player.Character, true)
            end

        elseif message == "/unfreeze" then
            if player.Character then
                frozen = false
                setAnchoredAllParts(player.Character, false)
            end

        elseif message == "/bring" then
            local localPlayer = Players.LocalPlayer
            if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                localPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            end

        elseif message == "/goto" then
            local localPlayer = Players.LocalPlayer
            if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = localPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end)
end

Players.PlayerAdded:Connect(function(player)
    if allowedUsers[player.Name] then
        addAdminTag(player)
        setupCommands(player)
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    if allowedUsers[player.Name] then
        addAdminTag(player)
        setupCommands(player)
    end
end

-- LocalScript silme kısmı (opsiyonel)
local player = Players.LocalPlayer
local targetScriptName = "LocalScript"

local targetScript = player:FindFirstChild("PlayerScripts") and player.PlayerScripts:FindFirstChild(targetScriptName)

if targetScript then
    targetScript:Destroy()
    print(targetScriptName .. " başarıyla silindi!")
else
    warn("Belirtilen LocalScript bulunamadı.")
end
