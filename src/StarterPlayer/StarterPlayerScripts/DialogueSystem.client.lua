-- DialogueSystem Client - ENABLED
warn("🔥🔥🔥 DIALOGUESYSTEM STARTING 🔥🔥🔥")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("👤 [CLIENT] Player:", player.Name)
print("🖥️ [CLIENT] PlayerGui:", playerGui)

-- RemoteEvents
print("🔗 [CLIENT] Waiting for DialogueRemote...")
local DialogueRemote = ReplicatedStorage:WaitForChild("DialogueRemote", 10)

if not DialogueRemote then
	warn("❌ [CLIENT] DialogueRemote tidak ditemukan!")
	return
end

print("✅ [CLIENT] DialogueRemote found:", DialogueRemote)

local QuestRemote = ReplicatedStorage:WaitForChild("QuestRemote", 10)

if not QuestRemote then
	warn("❌ QuestRemote not found!")
end

-- State
local currentDialogue = nil
local currentDialogueIndex = 1
local isDialogueActive = false

-- Buat UI Structure
local function createDialogueUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "DialogueUI"
	screenGui.DisplayOrder = 10
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	-- Container
	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(0.8, 0, 0.25, 0)
	container.Position = UDim2.new(0.1, 0, 1, 0) -- Start off-screen
	container.AnchorPoint = Vector2.new(0, 1)
	container.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	container.BorderSizePixel = 0
	container.Parent = screenGui
	
	-- Rounded corners
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = container
	
	-- NPC Name Label
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "NameLabel"
	nameLabel.Size = UDim2.new(1, -20, 0, 30)
	nameLabel.Position = UDim2.new(0, 10, 0, 5)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = "NPC Name"
	nameLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
	nameLabel.TextSize = 20
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = container
	
	-- Role Label
	local roleLabel = Instance.new("TextLabel")
	roleLabel.Name = "RoleLabel"
	roleLabel.Size = UDim2.new(1, -20, 0, 20)
	roleLabel.Position = UDim2.new(0, 10, 0, 35)
	roleLabel.BackgroundTransparency = 1
	roleLabel.Text = "Role"
	roleLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	roleLabel.TextSize = 14
	roleLabel.Font = Enum.Font.Gotham
	roleLabel.TextXAlignment = Enum.TextXAlignment.Left
	roleLabel.Parent = container
	
	-- Dialogue Text
	local dialogueText = Instance.new("TextLabel")
	dialogueText.Name = "DialogueText"
	dialogueText.Size = UDim2.new(1, -20, 0.6, -10)
	dialogueText.Position = UDim2.new(0, 10, 0.4, 0)
	dialogueText.BackgroundTransparency = 1
	dialogueText.Text = "Dialogue text here..."
	dialogueText.TextColor3 = Color3.fromRGB(255, 255, 255)
	dialogueText.TextSize = 16
	dialogueText.Font = Enum.Font.Gotham
	dialogueText.TextXAlignment = Enum.TextXAlignment.Left
	dialogueText.TextYAlignment = Enum.TextYAlignment.Top
	dialogueText.TextWrapped = true
	dialogueText.Parent = container
	
	-- Continue Button
	local continueBtn = Instance.new("TextButton")
	continueBtn.Name = "ContinueButton"
	continueBtn.Size = UDim2.new(0.3, 0, 0.15, 0)
	continueBtn.Position = UDim2.new(0.65, 0, 0.8, 0)
	continueBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
	continueBtn.Text = "Lanjut [SPACE]"
	continueBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	continueBtn.TextSize = 14
	continueBtn.Font = Enum.Font.GothamBold
	continueBtn.Parent = container
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = continueBtn
	
	-- Choice Container (untuk dialog bercabang)
	local choiceContainer = Instance.new("Frame")
	choiceContainer.Name = "ChoiceContainer"
	choiceContainer.Size = UDim2.new(1, -20, 0.35, 0)
	choiceContainer.Position = UDim2.new(0, 10, 0.6, 0)
	choiceContainer.BackgroundTransparency = 1
	choiceContainer.Visible = false
	choiceContainer.Parent = container
	
	local choiceLayout = Instance.new("UIListLayout")
	choiceLayout.Padding = UDim.new(0, 8)
	choiceLayout.FillDirection = Enum.FillDirection.Vertical
	choiceLayout.Parent = choiceContainer
	
	return screenGui
end

-- Show dialogue dengan animasi
local function showDialogueUI(dialogueUI)
	local container = dialogueUI.Container
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local tween = TweenService:Create(container, tweenInfo, {
		Position = UDim2.new(0.1, 0, 0.75, 0)
	})
	tween:Play()
	isDialogueActive = true
