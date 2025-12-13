--[[
	Main Menu System
	Fungsi: Menu utama saat player join (New Game / Continue)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEvent untuk komunikasi dengan server
local MainMenuRemote = Instance.new("RemoteEvent")
MainMenuRemote.Name = "MainMenuRemote"
MainMenuRemote.Parent = ReplicatedStorage

local hasShownMenu = false

-- Create Main Menu UI
local function createMainMenuUI(hasSaveData)
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "MainMenuUI"
	screenGui.DisplayOrder = 100
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	-- Background overlay
	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.3
	overlay.BorderSizePixel = 0
	overlay.Parent = screenGui
	
	-- Main container
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0.5, 0, 0.6, 0)
	container.Position = UDim2.new(0.25, 0, 0.2, 0)
	container.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	container.BorderSizePixel = 0
	container.Parent = screenGui
	
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 16)
	containerCorner.Parent = container
	
	-- Title
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -40, 0, 80)
	title.Position = UDim2.new(0, 20, 0, 20)
	title.BackgroundTransparency = 1
	title.Text = "UPN LIFE JOURNEY\nTO THE CAP & GOWN"
	title.TextColor3 = Color3.fromRGB(255, 220, 100)
	title.TextSize = 32
	title.Font = Enum.Font.GothamBold
	title.TextWrapped = true
	title.Parent = container
	
	-- Subtitle
	local subtitle = Instance.new("TextLabel")
	subtitle.Size = UDim2.new(1, -40, 0, 40)
	subtitle.Position = UDim2.new(0, 20, 0, 100)
	subtitle.BackgroundTransparency = 1
	subtitle.Text = "Pilih Mode Permainan"
	subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	subtitle.TextSize = 18
	subtitle.Font = Enum.Font.Gotham
	subtitle.Parent = container
	
	-- Button container
	local btnContainer = Instance.new("Frame")
	btnContainer.Size = UDim2.new(1, -80, 0.4, 0)
	btnContainer.Position = UDim2.new(0, 40, 0.45, 0)
	btnContainer.BackgroundTransparency = 1
	btnContainer.Parent = container
	
	local btnLayout = Instance.new("UIListLayout")
	btnLayout.Padding = UDim.new(0, 15)
	btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	btnLayout.Parent = btnContainer
	
	-- Function to create button
	local function createButton(text, color, order)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 60)
		btn.BackgroundColor3 = color
		btn.Text = text
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.TextSize = 20
		btn.Font = Enum.Font.GothamBold
		btn.LayoutOrder = order
		btn.Parent = btnContainer
		
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 10)
		btnCorner.Parent = btn
		
		-- Hover effect
		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(
					math.min(color.R * 255 * 1.2, 255),
					math.min(color.G * 255 * 1.2, 255),
					math.min(color.B * 255 * 1.2, 255)
				)
			}):Play()
		end)
		
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.2), {
				BackgroundColor3 = color
			}):Play()
		end)
		
		return btn
	end
	
	-- Create buttons based on save data
	local newGameBtn, continueBtn
	
	if hasSaveData then
		continueBtn = createButton("🔄 LANJUTKAN PERMAINAN", Color3.fromRGB(50, 150, 50), 1)
		newGameBtn = createButton("🆕 PERMAINAN BARU", Color3.fromRGB(100, 100, 200), 2)
	else
		newGameBtn = createButton("🆕 MULAI PERMAINAN", Color3.fromRGB(50, 150, 50), 1)
	end
	
	-- Footer
	local footer = Instance.new("TextLabel")
	footer.Size = UDim2.new(1, -40, 0, 30)
	footer.Position = UDim2.new(0, 20, 1, -40)
	footer.BackgroundTransparency = 1
	footer.Text = "Controls: J = Quest Log | I = Inventory | WASD = Move"
	footer.TextColor3 = Color3.fromRGB(150, 150, 150)
	footer.TextSize = 12
	footer.Font = Enum.Font.Gotham
	footer.Parent = container
	
	return screenGui, newGameBtn, continueBtn
end

-- Close main menu
local function closeMainMenu(screenGui)
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	local container = screenGui:FindFirstChild("Frame")
	
	if container then
		local tween = TweenService:Create(container, tweenInfo, {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		})
		tween:Play()
	end
	
	task.wait(0.5)
	screenGui:Destroy()
end

-- Show main menu
local function showMainMenu(hasSaveData)
	if hasShownMenu then return end
	hasShownMenu = true
	
	local menuUI, newGameBtn, continueBtn = createMainMenuUI(hasSaveData)
	
	-- New Game handler
	newGameBtn.MouseButton1Click:Connect(function()
		print("🆕 Memulai permainan baru...")
		MainMenuRemote:FireServer("NewGame")
		closeMainMenu(menuUI)
	end)
	
	-- Continue handler
	if continueBtn then
		continueBtn.MouseButton1Click:Connect(function()
			print("🔄 Melanjutkan permainan...")
			MainMenuRemote:FireServer("Continue")
			closeMainMenu(menuUI)
		end)
	end
end

-- Request save data status dari server
local CheckSaveRemote = Instance.new("RemoteFunction")
CheckSaveRemote.Name = "CheckSaveRemote"
CheckSaveRemote.Parent = ReplicatedStorage

task.wait(1) 

local hasSaveData = CheckSaveRemote:InvokeServer()
showMainMenu(hasSaveData)

print("✅ Main Menu System initialized")
