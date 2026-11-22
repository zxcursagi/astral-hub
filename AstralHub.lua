--!nocheck
-- ASTRAL HUB v2.0 | GitHub Module | Key ("soso1") | Aimbot + Silent Aim + Rage + ESP + 3D Skin Viewer

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

local CORRECT_KEY = "soso1"
local KEY_HOTKEY = Enum.KeyCode.Insert
local HUB_HOTKEY = Enum.KeyCode.RightShift

local Theme = {
	BgMain = Color3.fromRGB(16, 10, 30),
	BgCard = Color3.fromRGB(27, 17, 50),
	BgCardHover = Color3.fromRGB(38, 24, 70),
	BgInput = Color3.fromRGB(11, 7, 21),
	Stroke = Color3.fromRGB(139, 92, 246),
	Accent = Color3.fromRGB(168, 85, 247),
	AccentBright = Color3.fromRGB(192, 132, 252),
	SilentAccent = Color3.fromRGB(56, 189, 248),
	TextMain = Color3.fromRGB(245, 243, 255),
	TextMuted = Color3.fromRGB(167, 155, 204),
	Success = Color3.fromRGB(74, 222, 128),
	Error = Color3.fromRGB(248, 113, 113),
	GlassAlpha = 0.22
}

local AIM_MODES = { "Camera", "Snap", "Triggerbot" }
local TARGET_PARTS = { "Head", "HumanoidRootPart", "Nearest" }
local SILENT_PARTS = { "Head", "Neck", "Torso", "Arms", "Legs" }
local TRACER_ORIGINS = { "Bottom", "Center", "Mouse" }
local HITBOX_PARTS = { "HumanoidRootPart", "Head" }

local State = {
	KeyUnlocked = false,
	KeyWinVisible = false,
	HubVisible = false,
	Minimized = false,
	ActiveTab = "Aimbot",

	AimEnabled = false,
	AimMode = "Camera",
	TargetPartMode = "Head",
	AimHoldOnly = true,
	FOVEnabled = true,
	FOVRadius = 140,
	Smoothness = 0.22,
	Prediction = 0.12,
	TeamCheck = true,
	WallCheck = true,
	StickyTarget = true,
	TriggerDelay = 0.07,

	SilentEnabled = false,
	SilentPart = "Head",
	SilentFOVEnabled = true,
	SilentFOVRadius = 160,
	SilentHitChance = 100,
	SilentPrediction = 0.12,
	SilentWallCheck = true,
	SilentTeamCheck = true,

	SpinbotEnabled = false,
	SpinSpeed = 35,
	HitboxEnabled = false,
	HitboxPart = "HumanoidRootPart",
	HitboxSize = 7,
	HitboxTransparency = 0.75,
	RapidFireEnabled = false,
	RapidFireDelay = 0.04,
	AutoFireVisible = false,
	KillAuraEnabled = false,
	KillAuraRange = 16,
	NoClipEnabled = false,
	FlyEnabled = false,
	FlySpeed = 55,
	SpectateNearest = false,
	BHopEnabled = false,
	BHopBoost = 1.15,
	CFrameSpeedEnabled = false,
	CFrameSpeedMult = 1.4,
	GravityOverride = false,
	GravityValue = 95,
	AntiRagdollEnabled = false,
	OrbitTargetEnabled = false,
	OrbitRadius = 9,
	OrbitSpeed = 5,

	ESPEnabled = false,
	BoxESP = true,
	CornerBoxESP = false,
	TracerESP = true,
	TracerOrigin = "Bottom",
	SkeletonESP = true,
	InfoESP = true,
	ESPTeamCheck = true,
	ESPMaxDist = 900,

	BlurEnabled = true,
	BlurSize = 14,
	FOVOverride = false,
	CustomFOV = 70,
	WalkSpeedBoost = false,
	WalkSpeedVal = 24,
	CrosshairEnabled = false,
	CrosshairSize = 10,
	RadarHudEnabled = false,
	FullbrightEnabled = false,
	AntiAFKEnabled = false,

	SkinAutoRotate = true,
	SkinRotateSpeed = 35
}

local origAmbient = Lighting.Ambient
local origOutdoorAmbient = Lighting.OutdoorAmbient
local origBrightness = Lighting.Brightness
local origGravity = Workspace.Gravity

local oldGui = PlayerGui:FindFirstChild("AstralHubGui")
if oldGui then
	oldGui:Destroy()
end

local blurEffect = Lighting:FindFirstChild("AstralHubBlur")
if not blurEffect then
	blurEffect = Instance.new("BlurEffect")
	blurEffect.Name = "AstralHubBlur"
	blurEffect.Size = 0
	blurEffect.Parent = Lighting
end

local function updateBlur()
	if not blurEffect then
		return
	end
	local active = State.BlurEnabled and (State.HubVisible or State.KeyWinVisible) and not State.Minimized
	TweenService:Create(blurEffect, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Size = active and State.BlurSize or 0
	}):Play()
end

local function applyFullbright(enabled)
	if enabled then
		Lighting.Ambient = Color3.fromRGB(215, 215, 215)
		Lighting.OutdoorAmbient = Color3.fromRGB(215, 215, 215)
		Lighting.Brightness = 2
	else
		Lighting.Ambient = origAmbient
		Lighting.OutdoorAmbient = origOutdoorAmbient
		Lighting.Brightness = origBrightness
	end
end

local function applyGravity(enabled, val)
	Workspace.Gravity = enabled and val or origGravity
end

local function addCorner(obj, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = obj
end

local function addStroke(obj, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0.45
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = obj
	return s
end

local function makeDraggable(target, handle)
	local dragging = false
	local dragInput = nil
	local startPos = Vector2.zero
	local startFrame = UDim2.new()

	handle.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startPos = inp.Position
			startFrame = target.Position
			inp.Changed:Connect(function()
				if inp.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	handle.InputChanged:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
			dragInput = inp
		end
	end)

	UserInputService.InputChanged:Connect(function(inp)
		if inp == dragInput and dragging then
			local delta = inp.Position - startPos
			target.Position = UDim2.new(
				startFrame.X.Scale,
				startFrame.X.Offset + delta.X,
				startFrame.Y.Scale,
				startFrame.Y.Offset + delta.Y
			)
		end
	end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "AstralHubGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local notifHolder = Instance.new("Frame")
notifHolder.Size = UDim2.new(0, 300, 1, -24)
notifHolder.Position = UDim2.new(1, -314, 0, 12)
notifHolder.BackgroundTransparency = 1
notifHolder.Parent = gui

local notifList = Instance.new("UIListLayout")
notifList.Padding = UDim.new(0, 8)
notifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifList.HorizontalAlignment = Enum.HorizontalAlignment.Right
notifList.SortOrder = Enum.SortOrder.LayoutOrder
notifList.Parent = notifHolder

local function pushNotify(title, desc, isError)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 56)
	card.BackgroundColor3 = Theme.BgCard
	card.BackgroundTransparency = Theme.GlassAlpha
	card.ClipsDescendants = true
	card.Parent = notifHolder
	addCorner(card, 10)
	addStroke(card, isError and Theme.Error or Theme.Accent, 1.2, 0.25)

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(0, 4, 1, 0)
	bar.BackgroundColor3 = isError and Theme.Error or Theme.AccentBright
	bar.BorderSizePixel = 0
	bar.Parent = card

	local l1 = Instance.new("TextLabel")
	l1.Size = UDim2.new(1, -18, 0, 20)
	l1.Position = UDim2.new(0, 14, 0, 7)
	l1.BackgroundTransparency = 1
	l1.Text = title
	l1.TextColor3 = Theme.TextMain
	l1.Font = Enum.Font.GothamBold
	l1.TextSize = 13
	l1.TextXAlignment = Enum.TextXAlignment.Left
	l1.Parent = card

	local l2 = Instance.new("TextLabel")
	l2.Size = UDim2.new(1, -18, 0, 20)
	l2.Position = UDim2.new(0, 14, 0, 27)
	l2.BackgroundTransparency = 1
	l2.Text = desc
	l2.TextColor3 = Theme.TextMuted
	l2.Font = Enum.Font.Gotham
	l2.TextSize = 11
	l2.TextXAlignment = Enum.TextXAlignment.Left
	l2.TextTruncate = Enum.TextTruncate.AtEnd
	l2.Parent = card

	card.Position = UDim2.new(1, 330, 0, 0)
	TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, 0, 0, 0)
	}):Play()

	task.delay(3, function()
		if card and card.Parent then
			local out = TweenService:Create(card, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
				Position = UDim2.new(1, 330, 0, 0)
			})
			out:Play()
			out.Completed:Wait()
			card:Destroy()
		end
	end)
end

local triggerBtn = Instance.new("TextButton")
triggerBtn.Name = "AstralTrigger"
triggerBtn.Size = UDim2.new(0, 108, 0, 30)
triggerBtn.Position = UDim2.new(0, 14, 0.5, -15)
triggerBtn.BackgroundColor3 = Theme.BgCard
triggerBtn.BackgroundTransparency = 0.25
triggerBtn.Text = "✦ ASTRAL [INS]"
triggerBtn.TextColor3 = Theme.AccentBright
triggerBtn.Font = Enum.Font.GothamBold
triggerBtn.TextSize = 11
triggerBtn.AutoButtonColor = false
triggerBtn.Parent = gui
addCorner(triggerBtn, 8)
addStroke(triggerBtn, Theme.Accent, 1, 0.35)
makeDraggable(triggerBtn, triggerBtn)

