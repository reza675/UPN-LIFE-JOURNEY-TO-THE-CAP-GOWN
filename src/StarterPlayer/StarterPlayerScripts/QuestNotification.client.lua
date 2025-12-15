-- Quest Notification System
warn("🔔 Quest Notification System Loading...")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local QuestRemote = ReplicatedStorage:WaitForChild("QuestRemote", 10)

if not QuestRemote then
	error("❌ QuestRemote not found!")
end

-- Create Notification
local function showNotification(title, message, iconEmoji, color)
	color = color or Color3.fromRGB(100, 200, 100)
	iconEmoji = iconEmoji or "✅"
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "QuestNotification"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder = 100
	
	local frame = Instance.new("Frame")
	frame.Name = "NotificationFrame"
	frame.Size = UDim2.new(0.35, 0, 0.15, 0)
	frame.Position = UDim2.new(1.2, 0, 0.1, 0) -- Start off-screen right
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	frame.BorderSizePixel = 0
	frame.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 15)
	corner.Parent = frame
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = 3
	stroke.Parent = frame
	
	-- Icon
	local icon = Instance.new("TextLabel")
	icon.Size = UDim2.new(0.2, 0, 0.6, 0)
	icon.Position = UDim2.new(0.05, 0, 0.2, 0)
	icon.BackgroundTransparency = 1
	icon.Text = iconEmoji
	icon.TextSize = 40
	icon.Font = Enum.Font.GothamBold
	icon.Parent = frame
	
	-- Title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(0.7, 0, 0.4, 0)
	titleLabel.Position = UDim2.new(0.27, 0, 0.1, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.TextColor3 = color
	titleLabel.TextSize = 20
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextWrapped = true
	titleLabel.Parent = frame
	
	-- Message
	local messageLabel = Instance.new("TextLabel")
	messageLabel.Size = UDim2.new(0.7, 0, 0.45, 0)
	messageLabel.Position = UDim2.new(0.27, 0, 0.5, 0)
	messageLabel.BackgroundTransparency = 1
	messageLabel.Text = message
	messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	messageLabel.TextSize = 14
	messageLabel.Font = Enum.Font.Gotham
	messageLabel.TextXAlignment = Enum.TextXAlignment.Left
	messageLabel.TextWrapped = true
	messageLabel.Parent = frame
	
	screenGui.Parent = playerGui
	
	-- Slide in
	local slideIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.63, 0, 0.1, 0)
	})
	slideIn:Play()
	
	-- Wait then slide out
	task.wait(4)
	
	local slideOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
		Position = UDim2.new(1.2, 0, 0.1, 0)
	})
	
	slideOut.Completed:Connect(function()
		screenGui:Destroy()
	end)
	
	slideOut:Play()
end

-- Listen for quest events
QuestRemote.OnClientEvent:Connect(function(action, ...)
	local args = {...}
	
	if action == "QuestStarted" then
		local questId = args[1]
		showNotification(
			"📜 Quest Baru!",
			"Quest dimulai: " .. (questId or "Unknown"),
			"📜",
			Color3.fromRGB(100, 150, 255)
		)
		
	elseif action == "ObjectiveUpdated" then
		local questId = args[1]
		local objectiveIndex = args[2]
		showNotification(
			"✅ Objective Selesai!",
			"Objective " .. objectiveIndex .. " untuk quest " .. (questId or "Unknown"),
			"✅",
			Color3.fromRGB(100, 200, 100)
		)
		
	elseif action == "QuestCompleted" then
		local questId = args[1]
		local rewards = args[2]
		
		local rewardText = ""
		if rewards then
			if rewards.IPK then
				rewardText = rewardText .. "📈 IPK +" .. rewards.IPK .. " "
			end
			if rewards.Reputation then
				rewardText = rewardText .. "⭐ Rep +" .. rewards.Reputation .. " "
			end
			if rewards.Money then
				rewardText = rewardText .. "💰 +" .. rewards.Money
			end
		end
		
		showNotification(
			"🎉 Quest Selesai!",
			(questId or "Quest") .. "\n" .. rewardText,
			"🎉",
			Color3.fromRGB(255, 200, 50)
		)
	end
end)

warn("✅ Quest Notification System Ready!")
