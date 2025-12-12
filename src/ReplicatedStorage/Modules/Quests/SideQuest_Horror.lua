local SideQuest_Horror = {}

-- Side Quest bertema Horror/Mystery
SideQuest_Horror.Quests = {
	["Horror_GedungTua"] = {
		Title = "Misteri Gedung Lama",
		Description = "Selidiki gedung lama kampus yang konon berhantu",
		RequiredSemester = 2,
		TimeRequired = "Malam", -- Hanya bisa dimainkan malam hari
		Objectives = {
			{Type = "GoTo", Target = "GedungLama", Progress = 0, Required = 1},
			{Type = "Find", Target = "PetunjukTersembunyi", Progress = 0, Required = 3},
			{Type = "Solve", Target = "TekaMeki", Progress = 0, Required = 1}
		},
		Rewards = {
			Reputation = 25,
			Money = 50000,
			Item = "KunciRahasia"
		},
		NextQuest = "Horror_RuangRahasia"
	},
	
	["Horror_RuangRahasia"] = {
		Title = "Ruang Rahasia",
		Description = "Buka ruang rahasia di gedung lama dengan kunci yang ditemukan",
		RequiredSemester = 3,
		RequiredItem = "KunciRahasia",
		Objectives = {
			{Type = "UseItem", Target = "KunciRahasia", Progress = 0, Required = 1},
			{Type = "Explore", Target = "RuangRahasia", Progress = 0, Required = 1},
			{Type = "Collect", Target = "DokumenKuno", Progress = 0, Required = 5}
		},
		Rewards = {
			Reputation = 30,
			Item = "SejarahKampus",
			Achievement = "PenjirahKampus"
		}
	},
	
	["Horror_LabMalam"] = {
		Title = "Lab Tengah Malam",
		Description = "Selesaikan eksperimen di lab yang sepi pada malam hari",
		RequiredSemester = 4,
		TimeRequired = "Malam",
		Objectives = {
			{Type = "Enter", Target = "LabFisika", Progress = 0, Required = 1},
			{Type = "Complete", Target = "Eksperimen", Progress = 0, Required = 1},
			{Type = "Survive", Target = "EventMenakutkan", Progress = 0, Required = 1}
		},
		Rewards = {
			IPK = 0.15,
			Reputation = 20,
			Item = "HasilEksperimen"
		}
	},
	
	["Horror_Perpustakaan"] = {
		Title = "Buku Terlarang",
		Description = "Temukan buku langka di perpustakaan yang dijaga ketat",
		RequiredSemester = 3,
		Objectives = {
			{Type = "Sneak", Target = "PerpustakaanMalam", Progress = 0, Required = 1},
			{Type = "Avoid", Target = "Satpam", Progress = 0, Required = 3},
			{Type = "Find", Target = "BukuLangka", Progress = 0, Required = 1}
		},
		Rewards = {
			Reputation = 15,
			Item = "BukuRahasiaCampus",
			Knowledge = "SejarahGelap"
		}
	}
}

-- Fungsi untuk cek apakah quest tersedia
function SideQuest_Horror.IsQuestAvailable(player, questId)
	local PlayerData = require(script.Parent.Parent.Core.PlayerData)
	local data = PlayerData.Get(player)
	local questData = SideQuest_Horror.Quests[questId]
	
	if not questData then return false end
	
	-- Cek semester requirement
	if data.Semester < questData.RequiredSemester then
		return false
	end
	
	-- Cek item requirement jika ada
	if questData.RequiredItem then
		local hasItem = false
		for _, item in ipairs(data.Inventory) do
			if item == questData.RequiredItem then
				hasItem = true
				break
			end
		end
		if not hasItem then
			return false
		end
	end
	
	return true
end

-- Fungsi untuk mendapatkan detail quest
function SideQuest_Horror.GetQuestData(questId)
	return SideQuest_Horror.Quests[questId]
end

return SideQuest_Horror
