local QuestSystem = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerData = require(ReplicatedStorage.Modules.Core.PlayerData)

local activeQuests = {}

-- Memulai Quest Baru
function QuestSystem.StartQuest(player, questId)
	local data = PlayerData.Get(player)
	if not data then
		warn("⚠️ Player data tidak ditemukan!")
		return false
	end
	
	if not data.ActiveQuests then
		data.ActiveQuests = {}
	end
	
	if data.CompletedQuests[questId] then
		print("⚠️ Quest ini sudah selesai!")
		return false
	end
	
	if data.ActiveQuests[questId] then
		print("⚠️ Quest ini sudah aktif!")
		return false
	end

	if not activeQuests[player.UserId] then
		activeQuests[player.UserId] = {}
	end
	
	local currentTime = os.date("*t")
	local timeString = string.format("%02d:%02d:%02d", currentTime.hour, currentTime.min, currentTime.sec)
	local dateString = string.format("%02d/%02d/%04d", currentTime.day, currentTime.month, currentTime.year)
	
	local questData = {
		Status = "Active",
		Progress = 0,
		StartTime = os.time(),
		StartTimeFormatted = timeString,
		StartDate = dateString,
		Objectives = {}, -- Track individual objectives
		CurrentObjective = 1 -- Current objective index
	}
	
	activeQuests[player.UserId][questId] = questData
	data.ActiveQuests[questId] = questData
	
	print("📜 Quest Dimulai: " .. questId .. " pada " .. dateString .. " jam " .. timeString)

	return true
end

-- Update objective untuk quest
function QuestSystem.UpdateObjective(player, questId, objectiveIndex)
	local playerQuests = activeQuests[player.UserId]
	
	if not playerQuests or not playerQuests[questId] then
		warn("⚠️ Quest tidak ditemukan: " .. questId)
		return false
	end
	
	local quest = playerQuests[questId]
	if quest.Status ~= "Active" then
		return false
	end
	
	-- Mark objective sebagai complete
	quest.Objectives[objectiveIndex] = true
	quest.CurrentObjective = objectiveIndex + 1
	
	print("✅ Objective " .. objectiveIndex .. " selesai untuk quest: " .. questId)
	
	-- Fire event ke client untuk update UI
	local QuestRemote = game:GetService("ReplicatedStorage"):FindFirstChild("QuestRemote")
	if QuestRemote then
		QuestRemote:FireClient(player, "ObjectiveUpdated", questId, objectiveIndex)
	end
	
	return true
end

-- Check apakah objective sudah selesai
function QuestSystem.IsObjectiveComplete(player, questId, objectiveIndex)
	local playerQuests = activeQuests[player.UserId]
	
	if not playerQuests or not playerQuests[questId] then
		return false
	end
	
	return playerQuests[questId].Objectives[objectiveIndex] == true
end

-- Menyelesaikan Quest
function QuestSystem.CompleteQuest(player, questId)
	local data = PlayerData.Get(player)
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
		
		-- Update PlayerData
		if data then
			data.CompletedQuests[questId] = true
			if data.ActiveQuests then
				data.ActiveQuests[questId] = nil
			end
			PlayerData.Save(player) -- Auto-save setelah complete quest
		end
        
		print("🎉 Quest Selesai: " .. questId)
		print("⏱️ Waktu selesai: " .. dateString .. " jam " .. timeString)
		print("⌛ Durasi pengerjaan: " .. playerQuests[questId].Duration)
		
		playerQuests[questId] = nil
		
		return true
	end
	
	return false
end

-- Get active quests untuk player
function QuestSystem.GetActiveQuests(player)
	return activeQuests[player.UserId] or {}
end

return QuestSystem
