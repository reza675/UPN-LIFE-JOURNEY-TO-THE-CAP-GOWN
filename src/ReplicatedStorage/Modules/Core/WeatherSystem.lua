local WeatherSystem = {}

local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- Preset cuaca yang berbeda
WeatherSystem.Presets = {
	["PagiCerah"] = {
		ClockTime = 7,
		Brightness = 2,
		OutdoorAmbient = Color3.fromRGB(128, 128, 128),
		Ambient = Color3.fromRGB(140, 140, 140),
		FogEnd = 1000,
		FogStart = 0,
		ColorShift_Top = Color3.fromRGB(255, 200, 150),
		Description = "Pagi yang cerah, sempurna untuk memulai hari"
	},
	
	["SiangTerik"] = {
		ClockTime = 12,
		Brightness = 3,
		OutdoorAmbient = Color3.fromRGB(150, 150, 150),
		Ambient = Color3.fromRGB(160, 160, 160),
		FogEnd = 1500,
		FogStart = 0,
		ColorShift_Top = Color3.fromRGB(255, 255, 255),
		Description = "Siang yang terik, jangan lupa minum air"
	},
	
	["SoreSenja"] = {
		ClockTime = 17,
		Brightness = 1.5,
		OutdoorAmbient = Color3.fromRGB(200, 120, 80),
		Ambient = Color3.fromRGB(180, 100, 60),
		FogEnd = 800,
		FogStart = 0,
		ColorShift_Top = Color3.fromRGB(255, 140, 80),
		Description = "Sore yang indah dengan langit kemerahan"
	},
	
	["MalamBulan"] = {
		ClockTime = 20,
		Brightness = 0.5,
		OutdoorAmbient = Color3.fromRGB(50, 60, 80),
		Ambient = Color3.fromRGB(40, 50, 70),
		FogEnd = 400,
		FogStart = 0,
		ColorShift_Top = Color3.fromRGB(100, 100, 150),
		Description = "Malam dengan cahaya bulan yang menenangkan"
	},
	
	["MalamGelap"] = {
		ClockTime = 23,
		Brightness = 0.2,
		OutdoorAmbient = Color3.fromRGB(20, 20, 30),
		Ambient = Color3.fromRGB(10, 10, 20),
		FogEnd = 200,
		FogStart = 0,
		ColorShift_Top = Color3.fromRGB(50, 50, 80),
		Description = "Malam yang sangat gelap, hati-hati di jalan"
	},
	
	["Hujan"] = {
		ClockTime = 14,
		Brightness = 1,
		OutdoorAmbient = Color3.fromRGB(80, 80, 100),
		Ambient = Color3.fromRGB(70, 70, 90),
		FogEnd = 300,
		FogStart = 0,
		ColorShift_Top = Color3.fromRGB(150, 150, 180),
		Description = "Hujan deras, bawa payung!"
	},
	
	["Mendung"] = {
		ClockTime = 13,
		Brightness = 1.2,
		OutdoorAmbient = Color3.fromRGB(100, 100, 110),
		Ambient = Color3.fromRGB(90, 90, 100),
		FogEnd = 600,
		FogStart = 0,
		ColorShift_Top = Color3.fromRGB(180, 180, 200),
		Description = "Cuaca mendung, sepertinya akan hujan"
	},
	
	["Kabut"] = {
		ClockTime = 6,
		Brightness = 1,
		OutdoorAmbient = Color3.fromRGB(120, 120, 130),
		Ambient = Color3.fromRGB(100, 100, 110),
		FogEnd = 150,
		FogStart = 0,
		ColorShift_Top = Color3.fromRGB(200, 200, 220),
		Description = "Kabut pagi yang tebal"
	}
}

-- Waktu transisi cuaca (dalam detik)
local TRANSITION_TIME = 5

-- Current weather state
local currentWeather = "PagiCerah"

