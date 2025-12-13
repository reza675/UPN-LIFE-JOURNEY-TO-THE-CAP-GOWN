--[[
	Cutscene Manager
	Fungsi: Sistem untuk cinematic events
]]

local CutsceneManager = {}

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Active cutscenes
local activeCutscenes = {}

-- Cutscene data
local CUTSCENES = {
	Intro = {
		Name = "Opening - First Day",
		Duration = 15,
		Sequence = {
			{
				Type = "FadeIn",
				Duration = 2,
				Color = Color3.fromRGB(0, 0, 0)
			},
			{
				Type = "CameraMove",
				Duration = 5,
				StartCFrame = CFrame.new(100, 20, 100) * CFrame.Angles(math.rad(-20), 0, 0),
				EndCFrame = CFrame.new(80, 15, 80) * CFrame.Angles(math.rad(-15), math.rad(30), 0)
			},
			{
				Type = "ShowText",
				Duration = 3,
				Text = "UPN Veteran Jawa Timur\nHari Pertama Kuliah...",
				Position = UDim2.new(0.5, 0, 0.7, 0)
			},
			{
				Type = "FadeOut",
				Duration = 2,
				Color = Color3.fromRGB(0, 0, 0)
			}
		}
	},
	
	HorrorLibrary = {
		Name = "Listrik Padam - Perpustakaan",
		Duration = 12,
		Sequence = {
			{
				Type = "LightingChange",
				Duration = 1,
				Brightness = 0,
				Ambient = Color3.fromRGB(10, 10, 20)
			},
			{
				Type = "CameraShake",
				Duration = 2,
				Intensity = 0.5
			},
			{
				Type = "ShowText",
				Duration = 4,
				Text = "Listrik tiba-tiba padam...\nSesuatu terasa tidak beres...",
				Position = UDim2.new(0.5, 0, 0.5, 0),
				TextColor = Color3.fromRGB(255, 100, 100)
			},
			{
				Type = "LightingChange",
				Duration = 2,
				Brightness = 1,
				Ambient = Color3.fromRGB(150, 150, 150)
			}
		}
	},
	
	RomanceConfession = {
		Name = "Confession Scene",
		Duration = 10,
		Sequence = {
			{
				Type = "CameraFocus",
				Duration = 3,
				Target = "Kirana", -- NPC name
				Distance = 5,
				Angle = CFrame.Angles(0, math.rad(30), 0)
			},
			{
				Type = "ShowText",
				Duration = 5,
				Text = "Di taman kampus yang tenang...\nSebuah cerita baru dimulai...",
				Position = UDim2.new(0.5, 0, 0.8, 0),
				TextColor = Color3.fromRGB(255, 180, 200)
			}
		}
	},
	
	Graduation = {
		Name = "Wisuda - Ending",
		Duration = 20,
		Sequence = {
			{
				Type = "FadeIn",
				Duration = 2,
				Color = Color3.fromRGB(255, 255, 255)
			},
			{
				Type = "ShowText",
				Duration = 5,
				Text = "4 Tahun Berlalu...\nHari Yang Ditunggu Akhirnya Tiba",
				Position = UDim2.new(0.5, 0, 0.5, 0),
				TextColor = Color3.fromRGB(255, 220, 100)
			},
			{
				Type = "CameraMove",
				Duration = 8,
				StartCFrame = CFrame.new(0, 50, 100) * CFrame.Angles(math.rad(-30), 0, 0),
				EndCFrame = CFrame.new(0, 10, 50) * CFrame.Angles(math.rad(-10), 0, 0)
			},
			{
				Type = "FadeOut",
				Duration = 3,
				Color = Color3.fromRGB(255, 255, 255)
			}
		}
	}
}

-- Play cutscene for player
function CutsceneManager.Play(player, cutsceneId, customData)
	local cutscene = CUTSCENES[cutsceneId]
	if not cutscene then
		warn("⚠️ Cutscene not found: " .. tostring(cutsceneId))
		return false
	end
	
	print("🎬 Playing cutscene: " .. cutscene.Name .. " for " .. player.Name)
	
	-- Fire to client to play cutscene
	local CutsceneRemote = game:GetService("ReplicatedStorage"):FindFirstChild("CutsceneRemote")
	if not CutsceneRemote then
		CutsceneRemote = Instance.new("RemoteEvent")
		CutsceneRemote.Name = "CutsceneRemote"
		CutsceneRemote.Parent = game:GetService("ReplicatedStorage")
	end
	
	CutsceneRemote:FireClient(player, "PlayCutscene", {
		Id = cutsceneId,
		Data = cutscene,
		CustomData = customData
	})
	
	-- Track active cutscene
	activeCutscenes[player.UserId] = {
		CutsceneId = cutsceneId,
		StartTime = os.time()
	}
	
	-- Clear after duration
	task.delay(cutscene.Duration + 2, function()
		activeCutscenes[player.UserId] = nil
	end)
	
	return true
end

-- Check if player is in cutscene
function CutsceneManager.IsInCutscene(player)
	return activeCutscenes[player.UserId] ~= nil
end

-- Stop cutscene
function CutsceneManager.Stop(player)
	if not activeCutscenes[player.UserId] then
		return false
	end
	
	local CutsceneRemote = game:GetService("ReplicatedStorage"):FindFirstChild("CutsceneRemote")
	if CutsceneRemote then
		CutsceneRemote:FireClient(player, "StopCutscene")
	end
	
	activeCutscenes[player.UserId] = nil
	print("⏹️ Cutscene stopped for: " .. player.Name)
	
	return true
end

return CutsceneManager
