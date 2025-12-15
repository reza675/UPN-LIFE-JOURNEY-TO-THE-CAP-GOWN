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

	-- Send notification to client
	local QuestRemote = game:GetService("ReplicatedStorage"):FindFirstChild("QuestRemote")
	if QuestRemote then
		QuestRemote:FireClient(player, "QuestStarted", questId)
	end

	return true
end

-- Update objective untuk quest
function QuestSystem.UpdateObjective(player, questId, objectiveIndex)
	-- Initialize activeQuests for player if not exists
	if not activeQuests[player.UserId] then
		activeQuests[player.UserId] = {}
	end
	
	local playerQuests = activeQuests[player.UserId]
	
	-- If quest not in activeQuests, try to load from PlayerData
	if not playerQuests[questId] then
		local data = PlayerData.Get(player)
		if data and data.ActiveQuests and data.ActiveQuests[questId] then
			-- Restore quest to activeQuests from PlayerData
			playerQuests[questId] = data.ActiveQuests[questId]
			print("🔄 Restored quest from PlayerData: " .. questId)
		else
			warn("⚠️ Quest tidak ditemukan: " .. questId)
			return false
		end
	end
	
	local quest = playerQuests[questId]
	if quest.Status ~= "Active" then
		return false
	end
	
	-- Mark objective sebagai complete
	quest.Objectives[objectiveIndex] = true
	quest.CurrentObjective = objectiveIndex + 1
	
	print("✅ Objective " .. objectiveIndex .. " selesai untuk quest: " .. questId)
	
	-- Update PlayerData as well
	local data = PlayerData.Get(player)
	if data and data.ActiveQuests then
		data.ActiveQuests[questId] = quest
	end
	
	-- Fire event ke client untuk update UI
	local QuestRemote = game:GetService("ReplicatedStorage"):FindFirstChild("QuestRemote")
	if QuestRemote then
		QuestRemote:FireClient(player, "ObjectiveUpdated", questId, objectiveIndex)
	end
	
	-- Check if all objectives completed
	local MainQuest = require(ReplicatedStorage.Modules.Quests.MainQuest)
	local questInfo = MainQuest.Quests[questId]
	
	if questInfo and questInfo.Objectives then
		local allComplete = true
		for i = 1, #questInfo.Objectives do
			if not quest.Objectives[i] then
				allComplete = false
				break
			end
		end
		
		if allComplete then
			print("🎉 All objectives complete! Auto-completing quest: " .. questId)
			QuestSystem.CompleteQuest(player, questId)
		end
	end
	
	return true
end

-- Update objective berdasarkan Type dan Target (untuk auto-trigger)
function QuestSystem.UpdateObjectiveByTarget(player, objectiveType, targetName)
	local MainQuest = require(ReplicatedStorage.Modules.Quests.MainQuest)
	local playerQuests = activeQuests[player.UserId] or {}
	
	-- Loop semua active quest
	for questId, questData in pairs(playerQuests) do
		if questData.Status == "Active" then
			local questInfo = MainQuest.Quests[questId]
			if questInfo and questInfo.Objectives then
				-- Loop objectives
				for i, objective in ipairs(questInfo.Objectives) do
					-- Cek apakah objective match dengan type dan target
					if objective.Type == objectiveType and objective.Target == targetName then
						-- Cek apakah objective sebelumnya sudah selesai (urutan)
						local canUpdate = true
						if i > 1 then
							-- Harus complete objective sebelumnya dulu
							if not questData.Objectives[i - 1] then
								canUpdate = false
								print("⚠️ Cannot update objective " .. i .. " - previous objectives not complete!")
							end
						end
						
						-- Update objective ini jika urutan sudah benar
						if canUpdate and not questData.Objectives[i] then
							QuestSystem.UpdateObjective(player, questId, i)
							print("🎯 Auto-updated objective: " .. objectiveType .. " - " .. targetName)
						end
					end
				end
			end
		end
	end
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
		
		-- Apply rewards
		local MainQuest = require(ReplicatedStorage.Modules.Quests.MainQuest)
		local questData = MainQuest.Quests[questId]
		
		if questData and questData.Rewards and data then
			if questData.Rewards.IPK then
				PlayerData.UpdateIPK(player, questData.Rewards.IPK)
				print("📈 IPK naik: +" .. questData.Rewards.IPK .. " → Total: " .. data.IPK)
			end
			if questData.Rewards.Reputation then
				data.Reputation = (data.Reputation or 0) + questData.Rewards.Reputation
				print("⭐ Reputation naik: +" .. questData.Rewards.Reputation)
			end
			if questData.Rewards.Money then
				data.Money = (data.Money or 0) + questData.Rewards.Money
				print("💰 Money: +" .. questData.Rewards.Money)
			end
		end
		
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
		
		-- Send completion notification to client with rewards
		local QuestRemote = game:GetService("ReplicatedStorage"):FindFirstChild("QuestRemote")
		if QuestRemote then
			QuestRemote:FireClient(player, "QuestCompleted", questId, questData and questData.Rewards or nil)
		end
		
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
