local MainQuest = {}

local QuestSystem = require(script.Parent.Parent.Core.QuestSystem)

-- Daftar Main Quest berdasarkan chapter/bab
MainQuest.Quests = {
	["Bab1_Intro_PKKBN"] = {
		Title = "Pengenalan PKKBN",
		Description = "Ikuti kegiatan Pengenalan Kehidupan Kampus Bagi Mahasiswa Baru (PKKBN)",
		Objectives = {
			{Type = "TalkTo", Target = "PakEdo", Progress = 0, Required = 1},
			{Type = "Complete", Target = "PKKBN", Progress = 0, Required = 1}
		},
		Rewards = {
			IPK = 0.10,
			Reputation = 10,
			Money = 0
		},
		NextQuest = "Bab1_Pilih_Jurusan"
	},
	
	["Bab1_Pilih_Jurusan"] = {
		Title = "Memilih Jurusan",
		Description = "Kunjungi berbagai fakultas dan pilih jurusan yang sesuai",
		Objectives = {
			{Type = "Visit", Target = "FakultasTeknik", Progress = 0, Required = 1},
			{Type = "TalkTo", Target = "BuRatna", Progress = 0, Required = 1},
			{Type = "Choose", Target = "Jurusan", Progress = 0, Required = 1}
		},
		Rewards = {
			IPK = 0.05,
			Reputation = 5,
			Item = "KTM"
		},
		NextQuest = "Bab2_Semester1"
	},
	
	["Bab2_Semester1"] = {
		Title = "Semester 1 - Masa Orientasi",
		Description = "Hadapi semester pertama dengan berbagai tugas dan ujian",
		Objectives = {
			{Type = "Attend", Target = "Kelas", Progress = 0, Required = 8},
			{Type = "Complete", Target = "Tugas", Progress = 0, Required = 5},
			{Type = "Pass", Target = "UTS", Progress = 0, Required = 1}
		},
		Rewards = {
			IPK = 0.25,
			Reputation = 15,
			Money = 0
		},
		NextQuest = "Bab3_Semester2"
	},
	
	["Bab3_Semester2"] = {
		Title = "Semester 2 - Adaptasi",
		Description = "Tingkatkan prestasi dan mulai mengikuti organisasi",
		Objectives = {
			{Type = "Attend", Target = "Kelas", Progress = 0, Required = 8},
			{Type = "Join", Target = "Organisasi", Progress = 0, Required = 1},
			{Type = "Complete", Target = "Tugas", Progress = 0, Required = 6}
		},
		Rewards = {
			IPK = 0.30,
			Reputation = 20,
			Money = 0
		},
		NextQuest = "Bab4_Semester3"
	}
}

-- Fungsi untuk mendapatkan detail quest
function MainQuest.GetQuestData(questId)
	return MainQuest.Quests[questId]
end

-- Fungsi untuk update progress objective
function MainQuest.UpdateObjective(player, questId, objectiveIndex)
	local questData = MainQuest.Quests[questId]
	if questData and questData.Objectives[objectiveIndex] then
		questData.Objectives[objectiveIndex].Progress += 1
		
		-- Cek apakah objective selesai
		if questData.Objectives[objectiveIndex].Progress >= questData.Objectives[objectiveIndex].Required then
			print("✅ Objective selesai: " .. questData.Objectives[objectiveIndex].Target)
			return true
		end
	end
	return false
end

-- Cek apakah semua objective selesai
function MainQuest.CheckAllObjectivesComplete(questId)
	local questData = MainQuest.Quests[questId]
	if not questData then return false end
	
	for _, objective in ipairs(questData.Objectives) do
		if objective.Progress < objective.Required then
			return false
		end
	end
	return true
end

return MainQuest
