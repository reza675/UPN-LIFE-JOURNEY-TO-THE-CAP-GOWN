--[[
	Ending Screen Client
	Fungsi: Menampilkan ending cerita
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create Ending UI
local function createEndingUI(endingData)
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "EndingUI"
	screenGui.DisplayOrder = 200
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	-- Black overlay
	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 1
	overlay.BorderSizePixel = 0
	overlay.Parent = screenGui
	
	-- Fade in overlay
	TweenService:Create(overlay, TweenInfo.new(2), {
		BackgroundTransparency = 0.7
	}):Play()
	
	-- Main container
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0.7, 0, 0.7, 0)
	container.Position = UDim2.new(0.15, 0, 0.15, 0)
	container.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.Parent = screenGui
	
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 20)
	containerCorner.Parent = container
	
	-- Fade in container
	task.wait(1)
	TweenService:Create(container, TweenInfo.new(1.5), {
		BackgroundTransparency = 0
	}):Play()
	
	-- "THE END" title
	local theEndLabel = Instance.new("TextLabel")
	theEndLabel.Size = UDim2.new(1, 0, 0.15, 0)
	theEndLabel.Position = UDim2.new(0, 0, 0.1, 0)
	theEndLabel.BackgroundTransparency = 1
	theEndLabel.Text = "THE END"
	theEndLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	theEndLabel.TextSize = 48
	theEndLabel.Font = Enum.Font.GothamBold
	theEndLabel.TextTransparency = 1
	theEndLabel.Parent = container
	
	task.wait(2)
	TweenService:Create(theEndLabel, TweenInfo.new(1), {
		TextTransparency = 0
	}):Play()
	
	-- Ending Name
	local endingName = Instance.new("TextLabel")
	endingName.Size = UDim2.new(1, -40, 0.12, 0)
	endingName.Position = UDim2.new(0, 20, 0.28, 0)
	endingName.BackgroundTransparency = 1
	endingName.Text = endingData.Name
	endingName.TextColor3 = Color3.fromRGB(255, 220, 100)
	endingName.TextSize = 36
	endingName.Font = Enum.Font.GothamBold
	endingName.TextTransparency = 1
	endingName.Parent = container
	
	task.wait(1)
	TweenService:Create(endingName, TweenInfo.new(1), {
		TextTransparency = 0
	}):Play()
	
	-- Ending Description
	local endingDesc = Instance.new("TextLabel")
	endingDesc.Size = UDim2.new(1, -60, 0.2, 0)
	endingDesc.Position = UDim2.new(0, 30, 0.42, 0)
	endingDesc.BackgroundTransparency = 1
	endingDesc.Text = endingData.Description
	endingDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
	endingDesc.TextSize = 20
	endingDesc.Font = Enum.Font.Gotham
	endingDesc.TextWrapped = true
	endingDesc.TextTransparency = 1
	endingDesc.Parent = container
	
	task.wait(1)
	TweenService:Create(endingDesc, TweenInfo.new(1), {
		TextTransparency = 0
	}):Play()
	
	-- Stats Display
	local statsFrame = Instance.new("Frame")
	statsFrame.Size = UDim2.new(0.8, 0, 0.18, 0)
	statsFrame.Position = UDim2.new(0.1, 0, 0.65, 0)
	statsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	statsFrame.BackgroundTransparency = 1
	statsFrame.BorderSizePixel = 0
	statsFrame.Parent = container
	
	local statsCorner = Instance.new("UICorner")
	statsCorner.CornerRadius = UDim.new(0, 12)
	statsCorner.Parent = statsFrame
	
	task.wait(0.5)
	TweenService:Create(statsFrame, TweenInfo.new(1), {
		BackgroundTransparency = 0
	}):Play()
	
	-- Stats Layout
	local statsLayout = Instance.new("UIListLayout")
	statsLayout.Padding = UDim.new(0, 10)
	statsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	statsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	statsLayout.Parent = statsFrame
	
	-- Create stat labels
	local function createStatLabel(text)
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.9, 0, 0, 30)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextSize = 18
		label.Font = Enum.Font.GothamBold
		label.TextTransparency = 1
		label.Parent = statsFrame
		
		task.wait(0.3)
		TweenService:Create(label, TweenInfo.new(0.5), {
			TextTransparency = 0
		}):Play()
	end
	
	task.wait(1)
	createStatLabel("📊 IPK Akhir: " .. string.format("%.2f", endingData.PlayerStats.IPK))
	createStatLabel("🎓 Semester: " .. endingData.PlayerStats.Semester)
	createStatLabel("⭐ Reputasi: " .. endingData.PlayerStats.Reputation)
	
	-- Thank you message
	local thankYou = Instance.new("TextLabel")
	thankYou.Size = UDim2.new(1, 0, 0.08, 0)
	thankYou.Position = UDim2.new(0, 0, 0.88, 0)
	thankYou.BackgroundTransparency = 1
	thankYou.Text = "Terima kasih telah bermain!"
	thankYou.TextColor3 = Color3.fromRGB(150, 150, 150)
	thankYou.TextSize = 16
	thankYou.Font = Enum.Font.Gotham
	thankYou.TextTransparency = 1
	thankYou.Parent = container
	
	task.wait(2)
	TweenService:Create(thankYou, TweenInfo.new(1), {
		TextTransparency = 0
	}):Play()
end

-- Listen untuk ending event dari server
local EndingRemote = ReplicatedStorage:WaitForChild("EndingRemote", 30)
if EndingRemote then
	EndingRemote.OnClientEvent:Connect(function(endingData)
		print("🎬 Menampilkan ending screen...")
		createEndingUI(endingData)
	end)
end

print("✅ Ending Screen System initialized")
