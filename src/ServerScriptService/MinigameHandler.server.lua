--[[
	Minigame Handler (Server)
	Fungsi: Handle hasil mini-game dan update player data
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerData = require(ReplicatedStorage.Modules.Core.PlayerData)
local QuestSystem = require(ReplicatedStorage.Modules.Core.QuestSystem)

-- RemoteEvent
local MinigameRemote = ReplicatedStorage:WaitForChild("MinigameRemote")

-- Handle minigame completion
MinigameRemote.OnServerEvent:Connect(function(player, action, data)
	if action == "CodingComplete" then
		print("💻 Player " .. player.Name .. " menyelesaikan Coding Minigame")
		print("📊 Skor: " .. data.CorrectAnswers .. "/" .. data.TotalQuestions)
		
		-- Update IPK
		local ipkGain = data.IPKGain or 0
		PlayerData.UpdateIPK(player, ipkGain)
		
		print("📈 IPK gain: +" .. string.format("%.2f", ipkGain))
		
		-- Check quest completion (contoh: Assignment_Programming)
		local questData = PlayerData.Get(player)
		if questData and questData.ActiveQuests then
			-- Jika player punya quest programming aktif, complete objective
			if questData.ActiveQuests["Assignment_Programming"] then
				QuestSystem.UpdateObjective(player, "Assignment_Programming", 3)
				print("✅ Assignment Programming objective completed!")
			end
		end
		
	elseif action == "StudyComplete" then
		-- Untuk mini-game study/belajar lainnya
		print("📚 Player " .. player.Name .. " menyelesaikan Study Session")
		
		local ipkGain = data.IPKGain or 0.05
		PlayerData.UpdateIPK(player, ipkGain)
		
	elseif action == "DebateComplete" then
		-- Untuk mini-game debat organisasi
		print("🗣️ Player " .. player.Name .. " menyelesaikan Debate")
		
		local ipkGain = data.IPKGain or 0.1
		local reputationGain = data.ReputationGain or 5
		
		PlayerData.UpdateIPK(player, ipkGain)
		
		local playerDataRef = PlayerData.Get(player)
		if playerDataRef then
			playerDataRef.Reputation = math.clamp(playerDataRef.Reputation + reputationGain, 0, 100)
		end
	end
end)

print("✅ Minigame Handler initialized")
