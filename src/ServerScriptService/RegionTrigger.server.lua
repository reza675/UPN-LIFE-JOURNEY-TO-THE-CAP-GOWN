--[[
	Region Trigger System
	Fungsi: Mendeteksi player masuk ke zone tertentu untuk quest objectives
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QuestSystem = require(ReplicatedStorage.Modules.Core.QuestSystem)
local PlayerData = require(ReplicatedStorage.Modules.Core.PlayerData)

-- Mapping zone names ke quest objectives
local ZONE_QUEST_MAP = {
	-- Format: [ZoneName] = { QuestId, ObjectiveIndex }
	GedungLama = {
		{ QuestId = "Horror_GedungTua", ObjectiveIndex = 1 },
		{ QuestId = "SideQuest_Horror_Mystery", ObjectiveIndex = 2 }
	},
	Perpustakaan = {
		{ QuestId = "Bab1_Intro_PKKBN", ObjectiveIndex = 2 }, -- Complete PKKBN setelah bicara PakEdo
		{ QuestId = "MainQuest_StudyTime", ObjectiveIndex = 1 }
	},
	RuangKelas = {
		{ QuestId = "Bab2_KelasPertama", ObjectiveIndex = 1 },
		{ QuestId = "Assignment_Programming", ObjectiveIndex = 1 }
	},
	Kantin = {
		{ QuestId = "Romance_KantinMeeting", ObjectiveIndex = 1 },
		{ QuestId = "SideQuest_Romance_Date", ObjectiveIndex = 2 }
	},
	LabKomputer = {
		{ QuestId = "Assignment_Programming", ObjectiveIndex = 2 }
	},
	TamanCampus = {
		{ QuestId = "Romance_ParkWalk", ObjectiveIndex = 1 }
	},
	AulaUPN = {
		{ QuestId = "MainQuest_Wisuda", ObjectiveIndex = 1 }
	}
}

-- Player cooldowns to prevent spam triggers
local playerCooldowns = {}
local COOLDOWN_TIME = 3 -- seconds

-- Setup zone trigger
local function setupZone(zone)
	if not zone:IsA("BasePart") then
		warn("⚠️ Zone bukan BasePart: " .. zone.Name)
		return
	end
	
	-- Make zone invisible and non-collidable
	zone.Transparency = 0.5
	zone.CanCollide = false
	zone.Anchored = true
	
	-- Color code for easier debugging (optional)
	zone.BrickColor = BrickColor.new("Bright green")
	zone.Material = Enum.Material.Neon
	
	local zoneName = zone.Name
	
	-- Touched event
	zone.Touched:Connect(function(hit)
		local character = hit.Parent
		local player = game.Players:GetPlayerFromCharacter(character)
		
		if not player then return end
		
		-- Check cooldown
		local cooldownKey = player.UserId .. "_" .. zoneName
		if playerCooldowns[cooldownKey] then
			local timeSince = os.time() - playerCooldowns[cooldownKey]
			if timeSince < COOLDOWN_TIME then
				return
			end
		end
		
		-- Update cooldown
		playerCooldowns[cooldownKey] = os.time()
		
		-- Check if this zone is relevant to any active quests
		local questMappings = ZONE_QUEST_MAP[zoneName]
		if not questMappings then
			print("ℹ️ Zone tidak ada quest mapping: " .. zoneName)
			return
		end
		
		local data = PlayerData.Get(player)
		if not data then return end
		
		-- Loop through all possible quests for this zone
		for _, mapping in ipairs(questMappings) do
			local questId = mapping.QuestId
			local objectiveIndex = mapping.ObjectiveIndex
			
			-- Check if player has this quest active
			if data.ActiveQuests and data.ActiveQuests[questId] then
				-- Check if objective not already complete
				if not QuestSystem.IsObjectiveComplete(player, questId, objectiveIndex) then
					print("📍 Player " .. player.Name .. " masuk zone: " .. zoneName .. " untuk quest: " .. questId)
					QuestSystem.UpdateObjective(player, questId, objectiveIndex)
					
					-- Visual feedback
					local feedbackRemote = ReplicatedStorage:FindFirstChild("FeedbackRemote")
					if feedbackRemote then
						feedbackRemote:FireClient(player, "ZoneEntered", {
							ZoneName = zoneName,
							QuestId = questId,
							Message = "Objective selesai: Tiba di " .. zoneName
						})
					end
				end
			end
		end
	end)
	
	print("✅ Zone trigger setup: " .. zoneName)
end

-- Initialize all zones
local function initializeZones()
	print("🗺️ Menginisialisasi Quest Zones...")
	
	local questZonesFolder = workspace:WaitForChild("QuestZones", 10)
	
	if not questZonesFolder then
		warn("⚠️ Folder 'QuestZones' tidak ditemukan di Workspace!")
		warn("⚠️ Buat folder 'QuestZones' di Workspace dan masukkan Parts dengan nama zone (misal: GedungLama, Perpustakaan)")
		return
	end
	
	-- Setup each zone
	for _, zone in ipairs(questZonesFolder:GetChildren()) do
		setupZone(zone)
	end
	
	-- Watch for new zones added
	questZonesFolder.ChildAdded:Connect(function(zone)
		task.wait(0.1)
		setupZone(zone)
	end)
	
	print("✅ Total zones initialized: " .. #questZonesFolder:GetChildren())
end

-- Create feedback remote if not exists
local FeedbackRemote = ReplicatedStorage:FindFirstChild("FeedbackRemote")
if not FeedbackRemote then
	FeedbackRemote = Instance.new("RemoteEvent")
	FeedbackRemote.Name = "FeedbackRemote"
	FeedbackRemote.Parent = ReplicatedStorage
end

-- Start initialization
task.spawn(initializeZones)

print("✅ Region Trigger System initialized")
