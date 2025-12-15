local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")

print("🚀 NPCManager starting...")

-- Load semua modul NPC dengan error handling
local NPCModules = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("NPC")
local NPCList = {}

local npcNames = {"Bayu", "BuRatna", "Citra", "Kirana", "PakBambang", "PakEdo"}

for _, npcName in ipairs(npcNames) do
	local success, result = pcall(function()
		local npcModule = NPCModules:FindFirstChild(npcName)
		if npcModule then
			return require(npcModule)
		else
			warn("⚠️ Module tidak ditemukan: " .. npcName)
			return nil
		end
	end)
	
	if success and result then
		NPCList[npcName] = result
		print("✅ Module loaded: " .. npcName)
	else
		warn("❌ Error loading module " .. npcName .. ": " .. tostring(result))
	end
end

local count = 0
for _ in pairs(NPCList) do count = count + 1 end
print("📦 Total NPC modules loaded: " .. count)

-- RemoteEvent untuk komunikasi dengan Client
local DialogueRemote = Instance.new("RemoteEvent")
DialogueRemote.Name = "DialogueRemote"
DialogueRemote.Parent = ReplicatedStorage

-- Setup ProximityPrompt untuk satu NPC
local function setupNPC(npcModel, npcData, npcName)
	if not npcModel or not npcModel:IsA("Model") then
		warn("⚠️ Model NPC tidak ditemukan: " .. npcName)
		return
	end
	
	local rootPart = npcModel:FindFirstChild("HumanoidRootPart") or npcModel:FindFirstChild("Head") or npcModel.PrimaryPart
	if not rootPart then
		warn("⚠️ NPC tidak memiliki HumanoidRootPart: " .. npcName)
		return
	end
	
	-- Get NPC info (support both Info.Name and direct Name)
	local npcInfo = npcData.Info or npcData
	local displayName = npcInfo.Name or npcName
	local role = npcInfo.Role or "NPC"
	
	-- Buat ProximityPrompt
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "TalkPrompt"
	prompt.ActionText = "Bicara dengan " .. displayName
	prompt.ObjectText = role
	prompt.MaxActivationDistance = 8
	prompt.HoldDuration = 0.5
	prompt.RequiresLineOfSight = false
	prompt.Parent = rootPart
	
	-- Event saat player berinteraksi
	prompt.Triggered:Connect(function(player)
		print("🗨️ Player " .. player.Name .. " berbicara dengan " .. displayName)
		
		-- Update quest objective "TalkTo" untuk NPC ini
		local QuestSystem = require(ReplicatedStorage.Modules.Core.QuestSystem)
		QuestSystem.UpdateObjectiveByTarget(player, "TalkTo", npcName)
		
		-- Tentukan dialogue category berdasarkan relationship (untuk sekarang pakai FirstMeet atau random)
		local PlayerData = require(ReplicatedStorage.Modules.Core.PlayerData)
		local data = PlayerData.Get(player)
		
		local dialogueCategory = "FirstMeet"
		if data and data.NPCRelationships and data.NPCRelationships[npcName] then
			local relationship = data.NPCRelationships[npcName]
			if relationship >= 75 then
				dialogueCategory = "Close"
			elseif relationship >= 50 then
				dialogueCategory = "Friendly"
			elseif relationship >= 25 then
				dialogueCategory = "Casual"
			end
		end
		
		-- Pilih dialogue yang tepat
		local dialogues = npcData.Dialogues[dialogueCategory] or npcData.Dialogues.FirstMeet or npcData.Dialogues
		
		-- Jika dialogues masih table dengan categories, ambil FirstMeet
		if type(dialogues[1]) == "table" and dialogues[1].FirstMeet then
			dialogues = dialogues[1].FirstMeet
		end
		
		-- Kirim data dialog ke Client
		DialogueRemote:FireClient(player, {
			NPCName = displayName,
			Role = role,
			Dialogues = dialogues,
			NPCId = npcName
		})
	end)
	
	print("✅ NPC Setup: " .. displayName)
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
			setupNPC(npcModel, npcData, npcName)
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
