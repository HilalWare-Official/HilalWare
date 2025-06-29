--By HilalWare





local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local function addBillboardToHead(character)
    local head = character:WaitForChild("Head")
    if head:FindFirstChild("HilalWareBillboard") then
        head.HilalWareBillboard:Destroy()
    end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HilalWareBillboard"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "HilalWare.lua Üyesi"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 20
    label.TextStrokeTransparency = 0.4
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextWrapped = true
    local hue = 0
    RunService.RenderStepped:Connect(function()
        if label and label.Parent then
            hue = (hue + 1) % 360
            label.TextColor3 = Color3.fromHSV(hue / 360, 1, 1)
        end
    end)
end
local function createRGBRootPartBox(rootPart)
    if rootPart:FindFirstChild("HilalRGBESP") then
        rootPart.HilalRGBESP:Destroy()
    end
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "HilalRGBESP"
    box.Adornee = rootPart
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = rootPart.Size + Vector3.new(0.2, 0.2, 0.2)
    box.Transparency = 0.5
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Parent = rootPart
    local hue = 0
    RunService.RenderStepped:Connect(function()
        if box and box.Parent then
            hue = (hue + 1) % 360
            box.Color3 = Color3.fromHSV(hue / 360, 1, 1)
        end
    end)
end
local function lockFacingDirection(character)
    local hrp = character:WaitForChild("HumanoidRootPart")
    local targetLook = Vector3.new(1, 0, 0) -- Sağ tarafa bakıyor
    RunService.RenderStepped:Connect(function()
        if hrp and hrp.Parent then
            local pos = hrp.Position
            hrp.CFrame = CFrame.new(pos, pos + targetLook)
        end
    end)
end
local function setupCharacter(char)
    local hrp = char:WaitForChild("HumanoidRootPart")
    addBillboardToHead(char)
    createRGBRootPartBox(hrp)
    lockFacingDirection(char)
end
local char = player.Character or player.CharacterAdded:Wait()
setupCharacter(char)

player.CharacterAdded:Connect(function(char)
    wait(1)
    setupCharacter(char)
end)              
