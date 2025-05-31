-- Roblox GUI + 方塊控制腳本

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local head = char:WaitForChild("Head")

-- 建立 ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "GlowBoxController"
gui.Parent = game:GetService("CoreGui")

-- 建立主框
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0.5, -100, 0.3, 0)
frame.BackgroundTransparency = 0.2
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Active = true
frame.Draggable = true

-- + 按鈕
local plusBtn = Instance.new("TextButton", frame)
plusBtn.Size = UDim2.new(0, 80, 0, 40)
plusBtn.Position = UDim2.new(0, 15, 0, 20)
plusBtn.Text = "+"
plusBtn.Font = Enum.Font.SourceSansBold
plusBtn.TextSize = 40
plusBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
plusBtn.TextColor3 = Color3.new(1, 1, 1)

-- - 按鈕
local minusBtn = Instance.new("TextButton", frame)
minusBtn.Size = UDim2.new(0, 80, 0, 40)
minusBtn.Position = UDim2.new(0, 105, 0, 20)
minusBtn.Text = "-"
minusBtn.Font = Enum.Font.SourceSansBold
minusBtn.TextSize = 40
minusBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
minusBtn.TextColor3 = Color3.new(1, 1, 1)

-- 方塊列表
local glowBoxes = {}

local function createGlowBox()
    local box = Instance.new("Part")
    box.Size = Vector3.new(2, 2, 2)
    box.Anchored = false
    box.CanCollide = false
    box.Material = Enum.Material.Neon
    box.Color = Color3.fromRGB(255, 255, 0)
    box.Name = "GlowBox"
    -- 製造光源
    local light = Instance.new("PointLight", box)
    light.Color = Color3.fromRGB(255, 255, 0)
    light.Brightness = 2
    light.Range = 8
    -- 然後 weld 到頭上
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = box
    weld.Part1 = head
    weld.Parent = box
    box.Parent = head
    box.CFrame = head.CFrame * CFrame.new(0, 2 + #glowBoxes * 2.2, 0)
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

-- 防止重複 GUI
if game:GetService("CoreGui"):FindFirstChild("GlowBoxController") then
    game:GetService("CoreGui").GlowBoxController:Destroy()
end
gui.Parent = game:GetService("CoreGui")
