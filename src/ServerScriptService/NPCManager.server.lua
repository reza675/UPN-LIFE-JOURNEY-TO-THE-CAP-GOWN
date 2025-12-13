local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")

-- Load semua modul NPC
local NPCModules = ReplicatedStorage.Modules.NPC
local NPCList = {
	Bayu = require(NPCModules.Bayu),
	BuRatna = require(NPCModules.BuRatna),
	Citra = require(NPCModules.Citra),
	Kirana = require(NPCModules.Kirana),
	PakBambang = require(NPCModules.PakBambang),
	PakEdo = require(NPCModules.PakEdo)
}

-- RemoteEvent untuk komunikasi dengan Client
local DialogueRemote = Instance.new("RemoteEvent")
DialogueRemote.Name = "DialogueRemote"
DialogueRemote.Parent = ReplicatedStorage

-- Setup ProximityPrompt untuk satu NPC
local function setupNPC(npcModel, npcData)
	if not npcModel or not npcModel:IsA("Model") then
		warn("⚠️ Model NPC tidak ditemukan: " .. tostring(npcData.Name))
		return
	end
	
	local rootPart = npcModel:FindFirstChild("HumanoidRootPart") or npcModel.PrimaryPart
	if not rootPart then
		warn("⚠️ NPC tidak memiliki HumanoidRootPart: " .. npcData.Name)
		return
	end
	
	-- Buat ProximityPrompt
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "TalkPrompt"
	prompt.ActionText = "Bicara dengan " .. npcData.Name
	prompt.ObjectText = npcData.Role
	prompt.MaxActivationDistance = 8
	prompt.HoldDuration = 0.5
	prompt.RequiresLineOfSight = false
	prompt.Parent = rootPart
	
	-- Event saat player berinteraksi
	prompt.Triggered:Connect(function(player)
		print("🗨️ Player " .. player.Name .. " berbicara dengan " .. npcData.Name)
		
		-- Kirim data dialog ke Client
		DialogueRemote:FireClient(player, {
			NPCName = npcData.Name,
			Role = npcData.Role,
			Dialogues = npcData.Dialogues,
			NPCId = npcData.NPCId
		})
	end)
	
	print("✅ NPC Setup: " .. npcData.Name)
end

-- Scan Workspace untuk mencari NPC berdasarkan nama
local function initializeNPCs()
	print("🔄 Menginisialisasi NPC...")
	
	-- Cari folder NPCs di Workspace (asumsi model NPC ada di folder "NPCs")
	local npcFolder = workspace:WaitForChild("NPCs", 5)
	if not npcFolder then
		warn("⚠️ Folder 'NPCs' tidak ditemukan di Workspace!")
		return
	end
	
	-- Loop setiap NPC dari modul
	for npcName, npcData in pairs(NPCList) do
		local npcModel = npcFolder:FindFirstChild(npcName)
		if npcModel then
			setupNPC(npcModel, npcData)
		else
			warn("⚠️ Model NPC tidak ditemukan di Workspace: " .. npcName)
		end
	end
	
	print("✅ Semua NPC berhasil diinisialisasi!")
end

task.spawn(initializeNPCs)

-- Auto-save handler untuk semua player (setiap 5 menit)
local PlayerData = require(ReplicatedStorage.Modules.Core.PlayerData)
task.spawn(function()
	while true do
		task.wait(300) -- 5 menit
		for _, player in ipairs(game.Players:GetPlayers()) do
			PlayerData.Save(player)
		end
		print("💾 Auto-save completed untuk semua player")
	end
end)
