local AmbientSound = {}

local SoundService = game:GetService("SoundService")

-- Daftar ambient sounds untuk berbagai lokasi
AmbientSound.Sounds = {
	-- Kampus Outdoor
	["Campus_Outdoor"] = {
		{SoundId = "rbxassetid://2865227271", Volume = 0.3, Name = "Birds"}, -- Burung
		{SoundId = "rbxassetid://2865229536", Volume = 0.2, Name = "Wind"}, -- Angin
		{SoundId = "rbxassetid://3306145203", Volume = 0.15, Name = "Students"} -- Obrolan mahasiswa
	},
	
	-- Perpustakaan
	["Library"] = {
		{SoundId = "rbxassetid://2865227271", Volume = 0.1, Name = "Quiet_Ambient"},
		{SoundId = "rbxassetid://3306145203", Volume = 0.05, Name = "Pages_Turning"},
		{SoundId = "rbxassetid://2865229536", Volume = 0.08, Name = "AC_Hum"}
	},
	
	-- Kelas
	["Classroom"] = {
		{SoundId = "rbxassetid://3306145203", Volume = 0.15, Name = "Students_Chatter"},
		{SoundId = "rbxassetid://2865229536", Volume = 0.1, Name = "AC"},
		{SoundId = "rbxassetid://2865227271", Volume = 0.05, Name = "Clock_Ticking"}
	},
	
	-- Kantin
	["Cafeteria"] = {
		{SoundId = "rbxassetid://3306145203", Volume = 0.4, Name = "Crowd_Talk"},
		{SoundId = "rbxassetid://2865229536", Volume = 0.2, Name = "Kitchen_Sounds"},
		{SoundId = "rbxassetid://2865227271", Volume = 0.15, Name = "Plates_Cutlery"}
	},
	
	-- Lab Komputer
	["Computer_Lab"] = {
		{SoundId = "rbxassetid://2865229536", Volume = 0.2, Name = "Computer_Fan"},
		{SoundId = "rbxassetid://3306145203", Volume = 0.1, Name = "Keyboard_Typing"},
		{SoundId = "rbxassetid://2865227271", Volume = 0.05, Name = "Mouse_Clicks"}
	},
	
	-- Hujan
	["Rain"] = {
		{SoundId = "rbxassetid://4934079980", Volume = 0.4, Name = "Rain_Heavy"},
		{SoundId = "rbxassetid://5063533991", Volume = 0.2, Name = "Thunder"}
	},
	
	-- Malam (Horror atmosphere)
	["Night_Creepy"] = {
		{SoundId = "rbxassetid://2865229536", Volume = 0.15, Name = "Night_Wind"},
		{SoundId = "rbxassetid://3306145203", Volume = 0.1, Name = "Crickets"},
		{SoundId = "rbxassetid://2865227271", Volume = 0.08, Name = "Owl"}
	}
}

-- Active ambient sounds
local activeSounds = {}

-- Fungsi untuk play ambient sounds di lokasi
function AmbientSound.PlayAmbient(location)
	-- Stop semua ambient yang aktif
	AmbientSound.StopAllAmbient()
	
	local soundList = AmbientSound.Sounds[location]
	if not soundList then
		warn("Ambient location tidak ditemukan: " .. tostring(location))
		return false
	end
	
	-- Play semua ambient sounds untuk lokasi ini
	for _, soundData in ipairs(soundList) do
		local sound = Instance.new("Sound")
		sound.Name = soundData.Name
		sound.SoundId = soundData.SoundId
		sound.Volume = soundData.Volume
		sound.Looped = true
		sound.Parent = SoundService
		
		sound:Play()
		table.insert(activeSounds, sound)
	end
	
	print("🔊 Ambient sound aktif: " .. location)
	return true
end

-- Fungsi untuk stop semua ambient
function AmbientSound.StopAllAmbient()
	for _, sound in ipairs(activeSounds) do
		if sound and sound.Parent then
			sound:Stop()
			sound:Destroy()
		end
	end
	
	activeSounds = {}
end

-- Fungsi untuk play sound effect sekali
function AmbientSound.PlaySoundEffect(soundId, volume)
	volume = volume or 0.5
	
	local sound = Instance.new("Sound")
	sound.SoundId = soundId
	sound.Volume = volume
	sound.Looped = false
	sound.Parent = SoundService
	
	sound:Play()
	
	-- Auto-destroy setelah selesai
	sound.Ended:Connect(function()
		sound:Destroy()
	end)
	
	return sound
end

-- Sound Effects Library (untuk event tertentu)
AmbientSound.Effects = {
	-- UI Sounds
	["UI_Click"] = "rbxassetid://421058404",
	["UI_Hover"] = "rbxassetid://421058404",
	["UI_Open"] = "rbxassetid://421058404",
	["UI_Close"] = "rbxassetid://421058404",
	
	-- Quest Sounds
	["Quest_Complete"] = "rbxassetid://5063533991",
	["Quest_Start"] = "rbxassetid://4934079980",
	["Quest_Update"] = "rbxassetid://421058404",
	
	-- Interaction Sounds
	["Door_Open"] = "rbxassetid://238271554",
	["Door_Close"] = "rbxassetid://238271554",
	["Item_Pickup"] = "rbxassetid://3318713984",
	["Page_Turn"] = "rbxassetid://421058404",
	
	-- Notification Sounds
	["Notification"] = "rbxassetid://421058404",
	["Achievement"] = "rbxassetid://5063533991",
	["LevelUp"] = "rbxassetid://5063533991",
	
	-- Campus Sounds
	["Bell_Ring"] = "rbxassetid://238271554",
	["Footsteps"] = "rbxassetid://238271554",
	["Applause"] = "rbxassetid://3318713984"
}

-- Fungsi untuk play sound effect by name
function AmbientSound.PlayEffect(effectName, volume)
	local soundId = AmbientSound.Effects[effectName]
	if soundId then
		return AmbientSound.PlaySoundEffect(soundId, volume)
	else
		warn("Sound effect tidak ditemukan: " .. tostring(effectName))
		return nil
	end
end

return AmbientSound