local chHolder = Instance.new("Frame")
chHolder.Name = "CustomCrosshair"
chHolder.AnchorPoint = Vector2.new(0.5, 0.5)
chHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
chHolder.Size = UDim2.new(0, 40, 0, 40)
chHolder.BackgroundTransparency = 1
chHolder.Visible = false
chHolder.Parent = gui

local function makeCrossBar(size, pos)
	local f = Instance.new("Frame")
	f.Size = size
	f.Position = pos
	f.BackgroundColor3 = Theme.AccentBright
	f.BorderSizePixel = 0
	f.Parent = chHolder
	return f
end

local chTop = makeCrossBar(UDim2.new(0, 2, 0, 10), UDim2.new(0.5, -1, 0.5, -14))
local chBot = makeCrossBar(UDim2.new(0, 2, 0, 10), UDim2.new(0.5, -1, 0.5, 4))
local chLeft = makeCrossBar(UDim2.new(0, 10, 0, 2), UDim2.new(0.5, -14, 0.5, -1))
local chRight = makeCrossBar(UDim2.new(0, 10, 0, 2), UDim2.new(0.5, 4, 0.5, -1))

local radarCard = Instance.new("Frame")
radarCard.Name = "TargetRadarHUD"
radarCard.Size = UDim2.new(0, 215, 0, 62)
radarCard.Position = UDim2.new(0, 14, 0, 18)
radarCard.BackgroundColor3 = Theme.BgCard
radarCard.BackgroundTransparency = 0.25
radarCard.Visible = false
radarCard.Parent = gui
addCorner(radarCard, 10)
addStroke(radarCard, Theme.Stroke, 1.1, 0.35)
makeDraggable(radarCard, radarCard)

local radarTitle = Instance.new("TextLabel")
radarTitle.Size = UDim2.new(1, -16, 0, 18)
radarTitle.Position = UDim2.new(0, 10, 0, 6)
radarTitle.BackgroundTransparency = 1
radarTitle.Text = "ASTRAL RADAR  •  TARGETS"
radarTitle.TextColor3 = Theme.AccentBright
radarTitle.Font = Enum.Font.GothamBold
radarTitle.TextSize = 10
radarTitle.TextXAlignment = Enum.TextXAlignment.Left
radarTitle.Parent = radarCard

local radarInfo = Instance.new("TextLabel")
radarInfo.Size = UDim2.new(1, -16, 0, 26)
radarInfo.Position = UDim2.new(0, 10, 0, 25)
radarInfo.BackgroundTransparency = 1
radarInfo.Text = "Enemies: 0 | Silent: None"
radarInfo.TextColor3 = Theme.TextMain
radarInfo.Font = Enum.Font.GothamMedium
radarInfo.TextSize = 11
radarInfo.TextXAlignment = Enum.TextXAlignment.Left
radarInfo.Parent = radarCard

-- Key System
local keyWin = Instance.new("Frame")
keyWin.Name = "AstralKeyWindow"
keyWin.Size = UDim2.new(0, 370, 0, 215)
keyWin.Position = UDim2.new(0.5, -185, 0.5, -107)
keyWin.BackgroundColor3 = Theme.BgMain
keyWin.BackgroundTransparency = Theme.GlassAlpha
keyWin.Visible = false
keyWin.ClipsDescendants = true
keyWin.Parent = gui
addCorner(keyWin, 14)
addStroke(keyWin, Theme.Stroke, 1.3, 0.25)

local keyTop = Instance.new("Frame")
keyTop.Size = UDim2.new(1, 0, 0, 44)
keyTop.BackgroundColor3 = Theme.BgCard
keyTop.BackgroundTransparency = 0.25
keyTop.BorderSizePixel = 0
keyTop.Parent = keyWin
makeDraggable(keyWin, keyTop)

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1, -50, 1, 0)
keyTitle.Position = UDim2.new(0, 14, 0, 0)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "✦ ASTRAL HUB  •  KEY SYSTEM"
keyTitle.TextColor3 = Theme.TextMain
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextSize = 13
keyTitle.TextXAlignment = Enum.TextXAlignment.Left
keyTitle.Parent = keyTop

local keyClose = Instance.new("TextButton")
keyClose.Size = UDim2.new(0, 28, 0, 28)
keyClose.Position = UDim2.new(1, -38, 0.5, -14)
keyClose.BackgroundColor3 = Theme.BgInput
keyClose.BackgroundTransparency = 0.2
keyClose.Text = "×"
keyClose.TextColor3 = Theme.TextMuted
keyClose.Font = Enum.Font.GothamBold
keyClose.TextSize = 16
keyClose.Parent = keyTop
addCorner(keyClose, 7)

local keySub = Instance.new("TextLabel")
keySub.Size = UDim2.new(1, -28, 0, 32)
keySub.Position = UDim2.new(0, 14, 0, 52)
keySub.BackgroundTransparency = 1
keySub.Text = "Скрытое окно доступа ASTRAL HUB. Введите ключ для запуска."
keySub.TextColor3 = Theme.TextMuted
keySub.Font = Enum.Font.Gotham
keySub.TextSize = 11
keySub.TextXAlignment = Enum.TextXAlignment.Left
keySub.TextWrapped = true
keySub.Parent = keyWin

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -28, 0, 40)
keyBox.Position = UDim2.new(0, 14, 0, 94)
keyBox.BackgroundColor3 = Theme.BgInput
keyBox.BackgroundTransparency = 0.2
keyBox.PlaceholderText = "Введите ключ..."
keyBox.PlaceholderColor3 = Color3.fromRGB(120, 108, 158)
keyBox.Text = ""
keyBox.TextColor3 = Theme.TextMain
keyBox.Font = Enum.Font.GothamMedium
keyBox.TextSize = 13
keyBox.ClearTextOnFocus = false
keyBox.Parent = keyWin
addCorner(keyBox, 9)
local keyBoxStroke = addStroke(keyBox, Theme.Stroke, 1.1, 0.35)

local keySubmit = Instance.new("TextButton")
keySubmit.Size = UDim2.new(1, -28, 0, 38)
keySubmit.Position = UDim2.new(0, 14, 0, 148)
keySubmit.BackgroundColor3 = Theme.Accent
keySubmit.BackgroundTransparency = 0.12
keySubmit.Text = "Войти в ASTRAL HUB"
keySubmit.TextColor3 = Color3.fromRGB(255, 255, 255)
keySubmit.Font = Enum.Font.GothamBold
keySubmit.TextSize = 13
keySubmit.AutoButtonColor = false
keySubmit.Parent = keyWin
addCorner(keySubmit, 9)

-- Main Hub
local hub = Instance.new("Frame")
hub.Name = "AstralMainWindow"
hub.Size = UDim2.new(0, 720, 0, 475)
hub.Position = UDim2.new(0.5, -360, 0.5, -237)
hub.BackgroundColor3 = Theme.BgMain
hub.BackgroundTransparency = Theme.GlassAlpha
hub.Visible = false
hub.ClipsDescendants = true
hub.Parent = gui
addCorner(hub, 15)
addStroke(hub, Theme.Stroke, 1.4, 0.25)

local hubHeader = Instance.new("Frame")
hubHeader.Size = UDim2.new(1, 0, 0, 48)
hubHeader.BackgroundColor3 = Theme.BgCard
hubHeader.BackgroundTransparency = 0.25
hubHeader.BorderSizePixel = 0
hubHeader.Parent = hub
makeDraggable(hub, hubHeader)

local hubDot = Instance.new("Frame")
hubDot.Size = UDim2.new(0, 10, 0, 10)
hubDot.Position = UDim2.new(0, 16, 0.5, -5)
hubDot.BackgroundColor3 = Theme.AccentBright
hubDot.Parent = hubHeader
addCorner(hubDot, 999)

local hubTitle = Instance.new("TextLabel")
hubTitle.Size = UDim2.new(0, 340, 1, 0)
hubTitle.Position = UDim2.new(0, 34, 0, 0)
hubTitle.BackgroundTransparency = 1
hubTitle.Text = "✦ ASTRAL HUB  //  AIM • SILENT • RAGE • ESP • 3D"
hubTitle.TextColor3 = Theme.TextMain
hubTitle.Font = Enum.Font.GothamBold
hubTitle.TextSize = 13
hubTitle.TextXAlignment = Enum.TextXAlignment.Left
hubTitle.Parent = hubHeader

local statusBadge = Instance.new("TextLabel")
statusBadge.Size = UDim2.new(0, 125, 0, 24)
statusBadge.Position = UDim2.new(1, -210, 0.5, -12)
statusBadge.BackgroundColor3 = Theme.BgInput
statusBadge.BackgroundTransparency = 0.25
statusBadge.Text = "ASTRAL VERIFIED"
statusBadge.TextColor3 = Theme.Success
statusBadge.Font = Enum.Font.GothamBold
statusBadge.TextSize = 10
statusBadge.Parent = hubHeader
addCorner(statusBadge, 6)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -76, 0.5, -15)
minBtn.BackgroundColor3 = Theme.BgInput
minBtn.BackgroundTransparency = 0.25
minBtn.Text = "—"
minBtn.TextColor3 = Theme.TextMuted
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 13
minBtn.Parent = hubHeader
addCorner(minBtn, 8)

local closeHubBtn = Instance.new("TextButton")
closeHubBtn.Size = UDim2.new(0, 30, 0, 30)
closeHubBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeHubBtn.BackgroundColor3 = Theme.BgInput
closeHubBtn.BackgroundTransparency = 0.25
closeHubBtn.Text = "×"
closeHubBtn.TextColor3 = Theme.TextMuted
closeHubBtn.Font = Enum.Font.GothamBold
closeHubBtn.TextSize = 17
closeHubBtn.Parent = hubHeader
addCorner(closeHubBtn, 8)

