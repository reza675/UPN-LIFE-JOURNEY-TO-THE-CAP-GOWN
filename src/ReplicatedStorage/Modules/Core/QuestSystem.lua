local QuestSystem = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerData = require(ReplicatedStorage.Modules.Core.PlayerData)

local activeQuests = {}

-- Memulai Quest Baru
function QuestSystem.StartQuest(player, questId)
	local data = PlayerData.Get(player)
	if data.CompletedQuests[questId] then
		print("⚠️ Quest ini sudah selesai!")
		return false
	end

	if not activeQuests[player.UserId] then
		activeQuests[player.UserId] = {}
	end
	
	local currentTime = os.date("*t")
	local timeString = string.format("%02d:%02d:%02d", currentTime.hour, currentTime.min, currentTime.sec)
	local dateString = string.format("%02d/%02d/%04d", currentTime.day, currentTime.month, currentTime.year)
	
	activeQuests[player.UserId][questId] = {
		Status = "Active",
		Progress = 0,
		StartTime = os.time(),
		StartTimeFormatted = timeString,
		StartDate = dateString
	}
	
	print("📜 Quest Dimulai: " .. questId .. " pada " .. dateString .. " jam " .. timeString)

	return true
end

-- Menyelesaikan Quest
function QuestSystem.CompleteQuest(player, questId)
	local playerQuests = activeQuests[player.UserId]
	
	if playerQuests and playerQuests[questId] and playerQuests[questId].Status == "Active" then
		local currentTime = os.date("*t")
		local timeString = string.format("%02d:%02d:%02d", currentTime.hour, currentTime.min, currentTime.sec)
		local dateString = string.format("%02d/%02d/%04d", currentTime.day, currentTime.month, currentTime.year)
		local timeTaken = os.time() - playerQuests[questId].StartTime
		local minutes = math.floor(timeTaken / 60)
		local seconds = timeTaken % 60
		
		playerQuests[questId].Status = "Completed"
		playerQuests[questId].CompletionTime = os.time()
		playerQuests[questId].CompletionTimeFormatted = timeString
		playerQuests[questId].CompletionDate = dateString
		playerQuests[questId].Duration = string.format("%d menit %d detik", minutes, seconds)
		
		local data = PlayerData.Get(player)
		data.CompletedQuests[questId] = true
        
		print("🎉 Quest Selesai: " .. questId)
		print("⏱️ Waktu selesai: " .. dateString .. " jam " .. timeString)
		print("⌛ Durasi pengerjaan: " .. playerQuests[questId].Duration)
		
		playerQuests[questId] = nil
		
		return true
	end
	
	return false
end

return QuestSystem