-- Fungsi untuk mengubah cuaca dengan transisi smooth
function WeatherSystem.SetWeather(weatherName, instant)
	local preset = WeatherSystem.Presets[weatherName]
	if not preset then
		warn("Weather preset tidak ditemukan: " .. tostring(weatherName))
		return false
	end
	
	currentWeather = weatherName
	
	if instant then
		-- Set langsung tanpa transisi
		Lighting.ClockTime = preset.ClockTime
		Lighting.Brightness = preset.Brightness
		Lighting.OutdoorAmbient = preset.OutdoorAmbient
		Lighting.Ambient = preset.Ambient
		Lighting.FogEnd = preset.FogEnd
		Lighting.FogStart = preset.FogStart
		Lighting.ColorShift_Top = preset.ColorShift_Top
	else
		-- Transisi smooth dengan Tween
		local tweenInfo = TweenInfo.new(
			TRANSITION_TIME,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut
		)
		
		local tween = TweenService:Create(Lighting, tweenInfo, {
			ClockTime = preset.ClockTime,
			Brightness = preset.Brightness,
			OutdoorAmbient = preset.OutdoorAmbient,
			Ambient = preset.Ambient,
			FogEnd = preset.FogEnd,
			FogStart = preset.FogStart,
			ColorShift_Top = preset.ColorShift_Top
		})
		
		tween:Play()
	end
	
	print("🌤️ Cuaca berubah menjadi: " .. weatherName .. " - " .. preset.Description)
	return true
end

-- Fungsi untuk mendapatkan cuaca saat ini
function WeatherSystem.GetCurrentWeather()
	return currentWeather
end

-- Fungsi untuk cycle cuaca otomatis (simulasi waktu real)
function WeatherSystem.StartDayNightCycle(cycleSpeed)
	cycleSpeed = cycleSpeed or 1 -- 1 = normal speed, 2 = 2x faster
	
	spawn(function()
		while true do
			local hour = Lighting.ClockTime
			
			-- Pagi (6-11)
			if hour >= 6 and hour < 11 then
				WeatherSystem.SetWeather("PagiCerah", false)
			-- Siang (11-16)
			elseif hour >= 11 and hour < 16 then
				WeatherSystem.SetWeather("SiangTerik", false)
			-- Sore (16-19)
			elseif hour >= 16 and hour < 19 then
				WeatherSystem.SetWeather("SoreSenja", false)
			-- Malam (19-23)
			elseif hour >= 19 and hour < 23 then
				WeatherSystem.SetWeather("MalamBulan", false)
			-- Tengah malam (23-6)
			else
				WeatherSystem.SetWeather("MalamGelap", false)
			end
			
			-- Update setiap 60 detik (game time)
			task.wait(60 / cycleSpeed)
		end
	end)
	
	print("🌍 Day-Night cycle dimulai dengan speed: " .. cycleSpeed .. "x")
end

-- Fungsi untuk weather events (acak)
function WeatherSystem.StartRandomWeatherEvents()
	spawn(function()
		while true do
			-- Wait random time (5-15 menit)
			task.wait(math.random(300, 900))
			
			-- 30% chance untuk cuaca spesial
			local chance = math.random(1, 100)
			
			if chance <= 15 then
				-- Hujan
				WeatherSystem.SetWeather("Hujan", false)
				task.wait(180) -- Hujan selama 3 menit
				WeatherSystem.SetWeather("Mendung", false)
			elseif chance <= 30 then
				-- Mendung
				WeatherSystem.SetWeather("Mendung", false)
			elseif chance <= 40 and Lighting.ClockTime >= 5 and Lighting.ClockTime < 8 then
				-- Kabut (hanya pagi)
				WeatherSystem.SetWeather("Kabut", false)
			end
		end
	end)
	
	print("🌦️ Random weather events aktif")
end

-- Fungsi untuk set weather berdasarkan quest/event
function WeatherSystem.SetQuestWeather(questId)
	if string.find(questId, "Horror") then
		-- Quest horror = cuaca gelap/malam
		WeatherSystem.SetWeather("MalamGelap", false)
	elseif string.find(questId, "Romance") then
		-- Quest romance = cuaca sore/romantis
		WeatherSystem.SetWeather("SoreSenja", false)
	else
		-- Default berdasarkan waktu
		local hour = Lighting.ClockTime
		if hour >= 6 and hour < 12 then
			WeatherSystem.SetWeather("PagiCerah", false)
		elseif hour >= 12 and hour < 17 then
			WeatherSystem.SetWeather("SiangTerik", false)
		else
			WeatherSystem.SetWeather("SoreSenja", false)
		end
	end
end

return WeatherSystem
