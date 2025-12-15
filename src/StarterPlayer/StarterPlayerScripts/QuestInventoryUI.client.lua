--[[
	Quest Log & Inventory UI System
	Fungsi: Menampilkan quest aktif dan inventory pemain
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEvent
local QuestRemote = ReplicatedStorage:WaitForChild("QuestRemote", 10)

if not QuestRemote then
	warn("❌ QuestRemote not found in QuestInventoryUI!")
	return
end

-- State
local isQuestLogOpen = false
local isInventoryOpen = false
local activeQuestsData = {}
local inventoryData = {}

-- Create Quest Log UI
local function createQuestLogUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "QuestLogUI"
	screenGui.DisplayOrder = 5
	screenGui.ResetOnSpawn = false
	screenGui.Enabled = false
	screenGui.Parent = playerGui
	
	-- Main Frame
	local frame = Instance.new("Frame")
	frame.Name = "MainFrame"
	frame.Size = UDim2.new(0.4, 0, 0.6, 0)
	frame.Position = UDim2.new(0.05, 0, 0.2, 0)
	frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	frame.BorderSizePixel = 0
	frame.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = frame
	
	-- Title
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 0, 40)
	title.Position = UDim2.new(0, 10, 0, 10)
	title.BackgroundTransparency = 1
	title.Text = "📜 QUEST LOG"
	title.TextColor3 = Color3.fromRGB(255, 220, 100)
	title.TextSize = 24
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = frame
	
	-- Close Button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 40, 0, 40)
	closeBtn.Position = UDim2.new(1, -50, 0, 10)
	closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.TextSize = 20
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.Parent = frame
	
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 8)
	closeCorner.Parent = closeBtn
	
	-- Scroll Frame untuk quest list
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Size = UDim2.new(1, -20, 1, -70)
	scrollFrame.Position = UDim2.new(0, 10, 0, 60)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.ScrollBarThickness = 6
	scrollFrame.BorderSizePixel = 0
	scrollFrame.Parent = frame
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 10)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = scrollFrame
	
	return screenGui, closeBtn, scrollFrame
end

-- Create Inventory UI
local function createInventoryUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "InventoryUI"
	screenGui.DisplayOrder = 5
	screenGui.ResetOnSpawn = false
	screenGui.Enabled = false
	screenGui.Parent = playerGui
	
	-- Main Frame
	local frame = Instance.new("Frame")
	frame.Name = "MainFrame"
	frame.Size = UDim2.new(0.4, 0, 0.6, 0)
	frame.Position = UDim2.new(0.55, 0, 0.2, 0)
	frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	frame.BorderSizePixel = 0
	frame.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = frame
	
	-- Title
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 0, 40)
	title.Position = UDim2.new(0, 10, 0, 10)
	title.BackgroundTransparency = 1
	title.Text = "🎒 INVENTORY"
	title.TextColor3 = Color3.fromRGB(100, 220, 255)
	title.TextSize = 24
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = frame
	
	-- Close Button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 40, 0, 40)
	closeBtn.Position = UDim2.new(1, -50, 0, 10)
	closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.TextSize = 20
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.Parent = frame
	
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 8)
	closeCorner.Parent = closeBtn
	
	-- Grid Frame untuk items
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Size = UDim2.new(1, -20, 1, -70)
	scrollFrame.Position = UDim2.new(0, 10, 0, 60)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.ScrollBarThickness = 6
	scrollFrame.BorderSizePixel = 0
	scrollFrame.Parent = frame
	
	local gridLayout = Instance.new("UIGridLayout")
	gridLayout.CellSize = UDim2.new(0, 100, 0, 100)
	gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
	gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	gridLayout.Parent = scrollFrame
	
	return screenGui, closeBtn, scrollFrame
end

