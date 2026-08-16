local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local GUI_NAME = "CharacterSelector"

local PC_PANEL_WIDTH = 360
local PC_PANEL_HEIGHT = 430

local MOBILE_PANEL_WIDTH = 290
local MOBILE_PANEL_HEIGHT = 350

--==================================================
-- SCREEN GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

--==================================================
-- OPEN BUTTON
--==================================================

local openButton = Instance.new("TextButton")
openButton.Name = "CharacterButton"
openButton.Parent = gui

openButton.Position = UDim2.fromOffset(18, 18)
openButton.Size = UDim2.fromOffset(145, 48)

openButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
openButton.BackgroundTransparency = 0.05

openButton.Text = "CHARACTER"
openButton.TextColor3 = Color3.fromRGB(235, 235, 235)
openButton.TextSize = 14
openButton.Font = Enum.Font.GothamBold

openButton.BorderSizePixel = 0
openButton.AutoButtonColor = false

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 7)
openCorner.Parent = openButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(85, 85, 85)
openStroke.Thickness = 1
openStroke.Transparency = 0.2
openStroke.Parent = openButton

-- Accent

local accent = Instance.new("Frame")
accent.Parent = openButton

accent.Position = UDim2.fromOffset(8, 10)
accent.Size = UDim2.fromOffset(3, 28)

accent.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
accent.BorderSizePixel = 0

local accentCorner = Instance.new("UICorner")
accentCorner.CornerRadius = UDim.new(1, 0)
accentCorner.Parent = accent

--==================================================
-- MAIN PANEL
--==================================================

local panel = Instance.new("Frame")
panel.Name = "SelectorPanel"
panel.Parent = gui

panel.Position = UDim2.fromOffset(18, 78)
panel.Size = UDim2.fromOffset(
	PC_PANEL_WIDTH,
	PC_PANEL_HEIGHT
)

panel.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
panel.BackgroundTransparency = 0.03

panel.BorderSizePixel = 0
panel.Visible = false

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 10)
panelCorner.Parent = panel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(70, 70, 70)
panelStroke.Thickness = 1
panelStroke.Transparency = 0.15
panelStroke.Parent = panel

--==================================================
-- HEADER
--==================================================

local title = Instance.new("TextLabel")
title.Parent = panel

title.Position = UDim2.fromOffset(20, 18)
title.Size = UDim2.new(1, -80, 0, 28)

title.BackgroundTransparency = 1

title.Text = "CHARACTER SELECT"
title.TextColor3 = Color3.fromRGB(245, 245, 245)
title.TextSize = 19
title.Font = Enum.Font.GothamBold

title.TextXAlignment = Enum.TextXAlignment.Left

local subtitle = Instance.new("TextLabel")
subtitle.Parent = panel

subtitle.Position = UDim2.fromOffset(20, 47)
subtitle.Size = UDim2.new(1, -40, 0, 18)

subtitle.BackgroundTransparency = 1

subtitle.Text = "SELECT YOUR FIGHTER"
subtitle.TextColor3 = Color3.fromRGB(105, 105, 105)
subtitle.TextSize = 10
subtitle.Font = Enum.Font.GothamMedium

subtitle.TextXAlignment = Enum.TextXAlignment.Left

--==================================================
-- CLOSE BUTTON
--==================================================

local closeButton = Instance.new("TextButton")
closeButton.Parent = panel

closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.Position = UDim2.new(1, -15, 0, 15)
closeButton.Size = UDim2.fromOffset(34, 34)

closeButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)

closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(180, 180, 180)
closeButton.TextSize = 12
closeButton.Font = Enum.Font.GothamBold

closeButton.BorderSizePixel = 0
closeButton.AutoButtonColor = false

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

--==================================================
-- CHARACTER CARD
--==================================================

local card = Instance.new("TextButton")
card.Name = "Character01"
card.Parent = panel

card.Position = UDim2.fromOffset(20, 88)
card.Size = UDim2.new(1, -40, 0, 110)

card.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

card.Text = ""
card.BorderSizePixel = 0
card.AutoButtonColor = false

local cardCorner = Instance.new("UICorner")
cardCorner.CornerRadius = UDim.new(0, 8)
cardCorner.Parent = card

local cardStroke = Instance.new("UIStroke")
cardStroke.Color = Color3.fromRGB(55, 55, 55)
cardStroke.Thickness = 1
cardStroke.Parent = card

-- Character number

local number = Instance.new("TextLabel")
number.Parent = card

number.Position = UDim2.fromOffset(15, 14)
number.Size = UDim2.fromOffset(45, 18)

number.BackgroundTransparency = 1

number.Text = "01"
number.TextColor3 = Color3.fromRGB(100, 100, 100)
number.TextSize = 11
number.Font = Enum.Font.GothamBold

number.TextXAlignment = Enum.TextXAlignment.Left

-- Character name

local characterName = Instance.new("TextLabel")
characterName.Parent = card

characterName.Position = UDim2.fromOffset(15, 35)
characterName.Size = UDim2.new(1, -30, 0, 28)

characterName.BackgroundTransparency = 1

characterName.Text = "CHARACTER 01"
characterName.TextColor3 = Color3.fromRGB(240, 240, 240)
characterName.TextSize = 18
characterName.Font = Enum.Font.GothamBold

characterName.TextXAlignment = Enum.TextXAlignment.Left

-- Status

local status = Instance.new("TextLabel")
status.Parent = card

status.Position = UDim2.fromOffset(15, 68)
status.Size = UDim2.new(1, -30, 0, 18)

