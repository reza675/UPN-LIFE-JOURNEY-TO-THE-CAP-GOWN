# 📋 QUICK REFERENCE CARD

## 🚀 Instant Commands & Common Tasks

---

## 🎯 MOST USED COMMANDS

### Testing in Studio

#### Server Console
```lua
-- Get first player
local p = game.Players:GetPlayers()[1]

-- Load modules
local PD = require(game.ReplicatedStorage.Modules.Core.PlayerData)
local QS = require(game.ReplicatedStorage.Modules.Core.QuestSystem)
local CM = require(game.ReplicatedStorage.Modules.Core.CutsceneManager)
local SM = require(game.ReplicatedStorage.Modules.Core.StoryManager)

-- Quick Tests
PD.UpdateIPK(p, 1.0)                    -- Add IPK
PD.UpdateSemester(p, 8)                 -- Change semester
QS.StartQuest(p, "Bab1_Intro_PKKBN")    -- Start quest
QS.CompleteQuest(p, "Bab1_Intro_PKKBN") -- Complete quest
CM.Play(p, "Intro")                     -- Play cutscene
SM.TriggerEnding(p)                     -- Trigger ending
```
#### Client Console
```lua
-- Test minigame
_G.StartCodingMinigame("Beginner")

-- Check player GUI
game.Players.LocalPlayer.PlayerGui:GetChildren()
```

---

## 🎮 KEYBOARD SHORTCUTS

| Key | Action |
|-----|--------|
| `E` | Interact with NPC |
| `J` | Toggle Quest Log |
| `I` | Toggle Inventory |
| `SPACE` | Continue dialogue |
| `WASD` | Movement |

---

## 📁 FILE LOCATIONS

### Core Modules
```
ReplicatedStorage/Modules/Core/
├── PlayerData.lua          → Data management
├── QuestSystem.lua         → Quest logic
├── StoryManager.lua        → Story branching
├── CutsceneManager.lua     → Cutscenes
├── WeatherSystem.lua       → Weather/time
├── MusicSystem.lua         → Music
├── AmbientSound.lua        → Ambient audio
└── TimeDisplay.lua         → Clock
```

### Server Scripts
```
ServerScriptService/
├── Main.server.lua                → Init
├── NPCManager.server.lua          → NPCs
├── RegionTrigger.server.lua       → Zones ⭐
├── QuestRemoteHandler.server.lua  → Quests
├── MinigameHandler.server.lua     → Minigames ⭐
├── MainMenuHandler.server.lua     → Menu
└── ClockUI.server.lua             → Clock
```

### Client Scripts
```
StarterPlayerScripts/
├── DialogueSystem.client.lua      → Dialog UI
├── QuestInventoryUI.client.lua    → Quest/Inv UI
├── MainMenu.client.lua            → Main menu
├── CodingMinigame.client.lua      → Minigame ⭐
├── CutscenePlayer.client.lua      → Cutscenes ⭐
├── EndingScreen.client.lua        → Ending
├── ClockUI.client.lua             → Clock UI
└── init.client.lua                → Init
```

---

## 🔧 QUICK FIXES

### NPC Not Spawning ProximityPrompt?
```lua
-- Check in NPCManager.server.lua:
-- 1. Model name matches module name?
-- 2. Model has HumanoidRootPart?
-- 3. NPCs folder exists in Workspace?

-- Debug:
print(workspace:FindFirstChild("NPCs"))
for _, npc in ipairs(workspace.NPCs:GetChildren()) do
    print(npc.Name, npc:FindFirstChild("HumanoidRootPart"))
end
```

### Zone Not Triggering?
```lua
-- Check in Workspace:
-- 1. QuestZones folder exists?
-- 2. Part has correct name?
-- 3. Part CanCollide = false?
-- 4. Part Anchored = true?

-- Debug in RegionTrigger.server.lua:
local zones = workspace.QuestZones:GetChildren()
for _, zone in ipairs(zones) do
    print("Zone:", zone.Name, "Mapped:", ZONE_QUEST_MAP[zone.Name] ~= nil)
end
```

### Data Not Saving?
```lua
-- Check:
-- 1. Studio API Services enabled?
-- 2. DataStore name correct?
-- 3. Player leaving properly?

-- Force save:
local PD = require(game.ReplicatedStorage.Modules.Core.PlayerData)
PD.Save(game.Players:GetPlayers()[1])
```

---

## 📝 ADDING NEW CONTENT

### New NPC (5 steps)
```lua
-- 1. Create module: Modules/NPC/NewNPC.lua
return {
    NPCId = "NewNPC",
    Name = "Dr. Smith",
    Role = "Professor",
    Dialogues = { {Text = "Hello!"} }
}

-- 2. Add to NPCManager.server.lua
local NPCList = {
    NewNPC = require(NPCModules.NewNPC)
}

-- 3. Create model in Workspace/NPCs/NewNPC
-- 4. Ensure HumanoidRootPart exists
-- 5. Test!
```

### New Quest Zone (3 steps)
```lua
-- 1. Create Part in Workspace/QuestZones
--    Name: "NewLocation"
--    CanCollide: false
--    Anchored: true

-- 2. Add to RegionTrigger.server.lua ZONE_QUEST_MAP:
NewLocation = {
    { QuestId = "SomeQuest", ObjectiveIndex = 1 }
}

-- 3. Test by walking into zone
```

### New Cutscene (2 steps)
```lua
-- 1. Add to CutsceneManager.lua CUTSCENES:
MyScene = {
    Name = "My Scene",
    Duration = 10,
    Sequence = {
        { Type = "FadeIn", Duration = 2 },
        { Type = "ShowText", Duration = 5, Text = "..." },
        { Type = "FadeOut", Duration = 2 }
    }
}

-- 2. Trigger:
CM.Play(player, "MyScene")
```

