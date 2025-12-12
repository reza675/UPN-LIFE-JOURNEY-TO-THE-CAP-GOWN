local Kirana = {}

-- Data NPC Kirana
Kirana.Info = {
	Name = "Kirana",
	Role = "Mahasiswi",
	Personality = "Ceria, Ramah, Suka Membantu",
	Major = "Teknik Informatika",
	Semester = 1,
	Description = "Teman sekelas yang ceria dan selalu siap membantu"
}

-- Dialog berdasarkan relationship level
Kirana.Dialogues = {
	FirstMeet = {
		"Hai! Kamu mahasiswa baru juga ya?",
		"Aku Kirana, salam kenal!",
		"Kalau ada yang bingung tentang kampus, tanya aku aja ya!"
	},
	
	Casual = {
		"Eh, kamu sudah ngerjain tugas belum?",
		"Hari ini dosennya agak galak nih, hati-hati ya!",
		"Mau ke kantin bareng nggak? Aku lapar nih~",
		"Kemarin aku ketemu kucing lucu di taman kampus lho!"
	},
	
	Friendly = {
		"Seneng deh bisa kenal sama kamu!",
		"Eh, weekend nanti ada rencana? Mau belajar bareng?",
		"Makasih ya udah bantuin aku kemarin~",
		"Kamu tahu nggak, aku suka banget perpustakaan kampus ini!"
	},
	
	Close = {
		"Kamu satu-satunya teman yang benar-benar ngerti aku...",
		"Aku seneng banget bisa jadi partner belajar kamu!",
		"Jujur ya, aku agak nervous kalau ada ujian besok...",
		"Makasih ya udah selalu ada buat aku..."
	}
}

-- Quest yang diberikan Kirana
Kirana.Quests = {
	"Romance_Kirana",
	"Help_WithAssignment",
	"Study_Together"
}

-- Fungsi untuk interact dengan Kirana
function Kirana.Interact(player, relationshipLevel)
	relationshipLevel = relationshipLevel or "FirstMeet"
	
	local dialogues = Kirana.Dialogues[relationshipLevel]
	if dialogues then
		local randomDialogue = dialogues[math.random(1, #dialogues)]
		return randomDialogue
	end
	
	return "..."
end

-- Fungsi untuk memberikan quest
function Kirana.GiveQuest(player)
	local QuestSystem = require(script.Parent.Parent.Core.QuestSystem)
	-- Logic pemberian quest
	print("Kirana memberikan quest kepada " .. player.Name)
end

-- Fungsi untuk response terhadap gift/item
function Kirana.ReceiveGift(player, item)
	local responses = {
		["CatatanKuliah"] = "Wah makasih! Ini pasti berguna banget!",
		["Bunga"] = "Eh, buat aku? Makasih ya... >/<",
		["Makanan"] = "Asik! Kebetulan aku lagi lapar nih~",
		["Buku"] = "Aku suka baca! Makasih banyak ya!"
	}
	
	return responses[item] or "Makasih ya! Aku suka banget~"
end

return Kirana