local sideBar = Instance.new("Frame")
sideBar.Size = UDim2.new(0, 170, 1, -48)
sideBar.Position = UDim2.new(0, 0, 0, 48)
sideBar.BackgroundColor3 = Theme.BgCard
sideBar.BackgroundTransparency = 0.35
sideBar.BorderSizePixel = 0
sideBar.Parent = hub

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 6)
sideLayout.Parent = sideBar

local sidePad = Instance.new("UIPadding")
sidePad.PaddingTop = UDim.new(0, 12)
sidePad.PaddingLeft = UDim.new(0, 10)
sidePad.PaddingRight = UDim.new(0, 10)
sidePad.Parent = sideBar

local bodyArea = Instance.new("Frame")
bodyArea.Size = UDim2.new(1, -170, 1, -48)
bodyArea.Position = UDim2.new(0, 170, 0, 48)
bodyArea.BackgroundTransparency = 1
bodyArea.Parent = hub

local pages = {}
local tabBtns = {}
local rebuildSkinPreview = nil

local function createPage(tabId)
	local sf = Instance.new("ScrollingFrame")
	sf.Name = tabId .. "Page"
	sf.Size = UDim2.new(1, 0, 1, 0)
	sf.BackgroundTransparency = 1
	sf.BorderSizePixel = 0
	sf.ScrollBarThickness = 4
	sf.ScrollBarImageColor3 = Theme.Accent
	sf.CanvasSize = UDim2.new(0, 0, 0, 0)
	sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sf.Visible = (tabId == State.ActiveTab)
	sf.Parent = bodyArea

	local ll = Instance.new("UIListLayout")
	ll.Padding = UDim.new(0, 9)
	ll.SortOrder = Enum.SortOrder.LayoutOrder
	ll.Parent = sf

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 12)
	pad.PaddingBottom = UDim.new(0, 14)
	pad.PaddingLeft = UDim.new(0, 14)
	pad.PaddingRight = UDim.new(0, 14)
	pad.Parent = sf

	pages[tabId] = sf
	return sf
end

local function createTab(tabId, text, order)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, 36)
	b.LayoutOrder = order
	b.BackgroundColor3 = (tabId == State.ActiveTab) and Theme.BgCardHover or Theme.BgInput
	b.BackgroundTransparency = (tabId == State.ActiveTab) and 0.2 or 0.45
	b.Text = "  " .. text
	b.TextColor3 = (tabId == State.ActiveTab) and Theme.TextMain or Theme.TextMuted
	b.Font = Enum.Font.GothamBold
	b.TextSize = 12
	b.TextXAlignment = Enum.TextXAlignment.Left
	b.AutoButtonColor = false
	b.Parent = sideBar
	addCorner(b, 8)

	b.MouseButton1Click:Connect(function()
		State.ActiveTab = tabId
		for id, pg in pairs(pages) do
			pg.Visible = (id == tabId)
		end
		for id, tb in pairs(tabBtns) do
			local sel = (id == tabId)
			tb.BackgroundColor3 = sel and Theme.BgCardHover or Theme.BgInput
			tb.BackgroundTransparency = sel and 0.2 or 0.45
			tb.TextColor3 = sel and Theme.TextMain or Theme.TextMuted
		end
		if tabId == "Skin3D" and rebuildSkinPreview then
			rebuildSkinPreview()
		end
	end)

	tabBtns[tabId] = b
end

local function addSection(parent, title, order)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, 0, 0, 18)
	l.LayoutOrder = order
	l.BackgroundTransparency = 1
	l.Text = string.upper(title)
	l.TextColor3 = Theme.AccentBright
	l.Font = Enum.Font.GothamBold
	l.TextSize = 10
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Parent = parent
end

local function addToggle(parent, title, desc, initVal, order, cb)
	local cur = initVal
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 50)
	card.LayoutOrder = order
	card.BackgroundColor3 = Theme.BgCard
	card.BackgroundTransparency = Theme.GlassAlpha
	card.Parent = parent
	addCorner(card, 10)
	addStroke(card, Theme.Stroke, 1, 0.45)

	local t1 = Instance.new("TextLabel")
	t1.Size = UDim2.new(1, -76, 0, 18)
	t1.Position = UDim2.new(0, 12, 0, 7)
	t1.BackgroundTransparency = 1
	t1.Text = title
	t1.TextColor3 = Theme.TextMain
	t1.Font = Enum.Font.GothamBold
	t1.TextSize = 12
	t1.TextXAlignment = Enum.TextXAlignment.Left
	t1.Parent = card

	local t2 = Instance.new("TextLabel")
	t2.Size = UDim2.new(1, -76, 0, 16)
	t2.Position = UDim2.new(0, 12, 0, 26)
	t2.BackgroundTransparency = 1
	t2.Text = desc
	t2.TextColor3 = Theme.TextMuted
	t2.Font = Enum.Font.Gotham
	t2.TextSize = 10
	t2.TextXAlignment = Enum.TextXAlignment.Left
	t2.Parent = card

	local sw = Instance.new("TextButton")
	sw.Size = UDim2.new(0, 44, 0, 22)
	sw.Position = UDim2.new(1, -56, 0.5, -11)
	sw.BackgroundColor3 = cur and Theme.Accent or Theme.BgInput
	sw.BackgroundTransparency = 0.15
	sw.Text = ""
	sw.AutoButtonColor = false
	sw.Parent = card
	addCorner(sw, 999)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 16, 0, 16)
	knob.Position = cur and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.Parent = sw
	addCorner(knob, 999)

	sw.MouseButton1Click:Connect(function()
		cur = not cur
		sw.BackgroundColor3 = cur and Theme.Accent or Theme.BgInput
		knob.Position = cur and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
		cb(cur)
	end)
end

local function addSlider(parent, title, minV, maxV, initV, step, order, cb)
	local cur = math.clamp(initV, minV, maxV)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 56)
	card.LayoutOrder = order
	card.BackgroundColor3 = Theme.BgCard
	card.BackgroundTransparency = Theme.GlassAlpha
	card.Parent = parent
	addCorner(card, 10)
	addStroke(card, Theme.Stroke, 1, 0.45)

	local t1 = Instance.new("TextLabel")
	t1.Size = UDim2.new(0.7, -12, 0, 20)
	t1.Position = UDim2.new(0, 12, 0, 6)
	t1.BackgroundTransparency = 1
	t1.Text = title
	t1.TextColor3 = Theme.TextMain
	t1.Font = Enum.Font.GothamBold
	t1.TextSize = 12
	t1.TextXAlignment = Enum.TextXAlignment.Left
	t1.Parent = card

	local vLbl = Instance.new("TextLabel")
	vLbl.Size = UDim2.new(0.3, -12, 0, 20)
	vLbl.Position = UDim2.new(0.7, 0, 0, 6)
	vLbl.BackgroundTransparency = 1
	vLbl.Text = tostring(cur)
	vLbl.TextColor3 = Theme.AccentBright
	vLbl.Font = Enum.Font.GothamBold
	vLbl.TextSize = 12
	vLbl.TextXAlignment = Enum.TextXAlignment.Right
	vLbl.Parent = card

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, -24, 0, 7)
	bar.Position = UDim2.new(0, 12, 0, 35)
	bar.BackgroundColor3 = Theme.BgInput
	bar.BackgroundTransparency = 0.2
	bar.Parent = card
	addCorner(bar, 999)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((cur - minV) / math.max(maxV - minV, 1e-5), 0, 1, 0)
	fill.BackgroundColor3 = Theme.AccentBright
	fill.Parent = bar
	addCorner(fill, 999)

	local dragging = false
	local function applyX(x)
		local ratio = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
		local raw = minV + (maxV - minV) * ratio
		local snapped = math.floor(raw / step + 0.5) * step
		snapped = math.clamp(math.floor(snapped * 100 + 0.5) / 100, minV, maxV)
		cur = snapped
		vLbl.Text = tostring(cur)
		fill.Size = UDim2.new((cur - minV) / math.max(maxV - minV, 1e-5), 0, 1, 0)
		cb(cur)
	end

	bar.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			applyX(inp.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(inp)
		if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
			applyX(inp.Position.X)
		end
	end)
end

local function addCycle(parent, title, opts, initOpt, order, cb)
	local idx = 1
	for i, opt in ipairs(opts) do
		if opt == initOpt then
			idx = i
			break
		end
	end

	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 44)
	card.LayoutOrder = order
	card.BackgroundColor3 = Theme.BgCard
	card.BackgroundTransparency = Theme.GlassAlpha
	card.Parent = parent
	addCorner(card, 10)
	addStroke(card, Theme.Stroke, 1, 0.45)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.55, -12, 1, 0)
	lbl.Position = UDim2.new(0, 12, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = title
	lbl.TextColor3 = Theme.TextMain
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 12
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = card

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.42, -10, 0, 28)
	btn.Position = UDim2.new(0.58, 0, 0.5, -14)
	btn.BackgroundColor3 = Theme.BgInput
	btn.BackgroundTransparency = 0.15
	btn.Text = opts[idx] .. "  ▸"
	btn.TextColor3 = Theme.AccentBright
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	btn.AutoButtonColor = false
	btn.Parent = card
	addCorner(btn, 7)
	addStroke(btn, Theme.Accent, 1, 0.45)

	btn.MouseButton1Click:Connect(function()
		idx = (idx % #opts) + 1
		local selected = opts[idx]
		btn.Text = selected .. "  ▸"
		cb(selected)
	end)
end

local function addAction(parent, title, order, cb)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, 36)
	b.LayoutOrder = order
	b.BackgroundColor3 = Theme.BgCardHover
	b.BackgroundTransparency = 0.15
	b.Text = title
	b.TextColor3 = Theme.TextMain
	b.Font = Enum.Font.GothamBold
	b.TextSize = 12
	b.AutoButtonColor = false
	b.Parent = parent
	addCorner(b, 8)
	addStroke(b, Theme.Accent, 1, 0.35)
	b.MouseButton1Click:Connect(cb)
