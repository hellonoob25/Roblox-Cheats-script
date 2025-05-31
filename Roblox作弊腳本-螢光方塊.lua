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
-- Roblox GUI + 方塊控制腳本（只生成方塊，不傳送角色、不Weld到頭）

-- 防止重複載入 GUI
pcall(function()
    local cg = game:GetService("CoreGui")
    if cg:FindFirstChild("GlowBoxController") then
        cg.GlowBoxController:Destroy()
    end
end)

local player = game.Players.LocalPlayer
if not player then
    warn("無法獲取本地玩家，請確認用戶端環境執行")
    return
end

local char = player.Character or player.CharacterAdded:Wait()
local head = char:FindFirstChild("Head") or char:WaitForChild("Head")

-- 建立 ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "GlowBoxController"
gui.ResetOnSpawn = false

-- 建立主框
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0.5, -100, 0.3, 0)
frame.BackgroundTransparency = 0.2
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Active = true
frame.Parent = gui

-- 手動拖曳
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

-- + 按鈕
local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 80, 0, 40)
plusBtn.Position = UDim2.new(0, 15, 0, 20)
plusBtn.Text = "+"
plusBtn.Font = Enum.Font.SourceSansBold
plusBtn.TextSize = 40
plusBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
plusBtn.TextColor3 = Color3.new(1, 1, 1)
plusBtn.Parent = frame

-- - 按鈕
local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 80, 0, 40)
minusBtn.Position = UDim2.new(0, 105, 0, 20)
minusBtn.Text = "-"
minusBtn.Font = Enum.Font.SourceSansBold
minusBtn.TextSize = 40
minusBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
minusBtn.TextColor3 = Color3.new(1, 1, 1)
minusBtn.Parent = frame

-- 方塊列表
local glowBoxes = {}

-- 只生成方塊，不 Weld，不動玩家
local function createGlowBox()
    local box = Instance.new("Part")
    box.Size = Vector3.new(2, 2, 2)
    box.Anchored = true      -- 錨定，不會物理影響玩家
    box.CanCollide = false
    box.Material = Enum.Material.Neon
    box.Color = Color3.fromRGB(255, 255, 0)
    box.Name = "GlowBox"
    -- 光源
    local light = Instance.new("PointLight", box)
    light.Color = Color3.fromRGB(255, 255, 0)
    light.Brightness = 2
    light.Range = 8
    -- 產生在頭頂上方，不會 Weld
    box.CFrame = head.CFrame * CFrame.new(0, 4 + #glowBoxes * 2.2, 0)
    box.Parent = workspace   -- 放到 workspace
    table.insert(glowBoxes, box)
end

local function removeGlowBox()
    local box = table.remove(glowBoxes)
    if box and box.Parent then
        box:Destroy()
    end
end

plusBtn.MouseButton1Click:Connect(createGlowBox)
minusBtn.MouseButton1Click:Connect(removeGlowBox)

-- 加到 CoreGui
gui.Parent = game:GetService("CoreGui")
print("GlowBox GUI 已加載（修正版，只生成方塊不傳送）")
