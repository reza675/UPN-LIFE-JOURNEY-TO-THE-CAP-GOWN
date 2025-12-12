local BuRatna = {}

-- Data NPC Bu Ratna
BuRatna.Info = {
	Name = "Bu Ratna",
	Role = "Staff Akademik/Administrasi",
	Personality = "Ramah, Sabar, Detail",
	Office = "Bagian Akademik Fakultas",
	Description = "Staff akademik yang selalu membantu urusan administrasi mahasiswa"
}

-- Dialog Bu Ratna
BuRatna.Dialogues = {
	Greeting = {
		"Selamat pagi/siang, ada yang bisa Ibu bantu?",
		"Silakan duduk dulu, mau mengurus apa hari ini?",
		"Oh kamu, ada keperluan apa dengan bagian akademik?"
	},
	
	Helpful = {
		"Untuk mengurus KRS, kamu perlu minta tanda tangan dosen pembimbing dulu ya.",
		"Jadwal kuliah bisa dilihat di portal akademik atau papan pengumuman.",
		"Kalau ada masalah dengan nilai, langsung konsultasi ke dosen pengampu.",
		"Jangan lupa bayar UKT tepat waktu ya, nanti bisa kena sanksi."
	},
	
	Reminder = {
		"Batas akhir pengisian KRS tanggal 15, jangan sampai telat!",
		"Sudah ambil KTM belum? Nanti perlu buat akses perpustakaan.",
		"Cek email kampus kamu secara berkala, sering ada pengumuman penting.",
		"Kalau mau pindah kelas, harus ada persetujuan dari ketua jurusan."
	},
	
	Friendly = {
		"Kamu mahasiswa baru ya? Semangat kuliahnya!",
		"Wah sudah semester berapa sekarang? Cepat juga ya...",
		"Kalau ada yang bingung soal administrasi, jangan sungkan tanya Ibu.",
		"Rajin-rajin cek pengumuman ya, biar nggak ketinggalan info penting."
	}
}

-- Services yang bisa dibantu Bu Ratna
BuRatna.Services = {
	"Pengisian_KRS",
	"Cetak_Transkrip",
	"Surat_Keterangan",
	"Informasi_Jadwal",
	"Pengajuan_Cuti",
	"Verifikasi_Dokumen"
}

-- Fungsi untuk interact
function BuRatna.Interact(player, context)
	context = context or "Greeting"
	local dialogues = BuRatna.Dialogues[context]
	
	if dialogues then
		return dialogues[math.random(1, #dialogues)]
	end
	
	return "Ada yang bisa Ibu bantu?"
end

-- Fungsi untuk process administrasi
function BuRatna.ProcessAdministration(service)
	local responses = {
		["Pengisian_KRS"] = "Baik, ini form KRS-nya. Isi dengan lengkap dan minta tanda tangan PA ya.",
		["Cetak_Transkrip"] = "Transkrip bisa diambil besok, biaya cetak Rp 25.000.",
		["Surat_Keterangan"] = "Surat keterangan aktif kuliah bisa jadi hari ini, tunggu sekitar 2 jam ya.",
		["Informasi_Jadwal"] = "Jadwal sudah dipasang di mading fakultas dan portal akademik.",
		["Pengajuan_Cuti"] = "Cuti kuliah harus ada persetujuan orang tua dan dosen PA.",
		["Verifikasi_Dokumen"] = "Dokumennya sudah lengkap, tinggal tunggu proses dari fakultas."
	}
	
	return responses[service] or "Untuk keperluan itu, kamu harus ke bagian lain ya."
end

-- Fungsi untuk memberikan informasi penting
function BuRatna.GiveInformation(topic)
	local info = {
		["Deadline_KRS"] = "Pengisian KRS: 1-15 setiap awal semester.",
		["UKT"] = "Pembayaran UKT paling lambat tanggal 20 setiap semesternya.",
		["Wisuda"] = "Persyaratan wisuda: IPK min 2.75, lulus semua mata kuliah, tidak ada tunggakan.",
		["Beasiswa"] = "Info beasiswa bisa dicek di website kampus atau tanya ke bagian kemahasiswaan."
	}
	
	return info[topic] or "Untuk info lebih detail, coba cek website fakultas atau hubungi admin ya."
end

return BuRatna
