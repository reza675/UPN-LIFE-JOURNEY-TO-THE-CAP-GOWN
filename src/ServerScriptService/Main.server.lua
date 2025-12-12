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

-- Inisialisasi sistem cuaca dan musik saat server start
print("🌍 Menginisialisasi Weather System...")
WeatherSystem.SetWeather("PagiCerah", true)
WeatherSystem.StartDayNightCycle(2) -- 2x speed untuk testing
WeatherSystem.StartRandomWeatherEvents()

print("🎵 Menginisialisasi Music System...")
MusicSystem.PlayMusic("CampusDay", false)

print("🔊 Menginisialisasi Ambient Sound...")
AmbientSound.PlayAmbient("Campus_Outdoor")


Players.PlayerAdded:Connect(function(player)
	-- load data pemain saat join
	PlayerData.Init(player)
	
	task.wait(2)
	QuestSystem.StartQuest(player, "Bab1_Intro_PKKBN")
end)

-- save data saat pemain keluar
Players.PlayerRemoving:Connect(function(player)
	PlayerData.Remove(player)
	print("Simpan data untuk: " .. player.Name)
end)