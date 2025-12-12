-- Tunggu PlayerGui siap
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("⏰ Loading Clock UI...")

-- Buat ScreenGui untuk jam
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ClockUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame container untuk jam
local clockFrame = Instance.new("Frame")
clockFrame.Name = "ClockFrame"
clockFrame.Size = UDim2.new(0, 180, 0, 70)
clockFrame.Position = UDim2.new(0, 20, 0, 20) -- Kiri atas
clockFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
clockFrame.BackgroundTransparency = 0.5
clockFrame.BorderSizePixel = 0
clockFrame.Parent = screenGui

-- Corner untuk rounded frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = clockFrame

-- Label untuk jam
local timeLabel = Instance.new("TextLabel")
timeLabel.Name = "TimeLabel"
timeLabel.Size = UDim2.new(1, -10, 0, 35)
timeLabel.Position = UDim2.new(0, 5, 0, 5)
timeLabel.BackgroundTransparency = 1
timeLabel.Font = Enum.Font.GothamBold
timeLabel.TextSize = 28
timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timeLabel.Text = "00:00:00"
timeLabel.TextXAlignment = Enum.TextXAlignment.Center
timeLabel.Parent = clockFrame

-- Label untuk tanggal
local dateLabel = Instance.new("TextLabel")
dateLabel.Name = "DateLabel"
dateLabel.Size = UDim2.new(1, -10, 0, 20)
dateLabel.Position = UDim2.new(0, 5, 0, 45)
dateLabel.BackgroundTransparency = 1
dateLabel.Font = Enum.Font.Gotham
dateLabel.TextSize = 12
dateLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
dateLabel.Text = "Loading..."
dateLabel.TextXAlignment = Enum.TextXAlignment.Center
dateLabel.Parent = clockFrame

-- Fungsi untuk mendapatkan nama hari
local function getDayName(wday)
	local days = {"Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"}
	return days[wday] or "Unknown"
end

-- Update jam setiap detik
spawn(function()
	while true do
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

print("🕐 Clock UI loaded successfully!")
