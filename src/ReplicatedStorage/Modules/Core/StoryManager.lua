--[[
	Story Manager
	Fungsi: Mengelola alur cerita bercabang dan ending
]]

local StoryManager = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerData = require(ReplicatedStorage.Modules.Core.PlayerData)

-- Story Branches
local STORY_BRANCHES = {
	Romance = "Romance",
	Horror = "Horror",
	Neutral = "Neutral"
}

-- Endings berdasarkan kondisi
local ENDINGS = {
	PerfectGraduate = {
		Name = "Perfect Graduate",
		Description = "Lulus dengan IPK sempurna dan cerita romance yang bahagia!",
		Requirements = {
			MinIPK = 3.8,
			MinReputation = 80,
			CompletedRomanceQuests = 3
		}
	},
	GoodGraduate = {
		Name = "Good Graduate",
		Description = "Lulus dengan baik dan siap menghadapi masa depan!",
		Requirements = {
			MinIPK = 3.0,
			MinReputation = 60
		}
	},
	DarkPath = {
		Name = "Dark Path",
		Description = "Cerita horror telah mengubah jalan hidupmu...",
		Requirements = {
			CompletedHorrorQuests = 3,
			MaxReputation = 40
		}
	},
	Dropout = {
		Name = "Dropout",
		Description = "Sayangnya, perjalanan kuliah berakhir di tengah jalan...",
		Requirements = {
			MaxIPK = 2.0,
			MaxReputation = 30
		}
	}
}

-- Track story progress
function StoryManager.TrackChoice(player, choiceId, choiceValue)
	PlayerData.AddStoryChoice(player, choiceId, choiceValue)
	
	-- Analisa pilihan untuk menentukan branch
	local data = PlayerData.Get(player)
	if not data then return end
	
	local romanceCount = 0
	local horrorCount = 0
	
	for id, value in pairs(data.StoryChoices) do
		if string.find(id, "Romance") then
			romanceCount = romanceCount + 1
		elseif string.find(id, "Horror") then
			horrorCount = horrorCount + 1
		end
	end
	
	-- Update current story branch
	if romanceCount > horrorCount then
		data.CurrentStory = STORY_BRANCHES.Romance
	elseif horrorCount > romanceCount then
		data.CurrentStory = STORY_BRANCHES.Horror
	else
		data.CurrentStory = STORY_BRANCHES.Neutral
	end
	
	print("📖 Story Branch: " .. data.CurrentStory)
end

-- Check quest requirements
function StoryManager.CheckQuestRequirements(player, questId)
	local data = PlayerData.Get(player)
	if not data then return false end
	
	-- Example: Block certain quests based on reputation
	if string.find(questId, "Horror") and data.Reputation > 70 then
		return false, "Reputasi terlalu tinggi untuk quest ini"
	end
	
	if string.find(questId, "Romance") and data.Reputation < 40 then
		return false, "Reputasi terlalu rendah untuk quest ini"
	end
	
	-- Check semester requirements
	if string.find(questId, "Semester5") and data.Semester < 5 then
		return false, "Quest ini hanya tersedia di Semester 5 atau lebih"
	end
	
	return true
end

-- Calculate ending
function StoryManager.CalculateEnding(player)
	local data = PlayerData.Get(player)
	if not data then return nil end
	
	-- Count completed quests by type
	local romanceQuests = 0
	local horrorQuests = 0
	
	for questId, _ in pairs(data.CompletedQuests) do
		if string.find(questId, "Romance") then
			romanceQuests = romanceQuests + 1
		elseif string.find(questId, "Horror") then
			horrorQuests = horrorQuests + 1
		end
	end
	
	-- Check endings in priority order
	-- Perfect Graduate
	if data.IPK >= ENDINGS.PerfectGraduate.Requirements.MinIPK and
	   data.Reputation >= ENDINGS.PerfectGraduate.Requirements.MinReputation and
	   romanceQuests >= ENDINGS.PerfectGraduate.Requirements.CompletedRomanceQuests then
		return ENDINGS.PerfectGraduate
	end
	
	-- Dark Path
	if horrorQuests >= ENDINGS.DarkPath.Requirements.CompletedHorrorQuests and
	   data.Reputation <= ENDINGS.DarkPath.Requirements.MaxReputation then
		return ENDINGS.DarkPath
	end
	
	-- Dropout (bad ending)
	if data.IPK <= ENDINGS.Dropout.Requirements.MaxIPK and
	   data.Reputation <= ENDINGS.Dropout.Requirements.MaxReputation then
		return ENDINGS.Dropout
	end
	
	-- Good Graduate (default good ending)
	if data.IPK >= ENDINGS.GoodGraduate.Requirements.MinIPK and
	   data.Reputation >= ENDINGS.GoodGraduate.Requirements.MinReputation then
		return ENDINGS.GoodGraduate
	end
	
	-- Fallback
	return ENDINGS.GoodGraduate
end

-- Show ending to player
function StoryManager.TriggerEnding(player)
	local ending = StoryManager.CalculateEnding(player)
	if not ending then return end
	
	print("🎬 ENDING TRIGGERED for " .. player.Name)
	print("📜 Ending: " .. ending.Name)
	print("📝 " .. ending.Description)
	
	-- Fire ending event ke client untuk tampilkan UI
	local EndingRemote = ReplicatedStorage:FindFirstChild("EndingRemote")
	if not EndingRemote then
		EndingRemote = Instance.new("RemoteEvent")
		EndingRemote.Name = "EndingRemote"
		EndingRemote.Parent = ReplicatedStorage
	end
	
	EndingRemote:FireClient(player, {
		Name = ending.Name,
		Description = ending.Description,
		PlayerStats = {
			IPK = PlayerData.Get(player).IPK,
			Semester = PlayerData.Get(player).Semester,
			Reputation = PlayerData.Get(player).Reputation
		}
	})
	
	return ending
end

-- Get current story branch
function StoryManager.GetCurrentBranch(player)
	local data = PlayerData.Get(player)
	return data and data.CurrentStory or STORY_BRANCHES.Neutral
end

-- Check if player should trigger ending (Semester 8 complete)
function StoryManager.CheckGraduationCondition(player)
	local data = PlayerData.Get(player)
	if not data then return false end
	
	-- Graduation condition: Semester 8 atau lebih, minimal IPK 2.0
	if data.Semester >= 8 and data.IPK >= 2.0 then
		return true
	end
	
	return false
end

return StoryManager