-- Update Quest Log content
local function updateQuestLog(scrollFrame)
	-- Clear existing
	for _, child in ipairs(scrollFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	
	if not activeQuestsData or next(activeQuestsData) == nil then
		local emptyLabel = Instance.new("TextLabel")
		emptyLabel.Size = UDim2.new(1, 0, 0, 50)
		emptyLabel.BackgroundTransparency = 1
		emptyLabel.Text = "Tidak ada quest aktif"
		emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		emptyLabel.TextSize = 16
		emptyLabel.Font = Enum.Font.Gotham
		emptyLabel.Parent = scrollFrame
		return
	end
	
	-- Populate quests
	for questId, _ in pairs(activeQuestsData) do
		local questFrame = Instance.new("Frame")
		questFrame.Size = UDim2.new(1, 0, 0, 80)
		questFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		questFrame.BorderSizePixel = 0
		questFrame.Parent = scrollFrame
		
		local questCorner = Instance.new("UICorner")
		questCorner.CornerRadius = UDim.new(0, 8)
		questCorner.Parent = questFrame
		
		-- Quest Name
		local questName = Instance.new("TextLabel")
		questName.Size = UDim2.new(1, -20, 0, 30)
		questName.Position = UDim2.new(0, 10, 0, 10)
		questName.BackgroundTransparency = 1
		questName.Text = questId
		questName.TextColor3 = Color3.fromRGB(255, 255, 255)
		questName.TextSize = 18
		questName.Font = Enum.Font.GothamBold
		questName.TextXAlignment = Enum.TextXAlignment.Left
		questName.Parent = questFrame
		
		-- Status
		local status = Instance.new("TextLabel")
		status.Size = UDim2.new(1, -20, 0, 20)
		status.Position = UDim2.new(0, 10, 0, 40)
		status.BackgroundTransparency = 1
		status.Text = "📌 Status: Aktif"
		status.TextColor3 = Color3.fromRGB(100, 255, 100)
		status.TextSize = 14
		status.Font = Enum.Font.Gotham
		status.TextXAlignment = Enum.TextXAlignment.Left
		status.Parent = questFrame
	end
end

-- Update Inventory content
local function updateInventory(scrollFrame)
	-- Clear existing
	for _, child in ipairs(scrollFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	
	if not inventoryData or #inventoryData == 0 then
		local emptyLabel = Instance.new("TextLabel")
		emptyLabel.Size = UDim2.new(1, 0, 0, 50)
		emptyLabel.BackgroundTransparency = 1
		emptyLabel.Text = "Inventory kosong"
		emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		emptyLabel.TextSize = 16
		emptyLabel.Font = Enum.Font.Gotham
		emptyLabel.Parent = scrollFrame
		return
	end
	
	-- Populate items
	for _, itemName in ipairs(inventoryData) do
		local itemFrame = Instance.new("Frame")
		itemFrame.Size = UDim2.new(0, 100, 0, 100)
		itemFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		itemFrame.BorderSizePixel = 0
		itemFrame.Parent = scrollFrame
		
		local itemCorner = Instance.new("UICorner")
		itemCorner.CornerRadius = UDim.new(0, 8)
		itemCorner.Parent = itemFrame
		
		-- Item Icon (placeholder)
		local icon = Instance.new("TextLabel")
		icon.Size = UDim2.new(1, 0, 0.6, 0)
		icon.BackgroundTransparency = 1
		icon.Text = "📦"
		icon.TextColor3 = Color3.fromRGB(255, 255, 255)
		icon.TextSize = 40
		icon.Font = Enum.Font.Gotham
		icon.Parent = itemFrame
		
		-- Item Name
		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, -10, 0.4, 0)
		nameLabel.Position = UDim2.new(0, 5, 0.6, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = itemName
		nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		nameLabel.TextSize = 12
		nameLabel.Font = Enum.Font.Gotham
		nameLabel.TextWrapped = true
		nameLabel.TextScaled = true
		nameLabel.Parent = itemFrame
	end
end

-- Toggle Quest Log
local function toggleQuestLog()
	local questLogUI = playerGui:FindFirstChild("QuestLogUI")
	if not questLogUI then
		local ui, closeBtn, scrollFrame = createQuestLogUI()
		questLogUI = ui
		
		closeBtn.MouseButton1Click:Connect(function()
			questLogUI.Enabled = false
			isQuestLogOpen = false
		end)
	end
	
	isQuestLogOpen = not isQuestLogOpen
	questLogUI.Enabled = isQuestLogOpen
	
	if isQuestLogOpen then
		-- Request data dari server setiap kali buka
		QuestRemote:FireServer("GetActiveQuests")
		
		local scrollFrame = questLogUI.MainFrame:FindFirstChildOfClass("ScrollingFrame")
		updateQuestLog(scrollFrame)
	end
end

-- Toggle Inventory
local function toggleInventory()
	local inventoryUI = playerGui:FindFirstChild("InventoryUI")
	if not inventoryUI then
		local ui, closeBtn, scrollFrame = createInventoryUI()
		inventoryUI = ui
		
		closeBtn.MouseButton1Click:Connect(function()
			inventoryUI.Enabled = false
			isInventoryOpen = false
		end)
		
		-- Request data dari server
		QuestRemote:FireServer("GetInventory")
	end
	
	isInventoryOpen = not isInventoryOpen
	inventoryUI.Enabled = isInventoryOpen
	
	if isInventoryOpen then
		local scrollFrame = inventoryUI.MainFrame:FindFirstChildOfClass("ScrollingFrame")
		updateInventory(scrollFrame)
	end
end

-- Listen untuk data dari server
QuestRemote.OnClientEvent:Connect(function(action, data)
	if action == "ActiveQuestsData" then
		activeQuestsData = data
		local questLogUI = playerGui:FindFirstChild("QuestLogUI")
		if questLogUI and questLogUI.Enabled then
			local scrollFrame = questLogUI.MainFrame:FindFirstChildOfClass("ScrollingFrame")
			updateQuestLog(scrollFrame)
		end
		
	elseif action == "InventoryData" then
		inventoryData = data
		local inventoryUI = playerGui:FindFirstChild("InventoryUI")
		if inventoryUI and inventoryUI.Enabled then
			local scrollFrame = inventoryUI.MainFrame:FindFirstChildOfClass("ScrollingFrame")
			updateInventory(scrollFrame)
		end
	end
end)

-- Keyboard shortcuts
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	-- J untuk Quest Log
	if input.KeyCode == Enum.KeyCode.J then
		toggleQuestLog()
	end
	
	-- I untuk Inventory
	if input.KeyCode == Enum.KeyCode.I then
		toggleInventory()
	end
end)

print("✅ Quest Log & Inventory UI initialized (Press J for Quest Log, I for Inventory)")
