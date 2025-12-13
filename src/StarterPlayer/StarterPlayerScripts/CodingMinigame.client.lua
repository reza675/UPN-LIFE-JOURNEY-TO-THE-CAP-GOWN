--[[
	Coding Mini-Game System
	Fungsi: Mini-game untuk quest programming
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Coding challenges
local CODING_CHALLENGES = {
	Beginner = {
		{
			Question = "Apa fungsi untuk mencetak teks di Lua?",
			Options = { "print()", "echo()", "console.log()", "System.out.println()" },
			CorrectAnswer = 1,
			Reward = 0.1
		},
		{
			Question = "Bagaimana cara membuat variable lokal di Lua?",
			Options = { "var x = 5", "local x = 5", "int x = 5", "let x = 5" },
			CorrectAnswer = 2,
			Reward = 0.1
		},
		{
			Question = "Operator untuk menggabungkan string di Lua adalah:",
			Options = { "+", "&", "..", "concat()" },
			CorrectAnswer = 3,
			Reward = 0.1
		}
	},
	Intermediate = {
		{
			Question = "Bagaimana cara membuat table kosong di Lua?",
			Options = { "table = []", "table = {}", "table = new Table()", "table = array()" },
			CorrectAnswer = 2,
			Reward = 0.15
		},
		{
			Question = "Loop untuk mengiterasi table di Lua:",
			Options = { "foreach", "for i in pairs()", "while", "loop" },
			CorrectAnswer = 2,
			Reward = 0.15
		}
	},
	Advanced = {
		{
			Question = "Apa output dari: print(type({})) ?",
			Options = { "array", "object", "table", "dictionary" },
			CorrectAnswer = 3,
			Reward = 0.2
		},
		{
			Question = "Bagaimana cara membuat coroutine di Lua?",
			Options = { "coroutine.create()", "async function", "new Thread()", "spawn()" },
			CorrectAnswer = 1,
			Reward = 0.2
		}
	}
}

-- State
local currentChallenge = nil
local currentQuestionIndex = 1
local totalCorrect = 0

-- RemoteEvent
local MinigameRemote = ReplicatedStorage:FindFirstChild("MinigameRemote")
if not MinigameRemote then
	MinigameRemote = Instance.new("RemoteEvent")
	MinigameRemote.Name = "MinigameRemote"
	MinigameRemote.Parent = ReplicatedStorage
end

-- Create Coding Minigame UI
local function createCodingUI(difficulty)
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CodingMinigameUI"
	screenGui.DisplayOrder = 50
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	-- Background overlay
	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.5
	overlay.BorderSizePixel = 0
	overlay.Parent = screenGui
	
	-- Main container
	local container = Instance.new("Frame")
	container.Name = "MainContainer"
	container.Size = UDim2.new(0.6, 0, 0.7, 0)
	container.Position = UDim2.new(0.2, 0, 0.15, 0)
	container.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	container.BorderSizePixel = 0
	container.Parent = screenGui
	
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 16)
	containerCorner.Parent = container
	
	-- Title
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -40, 0, 50)
	title.Position = UDim2.new(0, 20, 0, 10)
	title.BackgroundTransparency = 1
	title.Text = "💻 CODING CHALLENGE - " .. difficulty:upper()
	title.TextColor3 = Color3.fromRGB(100, 220, 255)
	title.TextSize = 24
	title.Font = Enum.Font.GothamBold
	title.Parent = container
	
	-- Progress bar
	local progressBg = Instance.new("Frame")
	progressBg.Size = UDim2.new(1, -40, 0, 8)
	progressBg.Position = UDim2.new(0, 20, 0, 65)
	progressBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	progressBg.BorderSizePixel = 0
	progressBg.Parent = container
	
	local progressBar = Instance.new("Frame")
	progressBar.Name = "ProgressBar"
	progressBar.Size = UDim2.new(0, 0, 1, 0)
	progressBar.BackgroundColor3 = Color3.fromRGB(100, 220, 255)
	progressBar.BorderSizePixel = 0
	progressBar.Parent = progressBg
	
	-- Question container
	local questionContainer = Instance.new("Frame")
	questionContainer.Name = "QuestionContainer"
	questionContainer.Size = UDim2.new(1, -40, 0.3, 0)
	questionContainer.Position = UDim2.new(0, 20, 0, 90)
	questionContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	questionContainer.BorderSizePixel = 0
	questionContainer.Parent = container
	
	local qCorner = Instance.new("UICorner")
	qCorner.CornerRadius = UDim.new(0, 12)
	qCorner.Parent = questionContainer
	
	local questionText = Instance.new("TextLabel")
	questionText.Name = "QuestionText"
	questionText.Size = UDim2.new(1, -20, 1, -20)
	questionText.Position = UDim2.new(0, 10, 0, 10)
	questionText.BackgroundTransparency = 1
	questionText.Text = "Loading question..."
	questionText.TextColor3 = Color3.fromRGB(255, 255, 255)
	questionText.TextSize = 20
	questionText.Font = Enum.Font.Gotham
	questionText.TextWrapped = true
	questionText.TextYAlignment = Enum.TextYAlignment.Top
	questionText.Parent = questionContainer
	
	-- Options container
	local optionsContainer = Instance.new("Frame")
	optionsContainer.Name = "OptionsContainer"
	optionsContainer.Size = UDim2.new(1, -40, 0.45, 0)
	optionsContainer.Position = UDim2.new(0, 20, 0.45, 0)
	optionsContainer.BackgroundTransparency = 1
	optionsContainer.Parent = container
	
	local optionsLayout = Instance.new("UIListLayout")
	optionsLayout.Padding = UDim.new(0, 10)
	optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	optionsLayout.Parent = optionsContainer
	
	-- Result label
	local resultLabel = Instance.new("TextLabel")
	resultLabel.Name = "ResultLabel"
	resultLabel.Size = UDim2.new(1, -40, 0, 40)
	resultLabel.Position = UDim2.new(0, 20, 0.92, 0)
	resultLabel.BackgroundTransparency = 1
	resultLabel.Text = ""
	resultLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	resultLabel.TextSize = 18
	resultLabel.Font = Enum.Font.GothamBold
	resultLabel.Visible = false
	resultLabel.Parent = container
	
	return screenGui
