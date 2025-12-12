-- Server script untuk membuat Clock UI untuk semua player
local Players = game:GetService("Players")

local function createClockUI(player)
	-- Tunggu PlayerGui siap
	local playerGui = player:WaitForChild("PlayerGui")
	
	wait(1) -- Tunggu sebentar untuk memastikan player sudah load
	
	print("⏰ Creating Clock UI for " .. player.Name)
	
	-- Buat ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ClockUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	-- Frame untuk jam
	local clockFrame = Instance.new("Frame")
	clockFrame.Size = UDim2.new(0, 180, 0, 70)
	clockFrame.Position = UDim2.new(0, 20, 0, 20)
	clockFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	clockFrame.BackgroundTransparency = 0.5
	clockFrame.BorderSizePixel = 0
	clockFrame.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = clockFrame
	
	-- Label jam
	local timeLabel = Instance.new("TextLabel")
	timeLabel.Size = UDim2.new(1, -10, 0, 35)
	timeLabel.Position = UDim2.new(0, 5, 0, 5)
	timeLabel.BackgroundTransparency = 1
	timeLabel.Font = Enum.Font.GothamBold
	timeLabel.TextSize = 28
	timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	timeLabel.Text = "00:00:00"
	timeLabel.TextXAlignment = Enum.TextXAlignment.Center
	timeLabel.Parent = clockFrame
	
	-- Label tanggal
	local dateLabel = Instance.new("TextLabel")
	dateLabel.Size = UDim2.new(1, -10, 0, 20)
	dateLabel.Position = UDim2.new(0, 5, 0, 45)
	dateLabel.BackgroundTransparency = 1
	dateLabel.Font = Enum.Font.Gotham
	dateLabel.TextSize = 12
	dateLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	dateLabel.Text = "Loading..."
	dateLabel.TextXAlignment = Enum.TextXAlignment.Center
	dateLabel.Parent = clockFrame
	
	-- Update jam setiap detik
	spawn(function()
		local function getDayName(wday)
			local days = {"Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"}
			return days[wday] or "Unknown"
		end
		
		while screenGui and screenGui.Parent do
			local currentTime = os.date("*t")
			timeLabel.Text = string.format("%02d:%02d:%02d", currentTime.hour, currentTime.min, currentTime.sec)
			dateLabel.Text = string.format("%s, %02d/%02d/%04d", 
				getDayName(currentTime.wday), 
				currentTime.day, 
				currentTime.month, 
				currentTime.year)
			wait(1)
		end
	end)
	
	print("🕐 Clock UI created for " .. player.Name)
end

-- Buat UI untuk player yang sudah ada
for _, player in pairs(Players:GetPlayers()) do
	spawn(function()
		createClockUI(player)
	end)
end

-- Buat UI untuk player baru yang join
Players.PlayerAdded:Connect(function(player)
	spawn(function()
		createClockUI(player)
	end)
end)

print("✅ Clock UI System loaded!")