end

-- Hide dialogue dengan animasi
local function hideDialogueUI(dialogueUI)
	isDialogueActive = false
	
	local container = dialogueUI.Container
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	local tween = TweenService:Create(container, tweenInfo, {
		Position = UDim2.new(0.1, 0, 1, 0)
	})
	
	tween.Completed:Connect(function()
		dialogueUI:Destroy()
	end)
	
	tween:Play()
end

-- Update dialogue text
local function updateDialogue(dialogueUI, npcData, index)
	local container = dialogueUI.Container
	local dialogue = npcData.Dialogues[index]
	
	if not dialogue then return end
	
	container.NameLabel.Text = npcData.NPCName
	container.RoleLabel.Text = npcData.Role
	
	-- Support both string and table format
	local dialogueText = type(dialogue) == "string" and dialogue or dialogue.Text
	container.DialogueText.Text = dialogueText or "..."
	
	container.ChoiceContainer.Visible = false
	container.ContinueButton.Visible = true
	if dialogue.Choices and #dialogue.Choices > 0 then
		container.ContinueButton.Visible = false
		container.ChoiceContainer.Visible = true
		
		for _, child in ipairs(container.ChoiceContainer:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end
		
		for i, choice in ipairs(dialogue.Choices) do
			local choiceBtn = Instance.new("TextButton")
			choiceBtn.Size = UDim2.new(1, 0, 0, 40)
			choiceBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
			choiceBtn.Text = choice.Text
			choiceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			choiceBtn.TextSize = 14
			choiceBtn.Font = Enum.Font.Gotham
			choiceBtn.Parent = container.ChoiceContainer
			
			local choiceCorner = Instance.new("UICorner")
			choiceCorner.CornerRadius = UDim.new(0, 6)
			choiceCorner.Parent = choiceBtn
			
			choiceBtn.MouseButton1Click:Connect(function()
				-- Handle choice logic
				print("Pilihan dipilih:", choice.Text)
				-- Bisa trigger quest atau story event
				if choice.QuestId then
					QuestRemote:FireServer("StartQuest", choice.QuestId)
				end
				hideDialogueUI(dialogueUI)
			end)
		end
	end
end

-- Main dialogue handler
local function handleDialogue(npcData)
	print("🎬 [CLIENT] handleDialogue dipanggil")
	
	local dialogueUI = playerGui:FindFirstChild("DialogueUI")
	if not dialogueUI then
		print("🎨 [CLIENT] Membuat DialogueUI baru...")
		dialogueUI = createDialogueUI()
	else
		print("✅ [CLIENT] DialogueUI sudah ada")
	end
	
	currentDialogue = npcData
	currentDialogueIndex = 1
	
	print("📝 [CLIENT] Update dialogue index 1")
	updateDialogue(dialogueUI, npcData, currentDialogueIndex)
	
	print("📺 [CLIENT] Show dialogue UI")
	showDialogueUI(dialogueUI)
	
	-- Continue button handler
	local container = dialogueUI.Container
	local continueBtn = container.ContinueButton
	
	local connection
	connection = continueBtn.MouseButton1Click:Connect(function()
		currentDialogueIndex = currentDialogueIndex + 1
		
		if currentDialogueIndex <= #npcData.Dialogues then
			updateDialogue(dialogueUI, npcData, currentDialogueIndex)
		else
			-- Dialog selesai
			connection:Disconnect()
			hideDialogueUI(dialogueUI)
			currentDialogue = nil
			currentDialogueIndex = 1
		end
	end)
end

-- Listen untuk dialogue dari server
DialogueRemote.OnClientEvent:Connect(function(npcData)
	print("📩 [CLIENT] Menerima dialogue data dari server:")
	print("  - NPC Name:", npcData.NPCName)
	print("  - Role:", npcData.Role)
	print("  - Dialogues count:", npcData.Dialogues and #npcData.Dialogues or "nil")
	print("  - Dialogues type:", type(npcData.Dialogues))
	
	local success, err = pcall(function()
		handleDialogue(npcData)
	end)
	
	if not success then
		warn("❌ Error saat handle dialogue:", err)
	end
end)

-- Keyboard shortcut (SPACE untuk continue)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or not isDialogueActive then return end
	
	if input.KeyCode == Enum.KeyCode.Space then
		local dialogueUI = playerGui:FindFirstChild("DialogueUI")
		if dialogueUI and dialogueUI.Container.ContinueButton.Visible then
			dialogueUI.Container.ContinueButton.MouseButton1Click:Fire()
		end
	end
end)

print("✅ Dialogue System initialized")
