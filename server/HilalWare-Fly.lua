
--V2 Fly By hilalWare.luaa

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local gui = nil
local flying = false
local ctrl = {f=0, b=0, l=0, r=0}
local maxspeed = 50
local speed = 0
local bg = nil
local bv = nil
local torso = nil

function createGUI()
    gui = Instance.new("ScreenGui")
    gui.Name = "FlyGui"
    gui.ResetOnSpawn = false
    gui.Enabled = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 220)
    frame.Position = UDim2.new(0.5, -150, 0.5, -110)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.Active = true
    frame.Draggable = true

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    title.Text = "HilalWare - Fly System"
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20

    local inputLabel = Instance.new("TextLabel", frame)
    inputLabel.Size = UDim2.new(1, -20, 0, 30)
    inputLabel.Position = UDim2.new(0, 10, 0, 50)
    inputLabel.BackgroundTransparency = 1
    inputLabel.Text = "Toggle için tuş gir (örn: f)"
    inputLabel.TextColor3 = Color3.new(1,1,1)
    inputLabel.Font = Enum.Font.Gotham
    inputLabel.TextSize = 16

    local inputBox = Instance.new("TextBox", frame)
    inputBox.Size = UDim2.new(0.3, 0, 0, 30)
    inputBox.Position = UDim2.new(0.35, 0, 0, 50)
    inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    inputBox.TextColor3 = Color3.new(1,1,1)
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 18
    inputBox.ClearTextOnFocus = false
    inputBox.Text = "f"

    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(0.8, 0, 0.3, 0)
    button.Position = UDim2.new(0.1, 0, 0.65, 0)
    button.Text = "Uçmayı Başlat"
    button.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 18

    local function Fly()
        local character = player.Character or player.CharacterAdded:Wait()
        torso = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
        if not torso then return end

        bg = Instance.new("BodyGyro", torso)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = torso.CFrame

        bv = Instance.new("BodyVelocity", torso)
        bv.velocity = Vector3.new(0, 0.1, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end

        while flying do
            wait()
            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                speed = speed + 0.5 + (speed / maxspeed)
                if speed > maxspeed then speed = maxspeed end
            elseif speed ~= 0 then
                speed = speed - 1
                if speed < 0 then speed = 0 end
            end

            local cam = workspace.CurrentCamera
            local moveDir = ((cam.CFrame.LookVector * (ctrl.f + ctrl.b)) +
                ((cam.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b)*0.2, 0).p) - cam.CFrame.p)) * speed

            bv.velocity = moveDir
            bg.cframe = cam.CFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)
        end

        ctrl = {f=0, b=0, l=0, r=0}
        speed = 0
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
        if humanoid then
            humanoid.PlatformStand = false
        end
    end

    -- Klavye kontrolleri
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local key = input.KeyCode.Name:lower()
            if flying then
                if key == "w" then ctrl.f = 1 end
                if key == "s" then ctrl.b = -1 end
                if key == "a" then ctrl.l = -1 end
                if key == "d" then ctrl.r = 1 end
            end
            -- Toggle tuşu kontrolü
            if key == inputBox.Text:lower() then
                if not flying then
                    flying = true
                    button.Text = "Uçmayı Durdur"
                    spawn(Fly)
                else
                    flying = false
                    button.Text = "Uçmayı Başlat"
                end
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local key = input.KeyCode.Name:lower()
            if key == "w" then ctrl.f = 0 end
            if key == "s" then ctrl.b = 0 end
            if key == "a" then ctrl.l = 0 end
            if key == "d" then ctrl.r = 0 end
        end
    end)

    button.MouseButton1Click:Connect(function()
        if not flying then
            flying = true
            button.Text = "Uçmayı Durdur"
            spawn(Fly)
        else
            flying = false
            button.Text = "Uçmayı Başlat"
        end
    end)
end

player.Chatted:Connect(function(msg)
    if msg:lower() == "code.fly" then
        if not gui then
            createGUI()
        end
        gui.Enabled = true
    end
end)
