--[[
	Cutscene Player (Client)
	Fungsi: Menjalankan cutscene di client
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local playerGui = player:WaitForChild("PlayerGui")

-- State
local isPlaying = false
local originalCameraType = nil
local originalCameraSubject = nil

-- Create cutscene UI
local function createCutsceneUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CutsceneUI"
	screenGui.DisplayOrder = 100
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	-- Black bars (cinematic)
	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0.1, 0)
	topBar.Position = UDim2.new(0, 0, 0, 0)
	topBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	topBar.BorderSizePixel = 0
	topBar.Parent = screenGui
	
	local bottomBar = Instance.new("Frame")
	bottomBar.Name = "BottomBar"
	bottomBar.Size = UDim2.new(1, 0, 0.1, 0)
	bottomBar.Position = UDim2.new(0, 0, 0.9, 0)
	bottomBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bottomBar.BorderSizePixel = 0
	bottomBar.Parent = screenGui
	
	-- Fade overlay
	local fadeOverlay = Instance.new("Frame")
	fadeOverlay.Name = "FadeOverlay"
	fadeOverlay.Size = UDim2.new(1, 0, 1, 0)
	fadeOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	fadeOverlay.BackgroundTransparency = 1
	fadeOverlay.BorderSizePixel = 0
	fadeOverlay.ZIndex = 10
	fadeOverlay.Parent = screenGui
	
	-- Text label
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "CutsceneText"
	textLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
	textLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = ""
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextSize = 24
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextWrapped = true
	textLabel.TextTransparency = 1
	textLabel.Parent = screenGui
	
	return screenGui
end

-- Execute sequence step
local function executeStep(step, cutsceneUI)
	if step.Type == "FadeIn" then
		local overlay = cutsceneUI.FadeOverlay
		overlay.BackgroundColor3 = step.Color or Color3.fromRGB(0, 0, 0)
		overlay.BackgroundTransparency = 1
		
		TweenService:Create(overlay, TweenInfo.new(step.Duration), {
			BackgroundTransparency = 0
		}):Play()
		
	elseif step.Type == "FadeOut" then
		local overlay = cutsceneUI.FadeOverlay
		
		TweenService:Create(overlay, TweenInfo.new(step.Duration), {
			BackgroundTransparency = 1
		}):Play()
		
	elseif step.Type == "CameraMove" then
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = step.StartCFrame
		
		TweenService:Create(camera, TweenInfo.new(step.Duration, Enum.EasingStyle.Sine), {
			CFrame = step.EndCFrame
		}):Play()
		
	elseif step.Type == "CameraFocus" then
		-- Find target NPC
		local npcFolder = workspace:FindFirstChild("NPCs")
		if npcFolder then
			local npcModel = npcFolder:FindFirstChild(step.Target)
			if npcModel and npcModel:FindFirstChild("HumanoidRootPart") then
				camera.CameraType = Enum.CameraType.Scriptable
				local targetPos = npcModel.HumanoidRootPart.Position
				local offset = Vector3.new(0, 2, step.Distance or 5)
				
				local startCFrame = camera.CFrame
				local endCFrame = CFrame.new(targetPos + offset, targetPos) * (step.Angle or CFrame.new())
				
				TweenService:Create(camera, TweenInfo.new(step.Duration, Enum.EasingStyle.Sine), {
					CFrame = endCFrame
				}):Play()
			end
		end
		
	elseif step.Type == "ShowText" then
		local textLabel = cutsceneUI.CutsceneText
		textLabel.Text = step.Text
		textLabel.Position = step.Position or UDim2.new(0.1, 0, 0.4, 0)
		textLabel.TextColor3 = step.TextColor or Color3.fromRGB(255, 255, 255)
		textLabel.TextTransparency = 1
		
		-- Fade in text
		TweenService:Create(textLabel, TweenInfo.new(0.5), {
			TextTransparency = 0
		}):Play()
		
		-- Fade out before end
		task.wait(step.Duration - 0.5)
		TweenService:Create(textLabel, TweenInfo.new(0.5), {
			TextTransparency = 1
		}):Play()
		
	elseif step.Type == "LightingChange" then
		local originalBrightness = Lighting.Brightness
		local originalAmbient = Lighting.Ambient
		
		TweenService:Create(Lighting, TweenInfo.new(step.Duration), {
			Brightness = step.Brightness,
			Ambient = step.Ambient
		}):Play()
		
		-- Restore after cutscene
		task.delay(step.Duration + 2, function()
			TweenService:Create(Lighting, TweenInfo.new(2), {
				Brightness = originalBrightness,
				Ambient = originalAmbient
			}):Play()
		end)
		
	elseif step.Type == "CameraShake" then
		local originalCFrame = camera.CFrame
		local startTime = tick()
		local connection
		
		connection = game:GetService("RunService").RenderStepped:Connect(function()
			if tick() - startTime >= step.Duration then
				connection:Disconnect()
				return
			end
			
			local shake = CFrame.new(
				math.random(-step.Intensity, step.Intensity),
				math.random(-step.Intensity, step.Intensity),
				math.random(-step.Intensity, step.Intensity)
			)
			camera.CFrame = camera.CFrame * shake
		end)
	end
	
	return step.Duration or 0
end

-- Play cutscene
local function playCutscene(cutsceneData)
	if isPlaying then
		warn("⚠️ Cutscene sudah sedang dimainkan")
		return
	end
	
	isPlaying = true
	print("🎬 Playing cutscene: " .. cutsceneData.Data.Name)
	
	-- Save camera state
	originalCameraType = camera.CameraType
	originalCameraSubject = camera.CameraSubject
	
	-- Create UI
	local cutsceneUI = createCutsceneUI()
	
	-- Disable player controls
	player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 0
	
	-- Execute sequence
	task.spawn(function()
		for _, step in ipairs(cutsceneData.Data.Sequence) do
			local duration = executeStep(step, cutsceneUI)
			task.wait(duration)
		end
		
		-- Cleanup
		task.wait(1)
		stopCutscene(cutsceneUI)
	end)
end

-- Stop cutscene
function stopCutscene(cutsceneUI)
	if not isPlaying then return end
	
	isPlaying = false
	
	-- Restore camera
	camera.CameraType = originalCameraType or Enum.CameraType.Custom
	camera.CameraSubject = originalCameraSubject or player.Character:FindFirstChildOfClass("Humanoid")
	
	-- Restore player controls
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
	end
	
	-- Remove UI
	if cutsceneUI then
		cutsceneUI:Destroy()
	elseif playerGui:FindFirstChild("CutsceneUI") then
		playerGui.CutsceneUI:Destroy()
	end
	
	print("⏹️ Cutscene stopped")
end

-- Listen untuk cutscene events
local CutsceneRemote = ReplicatedStorage:WaitForChild("CutsceneRemote", 30)
if CutsceneRemote then
	CutsceneRemote.OnClientEvent:Connect(function(action, data)
		if action == "PlayCutscene" then
			playCutscene(data)
		elseif action == "StopCutscene" then
			stopCutscene()
		end
	end)
end

print("✅ Cutscene Player initialized")
