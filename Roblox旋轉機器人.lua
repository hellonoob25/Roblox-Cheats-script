-- 🔰 作者簽名畫面（會自動關閉）
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AuthorIntroGUI"

-- 背景半透明黑色全螢幕
local bg = Instance.new("Frame", gui)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BackgroundTransparency = 0
bg.ZIndex = 10

-- 中間文字
local text = Instance.new("TextLabel", bg)
text.Size = UDim2.new(1, 0, 1, 0)
text.Text = "腳本由 魚生 製作"
text.TextColor3 = Color3.new(1, 1, 1)
text.TextStrokeTransparency = 0
text.BackgroundTransparency = 1
text.Font = Enum.Font.GothamBlack
text.TextScaled = true
text.ZIndex = 11

-- 淡出動畫
task.delay(3, function() -- 顯示 3 秒
	for i = 0, 1, 0.05 do
		bg.BackgroundTransparency = i
		text.TextTransparency = i
		text.TextStrokeTransparency = i
		task.wait(0.05)
	end
	gui:Destroy()
end)local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local rotationSpeed = math.rad(70) -- 預設每秒旋轉70度
local rotating = false
local connection

-- 建立 ScreenGui 和主框架 Frame（用來拖動）
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RotateToggleGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 190, 0, 170)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- 按鈕
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.Text = "開始旋轉"
toggleButton.Parent = mainFrame

-- 標籤
local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 150, 0, 30)
label.Position = UDim2.new(0, 20, 0, 80)
label.Text = "旋轉速度 (度/秒)"
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundTransparency = 1
label.Parent = mainFrame

-- 輸入框
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0, 150, 0, 30)
inputBox.Position = UDim2.new(0, 20, 0, 115)
inputBox.Text = "70"
inputBox.ClearTextOnFocus = false
inputBox.TextColor3 = Color3.new(0, 0, 0)
inputBox.BackgroundColor3 = Color3.new(1, 1, 1)
inputBox.Parent = mainFrame

-- 拖動功能
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService = game:GetService("UserInputService")

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- 旋轉邏輯
local function startRotating()
    if connection then connection:Disconnect() end
    connection = RunService.Heartbeat:Connect(function(deltaTime)
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, rotationSpeed * deltaTime, 0)
    end)
    rotating = true
    toggleButton.Text = "停止旋轉"
end

local function stopRotating()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    rotating = false
    toggleButton.Text = "開始旋轉"
end

toggleButton.MouseButton1Click:Connect(function()
    if rotating then
        stopRotating()
    else
        local speedInput = tonumber(inputBox.Text)
        if speedInput and speedInput >= 0 then
            rotationSpeed = math.rad(speedInput)
        else
            rotationSpeed = math.rad(70)
            inputBox.Text = "70"
        end
        startRotating()
    end
end)
