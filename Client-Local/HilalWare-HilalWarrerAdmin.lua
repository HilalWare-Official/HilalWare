local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Siyah karartma arkaplanı
local blackout = Instance.new("Frame")
blackout.Size = UDim2.new(1,0,1,0)
blackout.Position = UDim2.new(0,0,0,0)
blackout.BackgroundColor3 = Color3.new(0,0,0)
blackout.BackgroundTransparency = 0.6 -- biraz saydam olsun
blackout.ZIndex = 10
blackout.Parent = playerGui

-- Yazı
local label = Instance.new("TextLabel")
label.Size = UDim2.new(0.6,0,0.2,0)
label.Position = UDim2.new(0.2,0,0.4,0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.new(1,1,1)
label.TextStrokeTransparency = 0 -- kenar çizgisi olsun
label.TextStrokeColor3 = Color3.new(0,0,0)
label.Font = Enum.Font.GothamBold
label.TextSize = 40
label.Text = "Admin geldi " .. player.Name .. " yarram!"
label.ZIndex = 11
label.Parent = playerGui

-- Animasyon: önce görünür olsun sonra 3 saniye bekle sonra kaybolsun
spawn(function()
    wait(3)
    for i = 0,1,0.05 do
        blackout.BackgroundTransparency = 0.6 + i*0.4 -- 1 olana kadar saydamlaşsın
        label.TextTransparency = i
        label.TextStrokeTransparency = 1 - i
        wait(0.05)
    end
    blackout:Destroy()
    label:Destroy()
end)
