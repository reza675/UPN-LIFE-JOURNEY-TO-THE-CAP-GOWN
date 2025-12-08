local MainQuest = {}

-- Diambil dari BAB 1–5 di design doc
MainQuest.Semesters = {
    [1] = {
        id = "SEM1_MABA",
        title = "Mahasiswa Baru",
        description = "Ikuti PKKBN, kenalan dengan senior dan teman seangkatan.",
        objectives = {
            "Datang ke lapangan upacara",
            "Bicara dengan Pak Bambang di gerbang",
            "Ikut tour kampus bersama Kusno & Wulan",
        },
    },
    [2] = {
        id = "SEM2_REAL_LIFE",
        title = "Semester Satu, Hidup Nyata Dimulai",
        -- dst…
    },
    -- lanjutkan 3–5 sesuai BAB di dokumen
}

return MainQuest
