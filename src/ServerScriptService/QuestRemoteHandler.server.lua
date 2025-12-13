--[[
	Quest Remote Handler
	Fungsi: Handle komunikasi quest antara Client dan Server
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QuestSystem = require(ReplicatedStorage.Modules.Core.QuestSystem)
local PlayerData = require(ReplicatedStorage.Modules.Core.PlayerData)

-- Buat RemoteEvent
local QuestRemote = Instance.new("RemoteEvent")
QuestRemote.Name = "QuestRemote"
QuestRemote.Parent = ReplicatedStorage

-- Handle request dari Client
QuestRemote.OnServerEvent:Connect(function(player, action, ...)
	local args = {...}
	
	if action == "StartQuest" then
		local questId = args[1]
		local success = QuestSystem.StartQuest(player, questId)
		
		-- Kirim feedback ke client
		QuestRemote:FireClient(player, "QuestStarted", questId, success)
		
	elseif action == "CompleteQuest" then
		local questId = args[1]
		QuestSystem.CompleteQuest(player, questId)
		QuestRemote:FireClient(player, "QuestCompleted", questId)
		
	elseif action == "GetActiveQuests" then
		local data = PlayerData.Get(player)
		if data then
			-- Kirim list quest yang sedang aktif
			local activeQuests = {}
			for questId, _ in pairs(data.ActiveQuests or {}) do
				activeQuests[questId] = true
			end
			QuestRemote:FireClient(player, "ActiveQuestsData", activeQuests)
		end
		
	elseif action == "GetInventory" then
		local data = PlayerData.Get(player)
		if data then
			QuestRemote:FireClient(player, "InventoryData", data.Inventory)
		end
	end
end)

print("✅ Quest Remote Handler initialized")