end

createTab("Aimbot", "🎯  Aimbot", 1)
createTab("Silent", "👻  Silent Aim", 2)
createTab("Rage", "🔥  Rage", 3)
createTab("ESP", "👁️  ESP", 4)
createTab("Skin3D", "🧍  Skin 3D", 5)
createTab("Visuals", "✨  Visuals / Extra", 6)

local aimPage = createPage("Aimbot")
local silentPage = createPage("Silent")
local ragePage = createPage("Rage")
local espPage = createPage("ESP")
local skinPage = createPage("Skin3D")
local visPage = createPage("Visuals")

-- Aimbot
addSection(aimPage, "Обычный аимбот (наводка камеры)", 1)
addToggle(aimPage, "Enable Aimbot", "Включает плавное наведение камеры на цель", false, 2, function(v) State.AimEnabled = v end)
addCycle(aimPage, "Aim Mode", AIM_MODES, State.AimMode, 3, function(v) State.AimMode = v end)
addCycle(aimPage, "Target Part", TARGET_PARTS, State.TargetPartMode, 4, function(v) State.TargetPartMode = v end)
addToggle(aimPage, "Hold RMB Only", "Наводить при зажатой правой кнопке мыши", true, 5, function(v) State.AimHoldOnly = v end)

addSection(aimPage, "Настройки и проверки", 6)
addToggle(aimPage, "Show Aimbot FOV", "Показывает фиолетовый круг захвата Aimbot", true, 7, function(v) State.FOVEnabled = v end)
addSlider(aimPage, "Aimbot FOV Radius", 35, 360, State.FOVRadius, 5, 8, function(v) State.FOVRadius = v end)
addSlider(aimPage, "Smoothness", 0.04, 1.0, State.Smoothness, 0.02, 9, function(v) State.Smoothness = v end)
addSlider(aimPage, "Prediction", 0, 0.35, State.Prediction, 0.01, 10, function(v) State.Prediction = v end)
addToggle(aimPage, "Team Check", "Не наводить на свою команду", true, 11, function(v) State.TeamCheck = v end)
addToggle(aimPage, "Wall Check", "Проверка видимости сквозь стены", true, 12, function(v) State.WallCheck = v end)
addToggle(aimPage, "Sticky Target Lock", "Удерживать цель пока она жива", true, 13, function(v) State.StickyTarget = v end)
addSlider(aimPage, "Triggerbot Delay", 0.02, 0.3, State.TriggerDelay, 0.01, 14, function(v) State.TriggerDelay = v end)

-- Silent Aim (всегда активен без ПКМ)
addSection(silentPage, "Silent Aim (всегда активен без ПКМ)", 1)
addToggle(silentPage, "Enable Silent Aim", "Работает постоянно без ПКМ при стрельбе и зажиме", false, 2, function(v)
	State.SilentEnabled = v
	if v then
		pushNotify("Silent Aim", "Включён без ПКМ -> " .. State.SilentPart)
	end
end)
addCycle(silentPage, "Магнитить пули в", SILENT_PARTS, State.SilentPart, 3, function(v)
	State.SilentPart = v
end)
addToggle(silentPage, "Show Silent FOV Circle", "Голубой круг зоны детекта Silent Aim вокруг прицела", true, 4, function(v)
	State.SilentFOVEnabled = v
end)
addSlider(silentPage, "Silent FOV Radius", 30, 420, State.SilentFOVRadius, 5, 5, function(v)
	State.SilentFOVRadius = v
end)
addSlider(silentPage, "Hit Chance (%)", 10, 100, State.SilentHitChance, 5, 6, function(v)
	State.SilentHitChance = v
end)
addSlider(silentPage, "Silent Prediction", 0, 0.35, State.SilentPrediction, 0.01, 7, function(v)
	State.SilentPrediction = v
end)
addToggle(silentPage, "Silent Team Check", "Игнорировать игроков своей команды", true, 8, function(v)
	State.SilentTeamCheck = v
end)
addToggle(silentPage, "Silent Wall Check", "Магнитить пули только если враг не за стеной", true, 9, function(v)
	State.SilentWallCheck = v
end)

-- Rage
addSection(ragePage, "Боевые Rage-функции", 1)
addToggle(ragePage, "Hitbox Expander", "Увеличивает хитбоксы живых противников", false, 2, function(v) State.HitboxEnabled = v end)
addCycle(ragePage, "Hitbox Part", HITBOX_PARTS, State.HitboxPart, 3, function(v) State.HitboxPart = v end)
addSlider(ragePage, "Hitbox Size", 2, 22, State.HitboxSize, 1, 4, function(v) State.HitboxSize = v end)
addSlider(ragePage, "Hitbox Transparency", 0.1, 1.0, State.HitboxTransparency, 0.05, 5, function(v) State.HitboxTransparency = v end)
addToggle(ragePage, "Rapid Fire", "Быстрая стрельба при удержании ЛКМ", false, 6, function(v) State.RapidFireEnabled = v end)
addSlider(ragePage, "Rapid Fire Delay", 0.01, 0.25, State.RapidFireDelay, 0.01, 7, function(v) State.RapidFireDelay = v end)
addToggle(ragePage, "Auto Fire on Visible", "Авто-выстрел при появлении цели в FOV", false, 8, function(v) State.AutoFireVisible = v end)
addToggle(ragePage, "Kill Aura (Close Range)", "Авто-удар оружием по врагам вблизи", false, 9, function(v) State.KillAuraEnabled = v end)
addSlider(ragePage, "Kill Aura Range", 6, 35, State.KillAuraRange, 1, 10, function(v) State.KillAuraRange = v end)
addToggle(ragePage, "Target Orbit", "Кружит вокруг ближайшего живого врага", false, 11, function(v) State.OrbitTargetEnabled = v end)
addSlider(ragePage, "Orbit Radius", 4, 24, State.OrbitRadius, 1, 12, function(v) State.OrbitRadius = v end)
addSlider(ragePage, "Orbit Speed", 1, 18, State.OrbitSpeed, 1, 13, function(v) State.OrbitSpeed = v end)

addSection(ragePage, "Anti-Aim и движение", 14)
addToggle(ragePage, "Spinbot (Anti-Aim)", "Быстрое вращение персонажа вокруг своей оси", false, 15, function(v) State.SpinbotEnabled = v end)
addSlider(ragePage, "Spin Speed", 5, 100, State.SpinSpeed, 5, 16, function(v) State.SpinSpeed = v end)
addToggle(ragePage, "Spectate Nearest Enemy", "Наводит камеру на ближайшего врага", false, 17, function(v) State.SpectateNearest = v end)
addToggle(ragePage, "BunnyHop (Auto Jump)", "Автоматический прыжок на земле", false, 18, function(v) State.BHopEnabled = v end)
addSlider(ragePage, "BHop Speed Boost", 1.0, 2.0, State.BHopBoost, 0.05, 19, function(v) State.BHopBoost = v end)
addToggle(ragePage, "CFrame Speed Hack", "Ускоренный рывок по направлению движения", false, 20, function(v) State.CFrameSpeedEnabled = v end)
addSlider(ragePage, "CFrame Speed Mult", 1.0, 3.0, State.CFrameSpeedMult, 0.1, 21, function(v) State.CFrameSpeedMult = v end)
addToggle(ragePage, "Custom Gravity", "Меняет гравитацию в мире", false, 22, function(v)
	State.GravityOverride = v
	applyGravity(v, State.GravityValue)
end)
addSlider(ragePage, "Gravity Value", 20, 250, State.GravityValue, 5, 23, function(v)
	State.GravityValue = v
	if State.GravityOverride then
		applyGravity(true, v)
	end
end)
addToggle(ragePage, "Anti-Ragdoll / Recover", "Защита от падения в Ragdoll", false, 24, function(v) State.AntiRagdollEnabled = v end)
addToggle(ragePage, "NoClip", "Прохождение сквозь стены и препятствия", false, 25, function(v) State.NoClipEnabled = v end)
addToggle(ragePage, "Fly Mode", "Полёт на WASD + Space / LeftShift", false, 26, function(v) State.FlyEnabled = v end)
addSlider(ragePage, "Fly Speed", 20, 150, State.FlySpeed, 5, 27, function(v) State.FlySpeed = v end)

-- ESP
addSection(espPage, "Все виды ESP", 1)
addToggle(espPage, "Master ESP", "Включает ESP для живых противников", false, 2, function(v) State.ESPEnabled = v end)
addToggle(espPage, "Box ESP", "Полная 2D-рамка", true, 3, function(v) State.BoxESP = v end)
addToggle(espPage, "Corner Box ESP", "Угловые рамки", false, 4, function(v) State.CornerBoxESP = v end)
addToggle(espPage, "Tracer ESP", "Линии к противникам", true, 5, function(v) State.TracerESP = v end)
addCycle(espPage, "Tracer Origin", TRACER_ORIGINS, State.TracerOrigin, 6, function(v) State.TracerOrigin = v end)
addToggle(espPage, "Skeleton ESP", "Линии по суставам и частям тела", true, 7, function(v) State.SkeletonESP = v end)
addToggle(espPage, "Name + HP + Distance", "Имя, здоровье и дистанция", true, 8, function(v) State.InfoESP = v end)
addToggle(espPage, "ESP Team Check", "Скрывать игроков своей команды", true, 9, function(v) State.ESPTeamCheck = v end)
addSlider(espPage, "Max ESP Distance", 100, 2500, State.ESPMaxDist, 50, 10, function(v) State.ESPMaxDist = v end)

