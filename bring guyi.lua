--v2 new update


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local whitelist = {}

-- GUI temizle
pcall(function()
    LocalPlayer.PlayerGui:FindFirstChild("TeleportGui"):Destroy()
end)

-- GUI kur
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "TeleportGui"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 250, 0, 320)
main.Position = UDim2.new(0, 10, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, 0, 1, -50)
scroll.Position = UDim2.new(0, 0, 0, 0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6

local layout = Instance.new("UIListLayout", scroll)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 4)

-- Getir butonu
local getir = Instance.new("TextButton", main)
getir.Size = UDim2.new(1, -20, 0, 35)
getir.Position = UDim2.new(0, 10, 1, -40)
getir.Text = "GETİR"
getir.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
getir.TextColor3 = Color3.new(1, 1, 1)
getir.BorderSizePixel = 0
Instance.new("UICorner", getir).CornerRadius = UDim.new(0, 6)

-- Oyuncu listesi güncelleme
local function updateList()
    for _, v in pairs(scroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = Instance.new("TextButton", scroll)
            btn.Size = UDim2.new(1, -20, 0, 30)
            btn.Text = player.Name
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.BorderSizePixel = 0
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

            btn.MouseButton1Click:Connect(function()
                whitelist[player.Name] = not whitelist[player.Name]
                btn.BackgroundTransparency = whitelist[player.Name] and 0.3 or 0
            end)
        end
    end

    task.wait()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end

-- Dinamik güncelleme
Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)

-- Başlangıçta çalıştır
updateList()

-- GETİR işlevi
getir.MouseButton1Click:Connect(function()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local pos = myChar.HumanoidRootPart.CFrame.Position
    local right = myChar.HumanoidRootPart.CFrame.RightVector * 2
    local forward = myChar.HumanoidRootPart.CFrame.LookVector * -2
    local targetPos = pos + right + forward

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not whitelist[player.Name] then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(targetPos)
            end
        end
    end
end)
