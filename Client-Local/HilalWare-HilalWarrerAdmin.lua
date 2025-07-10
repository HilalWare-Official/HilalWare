local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function showAdminScreen()
    if playerGui:FindFirstChild("AdminScreenGui") then
        playerGui.AdminScreenGui:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "AdminScreenGui"
    gui.Parent = playerGui
    gui.ResetOnSpawn = false

    local blackout = Instance.new("Frame")
    blackout.Size = UDim2.new(1,0,1,0)
    blackout.Position = UDim2.new(0,0,0,0)
    blackout.BackgroundColor3 = Color3.new(0,0,0)
    blackout.BackgroundTransparency = 0.6
    blackout.ZIndex = 10
    blackout.Parent = gui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6,0,0.2,0)
    label.Position = UDim2.new(0.2,0,0.4,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0,0,0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 40
    label.Text = "Admin geldi " .. player.Name
    label.ZIndex = 11
    label.Parent = gui

    spawn(function()
        wait(3)
        for i = 0,1,0.05 do
            blackout.BackgroundTransparency = 0.6 + i*0.4
            label.TextTransparency = i
            label.TextStrokeTransparency = 1 - i
            wait(0.05)
        end

        label:Destroy()
        blackout:Destroy()

        local panel = Instance.new("Frame")
        panel.Size = UDim2.new(0, 300, 0, 150)
        panel.Position = UDim2.new(0.5, -150, 0.5, -75)
        panel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        panel.BorderSizePixel = 0
        panel.Parent = gui
        panel.ZIndex = 12
        panel.Active = true
        panel.Draggable = true

        local title = Instance.new("TextLabel", panel)
        title.Size = UDim2.new(1, 0, 0, 30)
        title.BackgroundTransparency = 1
        title.Text = "Admin Panel"
        title.TextColor3 = Color3.new(1,1,1)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 22

        local flyBtn = Instance.new("TextButton", panel)
        flyBtn.Size = UDim2.new(0.6, 0, 0, 40)
        flyBtn.Position = UDim2.new(0.2, 0, 0.4, 0)
        flyBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        flyBtn.TextColor3 = Color3.new(1,1,1)
        flyBtn.Font = Enum.Font.GothamBold
        flyBtn.TextSize = 20
        flyBtn.Text = "Fly Aç"

        flyBtn.MouseButton1Click:Connect(function()
            loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Fly.txt"))()
        end)

        local closeBtn = Instance.new("TextButton", panel)
        closeBtn.Size = UDim2.new(0.3, 0, 0, 30)
        closeBtn.Position = UDim2.new(0.35, 0, 0.8, 0)
        closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        closeBtn.TextColor3 = Color3.new(1,1,1)
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 16
        closeBtn.Text = "Kapat"

        closeBtn.MouseButton1Click:Connect(function()
            gui:Destroy()
        end)
    end)
end

player.Chatted:Connect(function(msg)
    if msg:lower() == ":admin" then
        showAdminScreen()
    end
end)
