local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- [[ 🛠️ BAGIAN AUTO-FIX: MEMAKSA REMOTE EVENT MUNCUL 🛠️ ]] --
-- Kode ini akan mengecek apakah RemoteEvent ada. Kalau tidak ada, dia buatkan otomatis.
local function ensureRemote(name, typeName)
	typeName = typeName or "RemoteEvent"
	if not ReplicatedStorage:FindFirstChild(name) then
		local remote = Instance.new(typeName)
		remote.Name = name
		remote.Parent = ReplicatedStorage
		print("✅ EMERGENCY FIX: Berhasil membuat " .. name)
	end
end

-- Kita paksa buat semua remote yang dibutuhkan script kamu
ensureRemote("MinigameRemote", "RemoteEvent")
ensureRemote("MainMenuRemote", "RemoteEvent")
ensureRemote("QuestRemote", "RemoteEvent")
ensureRemote("DialogueRemote", "RemoteEvent")
ensureRemote("CutsceneRemote", "RemoteEvent")
ensureRemote("FeedbackRemote", "RemoteEvent")
ensureRemote("EndingRemote", "RemoteEvent")
ensureRemote("CheckSaveRemote", "RemoteFunction") 
-- [[ 🏁 SELESAI AUTO-FIX 🏁 ]] --


-- === KODE ASLI MAIN.SERVER.LUA KAMU DI BAWAH INI ===
local CoreModules = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Core")
local PlayerData = require(CoreModules.PlayerData)
local QuestSystem = require(CoreModules.QuestSystem)
local WeatherSystem = require(CoreModules.WeatherSystem)
local MusicSystem = require(CoreModules.MusicSystem)
local AmbientSound = require(CoreModules.AmbientSound)
local StoryManager = require(CoreModules.StoryManager)

print("=" .. string.rep("=", 50))
print("🎮 UPN LIFE JOURNEY - SERVER INITIALIZING")
print("=" .. string.rep("=", 50))

print("🌍 Menginisialisasi Weather System...")
WeatherSystem.SetWeather("PagiCerah", true)
WeatherSystem.StartDayNightCycle(2)
WeatherSystem.StartRandomWeatherEvents()

print("🎵 Menginisialisasi Music System...")
MusicSystem.PlayMusic("CampusDay", false)

print("🔊 Menginisialisasi Ambient Sound...")
AmbientSound.PlayAmbient("Campus_Outdoor")

print("✅ Semua sistem core berhasil diinisialisasi!")

Players.PlayerAdded:Connect(function(player)
	print("👤 Player joined: " .. player.Name)
	PlayerData.Init(player)
	
	-- Auto-start first quest setelah 2 detik
	task.wait(2)
	local data = PlayerData.Get(player)
	if data then
		-- Cek apakah quest pertama belum ada
		if not data.ActiveQuests["Bab1_Intro_PKKBN"] and not data.CompletedQuests["Bab1_Intro_PKKBN"] then
			print("📜 Auto-starting first quest for " .. player.Name)
			QuestSystem.StartQuest(player, "Bab1_Intro_PKKBN")
		end
	end
end)

Players.PlayerRemoving:Connect(function(player)
	print("👋 Player leaving: " .. player.Name)
	PlayerData.Remove(player)
end)

task.spawn(function()
	while true do
		task.wait(60)
		for _, player in ipairs(Players:GetPlayers()) do
			if StoryManager.CheckGraduationCondition(player) then
				print("🎓 Player " .. player.Name .. " memenuhi syarat kelulusan!")
				StoryManager.TriggerEnding(player)
			end
		end
	end
end)

print("🚀 Server siap! All systems operational.")