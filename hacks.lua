-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Variables
local walkSpeedEnabled = false
local flyEnabled = false
local espEnabled = false

local walkSpeed = 16
local flySpeed = 50

-- UI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "HackGUI"

local function createToggle(name, yPosition, callback)
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 300, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, yPosition)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18

    local toggle = Instance.new("TextButton", frame)
    toggle.Size = UDim2.new(0.3, 0, 1, 0)
    toggle.Position = UDim2.new(0.7, 0, 0, 0)
    toggle.Text = "OFF"
    toggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Font = Enum.Font.SourceSansBold
    toggle.TextSize = 18

    toggle.MouseButton1Click:Connect(function()
        local on = toggle.Text == "OFF"
        toggle.Text = on and "ON" or "OFF"
        toggle.BackgroundColor3 = on and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
        callback(on)
    end)
end

-- SPEED HACK
createToggle("Speed Hack", 10, function(enabled)
    walkSpeedEnabled = enabled
    if enabled then
        humanoid.WalkSpeed = walkSpeed
    else
        humanoid.WalkSpeed = 16
    end
end)

-- FLY HACK
local flyBodyGyro, flyBodyVelocity

createToggle("Fly Hack", 60, function(enabled)
    flyEnabled = enabled
    if enabled then
        character = player.Character or player.CharacterAdded:Wait()
        humanoid = character:WaitForChild("Humanoid")
        local rootPart = character:WaitForChild("HumanoidRootPart")
        flyBodyGyro = Instance.new("BodyGyro", rootPart)
        flyBodyGyro.P = 9e4
        flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro.CFrame = rootPart.CFrame

        flyBodyVelocity = Instance.new("BodyVelocity", rootPart)
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    else
        if flyBodyGyro then flyBodyGyro:Destroy() end
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
    end
end)

RunService.RenderStepped:Connect(function()
    if flyEnabled then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        local camera = workspace.CurrentCamera
        local direction = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + camera.CFrame.UpVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction = direction - camera.CFrame.UpVector end
        flyBodyVelocity.Velocity = direction.Unit * flySpeed
        flyBodyGyro.CFrame = camera.CFrame
    end
end)

-- PLAYER ESP
local function highlightCharacter(char)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineTransparency = 0
    highlight.Adornee = char
    highlight.Parent = char
end

local function removeESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local h = p.Character:FindFirstChild("ESPHighlight")
            if h then h:Destroy() end
        end
    end
end

createToggle("ESP", 110, function(enabled)
    espEnabled = enabled
    if enabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                highlightCharacter(p.Character)
            end
        end
        Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function(char)
                task.wait(1)
                highlightCharacter(char)
            end)
        end)
    else
        removeESP()
    end
end)
