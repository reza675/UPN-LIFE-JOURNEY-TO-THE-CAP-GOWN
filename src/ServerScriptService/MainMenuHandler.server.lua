--[[
	Main Menu Handler (Server)
	Fungsi: Handle request dari Main Menu client
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local PlayerDataStore = DataStoreService:GetDataStore("PlayerDataStore_v1")

local PlayerData = require(ReplicatedStorage.Modules.Core.PlayerData)

-- RemoteFunction untuk cek save data
local CheckSaveRemote = Instance.new("RemoteFunction")
CheckSaveRemote.Name = "CheckSaveRemote"
CheckSaveRemote.Parent = ReplicatedStorage

CheckSaveRemote.OnServerInvoke = function(player)
	local userId = player.UserId
	local success, savedData = pcall(function()
		return PlayerDataStore:GetAsync(userId)
	end)
	
	-- Return true jika ada save data
	return (success and savedData ~= nil)
end

-- RemoteEvent untuk handle menu actions
local MainMenuRemote = ReplicatedStorage:WaitForChild("MainMenuRemote")

MainMenuRemote.OnServerEvent:Connect(function(player, action)
	if action == "NewGame" then
		print("🆕 Player " .. player.Name .. " memulai permainan baru")
		-- Reset semua data ke default
		local data = PlayerData.Get(player)
		if data then
			data.Semester = 1
			data.IPK = 0.00
			data.Reputation = 50
			data.Money = 50000
			data.CurrentStory = "Intro"
			data.Inventory = {}
			data.CompletedQuests = {}
			data.ActiveQuests = {}
			data.StoryChoices = {}
			
			-- Update leaderstats
			if player:FindFirstChild("leaderstats") then
				player.leaderstats.Semester.Value = 1
				player.leaderstats.IPK.Value = 0.00
			end
			
			PlayerData.Save(player)
			print("✅ Data direset untuk: " .. player.Name)
		end
		
	elseif action == "Continue" then
		print("🔄 Player " .. player.Name .. " melanjutkan permainan")
		-- Data sudah di-load saat Init, tidak perlu action tambahan
	end
end)

print("✅ Main Menu Handler initialized")
