--hata tamamlandı sorunsuz
--new işlemleyici 12

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")

    local allowedUsers = {
        ["q692q"] = true,
        ["muhammet_bekir2004"] = true,
        ["HilalWare_Lua"] = true,
        ["Muhammet_bekir2003"] = true
    }

    local function applyRGBRightToLeft(textLabel)
        local hue = 0
        local text = textLabel.Text
        local letters = {}
        textLabel.Text = ""
        for i = 1, #text do
            local char = string.sub(text, i, i)
            local charLabel = Instance.new("TextLabel")
            charLabel.Size = UDim2.new(1 / #text, 0, 1, 0)
            charLabel.Position = UDim2.new((i - 1) / #text, 0, 0, 0)
            charLabel.BackgroundTransparency = 1
            charLabel.Text = char
            charLabel.Font = textLabel.Font
            charLabel.TextScaled = true
            charLabel.TextStrokeTransparency = textLabel.TextStrokeTransparency
            charLabel.Parent = textLabel
            table.insert(letters, charLabel)
        end

        RunService.RenderStepped:Connect(function()
            hue = (hue + 0.01) % 1
            for i = #letters, 1, -1 do
                local offset = (i / #letters)
                local color = Color3.fromHSV((hue + offset) % 1, 1, 1)
                letters[i].TextColor3 = color
            end
        end)
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
                textLabel.Text = "Admin (c00lkidd)"
                textLabel.TextStrokeTransparency = 0
                textLabel.Font = Enum.Font.GothamBold
                textLabel.Parent = billboard

                applyRGBRightToLeft(textLabel)
            end
        end

        player.CharacterAdded:Connect(onCharacterAdded)
        if player.Character then
            onCharacterAdded(player.Character)
        end
    end

    local function setAnchoredAllParts(char, anchored)
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = anchored
            end
        end
    end

    local frozen = false

    local function setupCommands()
        LocalPlayer.Chatted:Connect(function(message)
            message = string.lower(message)

            if message == ".kill" then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.Health = 0
                end
            elseif message == ".kick" then
                LocalPlayer:Kick("Yetkili tarafından oyundan atıldınız.")
            elseif message == ".freeze" then
                if LocalPlayer.Character then
                    frozen = true
                    setAnchoredAllParts(LocalPlayer.Character, true)
                end
            elseif message == ".unfreeze" then
                if LocalPlayer.Character then
                    frozen = false
                    setAnchoredAllParts(LocalPlayer.Character, false)
                end
            elseif message == ".bring" then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)                end
            end
        end)
    end

    Players.PlayerAdded:Connect(function(player)
        if allowedUsers[player.Name] then
            addAdminTag(player)
            -- Yeni chat sistemine sadece hoşgeldiniz mesajı
            local TextChatService = game:GetService("TextChatService")
            if TextChatService and TextChatService.TextChannels and TextChatService.TextChannels.RBXGeneral then
                TextChatService.TextChannels.RBXGeneral:SendAsync("Hoşgeldiniz " .. player.Name .. "!")
            end
            -- Eski chat sistemine de hoşgeldiniz mesajı
            local StarterGui = game:GetService("StarterGui")
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "Hoşgeldiniz " .. player.Name .. "!",
                Color = Color3.fromRGB(255, 255, 0),
                Font = Enum.Font.SourceSansBold,
                TextSize = 20
            })
        end
    end)

    for _, player in ipairs(Players:GetPlayers()) do
        if allowedUsers[player.Name] then
            addAdminTag(player)
        end
    end


    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "By HilalWare.Lua",
        Color = Color3.fromRGB(255, 255, 0),
        Font = Enum.Font.SourceSansBold,
        TextSize = 20
    })

    task.delay(20, function()
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "HilalWare.Lua New Script",
            Color = Color3.fromRGB(255, 255, 0),
            Font = Enum.Font.SourceSansBold,
            TextSize = 20
        })
    end)


-- GUI Oluştur
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "MoverGui"

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 140, 0, 40)
button.Position = UDim2.new(0, 100, 0, 100)
button.Text = "Efekti Başlat"
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.BorderSizePixel = 0
button.Active = true
button.Draggable = true

local moving = false
local originalStates = {}

-- RootPart alma
local function getRootPart()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return character:WaitForChild("HumanoidRootPart")
end

-- Hedef partları alma
local function getTargetParts()
    local parts = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "사라지는 파트" or obj.Name == "Gudock") then
            table.insert(parts, obj)
        end
    end
    return parts
end

-- Random offset
local function getLargerOffset()
    local maxOffset = 0.5
    local x = math.random(-100, 100) / 100 * maxOffset
    local y = math.random(-100, 100) / 100 * maxOffset
    local z = math.random(-100, 100) / 100 * maxOffset
    return Vector3.new(x, y, z)
end

-- İlk konumları kaydet
local function cacheOriginalStates()
    originalStates = {}
    for _, part in ipairs(getTargetParts()) do
        originalStates[part] = {CFrame = part.CFrame, Size = part.Size}
    end
end

-- Eski konumlara geri döndür
local function restoreOriginalStates()
    for part, data in pairs(originalStates) do
        if part and part.Parent then
            part.CFrame = data.CFrame
            part.Size = data.Size
            part.Anchored = false
            part.CanCollide = true
        end
    end
end

-- Efekt çalıştırma
local tickTime = 0
local connection

local function startMoving()
    connection = RunService.RenderStepped:Connect(function(delta)
        local root = getRootPart()
        if not root then return end

        local parts = getTargetParts()
        tickTime = tickTime + delta * 10

        for _, part in ipairs(parts) do
            part.Size = root.Size
            part.CanCollide = false
            part.Anchored = true

            local baseCFrame = root.CFrame
            local jumpOffset = math.sin(tickTime) * 1.3
            local offset = getLargerOffset()
            offset = Vector3.new(offset.X, offset.Y + jumpOffset, offset.Z)
            part.CFrame = baseCFrame + offset
        end
    end)
end

-- Efekt durdurma
local function stopMoving()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    restoreOriginalStates()
end

-- Buton basıldığında
button.MouseButton1Click:Connect(function()
    moving = not moving
    if moving then
        button.Text = "Efekti Durdur"
        cacheOriginalStates()
        startMoving()
    else
        button.Text = "Efekti Başlat"
        stopMoving()
    end
end)
