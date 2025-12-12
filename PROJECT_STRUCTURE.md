# 📂 Struktur Folder Lengkap - UPN Life Journey

```
UPN-LIFE-JOURNEY-TO-THE-CAP-GOWN/
│
├── .git/                           # Git repository
├── .gitignore                      # Git ignore file
├── default.project.json            # Rojo project configuration
├── AUDIO_WEATHER_GUIDE.md          # Panduan sistem audio & cuaca
├── PROJECT_STRUCTURE.md            # File ini
│
└── src/                            # Source code
    │
    ├── ServerScriptService/        # Server-side scripts
    │   ├── Main.server.lua         # Main server script
    │   └── Test.server.lua         # Testing script
    │
    ├── StarterPlayer/              # Player-related scripts
    │   └── StarterPlayerScripts/
    │       └── init.client.lua     # Client initialization
    │
    └── ReplicatedStorage/          # Shared resources
        └── Modules/                # Lua modules
            │
            ├── Core/               # Core systems
            │   ├── PlayerData.lua      # Player data management
            │   ├── QuestSystem.lua     # Quest management system
            │   ├── WeatherSystem.lua   # Weather & lighting system
            │   ├── MusicSystem.lua     # Background music manager
            │   └── AmbientSound.lua    # Sound effects & ambient
            │
            ├── Quests/             # Quest definitions
            │   ├── MainQuest.lua           # Main story quests
            │   ├── SideQuest_Romance.lua   # Romance side quests
            │   └── SideQuest_Horror.lua    # Horror side quests
            │
            └── NPC/                # NPC characters
                ├── Kirana.lua          # Mahasiswi ceria
                ├── Bayu.lua            # Mahasiswa rajin
                ├── Citra.lua           # Senior inspiratif
                ├── PakEdo.lua          # Dosen pembimbing
                ├── BuRatna.lua         # Staff akademik
                └── PakBambang.lua      # Satpam kampus
```

---

## 📝 Deskripsi Setiap Folder/File

### 🔧 Core Systems (`src/ReplicatedStorage/Modules/Core/`)
File-file sistem utama yang mengatur mekanik game:

- **PlayerData.lua** 
  - Manage data pemain (IPK, Semester, Reputation, Money, Inventory)
  - Handle leaderstats display
  - Session data management

- **QuestSystem.lua**
  - Quest tracking & progression
  - Quest completion handler
  - Active quest management

- **WeatherSystem.lua** ✨
  - Dynamic weather presets (8 variasi)
  - Day-night cycle automation
  - Random weather events
  - Quest-based weather control

- **MusicSystem.lua** 🎵
  - Background music management
  - Smooth transitions (fade in/out)
  - Context-based music selection
  - Volume control

- **AmbientSound.lua** 🔊
  - Location-based ambient sounds
  - Sound effects library
  - UI sound effects
  - Environmental audio

---

### 📜 Quest System (`src/ReplicatedStorage/Modules/Quests/`)
Definisi quest dan objective:

- **MainQuest.lua**
  - Main story progression (Bab 1-4)
  - Semester-based quests
  - Academic milestones
  - IPK & reputation rewards

- **SideQuest_Romance.lua**
  - Romance dengan NPC (Kirana, Bayu, Citra)
  - Relationship level system
  - Optional romantic storylines

- **SideQuest_Horror.lua**
  - Mystery & horror quests
  - Night-time exclusive quests
  - Exploration & puzzle solving
  - Special rewards & achievements

---

### 👥 NPC System (`src/ReplicatedStorage/Modules/NPC/`)
Karakter NPC dengan dialog & interaksi:

- **Kirana.lua** 💕
  - Role: Mahasiswi
  - Personality: Ceria, ramah, helpful
  - Relationship levels: FirstMeet → Casual → Friendly → Close
  - Quests: Romance, study together

- **Bayu.lua** 📚
  - Role: Mahasiswa rajin
  - Personality: Serius, perfeksionis
  - Study tips & academic advice
  - Quests: Group project, study marathon

- **Citra.lua** 🌟
  - Role: Senior/Kakak tingkat
  - Personality: Inspiratif, supportif
  - Mentoring & career advice
  - Quests: Organization, campus events

- **PakEdo.lua** 👨‍🏫
  - Role: Dosen pembimbing
  - Personality: Tegas tapi peduli
  - Academic consultation
  - Quest giver untuk tugas kuliah

- **BuRatna.lua** 📋
  - Role: Staff akademik
  - Personality: Ramah, sabar, detail
  - Administrative services (KRS, transkrip, dll)
  - Information provider

