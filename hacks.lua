local function createToggleWithSpeed(name, yPosition, defaultSpeed, callback, speedCallback)
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 300, 0, 60)
    frame.Position = UDim2.new(0, 10, 0, yPosition)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5, 0, 0.5, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18

    local toggle = Instance.new("TextButton", frame)
    toggle.Size = UDim2.new(0.3, 0, 0.5, 0)
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

    local speedBox = Instance.new("TextBox", frame)
    speedBox.PlaceholderText = tostring(defaultSpeed)
    speedBox.Size = UDim2.new(1, -10, 0.5, -5)
    speedBox.Position = UDim2.new(0, 5, 0.5, 5)
    speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    speedBox.TextColor3 = Color3.new(1, 1, 1)
    speedBox.Text = ""
    speedBox.ClearTextOnFocus = false
    speedBox.Font = Enum.Font.SourceSans
    speedBox.TextSize = 16

    speedBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(speedBox.Text)
            if val then
                speedCallback(val)
            end
        end
    end)
end