-- 3D Skin Viewer
addSection(skinPage, "3D просмотр вашего скина (тяните мышкой)", 1)

local skinCard = Instance.new("Frame")
skinCard.Size = UDim2.new(1, 0, 0, 235)
skinCard.LayoutOrder = 2
skinCard.BackgroundColor3 = Theme.BgCard
skinCard.BackgroundTransparency = Theme.GlassAlpha
skinCard.ClipsDescendants = true
skinCard.Parent = skinPage
addCorner(skinCard, 12)
addStroke(skinCard, Theme.Stroke, 1.2, 0.35)

local vpFrame = Instance.new("ViewportFrame")
vpFrame.Size = UDim2.new(1, -16, 1, -44)
vpFrame.Position = UDim2.new(0, 8, 0, 8)
vpFrame.BackgroundColor3 = Theme.BgInput
vpFrame.BackgroundTransparency = 0.25
vpFrame.BorderSizePixel = 0
vpFrame.Parent = skinCard
addCorner(vpFrame, 10)

local skinHint = Instance.new("TextLabel")
skinHint.Size = UDim2.new(1, -16, 0, 24)
skinHint.Position = UDim2.new(0, 8, 1, -30)
skinHint.BackgroundTransparency = 1
skinHint.Text = "Зажмите ЛКМ / палец на скине для вращения в 3D"
skinHint.TextColor3 = Theme.TextMuted
skinHint.Font = Enum.Font.GothamMedium
skinHint.TextSize = 11
skinHint.Parent = skinCard

local vpCamera = Instance.new("Camera")
vpCamera.FieldOfView = 45
vpFrame.CurrentCamera = vpCamera
vpCamera.Parent = vpFrame

local vpWorld = Instance.new("WorldModel")
vpWorld.Parent = vpFrame

local skinYaw = 0
local skinPitch = 8
local previewModel = nil

local function updateSkinCamera()
	local center = Vector3.new(0, 2.6, 0)
	local dist = 6.2
	local yawRad = math.rad(skinYaw)
	local pitchRad = math.rad(math.clamp(skinPitch, -35, 45))
	local dir = Vector3.new(
		math.sin(yawRad) * math.cos(pitchRad),
		math.sin(pitchRad),
		math.cos(yawRad) * math.cos(pitchRad)
	).Unit
	vpCamera.CFrame = CFrame.lookAt(center + dir * dist, center)
end

rebuildSkinPreview = function()
	if previewModel then
		previewModel:Destroy()
		previewModel = nil
	end
	local char = LocalPlayer.Character
	if not char then
		return
	end
	char.Archivable = true
	local ok, clone = pcall(function()
		return char:Clone()
	end)
	char.Archivable = false
	if not ok or not clone then
		return
	end
	clone.Name = "SkinPreviewModel"
	for _, obj in ipairs(clone:GetDescendants()) do
		if obj:IsA("Script") or obj:IsA("LocalScript") then
			obj:Destroy()
		elseif obj:IsA("BasePart") then
			obj.Anchored = true
			obj.CanCollide = false
		end
	end
	clone:PivotTo(CFrame.new(0, 2.8, 0))
	clone.Parent = vpWorld
	previewModel = clone
	updateSkinCamera()
end

local vpDragging = false
local vpDragInput = nil
local vpLastPos = Vector2.zero

vpFrame.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
		vpDragging = true
		vpLastPos = inp.Position
		inp.Changed:Connect(function()
			if inp.UserInputState == Enum.UserInputState.End then
				vpDragging = false
			end
		end)
	end
end)

vpFrame.InputChanged:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
		vpDragInput = inp
	end
end)

UserInputService.InputChanged:Connect(function(inp)
	if inp == vpDragInput and vpDragging then
		local delta = inp.Position - vpLastPos
		vpLastPos = inp.Position
		skinYaw = (skinYaw - delta.X * 0.45) % 360
		skinPitch = math.clamp(skinPitch + delta.Y * 0.25, -35, 45)
		updateSkinCamera()
	end
end)

addToggle(skinPage, "Auto Rotate 3D Skin", "Автоматически вращает скин в окне", true, 3, function(v)
	State.SkinAutoRotate = v
end)
addSlider(skinPage, "3D Rotation Speed", 5, 120, State.SkinRotateSpeed, 5, 4, function(v)
	State.SkinRotateSpeed = v
end)
addAction(skinPage, "Обновить скин / Сбросить угол", 5, function()
	skinYaw = 0
	skinPitch = 8
	if rebuildSkinPreview then
		rebuildSkinPreview()
	end
	pushNotify("ASTRAL 3D Viewer", "Скин обновлён и угол сброшен.")
end)

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.35)
	if rebuildSkinPreview then
		rebuildSkinPreview()
	end
end)

-- Visuals / Extra
addSection(visPage, "Внешний вид и размытие", 1)
addToggle(visPage, "Background Blur", "Размывает фон за меню", true, 2, function(v)
	State.BlurEnabled = v
	updateBlur()
end)
addSlider(visPage, "Blur Size", 2, 32, State.BlurSize, 1, 3, function(v)
	State.BlurSize = v
	updateBlur()
end)
addSlider(visPage, "Transparency", 0.05, 0.65, Theme.GlassAlpha, 0.05, 4, function(v)
	Theme.GlassAlpha = v
	hub.BackgroundTransparency = v
	keyWin.BackgroundTransparency = v
end)

addSection(visPage, "Дополнительные функции", 5)
addToggle(visPage, "Custom Crosshair", "Кастомный прицел по центру экрана", false, 6, function(v) State.CrosshairEnabled = v end)
addSlider(visPage, "Crosshair Size", 4, 24, State.CrosshairSize, 1, 7, function(v) State.CrosshairSize = v end)
addToggle(visPage, "Target Radar HUD", "Показывает число врагов и Silent-цель", false, 8, function(v) State.RadarHudEnabled = v end)
addToggle(visPage, "Fullbright", "Яркое освещение без теней", false, 9, function(v)
	State.FullbrightEnabled = v
	applyFullbright(v)
end)
addToggle(visPage, "Anti-AFK", "Защита от кика за бездействие", false, 10, function(v) State.AntiAFKEnabled = v end)
addToggle(visPage, "Custom FOV", "Меняет угол обзора камеры", false, 11, function(v) State.FOVOverride = v end)
addSlider(visPage, "Camera FOV", 60, 120, State.CustomFOV, 1, 12, function(v) State.CustomFOV = v end)
addToggle(visPage, "Custom WalkSpeed", "Меняет скорость бега", false, 13, function(v) State.WalkSpeedBoost = v end)
addSlider(visPage, "WalkSpeed", 16, 75, State.WalkSpeedVal, 1, 14, function(v) State.WalkSpeedVal = v end)

local function setKeyWin(open)
	if State.KeyUnlocked then
		return
	end
	State.KeyWinVisible = open
	keyWin.Visible = open
	updateBlur()
end

local function setHub(open)
	if not State.KeyUnlocked then
		setKeyWin(not State.KeyWinVisible)
		return
	end
	State.HubVisible = open
	hub.Visible = open
	updateBlur()
	if open and State.ActiveTab == "Skin3D" and rebuildSkinPreview then
		rebuildSkinPreview()
	end
end

local function submitKey()
	local entered = string.match(keyBox.Text, "^%s*(.-)%s*$") or ""
	if entered == CORRECT_KEY then
		State.KeyUnlocked = true
		State.KeyWinVisible = false
		keyWin.Visible = false
		State.HubVisible = true
		State.Minimized = false
		sideBar.Visible = true
		bodyArea.Visible = true
		hub.Size = UDim2.new(0, 720, 0, 475)
		hub.Visible = true
		triggerBtn.Text = "✦ ASTRAL [RSH]"
		updateBlur()
		if rebuildSkinPreview then
			rebuildSkinPreview()
		end
		pushNotify("ASTRAL HUB", "Доступ открыт. Скрыть/открыть: RightShift")
	else
		keyBoxStroke.Color = Theme.Error
		pushNotify("Неверный ключ", "Проверьте введённый ключ.", true)
		task.delay(0.75, function()
			keyBoxStroke.Color = Theme.Stroke
		end)
	end
end

keySubmit.MouseButton1Click:Connect(submitKey)
keyBox.FocusLost:Connect(function(enter)
	if enter then
		submitKey()
	end
end)

keyClose.MouseButton1Click:Connect(function()
	setKeyWin(false)
end)

triggerBtn.MouseButton1Click:Connect(function()
	if not State.KeyUnlocked then
		setKeyWin(not State.KeyWinVisible)
	else
		setHub(not State.HubVisible)
	end
end)

minBtn.MouseButton1Click:Connect(function()
	State.Minimized = not State.Minimized
	sideBar.Visible = not State.Minimized
	bodyArea.Visible = not State.Minimized
	hub.Size = State.Minimized and UDim2.new(0, 720, 0, 48) or UDim2.new(0, 720, 0, 475)
	updateBlur()
end)

closeHubBtn.MouseButton1Click:Connect(function()
	setHub(false)
	pushNotify("ASTRAL HUB скрыт", "Нажмите RightShift или кнопку слева.")
end)

