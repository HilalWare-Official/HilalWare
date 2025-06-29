local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- 🔧 Takip edilecek araç isimleri
local toolNames = {
    "Couch",
    "ShoppingCart",
    "Stretcher",
    "Wagon",
    "LawnMower"
}

local teleported = false
local returned = false
local activeTool = nil

-- 🔍 Tool'u karakterde veya çantada bul
local function getTool(name)
    return player.Character:FindFirstChild(name) or player.Backpack:FindFirstChild(name)
end

-- 🎯 Koltuk kontrolü: Seat + SeatWeld
local function checkAllTools()
    if teleported then return end

    for _, toolName in ipairs(toolNames) do
        local tool = getTool(toolName)
        if tool then
            for _, part in ipairs(tool:GetDescendants()) do
                if part:IsA("Seat") and part:FindFirstChild("SeatWeld") then
                    teleported = true
                    activeTool = tool
                    warn("🚨 SeatWeld bulundu! Tool:", toolName)
                    hrp.CFrame = CFrame.new(0, 100000000, 0)
                    return
                end
            end
        end
    end
end

-- 🧹 Tool silinirse geri dön
local function monitorToolRemoval()
    RunService.Heartbeat:Connect(function()
        if activeTool and not activeTool:IsDescendantOf(game) and teleported and not returned then
            returned = true
            task.wait(0.5)
            warn("↩️ Tool silindi: "..activeTool.Name)
            hrp.CFrame = CFrame.new(0, -100000000, 0)
        end
    end)
end

-- 🔁 Ana döngü
RunService.Heartbeat:Connect(function()
    if not teleported then
        checkAllTools()
    end
end)

monitorToolRemoval()

-- 🖥️ GUI oluştur (PlayerGui içine, kalıcı)
local gui = Instance.new("ScreenGui")
gui.Name = "TrapSystemUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 420, 0, 30)
label.Position = UDim2.new(0, 20, 0, 60)
label.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
label.TextColor3 = Color3.fromRGB(255, 255, 180)
label.Text = "⚠️ Koltuk tuzakları aktif! Araçlar: Couch, Cart, Stretcher, Wagon, LawnMower"
label.Font = Enum.Font.SourceSansBold
label.TextSize = 16
label.TextStrokeTransparency = 0.8
label.Parent = gui
