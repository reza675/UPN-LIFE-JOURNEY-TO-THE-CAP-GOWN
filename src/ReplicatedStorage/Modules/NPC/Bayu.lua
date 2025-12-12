local Bayu = {}

-- Data NPC Bayu
Bayu.Info = {
	Name = "Bayu",
	Role = "Mahasiswa",
	Personality = "Rajin, Serius, Perfeksionis",
	Major = "Teknik Informatika",
	Semester = 2,
	Description = "Mahasiswa rajin yang selalu dapat nilai tinggi"
}

-- Dialog Bayu
Bayu.Dialogues = {
	FirstMeet = {
		"Oh, kamu mahasiswa baru?",
		"Aku Bayu. Kalau mau serius kuliah, kita bisa kerja sama.",
		"Jangan lupa, IPK itu penting untuk masa depan."
	},
	
	Casual = {
		"Kamu sudah baca materi minggu depan belum?",
		"Aku lagi ngerjain tugas, jangan ganggu dulu ya.",
		"Untuk dapat nilai A, harus konsisten belajar setiap hari.",
		"Perpustakaan lebih tenang buat belajar daripada kantin."
	},
	
	Friendly = {
		"Kamu cukup rajin juga ya, aku respect itu.",
		"Mau gabung kelompok belajar aku?",
		"Nanti kalau ada proyek, kita bisa kerja sama.",
		"Jarang ada yang bisa ngimbangin pace belajar aku, tapi kamu bisa."
	},
	
	Close = {
		"Jujur, aku seneng punya partner belajar kayak kamu.",
		"Kadang aku terlalu keras ke diri sendiri... makasih udah ingetin.",
		"Kita bisa saling bantu sampai wisuda nanti.",
		"Nilai bukan segalanya, tapi usaha kita yang penting."
	}
}

-- Quest yang diberikan Bayu
Bayu.Quests = {
	"Romance_Bayu",
	"GroupProject_Excellence",
	"Study_Marathon"
}

-- Fungsi untuk interact
function Bayu.Interact(player, relationshipLevel)
	relationshipLevel = relationshipLevel or "FirstMeet"
	local dialogues = Bayu.Dialogues[relationshipLevel]
	
	if dialogues then
		return dialogues[math.random(1, #dialogues)]
	end
	
	return "..."
end

-- Fungsi untuk memberikan tips belajar
function Bayu.GiveStudyTips()
	local tips = {
		"Buat jadwal belajar yang konsisten.",
		"Fokus di kelas, jangan main HP.",
		"Kerjakan tugas H-1 sebelum deadline minimal.",
		"Review materi sebelum tidur, membantu memorisasi.",
		"Jangan begadang sebelum ujian, istirahat cukup itu penting."
	}
	
	return tips[math.random(1, #tips)]
end

return Bayu