UserInputService.InputBegan:Connect(function(inp, gp)
	if gp then
		return
	end
	if inp.KeyCode == KEY_HOTKEY then
		if not State.KeyUnlocked then
			setKeyWin(not State.KeyWinVisible)
		else
			setHub(not State.HubVisible)
		end
	elseif inp.KeyCode == HUB_HOTKEY and State.KeyUnlocked then
		setHub(not State.HubVisible)
	end
end)

LocalPlayer.Idled:Connect(function()
	if State.KeyUnlocked and State.AntiAFKEnabled then
		local cam = Workspace.CurrentCamera
		if cam then
			cam.CFrame = cam.CFrame * CFrame.Angles(0, math.rad(0.001), 0)
		end
	end
end)

-- Safe ESP
local espLayer = Instance.new("Frame")
espLayer.Name = "AstralESPOverlay"
espLayer.Size = UDim2.new(1, 0, 1, 0)
espLayer.BackgroundTransparency = 1
espLayer.ZIndex = 1
espLayer.Parent = gui

local espPool = {}

local function makeLine()
	local f = Instance.new("Frame")
	f.BackgroundColor3 = Theme.AccentBright
	f.BorderSizePixel = 0
	f.AnchorPoint = Vector2.new(0.5, 0.5)
	f.Visible = false
	f.Parent = espLayer
	return f
end

local function createESPSet()
	local box = Instance.new("Frame")
	box.BackgroundColor3 = Theme.Accent
	box.BackgroundTransparency = 0.88
	box.Visible = false
	box.Parent = espLayer
	addStroke(box, Theme.AccentBright, 1.4, 0.1)

	local corners = {}
	for _ = 1, 8 do
		table.insert(corners, makeLine())
	end

	local tracer = makeLine()

	local tag = Instance.new("TextLabel")
	tag.BackgroundColor3 = Theme.BgMain
	tag.BackgroundTransparency = 0.35
	tag.TextColor3 = Theme.TextMain
	tag.Font = Enum.Font.GothamBold
	tag.TextSize = 10
	tag.TextStrokeTransparency = 0.5
	tag.Visible = false
	tag.Parent = espLayer
	addCorner(tag, 5)

	local bones = {}
	for _ = 1, 10 do
		table.insert(bones, makeLine())
	end

	return {
		Box = box,
		C_TL_H = corners[1],
		C_TL_V = corners[2],
		C_TR_H = corners[3],
		C_TR_V = corners[4],
		C_BL_H = corners[5],
		C_BL_V = corners[6],
		C_BR_H = corners[7],
		C_BR_V = corners[8],
		Tracer = tracer,
		Tag = tag,
		Bones = bones
	}
end

local function hideESPSet(s)
	s.Box.Visible = false
	s.C_TL_H.Visible = false
	s.C_TL_V.Visible = false
	s.C_TR_H.Visible = false
	s.C_TR_V.Visible = false
	s.C_BL_H.Visible = false
	s.C_BL_V.Visible = false
	s.C_BR_H.Visible = false
	s.C_BR_V.Visible = false
	s.Tracer.Visible = false
	s.Tag.Visible = false
	for _, b in ipairs(s.Bones) do
		b.Visible = false
	end
end

local function removeESPSet(plr)
	local s = espPool[plr]
	if not s then
		return
	end
	s.Box:Destroy()
	s.C_TL_H:Destroy()
	s.C_TL_V:Destroy()
	s.C_TR_H:Destroy()
	s.C_TR_V:Destroy()
	s.C_BL_H:Destroy()
	s.C_BL_V:Destroy()
	s.C_BR_H:Destroy()
	s.C_BR_V:Destroy()
	s.Tracer:Destroy()
	s.Tag:Destroy()
	for _, b in ipairs(s.Bones) do
		b:Destroy()
	end
	espPool[plr] = nil
end

Players.PlayerRemoving:Connect(removeESPSet)

local function drawLine(line, p1, p2, thick, col)
	local delta = p2 - p1
	local dist = delta.Magnitude
	if dist < 1 then
		line.Visible = false
		return
	end
	line.Size = UDim2.new(0, dist, 0, thick)
	line.Position = UDim2.new(0, (p1.X + p2.X) * 0.5, 0, (p1.Y + p2.Y) * 0.5)
	line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
	line.BackgroundColor3 = col
	line.Visible = true
end

local function drawCornerBox(s, topLeft, size, col)
	local cw = math.clamp(size.X * 0.25, 4, 18)
	local ch = math.clamp(size.Y * 0.22, 4, 18)
	local t = 2
	local tr = Vector2.new(topLeft.X + size.X, topLeft.Y)
	local bl = Vector2.new(topLeft.X, topLeft.Y + size.Y)
	local br = topLeft + size

	drawLine(s.C_TL_H, topLeft, topLeft + Vector2.new(cw, 0), t, col)
	drawLine(s.C_TL_V, topLeft, topLeft + Vector2.new(0, ch), t, col)

	drawLine(s.C_TR_H, tr - Vector2.new(cw, 0), tr, t, col)
	drawLine(s.C_TR_V, tr, tr + Vector2.new(0, ch), t, col)

	drawLine(s.C_BL_H, bl, bl + Vector2.new(cw, 0), t, col)
	drawLine(s.C_BL_V, bl - Vector2.new(0, ch), bl, t, col)

	drawLine(s.C_BR_H, br - Vector2.new(cw, 0), br, t, col)
	drawLine(s.C_BR_V, br - Vector2.new(0, ch), br, t, col)
end

local function getAliveParts(char)
	if not char or not char.Parent then
		return false, nil, nil
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then
		return false, nil, nil
	end
	if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then
		return false, hum, hrp
	end
	return true, hum, hrp
end

-- FOV Circles & Silent Aim Hooks
local fovCircle = Instance.new("Frame")
fovCircle.Name = "AimbotFOVCircle"
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.Parent = gui
addCorner(fovCircle, 999)
addStroke(fovCircle, Theme.AccentBright, 1.5, 0.25)

local silentFovCircle = Instance.new("Frame")
silentFovCircle.Name = "SilentFOVCircle"
silentFovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
silentFovCircle.BackgroundTransparency = 1
silentFovCircle.Visible = false
silentFovCircle.Parent = gui
addCorner(silentFovCircle, 999)
local silentFovStroke = addStroke(silentFovCircle, Theme.SilentAccent, 1.6, 0.2)

local lockedPart = nil
local silentTargetPart = nil
local silentTargetPos = nil
local silentTargetPlayerName = "None"

local lastShot = 0
local lastRapidShot = 0
local lastAuraHit = 0
local spinAngle = 0
local orbitAngle = 0
local flyBodyVel = nil

local function canSeePart(fromPos, targetPart, targetChar, checkWall)
	if not checkWall then
		return true
	end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	local excludeList = { targetChar }
	if LocalPlayer.Character then
		table.insert(excludeList, LocalPlayer.Character)
	end
	params.FilterDescendantsInstances = excludeList
	params.IgnoreWater = true

	local res = Workspace:Raycast(fromPos, targetPart.Position - fromPos, params)
	return res == nil
end

local function getSilentBodyPoint(char, partMode)
	if partMode == "Head" then
		local head = char:FindFirstChild("Head")
		if head then
			return head, head.Position
		end
	elseif partMode == "Neck" then
		local upperTorso = char:FindFirstChild("UpperTorso")
		local torso = char:FindFirstChild("Torso")
		local head = char:FindFirstChild("Head")
		if upperTorso and head then
			return upperTorso, upperTorso.Position:Lerp(head.Position, 0.55)
		elseif torso and head then
			return torso, torso.Position + Vector3.new(0, 0.85, 0)
		elseif head then
			return head, head.Position - Vector3.new(0, 0.35, 0)
		end
	elseif partMode == "Torso" then
		local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
		if torso then
			return torso, torso.Position
		end
	elseif partMode == "Arms" then
		local arm = char:FindFirstChild("RightUpperArm")
			or char:FindFirstChild("LeftUpperArm")
			or char:FindFirstChild("Right Arm")
			or char:FindFirstChild("Left Arm")
		if arm then
			return arm, arm.Position
		end
	elseif partMode == "Legs" then
		local leg = char:FindFirstChild("RightUpperLeg")
			or char:FindFirstChild("LeftUpperLeg")
			or char:FindFirstChild("Right Leg")
			or char:FindFirstChild("Left Leg")
		if leg then
			return leg, leg.Position
		end
	end
	local fallback = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
	return fallback, fallback and fallback.Position or nil
end

local function updateSilentTarget(mousePos)
	if not State.KeyUnlocked or not State.SilentEnabled then
		silentTargetPart = nil
		silentTargetPos = nil
		silentTargetPlayerName = "None"
		return
	end

	local bestPart = nil
	local bestPos = nil
	local bestName = "None"
	local bestDist = State.SilentFOVRadius

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local sameTeam = State.SilentTeamCheck and (LocalPlayer.Team ~= nil) and (plr.Team == LocalPlayer.Team)
			if not sameTeam then
				local alive = getAliveParts(plr.Character)
				if alive and plr.Character then
					local part, pointPos = getSilentBodyPoint(plr.Character, State.SilentPart)
					if part and pointPos then
						local sp, onScreen = Camera:WorldToViewportPoint(pointPos)
						if onScreen and sp.Z > 0 then
							local d = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
							if d <= bestDist and canSeePart(Camera.CFrame.Position, part, plr.Character, State.SilentWallCheck) then
								bestDist = d
								bestPart = part
								bestPos = pointPos + (part.AssemblyLinearVelocity * State.SilentPrediction)
								bestName = plr.Name
							end
						end
					end
				end
			end
		end
	end

	silentTargetPart = bestPart
	silentTargetPos = bestPos
	silentTargetPlayerName = bestName
