local PlayerData = {}

local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService") 
local PlayerDataStore = DataStoreService:GetDataStore("PlayerDataStore_v1")

local sessionData = {}

-- Data default pemain 
local DEFAULT_DATA = {
	Semester = 1,          
	IPK = 0.00,            
	Reputation = 50,       
	Money = 50000,         
	CurrentStory = "Intro",
	Inventory = {},        
	CompletedQuests = {},
	StoryChoices = {},     -- Track player kalau ada branching story
	LastPlayed = os.time()
}

-- kloning tabel secara rekursif
local function deepClone(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			copy[k] = deepClone(v)
		else
			copy[k] = v
		end
	end
	return copy
end

-- Inisialisasi Data saat Player Join
function PlayerData.Init(player)
	local userId = player.UserId
	local success, savedData = pcall(function()
		return PlayerDataStore:GetAsync(userId)
	end)
	
	if success and savedData then
		-- Load data dari DataStore
		sessionData[userId] = savedData
		sessionData[userId].LastPlayed = os.time()
		print("✅ Data loaded dari DataStore untuk: " .. player.Name)
	else
		-- Buat data baru jika belum ada
		sessionData[userId] = deepClone(DEFAULT_DATA)
		print("🆕 Data baru dibuat untuk: " .. player.Name)
		if not success then
			warn("⚠️ Gagal load DataStore: " .. tostring(savedData))
		end
	end
	
	-- Buat leaderstats untuk UI
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local sem = Instance.new("IntValue")
	sem.Name = "Semester"
	sem.Value = sessionData[userId].Semester
	sem.Parent = leaderstats

	local ipk = Instance.new("NumberValue")
	ipk.Name = "IPK"
	ipk.Value = sessionData[userId].IPK
	ipk.Parent = leaderstats
end

-- Mengambil data pemain
function PlayerData.Get(player)
	return sessionData[player.UserId]
end

-- Update IPK 
function PlayerData.UpdateIPK(player, amount)
	local data = sessionData[player.UserId]
	if data then
		data.IPK = math.clamp(data.IPK + amount, 0.00, 4.00)
		player.leaderstats.IPK.Value = data.IPK 
		-- Auto-save setelah update penting
		PlayerData.Save(player)
	end
end

-- Update Semester
function PlayerData.UpdateSemester(player, newSemester)
	local data = sessionData[player.UserId]
	if data then
		data.Semester = newSemester
		player.leaderstats.Semester.Value = newSemester
		PlayerData.Save(player)
	end
end

-- Menambah Item ke Inventaris 
function PlayerData.AddItem(player, itemName)
	local data = sessionData[player.UserId]
	if data then
		table.insert(data.Inventory, itemName)
		print("📦 Item ditambahkan: " .. itemName)
	end
end

-- Track Story Choice untuk branching
function PlayerData.AddStoryChoice(player, choiceId, choiceValue)
	local data = sessionData[player.UserId]
	if data then
		data.StoryChoices[choiceId] = choiceValue
	end
end

-- Save data ke DataStore
function PlayerData.Save(player)
	local userId = player.UserId
	local data = sessionData[userId]
	
	if not data then
		warn("⚠️ Tidak ada data untuk disimpan: " .. player.Name)
		return false
	end
	
	local success, errorMsg = pcall(function()
		PlayerDataStore:SetAsync(userId, data)
	end)
	
	if success then
		print("💾 Data tersimpan untuk: " .. player.Name)
		return true
	else
		warn("❌ Gagal menyimpan data: " .. tostring(errorMsg))
		return false
	end
end

-- Hapus data saat keluar (dengan auto-save)
function PlayerData.Remove(player)
	-- Save sebelum remove
	PlayerData.Save(player)
	sessionData[player.UserId] = nil
	print("👋 Data player dihapus dari session: " .. player.Name)
end

return PlayerData