status.BackgroundTransparency = 1

status.Text = "AVAILABLE"
status.TextColor3 = Color3.fromRGB(120, 120, 120)
status.TextSize = 9
status.Font = Enum.Font.GothamMedium

status.TextXAlignment = Enum.TextXAlignment.Left

-- Selected line

local selectedLine = Instance.new("Frame")
selectedLine.Parent = card

selectedLine.Position = UDim2.new(1, -5, 0, 10)
selectedLine.Size = UDim2.new(0, 3, 1, -20)

selectedLine.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
selectedLine.BorderSizePixel = 0

local selectedCorner = Instance.new("UICorner")
selectedCorner.CornerRadius = UDim.new(1, 0)
selectedCorner.Parent = selectedLine

--==================================================
-- SELECT BUTTON
--==================================================

local selectButton = Instance.new("TextButton")
selectButton.Parent = panel

selectButton.Position = UDim2.fromOffset(20, 215)
selectButton.Size = UDim2.new(1, -40, 0, 48)

selectButton.BackgroundColor3 = Color3.fromRGB(225, 225, 225)

selectButton.Text = "SELECT"
selectButton.TextColor3 = Color3.fromRGB(15, 15, 15)
selectButton.TextSize = 13
selectButton.Font = Enum.Font.GothamBold

selectButton.BorderSizePixel = 0
selectButton.AutoButtonColor = false

local selectCorner = Instance.new("UICorner")
selectCorner.CornerRadius = UDim.new(0, 7)
selectCorner.Parent = selectButton

--==================================================
-- BOTTOM INFO
--==================================================

local info = Instance.new("TextLabel")
info.Parent = panel

info.Position = UDim2.fromOffset(20, 280)
info.Size = UDim2.new(1, -40, 0, 45)

info.BackgroundTransparency = 1

info.Text = "Character selection will be available here."
info.TextColor3 = Color3.fromRGB(85, 85, 85)
info.TextSize = 10
info.Font = Enum.Font.GothamMedium

info.TextWrapped = true
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Top

--==================================================
-- OPEN / CLOSE
--==================================================

local opened = false

local function openPanel()

	if opened then
		return
	end

	opened = true

	panel.Visible = true

	panel.Size = UDim2.fromOffset(
		PC_PANEL_WIDTH,
		0
	)

	TweenService:Create(
		panel,
		TweenInfo.new(
			0.22,
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out
		),
		{
			Size = UDim2.fromOffset(
				PC_PANEL_WIDTH,
				PC_PANEL_HEIGHT
			)
		}
	):Play()

end

local function closePanel()

	if not opened then
		return
	end

	opened = false

	local tween = TweenService:Create(
		panel,
		TweenInfo.new(
			0.16,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.In
		),
		{
			Size = UDim2.fromOffset(
				PC_PANEL_WIDTH,
				0
			)
		}
	)

	tween:Play()

	tween.Completed:Connect(function()

		if not opened then
			panel.Visible = false
		end

	end)

end

openButton.Activated:Connect(function()

	if opened then
		closePanel()
	else
		openPanel()
	end

end)

closeButton.Activated:Connect(closePanel)

--==================================================
-- HOVER EFFECTS
--==================================================

card.MouseEnter:Connect(function()

	TweenService:Create(
		card,
		TweenInfo.new(0.12),
		{
			BackgroundColor3 = Color3.fromRGB(27, 27, 27)
		}
	):Play()

end)

card.MouseLeave:Connect(function()

	TweenService:Create(
		card,
		TweenInfo.new(0.12),
		{
			BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		}
	):Play()

end)

--==================================================
-- SELECT
--==================================================

selectButton.Activated:Connect(function()

	-- Später kommt hier der echte Character-Wechsel hin.

	info.Text = "CHARACTER 01 SELECTED"

	TweenService:Create(
		selectButton,
		TweenInfo.new(0.08),
		{
			BackgroundColor3 = Color3.fromRGB(190, 190, 190)
		}
	):Play()

	task.wait(0.08)

	TweenService:Create(
		selectButton,
		TweenInfo.new(0.12),
		{
			BackgroundColor3 = Color3.fromRGB(225, 225, 225)
		}
	):Play()

end)

--==================================================
-- RESPONSIVE MOBILE
--==================================================

local function updateResponsive()

	local camera = workspace.CurrentCamera

	if not camera then
		return
	end

	local width = camera.ViewportSize.X

	local mobile =
		UserInputService.TouchEnabled
		and not UserInputService.KeyboardEnabled

	if mobile then

		openButton.Position = UDim2.fromOffset(10, 10)
		openButton.Size = UDim2.fromOffset(115, 42)
		openButton.TextSize = 12

		panel.Position = UDim2.fromOffset(10, 62)

		local panelWidth = math.min(
			MOBILE_PANEL_WIDTH,
			width - 20
		)

		panel.Size = UDim2.fromOffset(
			panelWidth,
			MOBILE_PANEL_HEIGHT
		)

	else

		openButton.Position = UDim2.fromOffset(18, 18)
		openButton.Size = UDim2.fromOffset(145, 48)
		openButton.TextSize = 14

		panel.Position = UDim2.fromOffset(18, 78)

		panel.Size = UDim2.fromOffset(
			PC_PANEL_WIDTH,
			PC_PANEL_HEIGHT
		)

	end

end

updateResponsive()

local camera = workspace.CurrentCamera

if camera then

	camera:GetPropertyChangedSignal("ViewportSize"):Connect(
		updateResponsive
	)

end