- **PakBambang.lua** 👮
  - Role: Satpam kampus
  - Personality: Tegas, humoris
  - Security & access control
  - Night shift interactions
  - Quest blocker/helper untuk horror quests

---

### 🎮 Server Scripts (`src/ServerScriptService/`)

- **Main.server.lua**
  - Server initialization
  - Player join/leave handlers
  - Systems activation (Weather, Music, Ambient)
  - Quest distribution

- **Test.server.lua**
  - Testing & debugging
  - Development helpers

---

### 👤 Client Scripts (`src/StarterPlayer/StarterPlayerScripts/`)

- **init.client.lua**
  - Client-side initialization
  - UI management (akan ditambahkan)
  - Local player interactions

---

## 🔄 Game Flow

```
1. Server Start
   ├─→ Initialize Weather System (PagiCerah)
   ├─→ Start Day-Night Cycle (2x speed)
   ├─→ Start Random Weather Events
   ├─→ Play Background Music (CampusDay)
   └─→ Play Ambient Sound (Campus_Outdoor)

2. Player Join
   ├─→ Initialize Player Data (IPK, Semester, dll)
   ├─→ Create Leaderstats (Semester, IPK display)
   ├─→ Start Initial Quest (Bab1_Intro_PKKBN)
   └─→ Load player inventory

3. Quest Progression
   ├─→ Update quest objectives
   ├─→ Track progress
   ├─→ Give rewards (IPK, reputation, items)
   └─→ Unlock next quests

4. NPC Interaction
   ├─→ Display dialog based on relationship
   ├─→ Give quests
   ├─→ Provide information/tips
   └─→ Respond to gifts/items

5. Environment Changes
   ├─→ Weather transitions (time-based)
   ├─→ Music changes (context-based)
   └─→ Ambient sounds (location-based)
```

---

## 🎯 Next Steps / TODO

### 🔨 Yang Perlu Ditambahkan:

1. **Client UI System**
   - Quest log UI
   - Dialog system UI
   - Inventory UI
   - Stats display (IPK, Semester, dll)

2. **Location System**
   - Zone detection untuk ambient sound
   - Location-based music triggers
   - NPC spawn locations

3. **Inventory System**
   - Item management
   - Item usage
   - Item giving/trading

4. **Save System**
   - DataStore integration
   - Auto-save functionality
   - Load player progress

5. **More NPCs**
   - Teman kelas lainnya
   - Dosen-dosen lain
   - Petugas kantin
   - Petugas perpustakaan

6. **More Quests**
   - Organisasi quests
   - Event kampus quests
   - Exam preparation quests
   - Final project/Skripsi quests

7. **Mini Games**
   - Study mini-game
   - Exam simulation
   - Presentation simulator

8. **Achievement System**
   - Badges untuk milestone
   - Leaderboard
   - Rewards untuk achievement

---

## 📱 Audio Asset Requirements

### Musik yang Dibutuhkan:
- [ ] Main Menu Theme (chill, welcoming)
- [ ] Campus Day Music (upbeat, energetic)
- [ ] Campus Evening Music (calm, relaxing)
- [ ] Study Music (focus, lo-fi)
- [ ] Romantic Theme (sweet, emotional)
- [ ] Horror Ambient (tense, creepy)
- [ ] Boss Event Music (epic, intense)
- [ ] Victory Theme (triumphant)
- [ ] Graduation Theme (emotional, grand)

### Sound Effects yang Dibutuhkan:
- [ ] UI clicks & hovers
- [ ] Quest complete sound
- [ ] Notification sounds
- [ ] Door open/close
- [ ] Footsteps
- [ ] Bell ring
- [ ] Ambient bird sounds
- [ ] Rain & thunder
- [ ] Crowd chatter
- [ ] Keyboard typing

---

## 🎨 Asset Requirements (3D Models/Maps)

### Bangunan & Lokasi:
- [ ] Gedung fakultas
- [ ] Perpustakaan
- [ ] Kantin
- [ ] Lab komputer
- [ ] Ruang kelas
- [ ] Taman kampus
- [ ] Parkiran
- [ ] Gedung lama (untuk horror quest)

### Props:
- [ ] Meja & kursi
- [ ] Komputer
- [ ] Buku
- [ ] Papan tulis
- [ ] Loker
- [ ] Pohon & tanaman

---

**Project Status:** 🟡 In Development
**Version:** 0.1.0 Alpha
**Last Updated:** December 2025