---

## 🎯 COMMON PATTERNS

### Start Quest from NPC Dialog
```lua
Dialogues = {
    {
        Text = "Want to start a quest?",
        Choices = {
            {
                Text = "Yes!",
                QuestId = "MyQuest"  -- This starts quest
            }
        }
    }
}
```

### Trigger Minigame from Zone
```lua
-- In RegionTrigger.server.lua
if zoneName == "LabKomputer" then
    local MinigameRemote = ReplicatedStorage:FindFirstChild("MinigameRemote")
    if MinigameRemote then
        MinigameRemote:FireClient(player, "StartCoding", {
            Difficulty = "Beginner"
        })
    end
end
```

### Track Story Choice
```lua
-- In NPC dialogue action:
Action = function(player)
    local SM = require(game.ReplicatedStorage.Modules.Core.StoryManager)
    SM.TrackChoice(player, "MyChoice", "OptionA")
end
```

---

## 📊 DATA STRUCTURE REFERENCE

### PlayerData.Get() Returns:
```lua
{
    Semester = 1,
    IPK = 0.00,
    Reputation = 50,
    Money = 50000,
    CurrentStory = "Intro",
    Inventory = {"Item1", "Item2"},
    CompletedQuests = {
        ["QuestId"] = true
    },
    ActiveQuests = {
        ["QuestId"] = {
            Status = "Active",
            Progress = 0,
            Objectives = {[1] = true},
            CurrentObjective = 2,
            StartTime = 1234567890
        }
    },
    StoryChoices = {
        ["ChoiceId"] = "Value"
    }
}
```

---

## 🔍 DEBUGGING TIPS

### Enable Verbose Logging
```lua
-- All systems already have print statements
-- Check Output window in Studio

-- Common prefixes:
-- ✅ = Success
-- ⚠️ = Warning
-- ❌ = Error
-- 📜 = Quest
-- 🗨️ = Dialogue
-- 🎬 = Cutscene
-- 💻 = Minigame
```

### Check RemoteEvents
```lua
-- List all RemoteEvents:
for _, remote in ipairs(game.ReplicatedStorage:GetChildren()) do
    if remote:IsA("RemoteEvent") then
        print("RemoteEvent:", remote.Name)
    end
end
```

### Monitor Player Data Changes
```lua
-- In server console:
local PD = require(game.ReplicatedStorage.Modules.Core.PlayerData)
local p = game.Players:GetPlayers()[1]

while wait(1) do
    local data = PD.Get(p)
    print("IPK:", data.IPK, "Semester:", data.Semester, "Active Quests:", #data.ActiveQuests)
end
```

---

## ⚡ PERFORMANCE TIPS

### Reduce Zone Trigger Spam
Already implemented with cooldown system (3 seconds)

### Optimize DataStore Calls
Auto-save happens:
- Every 5 minutes (auto-save loop)
- On important updates (IPK, quest complete)
- On player leave

### Efficient Quest Checking
Use `ActiveQuests` table lookup instead of iterating

---

## 📚 DOCUMENTATION QUICK LINKS

| Doc | Purpose |
|-----|---------|
| [README.md](README.md) | Project overview |
| [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) | Full API reference |
| [WORKSPACE_SETUP_GUIDE.md](WORKSPACE_SETUP_GUIDE.md) | Workspace setup |
| [GAP_RESOLUTION.md](GAP_RESOLUTION.md) | What was fixed |
| [SYSTEM_ARCHITECTURE.md](SYSTEM_ARCHITECTURE.md) | System diagrams |
| [PROJECT_COMPLETION_SUMMARY.md](PROJECT_COMPLETION_SUMMARY.md) | Final status |

---

## 🚨 EMERGENCY FIXES

### Game Won't Start?
```lua
-- Check Main.server.lua is running
-- Check for script errors in Output
-- Verify all modules exist in ReplicatedStorage
```

### NPCs Frozen?
```lua
-- Check Humanoid exists
-- Check HumanoidRootPart is not anchored
-- Verify ProximityPrompt is not disabled
```

### UI Not Showing?
```lua
-- Check ScreenGui.Enabled = true
-- Check DisplayOrder (higher = on top)
-- Check ZIndex for overlapping elements
```

### Data Lost?
```lua
-- DataStore might be in different slot
-- Check PlayerDataStore name
-- Enable Studio Access to API Services
```

---

## 💡 PRO TIPS

1. **Always test in Published game** - Some features work differently in Studio
2. **Use wait() wisely** - Too many can lag the game
3. **Check console constantly** - All systems log their actions
4. **Save often** - Data auto-saves, but manual save doesn't hurt
5. **Name things consistently** - Makes debugging easier
6. **Document custom changes** - Help future you

---

## 🎓 LEARNING RESOURCES

### Roblox DevHub
- [DataStoreService](https://create.roblox.com/docs/reference/engine/classes/DataStoreService)
- [RemoteEvents](https://create.roblox.com/docs/scripting/events/remote)
- [ProximityPrompt](https://create.roblox.com/docs/reference/engine/classes/ProximityPrompt)

### Our Documentation
- Full workflows in IMPLEMENTATION_GUIDE.md
- Architecture diagrams in SYSTEM_ARCHITECTURE.md
- Setup guides in WORKSPACE_SETUP_GUIDE.md

---

**Keep this card handy while developing!** 📋✨

**Version:** 2.5  
**Last Updated:** December 2025