end

local function passHitChance()
	if State.SilentHitChance >= 100 then
		return true
	end
	return math.random(1, 100) <= State.SilentHitChance
end

if typeof(hookmetamethod) == "function" and typeof(getnamecallmethod) == "function" then
	local oldNamecall
	oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
		local method = getnamecallmethod()
		local args = { ... }

		if State.KeyUnlocked and State.SilentEnabled and silentTargetPos and silentTargetPart and not checkcaller() then
			if self == Workspace and method == "Raycast" and typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
				if passHitChance() then
					local origin = args[1]
					local dist = math.max(args[2].Magnitude, (silentTargetPos - origin).Magnitude + 5)
					args[2] = (silentTargetPos - origin).Unit * dist
					return oldNamecall(self, unpack(args))
				end
			elseif self == Workspace and (method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRayWithWhitelist" or method == "FindPartOnRay") and typeof(args[1]) == "Ray" then
				if passHitChance() then
					local origin = args[1].Origin
					local dist = math.max(args[1].Direction.Magnitude, (silentTargetPos - origin).Magnitude + 5)
					args[1] = Ray.new(origin, (silentTargetPos - origin).Unit * dist)
					return oldNamecall(self, unpack(args))
				end
			end
		end

		return oldNamecall(self, ...)
	end)

	local oldIndex
	oldIndex = hookmetamethod(game, "__index", function(self, key)
		if State.KeyUnlocked and State.SilentEnabled and silentTargetPos and silentTargetPart and self == Mouse and not checkcaller() then
			if key == "Hit" and passHitChance() then
				return CFrame.new(silentTargetPos)
			elseif key == "Target" and passHitChance() then
				return silentTargetPart
			end
		end
		return oldIndex(self, key)
	end)
end

local function selectTargetPart(char, mousePos)
	if State.TargetPartMode == "Head" then
		return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
	elseif State.TargetPartMode == "HumanoidRootPart" then
		return char:FindFirstChild("HumanoidRootPart")
	else
		local bestPart = nil
		local bestDist = math.huge
		for _, item in ipairs(char:GetChildren()) do
			if item:IsA("BasePart") and item.Name ~= "HumanoidRootPart" then
				local sp, onScreen = Camera:WorldToViewportPoint(item.Position)
				if onScreen and sp.Z > 0 then
					local d = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
					if d < bestDist then
						bestDist = d
						bestPart = item
					end
				end
			end
		end
		return bestPart or char:FindFirstChild("HumanoidRootPart")
	end
end

local function findAimTarget(mousePos)
	if State.StickyTarget and lockedPart and lockedPart.Parent then
		local char = lockedPart:FindFirstAncestorOfClass("Model")
		local alive = getAliveParts(char)
		if alive and char then
			local plr = Players:GetPlayerFromCharacter(char)
			local sameTeam = State.TeamCheck and plr and (LocalPlayer.Team ~= nil) and (plr.Team == LocalPlayer.Team)
			if not sameTeam then
				local sp, onScreen = Camera:WorldToViewportPoint(lockedPart.Position)
				if onScreen and sp.Z > 0 then
					local d = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
					if d <= State.FOVRadius * 1.15 and canSeePart(Camera.CFrame.Position, lockedPart, char, State.WallCheck) then
						return lockedPart
					end
				end
			end
		end
		lockedPart = nil
	end

	local best = nil
	local bestDist = State.FOVRadius

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local sameTeam = State.TeamCheck and (LocalPlayer.Team ~= nil) and (plr.Team == LocalPlayer.Team)
			if not sameTeam then
				local alive = getAliveParts(plr.Character)
				if alive and plr.Character then
					local part = selectTargetPart(plr.Character, mousePos)
					if part then
						local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
						if onScreen and sp.Z > 0 then
							local d = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
							if d <= bestDist and canSeePart(Camera.CFrame.Position, part, plr.Character, State.WallCheck) then
								bestDist = d
								best = part
							end
						end
					end
				end
			end
		end
	end

	lockedPart = best
	return best
end

