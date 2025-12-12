local TimeDisplay = {}

-- Fungsi untuk mendapatkan waktu saat ini dalam format 24 jam (HH:MM)
function TimeDisplay.GetCurrentTime()
	local currentTime = os.date("*t")
	return string.format("%02d:%02d", currentTime.hour, currentTime.min)
end

-- Fungsi untuk mendapatkan waktu lengkap dengan detik (HH:MM:SS)
function TimeDisplay.GetCurrentTimeWithSeconds()
	local currentTime = os.date("*t")
	return string.format("%02d:%02d:%02d", currentTime.hour, currentTime.min, currentTime.sec)
end

-- Fungsi untuk mendapatkan tanggal (DD/MM/YYYY)
function TimeDisplay.GetCurrentDate()
	local currentTime = os.date("*t")
	return string.format("%02d/%02d/%04d", currentTime.day, currentTime.month, currentTime.year)
end

-- Fungsi untuk mendapatkan hari dalam bahasa Indonesia
function TimeDisplay.GetDayName()
	local days = {"Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"}
	local currentTime = os.date("*t")
	return days[currentTime.wday]
end

-- Fungsi untuk update UI Text Label secara otomatis
function TimeDisplay.StartClockUI(textLabel, showSeconds)
	if not textLabel or not textLabel:IsA("TextLabel") then
		warn("⚠️ TimeDisplay: TextLabel tidak valid!")
		return
	end
	
	local function updateClock()
		if showSeconds then
			textLabel.Text = TimeDisplay.GetCurrentTimeWithSeconds()
		else
			textLabel.Text = TimeDisplay.GetCurrentTime()
		end
	end
	
	-- Update pertama kali
	updateClock()
	
	-- Update setiap detik
	spawn(function()
		while textLabel and textLabel.Parent do
			wait(1)
			updateClock()
		end
	end)
end

return TimeDisplay
