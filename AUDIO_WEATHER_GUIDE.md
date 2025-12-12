# 🎮 UPN Life Journey - Audio & Weather System

## 📁 Struktur File Audio & Cuaca

```
src/ReplicatedStorage/Modules/Core/
├── WeatherSystem.lua    → Sistem cuaca dinamis
├── MusicSystem.lua      → Background music manager
└── AmbientSound.lua     → Sound effects & ambient
```

---

## 🌤️ Weather System

### Preset Cuaca
- **PagiCerah** - Pagi cerah (7:00)
- **SiangTerik** - Siang terik (12:00)
- **SoreSenja** - Sore romantis (17:00)
- **MalamBulan** - Malam dengan cahaya bulan (20:00)
- **MalamGelap** - Malam sangat gelap (23:00) - untuk quest horror
- **Hujan** - Hujan deras
- **Mendung** - Cuaca mendung
- **Kabut** - Kabut pagi

### Cara Pakai
```lua
local WeatherSystem = require(ReplicatedStorage.Modules.Core.WeatherSystem)

-- Set cuaca langsung
WeatherSystem.SetWeather("Hujan", false)

-- Set cuaca berdasarkan quest
WeatherSystem.SetQuestWeather("Horror_GedungTua")

-- Start day-night cycle otomatis
WeatherSystem.StartDayNightCycle(2) -- 2x speed

-- Start random weather events
WeatherSystem.StartRandomWeatherEvents()
```

---

## 🎵 Music System

### Track List
- **MainMenu** - Music menu utama
- **CampusDay** - Music kampus siang (ceria)
- **CampusEvening** - Music kampus sore (santai)
- **StudyMusic** - Music belajar (fokus)
- **RomanticTheme** - Music romantis
- **HorrorAmbient** - Music horror/tegang
- **BossEvent** - Music event penting (ujian)
- **VictoryTheme** - Music kemenangan
- **Graduation** - Music wisuda

### Cara Pakai
```lua
local MusicSystem = require(ReplicatedStorage.Modules.Core.MusicSystem)

-- Play music
MusicSystem.PlayMusic("CampusDay", true) -- true = fade in

-- Ganti music dengan transisi
MusicSystem.TransitionTo("RomanticTheme", 2)

-- Set music berdasarkan konteks
MusicSystem.SetContextMusic("Romance")
MusicSystem.SetContextMusic("Horror")
MusicSystem.SetContextMusic("Exam")

-- Stop music
MusicSystem.StopMusic(true) -- true = fade out

-- Adjust volume
MusicSystem.SetVolume(0.5)
```

---

## 🔊 Ambient Sound System

### Lokasi Ambient
- **Campus_Outdoor** - Suara outdoor kampus (burung, angin, obrolan)
- **Library** - Suara perpustakaan (tenang)
- **Classroom** - Suara kelas (AC, obrolan pelan)
- **Cafeteria** - Suara kantin (ramai)
- **Computer_Lab** - Suara lab komputer (kipas, keyboard)
- **Rain** - Suara hujan dan petir
- **Night_Creepy** - Suara malam (jangkrik, burung hantu)

### Sound Effects
- **UI Sounds** - Click, hover, open, close
- **Quest Sounds** - Complete, start, update
- **Interaction** - Door, item pickup, page turn
- **Notification** - Notification, achievement, level up
- **Campus** - Bell ring, footsteps, applause

### Cara Pakai
```lua
local AmbientSound = require(ReplicatedStorage.Modules.Core.AmbientSound)

-- Play ambient untuk lokasi
AmbientSound.PlayAmbient("Library")
AmbientSound.PlayAmbient("Campus_Outdoor")

-- Play sound effect
AmbientSound.PlayEffect("Quest_Complete", 0.7)
AmbientSound.PlayEffect("Bell_Ring", 0.5)

-- Stop semua ambient
AmbientSound.StopAllAmbient()
```

---

## 🎯 Integrasi dengan Quest System

### Contoh di Quest Handler
```lua
-- Quest romance dimulai
WeatherSystem.SetWeather("SoreSenja", false)
MusicSystem.TransitionTo("RomanticTheme", 2)

-- Quest horror dimulai
WeatherSystem.SetWeather("MalamGelap", false)
MusicSystem.TransitionTo("HorrorAmbient", 2)
AmbientSound.PlayAmbient("Night_Creepy")

-- Quest selesai
AmbientSound.PlayEffect("Quest_Complete", 0.8)
MusicSystem.PlayMusic("VictoryTheme", false)
```

---

## 📝 Catatan Penting

### 1. **Audio Asset IDs**
Semua Sound IDs di file menggunakan **placeholder**. Anda perlu:
- Upload audio files ke Roblox
- Dapatkan Asset ID dari audio yang di-upload
- Ganti placeholder IDs dengan Asset IDs yang benar

### 2. **Cara Upload Audio ke Roblox**
1. Buka Roblox Studio
2. View → Toolbox → Audio
3. Klik "Import Audio"
4. Upload file MP3/OGG (max 7MB untuk non-premium)
5. Copy Asset ID yang didapat
6. Paste ke file MusicSystem.lua / AmbientSound.lua

### 3. **Free Music Resources**
- **Pixabay** - https://pixabay.com/music/
- **Incompetech** - https://incompetech.com/music/
- **Free Music Archive** - https://freemusicarchive.org/
- **YouTube Audio Library** - https://studio.youtube.com/

### 4. **Roblox Audio Library**
Bisa pakai audio gratis dari Roblox Asset Library:
- Search "campus music", "study music", dll
- Filter: Audio Only
- Pilih yang gratis/free to use

### 5. **Volume Guidelines**
- Background Music: 0.3 - 0.5
- Ambient Sounds: 0.1 - 0.3
- Sound Effects: 0.5 - 0.8
- Important Alerts: 0.7 - 1.0

---

## 🚀 Auto-Start di Main.server.lua

Sistem sudah diintegrasikan di `Main.server.lua`:
```lua
-- Weather System (auto start)
WeatherSystem.SetWeather("PagiCerah", true)
WeatherSystem.StartDayNightCycle(2)
WeatherSystem.StartRandomWeatherEvents()

-- Music System (auto start)
MusicSystem.PlayMusic("CampusDay", false)

-- Ambient Sound (auto start)
AmbientSound.PlayAmbient("Campus_Outdoor")
```

---

## 🎨 Customization Tips

### Tambah Preset Cuaca Baru
Edit `WeatherSystem.lua`:
```lua
["NamaPreset"] = {
	ClockTime = 15,
	Brightness = 2,
	OutdoorAmbient = Color3.fromRGB(255, 255, 255),
	-- ... dst
}
```

### Tambah Music Track Baru
Edit `MusicSystem.lua`:
```lua
["NamaTrack"] = {
	SoundId = "rbxassetid://YOUR_ID",
	Volume = 0.5,
	Looped = true,
	Description = "Deskripsi musik"
}
```

### Tambah Sound Effect Baru
Edit `AmbientSound.lua`:
```lua
["Effect_Name"] = "rbxassetid://YOUR_ID"
```

---

## ✅ Testing Checklist

- [ ] Weather transitions smooth (tidak lag)
- [ ] Music fade in/out works
- [ ] Ambient sounds sesuai lokasi
- [ ] Sound effects playing correctly
- [ ] Volume levels balanced
- [ ] Day-night cycle working
- [ ] Random weather events triggering
- [ ] Quest-based weather/music changes

---

**Dibuat untuk: UPN Life Journey Game**
**Engine: Roblox Studio**
**Last Updated: December 2025**
