local MusicSystem = {}

local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

-- Daftar musik berdasarkan situasi/lokasi
MusicSystem.Tracks = {
	-- Background Music Main
	["MainMenu"] = {
		SoundId = "rbxassetid://1838673350", 
		Volume = 0.5,
		Looped = true,
		Description = "Music menu utama yang santai"
	},
	
	["CampusDay"] = {
		SoundId = "rbxassetid://1841647093", -- Placeholder
		Volume = 0.4,
		Looped = true,
		Description = "Music kampus siang hari - ceria & energik"
	},
	
	["CampusEvening"] = {
		SoundId = "rbxassetid://1842819398", -- Placeholder
		Volume = 0.4,
		Looped = true,
		Description = "Music kampus sore hari - santai & tenang"
	},
	
	["StudyMusic"] = {
		SoundId = "rbxassetid://1843819103", -- Placeholder
		Volume = 0.3,
		Looped = true,
		Description = "Music untuk belajar - fokus & konsentrasi"
	},
	
	["RomanticTheme"] = {
		SoundId = "rbxassetid://1845714416", -- Placeholder
		Volume = 0.4,
		Looped = true,
		Description = "Music romantis untuk scene romance"
	},
	
	["HorrorAmbient"] = {
		SoundId = "rbxassetid://1847499027", -- Placeholder
		Volume = 0.5,
		Looped = true,
		Description = "Music menegangkan untuk quest horror"
	},
	
	["BossEvent"] = {
		SoundId = "rbxassetid://1848196339", -- Placeholder
		Volume = 0.6,
		Looped = true,
		Description = "Music epic untuk event penting (ujian besar, dll)"
	},
	
	["VictoryTheme"] = {
		SoundId = "rbxassetid://1845714416", -- Placeholder
		Volume = 0.5,
		Looped = false,
		Description = "Music kemenangan saat selesai quest"
	},
	
	["Graduation"] = {
		SoundId = "rbxassetid://1848196339", -- Placeholder
		Volume = 0.6,
		Looped = false,
		Description = "Music wisuda - emotional & triumphant"
	}
}

-- Current playing track
local currentTrack = nil
local currentSound = nil

-- Fungsi untuk play music
function MusicSystem.PlayMusic(trackName, fadeIn)
	local track = MusicSystem.Tracks[trackName]
	if not track then
		warn("Track tidak ditemukan: " .. tostring(trackName))
		return false
	end
	
	-- Stop current music jika ada
	if currentSound then
		if fadeIn then
			MusicSystem.FadeOut(currentSound, 1)
		else
			currentSound:Stop()
			currentSound:Destroy()
		end
	end
	
	-- Create new sound
	local sound = Instance.new("Sound")
	sound.Name = trackName
	sound.SoundId = track.SoundId
	sound.Volume = fadeIn and 0 or track.Volume
	sound.Looped = track.Looped
	sound.Parent = SoundService
	
	sound:Play()
	
	-- Fade in jika diminta
	if fadeIn then
		MusicSystem.FadeIn(sound, track.Volume, 2)
	end
	
	currentTrack = trackName
	currentSound = sound
	
	print("🎵 Now Playing: " .. trackName .. " - " .. track.Description)
	return true
end

-- Fungsi untuk stop music
function MusicSystem.StopMusic(fadeOut)
	if not currentSound then return end
	
	if fadeOut then
		MusicSystem.FadeOut(currentSound, 1)
	else
		currentSound:Stop()
		currentSound:Destroy()
		currentSound = nil
		currentTrack = nil
	end
	
	print("🎵 Music stopped")
end

-- Fade In effect
function MusicSystem.FadeIn(sound, targetVolume, duration)
	local tweenInfo = TweenInfo.new(
		duration,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.In
	)
	
	local tween = TweenService:Create(sound, tweenInfo, {
		Volume = targetVolume
	})
	
	tween:Play()
end

-- Fade Out effect
function MusicSystem.FadeOut(sound, duration)
	local tweenInfo = TweenInfo.new(
		duration,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out
	)
	
	local tween = TweenService:Create(sound, tweenInfo, {
		Volume = 0
	})
	
	tween:Play()
	tween.Completed:Connect(function()
		sound:Stop()
		sound:Destroy()
	end)
end

-- Fungsi untuk ganti music dengan transition
function MusicSystem.TransitionTo(trackName, transitionTime)
	transitionTime = transitionTime or 2
	
	if currentSound then
		MusicSystem.FadeOut(currentSound, transitionTime / 2)
		task.wait(transitionTime / 2)
	end
	
	MusicSystem.PlayMusic(trackName, true)
end

-- Fungsi untuk set music berdasarkan situasi
function MusicSystem.SetContextMusic(context)
	local musicMap = {
		["Menu"] = "MainMenu",
		["Campus_Day"] = "CampusDay",
		["Campus_Evening"] = "CampusEvening",
		["Library"] = "StudyMusic",
		["Classroom"] = "StudyMusic",
		["Romance"] = "RomanticTheme",
		["Horror"] = "HorrorAmbient",
		["Exam"] = "BossEvent",
		["Victory"] = "VictoryTheme",
		["Graduation"] = "Graduation"
	}
	
	local trackName = musicMap[context]
	if trackName then
		MusicSystem.TransitionTo(trackName, 2)
	end
end

-- Fungsi untuk adjust volume
function MusicSystem.SetVolume(volume)
	if currentSound then
		currentSound.Volume = volume
	end
end

-- Fungsi untuk get current track info
function MusicSystem.GetCurrentTrack()
	return currentTrack
end

-- Fungsi untuk musik berdasarkan waktu
function MusicSystem.SetTimeBasedMusic()
	local Lighting = game:GetService("Lighting")
	local hour = Lighting.ClockTime
	
	if hour >= 6 and hour < 17 then
		MusicSystem.SetContextMusic("Campus_Day")
	else
		MusicSystem.SetContextMusic("Campus_Evening")
	end
end

return MusicSystem
