local Citra = {}

-- Data NPC Citra
Citra.Info = {
	Name = "Citra",
	Role = "Senior/Kakak Tingkat",
	Personality = "Inspiratif, Bijaksana, Supportif",
	Major = "Teknik Informatika",
	Semester = 6,
	Position = "Ketua Himpunan",
	Description = "Senior yang aktif di organisasi dan inspiratif"
}

-- Dialog Citra
Citra.Dialogues = {
	FirstMeet = {
		"Halo adik tingkat! Selamat datang di kampus kita!",
		"Aku Citra, kakak tingkat dari jurusan yang sama.",
		"Kalau ada kesulitan, jangan ragu tanya senior ya!"
	},
	
	Casual = {
		"Gimana kuliah semester ini? Lancar?",
		"Jangan cuma fokus nilai, aktif organisasi juga penting lho!",
		"Kampus ini banyak kesempatan, manfaatin sebaik-baiknya.",
		"Aku dulu juga pernah struggle kayak kamu kok."
	},
	
	Friendly = {
		"Kamu punya potensi besar, aku yakin itu!",
		"Mau ikut event yang aku organize? Bisa tambah pengalaman.",
		"Seneng liat junior yang semangat kayak kamu.",
		"Nanti kalau butuh surat rekomendasi, bilang aja ya!"
	},
	
	Mentor = {
		"Life balance itu penting: akademik, organisasi, dan self-care.",
		"Jangan takut gagal, itu bagian dari proses belajar.",
		"Networking itu investasi jangka panjang, jaga hubungan baik.",
		"Kamu udah berkembang banyak sejak semester pertama!"
	}
}

-- Quest yang diberikan Citra
Citra.Quests = {
	"Romance_Citra",
	"Organization_Leader",
	"Campus_Event"
}

-- Fungsi untuk interact
function Citra.Interact(player, relationshipLevel)
	relationshipLevel = relationshipLevel or "FirstMeet"
	local dialogues = Citra.Dialogues[relationshipLevel]
	
	if dialogues then
		return dialogues[math.random(1, #dialogues)]
	end
	
	return "Ada yang bisa kakak bantu?"
end

-- Fungsi untuk memberikan mentoring
function Citra.GiveMentoring(topic)
	local mentoring = {
		["Akademik"] = "Kunci sukses akademik: konsisten, time management, dan jangan ragu bertanya.",
		["Organisasi"] = "Organisasi itu tempat belajar leadership dan teamwork, jangan takut terlibat.",
		["Karir"] = "Mulai cari pengalaman dari sekarang: magang, project, atau freelance.",
		["LifeBalance"] = "Jangan lupakan kesehatan mental, istirahat yang cukup, dan quality time dengan orang terdekat."
	}
	
	return mentoring[topic] or "Selalu ingat tujuan awal kamu kuliah, itu akan jadi motivasi terbesar."
end

return Citra
