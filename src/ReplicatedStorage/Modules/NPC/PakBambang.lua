local PakBambang = {}

-- Data NPC Pak Bambang
PakBambang.Info = {
	Name = "Pak Bambang",
	Role = "Satpam/Security Campus",
	Personality = "Tegas, Humoris, Peduli",
	Shift = "Siang & Malam",
	Description = "Satpam kampus yang tegas tapi punya sisi humoris"
}

-- Dialog Pak Bambang
PakBambang.Dialogues = {
	Greeting = {
		"Pagi/Siang/Malam! KTM-nya mana?",
		"Mahasiswa? Tunjukkan identitas dulu.",
		"Eh kamu, kemana aja? Jarang keliatan!"
	},
	
	Strict = {
		"Eh, helm harus dipake! Keselamatan nomor satu!",
		"Parkir yang bener dong, jangan sembarangan!",
		"Kampus sudah tutup, mahasiswa harus pulang!",
		"Ngapain masih di kampus jam segini? Udah malem!"
	},
	
	Friendly = {
		"Kuliah dimana? Oh jurusan itu ya, bagus!",
		"Rajin-rajin kuliah ya, jangan sering bolos!",
		"Hati-hati di jalan, terutama kalau pulang malem.",
		"Eh ada acara kampus ya hari ini? Rame banget."
	},
	
	Humorous = {
		"Kalau ketemu pacar di kampus, jangan lupa parkir kendaraan dulu ya hahaha!",
		"Mahasiswa sekarang makin pinter aja, beda sama jaman saya dulu.",
		"Eh, kamu kok tiap hari lewat sini? Jangan-jangan ada yang 'dituju' nih!",
		"Jaga kesehatan, jangan sampai sakit gara-gara begadang ngerjain tugas!"
	},
	
	Warning = {
		"Hati-hati sama barang berharga, jangan ditaruh sembarangan!",
		"Kalau ada orang mencurigakan, lapor ke saya ya!",
		"Jangan tinggalkan motor tanpa dikunci, banyak maling!",
		"Gedung sebelah lagi renovasi, jangan lewat sana ya bahaya!"
	},
	
	NightShift = {
		"Masih di kampus jam segini? Ngerjain tugas ya?",
		"Lab sudah tutup jam 9 malam, jangan lupa keluar!",
		"Parkiran sudah sepi nih, hati-hati ya pulangnya.",
		"Ada suara aneh dari gedung lama... eh, jangan takut ya hahaha!"
	}
}

-- Fungsi untuk interact
function PakBambang.Interact(player, context, timeOfDay)
	context = context or "Greeting"
	
	-- Special case untuk malam hari
	if timeOfDay == "Night" and context ~= "NightShift" then
		context = "NightShift"
	end
	
	local dialogues = PakBambang.Dialogues[context]
	
	if dialogues then
		return dialogues[math.random(1, #dialogues)]
	end
	
	return "Ada perlu apa?"
end

-- Fungsi untuk cek akses area tertentu
function PakBambang.CheckAccess(player, area, hasPermit)
	local restrictedAreas = {
		["GedungLama"] = "Gedung itu lagi dalam perbaikan, nggak boleh masuk!",
		["LabMalam"] = "Lab sudah tutup, kalau mau masuk harus ada surat izin dari dosen!",
		["KantorDekan"] = "Ruangan Dekan nggak bisa sembarangan masuk, ada perlu apa?",
		["RuangServer"] = "Area terbatas! Cuma IT support yang boleh masuk!"
	}
	
	if restrictedAreas[area] and not hasPermit then
		return false, restrictedAreas[area]
	end
	
	return true, "Silakan masuk, tapi jangan lama-lama ya!"
end

-- Fungsi untuk memberikan tips keamanan
function PakBambang.SecurityTips()
	local tips = {
		"Selalu kunci motor dan simpan helm dalam bagasi.",
		"Jangan tinggalkan tas atau laptop di tempat umum tanpa pengawasan.",
		"Kalau pulang malam, usahakan bareng teman atau naik transportasi online.",
		"Jaga barang berharga seperti HP, laptop, dan dompet dengan baik.",
		"Kalau ada yang mencurigakan, langsung lapor ke security terdekat."
	}
	
	return tips[math.random(1, #tips)]
end

-- Fungsi untuk quest-related interaction
function PakBambang.QuestInteraction(questType)
	if questType == "Horror_GedungTua" then
		return "Gedung lama? Hati-hati ya, katanya sering ada yang aneh di sana... tapi mungkin cuma rumor aja sih."
	elseif questType == "Horror_LabMalam" then
		return "Mau ke lab malam-malam? Bawa surat izin dari dosen dong!"
	elseif questType == "Sneak_Mission" then
		return "Eh, ngapain kamu? Jangan macam-macam ya!"
	end
	
	return "Ada yang bisa saya bantu?"
end

return PakBambang