end

-- Update question
local function updateQuestion(screenGui, challenge, questionIndex)
	local container = screenGui.MainContainer
	local question = challenge[questionIndex]
	
	if not question then
		-- Selesai semua
		showResults(screenGui)
		return
	end
	
	-- Update progress
	local progress = (questionIndex - 1) / #challenge
	local progressBar = container:FindFirstChild("Frame"):FindFirstChild("ProgressBar")
	TweenService:Create(progressBar, TweenInfo.new(0.5), {
		Size = UDim2.new(progress, 0, 1, 0)
	}):Play()
	
	-- Update question text
	container.QuestionContainer.QuestionText.Text = questionIndex .. ". " .. question.Question
	
	-- Clear old options
	local optionsContainer = container.OptionsContainer
	for _, child in ipairs(optionsContainer:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	
	-- Create option buttons
	for i, option in ipairs(question.Options) do
		local optionBtn = Instance.new("TextButton")
		optionBtn.Name = "Option" .. i
		optionBtn.Size = UDim2.new(1, 0, 0, 60)
		optionBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
		optionBtn.Text = option
		optionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		optionBtn.TextSize = 16
		optionBtn.Font = Enum.Font.Gotham
		optionBtn.LayoutOrder = i
		optionBtn.Parent = optionsContainer
		
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 8)
		btnCorner.Parent = optionBtn
		
		-- Button click handler
		optionBtn.MouseButton1Click:Connect(function()
			handleAnswer(screenGui, challenge, questionIndex, i, question.CorrectAnswer)
		end)
		
		-- Hover effect
		optionBtn.MouseEnter:Connect(function()
			TweenService:Create(optionBtn, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(70, 70, 100)
			}):Play()
		end)
		
		optionBtn.MouseLeave:Connect(function()
			TweenService:Create(optionBtn, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(50, 50, 70)
			}):Play()
		end)
	end
end

-- Handle answer
function handleAnswer(screenGui, challenge, questionIndex, selectedAnswer, correctAnswer)
	local container = screenGui.MainContainer
	local resultLabel = container.ResultLabel
	local question = challenge[questionIndex]
	
	-- Disable all buttons
	for _, btn in ipairs(container.OptionsContainer:GetChildren()) do
		if btn:IsA("TextButton") then
			btn.Active = false
		end
	end
	
	-- Show result
	resultLabel.Visible = true
	
	if selectedAnswer == correctAnswer then
		resultLabel.Text = "✅ BENAR! +IPK"
		resultLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
		totalCorrect = totalCorrect + 1
		
		-- Visual feedback - correct answer turns green
		local correctBtn = container.OptionsContainer:FindFirstChild("Option" .. correctAnswer)
		if correctBtn then
			TweenService:Create(correctBtn, TweenInfo.new(0.3), {
				BackgroundColor3 = Color3.fromRGB(50, 200, 50)
			}):Play()
		end
	else
		resultLabel.Text = "❌ SALAH! Jawaban: " .. challenge[questionIndex].Options[correctAnswer]
		resultLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		
		-- Visual feedback - wrong turns red, correct turns green
		local wrongBtn = container.OptionsContainer:FindFirstChild("Option" .. selectedAnswer)
		if wrongBtn then
			TweenService:Create(wrongBtn, TweenInfo.new(0.3), {
				BackgroundColor3 = Color3.fromRGB(200, 50, 50)
			}):Play()
		end
		
		local correctBtn = container.OptionsContainer:FindFirstChild("Option" .. correctAnswer)
		if correctBtn then
			TweenService:Create(correctBtn, TweenInfo.new(0.3), {
				BackgroundColor3 = Color3.fromRGB(50, 200, 50)
			}):Play()
		end
	end
	
	-- Next question after delay
	task.wait(2)
	resultLabel.Visible = false
	currentQuestionIndex = currentQuestionIndex + 1
	updateQuestion(screenGui, challenge, currentQuestionIndex)
