-- new update
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local whitelist = {}

-- Önce varsa eski GUI'yi temizle
pcall(function()
    LocalPlayer.PlayerGui:FindFirstChild("TeleportGUI"):Destroy()
end)

-- GUI kur
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "TeleportGUI"
gui.ResetOnSpawn = false

-- Ana Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 250, 0, 300)
main.Position = UDim2.new(0, 50, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)

-- Sürüklenebilirlik
local dragging, dragInput, dragStart, startPos

main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Scroll alanı
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, 0, 1, -40)
scroll.Position = UDim2.new(0, 0, 0, 0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Getir butonu
local getir = Instance.new("TextButton", main)
getir.Size = UDim2.new(1, -10, 0, 30)
getir.Position = UDim2.new(0, 5, 1, -35)
getir.Text = "GETİR"
getir.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
getir.TextColor3 = Color3.fromRGB(255, 255, 255)
getir.BorderSizePixel = 0

local getirCorner = Instance.new("UICorner", getir)
getirCorner.CornerRadius = UDim.new(0, 6)

-- Oyuncu butonlarını oluştur
function updatePlayerList()
    for _, child in pairs(scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = Instance.new("TextButton", scroll)
            btn.Size = UDim2.new(1, -10, 0, 28)
            btn.Text = player.Name
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BorderSizePixel = 0

            local corner = Instance.new("UICorner", btn)
            corner.CornerRadius = UDim.new(0, 6)

            btn.MouseButton1Click:Connect(function()
                whitelist[player.Name] = not whitelist[player.Name]
                btn.BackgroundTransparency = whitelist[player.Name] and 0.3 or 0
            end)
        end
    end

    task.wait()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

updatePlayerList()

-- GETİR Butonu işlevi
getir.MouseButton1Click:Connect(function()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end

    local myHRP = myChar.HumanoidRootPart
    local targetPos = myHRP.Position + (myHRP.CFrame.RightVector * 2) + (myHRP.CFrame.LookVector * -2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not whitelist[player.Name] then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(targetPos)
            end
        end
    end
end)
