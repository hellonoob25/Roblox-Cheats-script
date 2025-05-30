local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer

-- 建立主框架
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlayerTeleportGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")  -- 第三方注入器用CoreGui比較保險

-- 主面板
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 400)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = ScreenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- 標題
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.BorderSizePixel = 0
title.Text = "玩家列表（點擊傳送）-by魚生"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Parent = mainFrame

-- 滑動框架顯示玩家名單
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, -30)
scrollingFrame.Position = UDim2.new(0, 0, 0, 30)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.Parent = mainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = scrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- 建立玩家條目
local function createPlayerButton(player)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 40)
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.SourceSansBold
	button.TextScaled = true
	button.Text = player.Name
	button.AutoButtonColor = true

	-- 玩家頭像
	local icon = Instance.new("ImageLabel")
	icon.Size = UDim2.new(0, 40, 0, 40)
	icon.Position = UDim2.new(0, 5, 0, 0)
	icon.BackgroundTransparency = 1
	icon.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	icon.Parent = button

	-- 點擊傳送
	button.MouseButton1Click:Connect(function()
		local character = player.Character
		if character then
			local hrp = character:FindFirstChild("HumanoidRootPart")
			local localChar = localPlayer.Character
			local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
			if hrp and localHRP then
				localHRP.CFrame = hrp.CFrame + Vector3.new(0, 3, 0) -- 瞬移到對方頭頂3格高度
			end
		end
	end)

	return button
end

-- 刷新玩家列表
local function refreshPlayerList()
	for _, child in pairs(scrollingFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= localPlayer then
			local btn = createPlayerButton(player)
			btn.Parent = scrollingFrame
		end
	end

	-- 更新滾動區域高度
	local count = #Players:GetPlayers() - 1
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, count * 45)
end

refreshPlayerList()

-- 玩家加入離開時更新
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
