local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")


local function showAdminScreen()
    -- Eğer zaten varsa yok et
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
    label.Text = "Admin geldi " .. player.Name .. " yarram!"
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
        gui:Destroy()
    end)
end

player.Chatted:Connect(function(msg)
    if msg:lower() == ":admin" then
        showAdminScreen()
    end
end)