RunService.RenderStepped:Connect(function(dt)
	Camera = Workspace.CurrentCamera
	if not Camera then
		return
	end

	if State.KeyUnlocked and State.ActiveTab == "Skin3D" and State.SkinAutoRotate and not vpDragging then
		skinYaw = (skinYaw + State.SkinRotateSpeed * dt) % 360
		updateSkinCamera()
	end

	local mousePos = UserInputService:GetMouseLocation()
	local vp = Camera.ViewportSize

	updateSilentTarget(mousePos)

	chHolder.Visible = State.KeyUnlocked and State.CrosshairEnabled
	if chHolder.Visible then
		local len = State.CrosshairSize
		local gap = math.max(3, math.floor(len * 0.4))
		chTop.Size = UDim2.new(0, 2, 0, len)
		chTop.Position = UDim2.new(0.5, -1, 0.5, -(gap + len))
		chBot.Size = UDim2.new(0, 2, 0, len)
		chBot.Position = UDim2.new(0.5, -1, 0.5, gap)
		chLeft.Size = UDim2.new(0, len, 0, 2)
		chLeft.Position = UDim2.new(0.5, -(gap + len), 0.5, -1)
		chRight.Size = UDim2.new(0, len, 0, 2)
		chRight.Position = UDim2.new(0.5, gap, 0.5, -1)
	end

	fovCircle.Visible = State.KeyUnlocked and State.FOVEnabled and (State.AimEnabled or State.AutoFireVisible)
	if fovCircle.Visible then
		local diam = State.FOVRadius * 2
		fovCircle.Size = UDim2.new(0, diam, 0, diam)
		fovCircle.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
	end

	silentFovCircle.Visible = State.KeyUnlocked and State.SilentEnabled and State.SilentFOVEnabled
	if silentFovCircle.Visible then
		local sDiam = State.SilentFOVRadius * 2
		silentFovCircle.Size = UDim2.new(0, sDiam, 0, sDiam)
		silentFovCircle.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
		silentFovStroke.Color = silentTargetPart and Theme.Success or Theme.SilentAccent
	end

	local myAlive, myHum, myHRP = getAliveParts(LocalPlayer.Character)
	local myChar = LocalPlayer.Character

	local nearestEnemyHRP = nil
	local nearestDist = math.huge
	local enemyCount = 0

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local sameTeam = State.TeamCheck and (LocalPlayer.Team ~= nil) and (plr.Team == LocalPlayer.Team)
			if not sameTeam then
				local alive, _, hrp = getAliveParts(plr.Character)
				if alive and hrp then
					enemyCount += 1
					local refPos = myHRP and myHRP.Position or Camera.CFrame.Position
					local d = (hrp.Position - refPos).Magnitude
					if d < nearestDist then
						nearestDist = d
						nearestEnemyHRP = hrp
					end
				end
			end
		end
	end

	radarCard.Visible = State.KeyUnlocked and State.RadarHudEnabled
	if radarCard.Visible then
		radarInfo.Text = string.format("Enemies: %d | Silent: %s", enemyCount, silentTargetPlayerName)
	end

	if State.KeyUnlocked then
		if State.FOVOverride then
			Camera.FieldOfView = State.CustomFOV
		end
		if State.WalkSpeedBoost and myAlive and myHum then
			myHum.WalkSpeed = State.WalkSpeedVal
		end

		if State.AntiRagdollEnabled and myAlive and myHum then
			myHum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			myHum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			local st = myHum:GetState()
			if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
				myHum:ChangeState(Enum.HumanoidStateType.GettingUp)
			end
		end

		if State.BHopEnabled and myAlive and myHum and myHRP then
			if myHum.FloorMaterial ~= Enum.Material.Air and myHum.MoveDirection.Magnitude > 0.05 then
				myHum:ChangeState(Enum.HumanoidStateType.Jumping)
				myHRP.AssemblyLinearVelocity = Vector3.new(
					myHRP.AssemblyLinearVelocity.X * State.BHopBoost,
					myHRP.AssemblyLinearVelocity.Y,
					myHRP.AssemblyLinearVelocity.Z * State.BHopBoost
				)
			end
		end

		if State.CFrameSpeedEnabled and myAlive and myHum and myHRP and not State.FlyEnabled then
			local moveDir = myHum.MoveDirection
			if moveDir.Magnitude > 0.05 then
				local stepDist = myHum.WalkSpeed * (State.CFrameSpeedMult - 1) * dt
				myHRP.CFrame = myHRP.CFrame + (moveDir.Unit * stepDist)
			end
		end

		if State.OrbitTargetEnabled and myAlive and myHRP and nearestEnemyHRP then
			orbitAngle = (orbitAngle + State.OrbitSpeed * dt) % (math.pi * 2)
			local offset = Vector3.new(
				math.cos(orbitAngle) * State.OrbitRadius,
				0,
				math.sin(orbitAngle) * State.OrbitRadius
			)
			local goalPos = nearestEnemyHRP.Position + offset
			myHRP.CFrame = CFrame.lookAt(goalPos, Vector3.new(nearestEnemyHRP.Position.X, goalPos.Y, nearestEnemyHRP.Position.Z))
		end

		if State.SpinbotEnabled and myAlive and myHRP and myHum and not State.OrbitTargetEnabled then
			myHum.AutoRotate = false
			spinAngle = (spinAngle + State.SpinSpeed * dt * 25) % 360
			local pos = myHRP.Position
			myHRP.CFrame = CFrame.new(pos) * CFrame.Angles(0, math.rad(spinAngle), 0)
		elseif myHum and not State.OrbitTargetEnabled then
			myHum.AutoRotate = true
		end

		if State.NoClipEnabled and myChar then
			for _, part in ipairs(myChar:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end

		if State.FlyEnabled and myAlive and myHRP then
			if not flyBodyVel or flyBodyVel.Parent ~= myHRP then
				if flyBodyVel then
					flyBodyVel:Destroy()
				end
				local bv = Instance.new("BodyVelocity")
				bv.Name = "AstralFlyBV"
				bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
				bv.Velocity = Vector3.zero
				bv.Parent = myHRP
				flyBodyVel = bv
			end
			local moveVec = Vector3.zero
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				moveVec += Camera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				moveVec -= Camera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				moveVec += Camera.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				moveVec -= Camera.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				moveVec += Vector3.new(0, 1, 0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				moveVec -= Vector3.new(0, 1, 0)
			end
			if moveVec.Magnitude > 0 then
				moveVec = moveVec.Unit * State.FlySpeed
			end
			flyBodyVel.Velocity = moveVec
		elseif flyBodyVel then
			flyBodyVel:Destroy()
			flyBodyVel = nil
		end

		if State.RapidFireEnabled and myAlive and myChar then
			if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
				if (os.clock() - lastRapidShot) >= State.RapidFireDelay then
					lastRapidShot = os.clock()
					local tool = myChar:FindFirstChildOfClass("Tool")
					if tool then
						tool:Activate()
					end
				end
			end
		end

		if State.KillAuraEnabled and myAlive and myHRP and myChar then
			if (os.clock() - lastAuraHit) >= 0.08 then
				for _, plr in ipairs(Players:GetPlayers()) do
					if plr ~= LocalPlayer then
						local sameTeam = State.TeamCheck and (LocalPlayer.Team ~= nil) and (plr.Team == LocalPlayer.Team)
						if not sameTeam then
							local alive, _, hrp = getAliveParts(plr.Character)
							if alive and hrp and (hrp.Position - myHRP.Position).Magnitude <= State.KillAuraRange then
								lastAuraHit = os.clock()
								local tool = myChar:FindFirstChildOfClass("Tool")
								if tool then
									tool:Activate()
								end
								break
							end
						end
					end
				end
			end
		end
	end

	if State.KeyUnlocked and State.SpectateNearest and nearestEnemyHRP then
		Camera.CameraType = Enum.CameraType.Scriptable
		local backPos = nearestEnemyHRP.Position - (nearestEnemyHRP.CFrame.LookVector * 8) + Vector3.new(0, 3, 0)
		Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(backPos, nearestEnemyHRP.Position), 0.25)
	elseif Camera.CameraType == Enum.CameraType.Scriptable and not State.SpectateNearest then
		Camera.CameraType = Enum.CameraType.Custom
	end

	if State.KeyUnlocked and (State.AimEnabled or State.AutoFireVisible) then
		local rmb = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
		local activeAim = (not State.AimHoldOnly) or rmb or State.AutoFireVisible
		local part = activeAim and findAimTarget(mousePos) or nil

		if part then
			local predicted = part.Position + (part.AssemblyLinearVelocity * State.Prediction)

			if State.AimEnabled and ((not State.AimHoldOnly) or rmb) then
				if State.AimMode == "Camera" then
					local goalCF = CFrame.lookAt(Camera.CFrame.Position, predicted)
					Camera.CFrame = Camera.CFrame:Lerp(goalCF, math.clamp(State.Smoothness, 0.02, 1))
				elseif State.AimMode == "Snap" then
					Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, predicted)
				elseif State.AimMode == "Triggerbot" then
					local sp, onScreen = Camera:WorldToViewportPoint(predicted)
					if onScreen and sp.Z > 0 then
						local d = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
						if d <= 24 and (os.clock() - lastShot) >= State.TriggerDelay then
							lastShot = os.clock()
							local tool = myChar and myChar:FindFirstChildOfClass("Tool")
							if tool then
								tool:Activate()
							end
						end
					end
				end
			end

			if State.AutoFireVisible and (os.clock() - lastShot) >= State.TriggerDelay then
				lastShot = os.clock()
				local tool = myChar and myChar:FindFirstChildOfClass("Tool")
				if tool then
					tool:Activate()
				end
			end
		else
			lockedPart = nil
		end
	else
		lockedPart = nil
	end

	local tracerOrigin = Vector2.new(vp.X * 0.5, vp.Y)
	if State.TracerOrigin == "Center" then
		tracerOrigin = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
	elseif State.TracerOrigin == "Mouse" then
		tracerOrigin = mousePos
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			if not espPool[plr] then
				espPool[plr] = createESPSet()
			end
			local s = espPool[plr]

			local sameTeamAim = State.TeamCheck and (LocalPlayer.Team ~= nil) and (plr.Team == LocalPlayer.Team)
			local sameTeamESP = State.ESPTeamCheck and (LocalPlayer.Team ~= nil) and (plr.Team == LocalPlayer.Team)
			local alive, hum, hrp = getAliveParts(plr.Character)

			if plr.Character then
				local targetHB = (State.HitboxPart == "Head")
					and plr.Character:FindFirstChild("Head")
					or hrp
				if targetHB then
					if State.KeyUnlocked and State.HitboxEnabled and alive and not sameTeamAim then
						targetHB.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
						targetHB.Transparency = State.HitboxTransparency
						targetHB.CanCollide = false
					else
						if targetHB.Name == "Head" then
							targetHB.Size = Vector3.new(2, 1, 1)
							targetHB.Transparency = 0
						else
							targetHB.Size = Vector3.new(2, 2, 1)
							targetHB.Transparency = 1
						end
					end
				end
			end

			if not State.KeyUnlocked or not State.ESPEnabled or sameTeamESP or not alive or not hum or not hrp then
				hideESPSet(s)
			else
				local dist3D = (hrp.Position - Camera.CFrame.Position).Magnitude
				if dist3D > State.ESPMaxDist then
					hideESPSet(s)
				else
					local rootSP, onScreen = Camera:WorldToViewportPoint(hrp.Position)
					if not onScreen or rootSP.Z <= 0 then
						hideESPSet(s)
					else
						local topSP = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 2.7, 0))
						local botSP = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.1, 0))
						local h = math.max(math.abs(botSP.Y - topSP.Y), 16)
						local w = math.max(h * 0.58, 12)
						local tl = Vector2.new(rootSP.X - w * 0.5, topSP.Y)
						local sz = Vector2.new(w, h)
						local col = (silentTargetPlayerName == plr.Name) and Theme.SilentAccent or Theme.AccentBright

						if State.BoxESP then
							s.Box.Position = UDim2.new(0, tl.X, 0, tl.Y)
							s.Box.Size = UDim2.new(0, sz.X, 0, sz.Y)
							s.Box.Visible = true
						else
							s.Box.Visible = false
						end

						if State.CornerBoxESP then
							drawCornerBox(s, tl, sz, col)
						else
							s.C_TL_H.Visible = false
							s.C_TL_V.Visible = false
							s.C_TR_H.Visible = false
							s.C_TR_V.Visible = false
							s.C_BL_H.Visible = false
							s.C_BL_V.Visible = false
							s.C_BR_H.Visible = false
							s.C_BR_V.Visible = false
						end

						if State.TracerESP then
							drawLine(s.Tracer, tracerOrigin, Vector2.new(rootSP.X, botSP.Y), 1.4, col)
						else
							s.Tracer.Visible = false
						end

						if State.InfoESP then
							local hpPct = math.clamp(math.floor((hum.Health / math.max(hum.MaxHealth, 1)) * 100 + 0.5), 0, 100)
							s.Tag.Text = string.format(" %s | %d%% HP | %dm ", plr.Name, hpPct, math.floor(dist3D))
							s.Tag.Size = UDim2.new(0, math.max(#s.Tag.Text * 6 + 10, 80), 0, 18)
							s.Tag.Position = UDim2.new(0, rootSP.X - s.Tag.Size.X.Offset * 0.5, 0, tl.Y - 22)
							s.Tag.Visible = true
						else
							s.Tag.Visible = false
						end

						for _, b in ipairs(s.Bones) do
							b.Visible = false
						end

						if State.SkeletonESP and plr.Character then
							local head = plr.Character:FindFirstChild("Head")
							local torso = plr.Character:FindFirstChild("UpperTorso") or plr.Character:FindFirstChild("Torso")
							local lArm = plr.Character:FindFirstChild("LeftUpperArm") or plr.Character:FindFirstChild("Left Arm")
							local rArm = plr.Character:FindFirstChild("RightUpperArm") or plr.Character:FindFirstChild("Right Arm")
							local lLeg = plr.Character:FindFirstChild("LeftUpperLeg") or plr.Character:FindFirstChild("Left Leg")
							local rLeg = plr.Character:FindFirstChild("RightUpperLeg") or plr.Character:FindFirstChild("Right Leg")

							local idx = 1
							local function linkBone(a, b)
								if a and b and idx <= #s.Bones then
									local sA, vA = Camera:WorldToViewportPoint(a.Position)
									local sB, vB = Camera:WorldToViewportPoint(b.Position)
									if vA and vB and sA.Z > 0 and sB.Z > 0 then
										drawLine(s.Bones[idx], Vector2.new(sA.X, sA.Y), Vector2.new(sB.X, sB.Y), 1.5, Theme.TextMain)
										idx += 1
									end
								end
							end

							linkBone(head, torso)
							linkBone(torso, lArm)
							linkBone(torso, rArm)
							linkBone(torso, lLeg)
							linkBone(torso, rLeg)
						end
					end
				end
			end
		end
	end
end)
