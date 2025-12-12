local PlayerData = {}

local sessionData = {}

-- Data default pemain 
local DEFAULT_DATA = {
	Semester = 1,          
	IPK = 0.00,            
	Reputation = 50,       
	Money = 50000,         
	CurrentStory = "Intro",
	Inventory = {},        
	CompletedQuests = {}   
}

-- Inisialisasi Data saat Player Join
function PlayerData.Init(player)
	sessionData[player.UserId] = table.clone(DEFAULT_DATA)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local sem = Instance.new("IntValue")
	sem.Name = "Semester"
	sem.Value = sessionData[player.UserId].Semester
	sem.Parent = leaderstats

	local ipk = Instance.new("NumberValue")
	ipk.Name = "IPK"
	ipk.Value = sessionData[player.UserId].IPK
	ipk.Parent = leaderstats
	
	print("✅ Data dimuat untuk: " .. player.Name)
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

-- Hapus data saat keluar
function PlayerData.Remove(player)
	sessionData[player.UserId] = nil
end

return PlayerData