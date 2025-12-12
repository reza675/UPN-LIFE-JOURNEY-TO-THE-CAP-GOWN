local SideQuest_Romance = {}

-- Side Quest bertema Romance/Relationship
SideQuest_Romance.Quests = {
	["Romance_Kirana"] = {
		Title = "Teman Dekat",
		Description = "Kenali lebih dekat dengan Kirana, teman sekelas yang ceria",
		NPC = "Kirana",
		RequiredSemester = 1,
		Objectives = {
			{Type = "TalkTo", Target = "Kirana", Progress = 0, Required = 3},
			{Type = "GiveItem", Target = "CatatanKuliah", Progress = 0, Required = 1},
			{Type = "StudyTogether", Target = "Perpustakaan", Progress = 0, Required = 2}
		},
		Rewards = {
			Reputation = 10,
			Relationship = "Kirana_Level1",
			Item = "FotoKirana"
		},
		NextQuest = "Romance_Kirana_2"
	},
	
	["Romance_Bayu"] = {
		Title = "Partner Proyek",
		Description = "Kerjakan proyek bersama Bayu, teman satu tim yang rajin",
		NPC = "Bayu",
		RequiredSemester = 2,
		Objectives = {
			{Type = "TalkTo", Target = "Bayu", Progress = 0, Required = 2},
			{Type = "Complete", Target = "ProyekBersama", Progress = 0, Required = 1},
			{Type = "HangOut", Target = "Kantin", Progress = 0, Required = 1}
		},
		Rewards = {
			Reputation = 15,
			Relationship = "Bayu_Level1",
			IPK = 0.10
		},
		NextQuest = "Romance_Bayu_2"
	},
	
	["Romance_Citra"] = {
		Title = "Sahabat Sejati",
		Description = "Bangun persahabatan dengan Citra, senior yang inspiratif",
		NPC = "Citra",
		RequiredSemester = 3,
		Objectives = {
			{Type = "TalkTo", Target = "Citra", Progress = 0, Required = 2},
			{Type = "HelpWith", Target = "OrganisasiEvent", Progress = 0, Required = 1},
			{Type = "Attend", Target = "SeminarCitra", Progress = 0, Required = 1}
		},
		Rewards = {
			Reputation = 20,
			Relationship = "Citra_Level1",
			Item = "RekomendasiSenior"
		}
	}
}

-- Fungsi untuk cek apakah quest tersedia
function SideQuest_Romance.IsQuestAvailable(player, questId)
	local PlayerData = require(script.Parent.Parent.Core.PlayerData)
	local data = PlayerData.Get(player)
	local questData = SideQuest_Romance.Quests[questId]
	
	if not questData then return false end
	
	-- Cek semester requirement
	if data.Semester < questData.RequiredSemester then
		return false
	end
	
	return true
end

-- Fungsi untuk mendapatkan detail quest
function SideQuest_Romance.GetQuestData(questId)
	return SideQuest_Romance.Quests[questId]
end

return SideQuest_Romance
