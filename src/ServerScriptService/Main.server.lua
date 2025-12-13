local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- modul Core
local CoreModules = ReplicatedStorage.Modules.Core
local PlayerData = require(CoreModules.PlayerData)
local QuestSystem = require(CoreModules.QuestSystem)
local WeatherSystem = require(CoreModules.WeatherSystem)
local MusicSystem = require(CoreModules.MusicSystem)
local AmbientSound = require(CoreModules.AmbientSound)
local StoryManager = require(CoreModules.StoryManager)

print("=" .. string.rep("=", 50))
print("🎮 UPN LIFE JOURNEY - SERVER INITIALIZING")
print("=" .. string.rep("=", 50))

-- Inisialisasi sistem cuaca dan musik saat server start
print("🌍 Menginisialisasi Weather System...")
WeatherSystem.SetWeather("PagiCerah", true)
WeatherSystem.StartDayNightCycle(2) -- 2x speed untuk testing
WeatherSystem.StartRandomWeatherEvents()

print("🎵 Menginisialisasi Music System...")
MusicSystem.PlayMusic("CampusDay", false)

print("🔊 Menginisialisasi Ambient Sound...")
AmbientSound.PlayAmbient("Campus_Outdoor")

print("✅ Semua sistem core berhasil diinisialisasi!")
print("⏳ Menunggu player...")
print("=" .. string.rep("=", 50))

Players.PlayerAdded:Connect(function(player)
	print("👤 Player joined: " .. player.Name)
	
	-- load data pemain saat join
	PlayerData.Init(player)
	
	-- Tidak auto-start quest lagi, tunggu dari Main Menu
	-- Quest akan dimulai setelah player memilih di Main Menu
end)

-- save data saat pemain keluar
Players.PlayerRemoving:Connect(function(player)
	print("👋 Player leaving: " .. player.Name)
	PlayerData.Remove(player) -- Sudah include auto-save
end)

-- Auto-check graduation condition setiap 60 detik
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