end

-- Show final results
function showResults(screenGui)
	local container = screenGui.MainContainer
	
	-- Clear everything
	container.QuestionContainer.QuestionText.Text = "SELESAI!"
	
	for _, child in ipairs(container.OptionsContainer:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	
	-- Calculate score
	local totalQuestions = #currentChallenge
	local percentage = (totalCorrect / totalQuestions) * 100
	local ipkGain = totalCorrect * (currentChallenge[1].Reward or 0.1)
	
	-- Result message
	local resultFrame = Instance.new("Frame")
	resultFrame.Size = UDim2.new(0.8, 0, 0.4, 0)
	resultFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
	resultFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	resultFrame.Parent = container
	
	local resultCorner = Instance.new("UICorner")
	resultCorner.CornerRadius = UDim.new(0, 12)
	resultCorner.Parent = resultFrame
	
	local scoreText = Instance.new("TextLabel")
	scoreText.Size = UDim2.new(1, -40, 0.3, 0)
	scoreText.Position = UDim2.new(0, 20, 0.1, 0)
	scoreText.BackgroundTransparency = 1
	scoreText.Text = string.format("Skor: %d/%d (%.0f%%)", totalCorrect, totalQuestions, percentage)
	scoreText.TextColor3 = Color3.fromRGB(255, 220, 100)
	scoreText.TextSize = 24
	scoreText.Font = Enum.Font.GothamBold
	scoreText.Parent = resultFrame
	
	local ipkText = Instance.new("TextLabel")
	ipkText.Size = UDim2.new(1, -40, 0.2, 0)
	ipkText.Position = UDim2.new(0, 20, 0.4, 0)
	ipkText.BackgroundTransparency = 1
	ipkText.Text = string.format("IPK +%.2f", ipkGain)
	ipkText.TextColor3 = Color3.fromRGB(100, 255, 100)
	ipkText.TextSize = 20
	ipkText.Font = Enum.Font.GothamBold
	ipkText.Parent = resultFrame
	
	-- Close button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0.4, 0, 0.2, 0)
	closeBtn.Position = UDim2.new(0.3, 0, 0.7, 0)
	closeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
	closeBtn.Text = "SELESAI"
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.TextSize = 18
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.Parent = resultFrame
	
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 8)
	closeCorner.Parent = closeBtn
	
	closeBtn.MouseButton1Click:Connect(function()
		-- Send results to server
		MinigameRemote:FireServer("CodingComplete", {
			TotalQuestions = totalQuestions,
			CorrectAnswers = totalCorrect,
			IPKGain = ipkGain
		})
		
		screenGui:Destroy()
	end)
end

-- Start minigame
local function startCodingMinigame(difficulty)
	difficulty = difficulty or "Beginner"
	
	currentChallenge = CODING_CHALLENGES[difficulty]
	currentQuestionIndex = 1
	totalCorrect = 0
	
	if not currentChallenge then
		warn("⚠️ Difficulty tidak ditemukan: " .. difficulty)
		return
	end
	
	local ui = createCodingUI(difficulty)
	updateQuestion(ui, currentChallenge, currentQuestionIndex)
end

-- Listen untuk start minigame dari server/NPC
MinigameRemote.OnClientEvent:Connect(function(action, data)
	if action == "StartCoding" then
		local difficulty = data.Difficulty or "Beginner"
		startCodingMinigame(difficulty)
	end
end)

-- Export function for testing
_G.StartCodingMinigame = startCodingMinigame

print("✅ Coding Minigame System initialized")
print("📝 Test dengan: _G.StartCodingMinigame('Beginner')")
