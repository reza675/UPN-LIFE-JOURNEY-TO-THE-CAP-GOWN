local PakEdo = {}

-- Data NPC Pak Edo
PakEdo.Info = {
	Name = "Pak Edo",
	Role = "Dosen/Pembimbing Akademik",
	Personality = "Tegas, Bijaksana, Peduli",
	Subject = "Pemrograman Dasar & Struktur Data",
	Description = "Dosen favorit yang tegas tapi peduli dengan mahasiswa"
}

-- Dialog Pak Edo
PakEdo.Dialogues = {
	FirstMeet = {
		"Selamat datang di kampus, saya Pak Edo, dosen pembimbing kalian.",
		"Kuliah itu bukan cuma soal nilai, tapi bagaimana kalian berkembang.",
		"Kalau ada masalah akademik, langsung konsultasi ke saya."
	},
	
	InClass = {
		"Perhatikan baik-baik, materi ini penting untuk ujian!",
		"Ada yang mau bertanya? Jangan malu-malu.",
		"Tugas dikumpulkan paling lambat hari Jumat, tidak ada toleransi!",
		"Kalian harus paham konsep dasarnya dulu sebelum lanjut ke materi berikutnya."
	},
	
	Consultation = {
		"Jadi, apa yang ingin kamu konsultasikan?",
		"IPK kamu turun? Coba kita evaluasi study habit kamu.",
		"Jangan terlalu stress, ambil waktu istirahat yang cukup.",
		"Kalau merasa overwhelmed, prioritaskan yang paling penting dulu."
	},
	
	Encouraging = {
		"Saya lihat progress kamu bagus, pertahankan!",
		"Jangan patah semangat, kesulitan itu wajar di semester awal.",
		"Saya percaya kamu bisa menyelesaikan tugas akhir dengan baik.",
		"Kerja keras kamu tidak akan mengkhianati hasil."
	},
	
	Strict = {
		"Terlambat lagi? Ini peringatan terakhir.",
		"Nilai kamu jelek karena kamu tidak serius, bukan karena materinya sulit.",
		"Kalau begini terus, saya tidak bisa meluluskan kamu.",
		"Disiplin itu penting, bukan cuma di kampus tapi juga di dunia kerja nanti!"
	}
}

-- Quest yang diberikan Pak Edo
PakEdo.Quests = {
	"Bab1_Intro_PKKBN",
	"Assignment_Programming",
	"Final_Project"
}

-- Fungsi untuk interact
function PakEdo.Interact(player, context)
	context = context or "InClass"
	local dialogues = PakEdo.Dialogues[context]
	
	if dialogues then
		return dialogues[math.random(1, #dialogues)]
	end
	
	return "Ya, ada yang bisa saya bantu?"
end

-- Fungsi untuk memberikan nilai/feedback
function PakEdo.GiveFeedback(score)
	if score >= 85 then
		return "Excellent! Pertahankan performa kamu."
	elseif score >= 70 then
		return "Cukup bagus, tapi masih bisa ditingkatkan lagi."
	elseif score >= 60 then
		return "Kamu harus lebih serius belajar. Ini nilai minimal."
	else
		return "Tidak lulus! Kamu harus remedial dan perbaiki cara belajar kamu."
	end
end

-- Fungsi untuk konsultasi akademik
function PakEdo.AcademicConsultation(player, issue)
	local advice = {
		["IPK_Rendah"] = "Buat jadwal belajar terstruktur, fokus di mata kuliah yang lemah.",
		["Sulit_Memahami"] = "Coba belajar kelompok, atau ambil kelas tambahan di luar jam kuliah.",
		["Time_Management"] = "Prioritaskan tugas berdasarkan deadline dan tingkat kesulitan.",
		["Stress"] = "Jangan memaksakan diri, kesehatan mental lebih penting. Ambil istirahat."
	}
	
	return advice[issue] or "Coba jelaskan masalahnya lebih detail, nanti kita cari solusinya bersama."
end

return PakEdo
