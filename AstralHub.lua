--!nocheck
-- ASTRAL HUB v2.4 | GitHub Module | Aimbot + Silent Aim v2 + Rage + Smooth ESP + Skin 3D + Configs

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

local HUB_HOTKEY = Enum.KeyCode.RightShift
local ALT_HOTKEY = Enum.KeyCode.Insert

local COLOR_THEMES = {
	["Astral Violet"] = {
		BgMain = Color3.fromRGB(16, 10, 30),
		BgCard = Color3.fromRGB(27, 17, 50),
		BgCardHover = Color3.fromRGB(38, 24, 70),
		BgInput = Color3.fromRGB(11, 7, 21),
		Stroke = Color3.fromRGB(139, 92, 246),
		Accent = Color3.fromRGB(168, 85, 247),
		AccentBright = Color3.fromRGB(192, 132, 252),
		SilentAccent = Color3.fromRGB(56, 189, 248)
	},
	["Crimson Void"] = {
		BgMain = Color3.fromRGB(22, 9, 14),
		BgCard = Color3.fromRGB(38, 14, 22),
		BgCardHover = Color3.fromRGB(56, 19, 31),
		BgInput = Color3.fromRGB(14, 6, 9),
		Stroke = Color3.fromRGB(239, 68, 68),
		Accent = Color3.fromRGB(220, 38, 38),
		AccentBright = Color3.fromRGB(248, 113, 113),
		SilentAccent = Color3.fromRGB(251, 146, 60)
	},
	["Cyber Cyan"] = {
		BgMain = Color3.fromRGB(8, 18, 26),
		BgCard = Color3.fromRGB(13, 30, 42),
		BgCardHover = Color3.fromRGB(19, 44, 60),
		BgInput = Color3.fromRGB(5, 12, 18),
		Stroke = Color3.fromRGB(34, 211, 238),
		Accent = Color3.fromRGB(6, 182, 212),
		AccentBright = Color3.fromRGB(103, 232, 249),
		SilentAccent = Color3.fromRGB(167, 139, 250)
	},
	["Emerald Ghost"] = {
		BgMain = Color3.fromRGB(9, 21, 16),
		BgCard = Color3.fromRGB(15, 36, 27),
		BgCardHover = Color3.fromRGB(22, 52, 39),
		BgInput = Color3.fromRGB(6, 14, 10),
		Stroke = Color3.fromRGB(52, 211, 153),
		Accent = Color3.fromRGB(16, 185, 129),
		AccentBright = Color3.fromRGB(110, 231, 183),
		SilentAccent = Color3.fromRGB(56, 189, 248)
	}
}

local Theme = {
	BgMain = COLOR_THEMES["Astral Violet"].BgMain,
	BgCard = COLOR_THEMES["Astral Violet"].BgCard,
	BgCardHover = COLOR_THEMES["Astral Violet"].BgCardHover,
	BgInput = COLOR_THEMES["Astral Violet"].BgInput,
	Stroke = COLOR_THEMES["Astral Violet"].Stroke,
	Accent = COLOR_THEMES["Astral Violet"].Accent,
	AccentBright = COLOR_THEMES["Astral Violet"].AccentBright,
	SilentAccent = COLOR_THEMES["Astral Violet"].SilentAccent,
	TextMain = Color3.fromRGB(245, 243, 255),
	TextMuted = Color3.fromRGB(167, 155, 204),
	Success = Color3.fromRGB(74, 222, 128),
	Error = Color3.fromRGB(248, 113, 113),
	GlassAlpha = 0.22
}

local THEME_NAMES = { "Astral Violet", "Crimson Void", "Cyber Cyan", "Emerald Ghost" }
local CONFIG_PROFILES = { "Default", "Legit", "Rage", "HvH" }
local AIM_MODES = { "Camera", "Snap", "Triggerbot" }
local TARGET_PARTS = { "Head", "HumanoidRootPart", "Nearest" }
local SILENT_PARTS = { "Head", "Neck", "Torso", "Arms", "Legs" }
local TRACER_ORIGINS = { "Bottom", "Center", "Mouse" }
local HITBOX_PARTS = { "HumanoidRootPart", "Head" }

local DEFAULT_STATE = {
	HubReady = false,
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
	ESPSmoothness = 0.35,

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
	SkinRotateSpeed = 35,

	ConfigProfile = "Default",
	AutoSaveEnabled = true,
	NotificationsEnabled = true,
	ColorTheme = "Astral Violet",
	CompactMode = false,
	WatermarkEnabled = true,
	FPSSaverEnabled = false
}

local function cloneTable(t)
	local copy = {}
	for k, v in pairs(t) do
		copy[k] = v
	end
	return copy
end

local State = cloneTable(DEFAULT_STATE)

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

local splashActive = true

local function updateBlur()
	if not blurEffect or not blurEffect.Parent then
		return
	end
	local active = State.BlurEnabled and (splashActive or (State.HubVisible and not State.Minimized))
	TweenService:Create(blurEffect, TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Size = active and math.max(State.BlurSize, splashActive and 18 or 0) or 0
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

-- FIXED: safe TeamColor comparison to avoid 'Neutral' BrickColor error
local function isTeammate(plr, enabled)
	if not enabled or not plr or plr == LocalPlayer then
		return false
	end
	if LocalPlayer.Team and plr.Team then
		return plr.Team == LocalPlayer.Team
	end
	if not LocalPlayer.Team or not plr.Team then
		return false
	end
	return false
end

local function getAliveParts(char)
	if not char or not char.Parent then
		return false, nil, nil
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp or hum.Health <= 0 then
		return false, hum, hrp
	end
	return true, hum, hrp
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

-- Загрузочный фон (Splash Screen)
local splashBg = Instance.new("Frame")
splashBg.Name = "AstralSplashScreen"
splashBg.Size = UDim2.new(1, 0, 1, 0)
splashBg.Position = UDim2.new(0, 0, 0, 0)
splashBg.BackgroundColor3 = Theme.BgMain
splashBg.BackgroundTransparency = 0.14
splashBg.BorderSizePixel = 0
splashBg.ZIndex = 50
splashBg.Parent = gui

local splashGrad = Instance.new("UIGradient")
splashGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.55, Color3.fromRGB(165, 130, 235)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 45, 120))
})
splashGrad.Rotation = 35
splashGrad.Parent = splashBg

local glowOrb1 = Instance.new("Frame")
glowOrb1.Size = UDim2.new(0, 320, 0, 320)
glowOrb1.Position = UDim2.new(0.5, -240, 0.5, -190)
glowOrb1.BackgroundColor3 = Theme.Accent
glowOrb1.BackgroundTransparency = 0.78
glowOrb1.BorderSizePixel = 0
glowOrb1.ZIndex = 51
glowOrb1.Parent = splashBg
addCorner(glowOrb1, 999)

local glowOrb2 = Instance.new("Frame")
glowOrb2.Size = UDim2.new(0, 260, 0, 260)
glowOrb2.Position = UDim2.new(0.5, -10, 0.5, -50)
glowOrb2.BackgroundColor3 = Theme.SilentAccent
glowOrb2.BackgroundTransparency = 0.84
glowOrb2.BorderSizePixel = 0
glowOrb2.ZIndex = 51
glowOrb2.Parent = splashBg
addCorner(glowOrb2, 999)

local splashCard = Instance.new("Frame")
splashCard.Name = "SplashCenterCard"
splashCard.AnchorPoint = Vector2.new(0.5, 0.5)
splashCard.Size = UDim2.new(0, 410, 0, 195)
splashCard.Position = UDim2.new(0.5, 0, 0.5, 0)
splashCard.BackgroundColor3 = Theme.BgCard
splashCard.BackgroundTransparency = 0.18
splashCard.BorderSizePixel = 0
splashCard.ZIndex = 52
splashCard.Parent = splashBg
addCorner(splashCard, 18)
local splashStroke = addStroke(splashCard, Theme.Stroke, 1.5, 0.2)

local splashScale = Instance.new("UIScale")
splashScale.Scale = 0.92
splashScale.Parent = splashCard

local splashTag = Instance.new("TextLabel")
splashTag.Size = UDim2.new(1, -32, 0, 20)
splashTag.Position = UDim2.new(0, 16, 0, 18)
splashTag.BackgroundTransparency = 1
splashTag.Text = "✦ ASTRAL HUB  •  v2.4"
splashTag.TextColor3 = Theme.AccentBright
splashTag.Font = Enum.Font.GothamBold
splashTag.TextSize = 11
splashTag.TextXAlignment = Enum.TextXAlignment.Left
splashTag.ZIndex = 53
splashTag.Parent = splashCard

local splashMainTitle = Instance.new("TextLabel")
splashMainTitle.Size = UDim2.new(1, -32, 0, 32)
splashMainTitle.Position = UDim2.new(0, 16, 0, 40)
splashMainTitle.BackgroundTransparency = 1
splashMainTitle.Text = "Загрузка интерфейса..."
splashMainTitle.TextColor3 = Theme.TextMain
splashMainTitle.Font = Enum.Font.GothamBold
splashMainTitle.TextSize = 21
splashMainTitle.TextXAlignment = Enum.TextXAlignment.Left
splashMainTitle.ZIndex = 53
splashMainTitle.Parent = splashCard

local splashStatus = Instance.new("TextLabel")
splashStatus.Size = UDim2.new(1, -32, 0, 20)
splashStatus.Position = UDim2.new(0, 16, 0, 76)
splashStatus.BackgroundTransparency = 1
splashStatus.Text = "Подготовка модулей Aimbot, Silent Aim, Rage и ESP..."
splashStatus.TextColor3 = Theme.TextMuted
splashStatus.Font = Enum.Font.GothamMedium
splashStatus.TextSize = 11
splashStatus.TextXAlignment = Enum.TextXAlignment.Left
splashStatus.TextTruncate = Enum.TextTruncate.AtEnd
splashStatus.ZIndex = 53
splashStatus.Parent = splashCard

local splashPct = Instance.new("TextLabel")
splashPct.Size = UDim2.new(0, 60, 0, 18)
splashPct.Position = UDim2.new(1, -76, 0, 114)
splashPct.BackgroundTransparency = 1
splashPct.Text = "0%"
splashPct.TextColor3 = Theme.AccentBright
splashPct.Font = Enum.Font.GothamBold
splashPct.TextSize = 11
splashPct.TextXAlignment = Enum.TextXAlignment.Right
splashPct.ZIndex = 53
splashPct.Parent = splashCard

local splashBarBg = Instance.new("Frame")
splashBarBg.Size = UDim2.new(1, -32, 0, 8)
splashBarBg.Position = UDim2.new(0, 16, 0, 138)
splashBarBg.BackgroundColor3 = Theme.BgInput
splashBarBg.BackgroundTransparency = 0.2
splashBarBg.BorderSizePixel = 0
splashBarBg.ZIndex = 53
splashBarBg.Parent = splashCard
addCorner(splashBarBg, 999)

local splashBarFill = Instance.new("Frame")
splashBarFill.Size = UDim2.new(0, 0, 1, 0)
splashBarFill.BackgroundColor3 = Theme.AccentBright
splashBarFill.BorderSizePixel = 0
splashBarFill.ZIndex = 54
splashBarFill.Parent = splashBarBg
addCorner(splashBarFill, 999)

local splashFooter = Instance.new("TextLabel")
splashFooter.Size = UDim2.new(1, -32, 0, 18)
splashFooter.Position = UDim2.new(0, 16, 1, -28)
splashFooter.BackgroundTransparency = 1
splashFooter.Text = "Автоматическое открытие меню после инициализации"
splashFooter.TextColor3 = Theme.TextMuted
splashFooter.Font = Enum.Font.Gotham
splashFooter.TextSize = 10
splashFooter.TextXAlignment = Enum.TextXAlignment.Left
splashFooter.ZIndex = 53
splashFooter.Parent = splashCard

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
	if not State.NotificationsEnabled and not isError then
		return
	end
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

-- Watermark HUD
local watermarkCard = Instance.new("Frame")
watermarkCard.Name = "AstralWatermarkHUD"
watermarkCard.Size = UDim2.new(0, 315, 0, 28)
watermarkCard.Position = UDim2.new(0.5, -157, 0, 12)
watermarkCard.BackgroundColor3 = Theme.BgCard
watermarkCard.BackgroundTransparency = 0.25
watermarkCard.Visible = false
watermarkCard.Parent = gui
addCorner(watermarkCard, 8)
local wmStroke = addStroke(watermarkCard, Theme.Accent, 1, 0.35)
makeDraggable(watermarkCard, watermarkCard)

local wmLabel = Instance.new("TextLabel")
wmLabel.Size = UDim2.new(1, -14, 1, 0)
wmLabel.Position = UDim2.new(0, 7, 0, 0)
wmLabel.BackgroundTransparency = 1
wmLabel.Text = "✦ ASTRAL HUB  |  60 FPS"
wmLabel.TextColor3 = Theme.TextMain
wmLabel.Font = Enum.Font.GothamBold
wmLabel.TextSize = 11
wmLabel.Parent = watermarkCard

local triggerBtn = Instance.new("TextButton")
triggerBtn.Name = "AstralTrigger"
triggerBtn.Size = UDim2.new(0, 114, 0, 30)
triggerBtn.Position = UDim2.new(0, 14, 0.5, -15)
triggerBtn.BackgroundColor3 = Theme.BgCard
triggerBtn.BackgroundTransparency = 0.25
triggerBtn.Text = "✦ ASTRAL [RSH]"
triggerBtn.TextColor3 = Theme.AccentBright
triggerBtn.Font = Enum.Font.GothamBold
triggerBtn.TextSize = 11
triggerBtn.AutoButtonColor = false
triggerBtn.Visible = false
triggerBtn.Parent = gui
addCorner(triggerBtn, 8)
local trigStroke = addStroke(triggerBtn, Theme.Accent, 1, 0.35)
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
local radarStroke = addStroke(radarCard, Theme.Stroke, 1.1, 0.35)
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

-- Main Hub
local HUB_NORMAL_SIZE = UDim2.new(0, 720, 0, 475)
local HUB_COMPACT_SIZE = UDim2.new(0, 620, 0, 405)

local hub = Instance.new("Frame")
hub.Name = "AstralMainWindow"
hub.AnchorPoint = Vector2.new(0.5, 0.5)
hub.Size = HUB_NORMAL_SIZE
hub.Position = UDim2.new(0.5, 0, 0.5, 24)
hub.BackgroundColor3 = Theme.BgMain
hub.BackgroundTransparency = Theme.GlassAlpha
hub.Visible = false
hub.ClipsDescendants = true
hub.Parent = gui
addCorner(hub, 15)
local hubStroke = addStroke(hub, Theme.Stroke, 1.4, 0.25)

local hubScale = Instance.new("UIScale")
hubScale.Scale = 0.94
hubScale.Parent = hub

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
statusBadge.Size = UDim2.new(0, 118, 0, 24)
statusBadge.Position = UDim2.new(1, -203, 0.5, -12)
statusBadge.BackgroundColor3 = Theme.BgInput
statusBadge.BackgroundTransparency = 0.25
statusBadge.Text = "ASTRAL READY"
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
local uiSyncList = {}
local themedCards = {}
local themedStrokes = {}
local themedInputs = {}
local themedAccents = {}
local rebuildSkinPreview = nil
local scheduleAutoSave = nil

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
	table.insert(themedAccents, { obj = sf, prop = "ScrollBarImageColor3", key = "Accent" })

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
	table.insert(themedAccents, { obj = l, prop = "TextColor3", key = "AccentBright" })
end

local function addToggle(parent, title, desc, initVal, order, cb, stateKey)
	local cur = initVal
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 50)
	card.LayoutOrder = order
	card.BackgroundColor3 = Theme.BgCard
	card.BackgroundTransparency = Theme.GlassAlpha
	card.Parent = parent
	addCorner(card, 10)
	local st = addStroke(card, Theme.Stroke, 1, 0.45)
	table.insert(themedCards, card)
	table.insert(themedStrokes, st)

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

	local function setVisual(val, fireCb, triggerSave)
		cur = not not val
		sw.BackgroundColor3 = cur and Theme.Accent or Theme.BgInput
		knob.Position = cur and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
		if fireCb and cb then
			cb(cur)
		end
		if triggerSave and scheduleAutoSave then
			scheduleAutoSave()
		end
	end

	sw.MouseButton1Click:Connect(function()
		setVisual(not cur, true, true)
	end)

	table.insert(uiSyncList, function()
		local nextVal = stateKey and State[stateKey] or cur
		setVisual(nextVal, true, false)
	end)
end

local function addSlider(parent, title, minV, maxV, initV, step, order, cb, stateKey)
	local cur = math.clamp(initV, minV, maxV)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 56)
	card.LayoutOrder = order
	card.BackgroundColor3 = Theme.BgCard
	card.BackgroundTransparency = Theme.GlassAlpha
	card.Parent = parent
	addCorner(card, 10)
	local st = addStroke(card, Theme.Stroke, 1, 0.45)
	table.insert(themedCards, card)
	table.insert(themedStrokes, st)

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
	table.insert(themedAccents, { obj = vLbl, prop = "TextColor3", key = "AccentBright" })

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, -24, 0, 7)
	bar.Position = UDim2.new(0, 12, 0, 35)
	bar.BackgroundColor3 = Theme.BgInput
	bar.BackgroundTransparency = 0.2
	bar.Parent = card
	addCorner(bar, 999)
	table.insert(themedInputs, bar)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((cur - minV) / math.max(maxV - minV, 1e-5), 0, 1, 0)
	fill.BackgroundColor3 = Theme.AccentBright
	fill.Parent = bar
	addCorner(fill, 999)
	table.insert(themedAccents, { obj = fill, prop = "BackgroundColor3", key = "AccentBright" })

	local function setVal(val, fireCb, triggerSave)
		local snapped = math.floor(val / step + 0.5) * step
		snapped = math.clamp(math.floor(snapped * 100 + 0.5) / 100, minV, maxV)
		cur = snapped
		vLbl.Text = tostring(cur)
		fill.Size = UDim2.new((cur - minV) / math.max(maxV - minV, 1e-5), 0, 1, 0)
		if fireCb and cb then
			cb(cur)
		end
		if triggerSave and scheduleAutoSave then
			scheduleAutoSave()
		end
	end

	local dragging = false
	local function applyX(x)
		local ratio = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
		local raw = minV + (maxV - minV) * ratio
		setVal(raw, true, true)
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

	table.insert(uiSyncList, function()
		local nextVal = stateKey and State[stateKey] or cur
		setVal(nextVal, true, false)
	end)
end

local function addCycle(parent, title, opts, initOpt, order, cb, stateKey)
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
	local st = addStroke(card, Theme.Stroke, 1, 0.45)
	table.insert(themedCards, card)
	table.insert(themedStrokes, st)

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
	local bSt = addStroke(btn, Theme.Accent, 1, 0.45)
	table.insert(themedInputs, btn)
	table.insert(themedAccents, { obj = btn, prop = "TextColor3", key = "AccentBright" })
	table.insert(themedStrokes, bSt)

	local function setOpt(optVal, fireCb, triggerSave)
		local found = 1
		for i, o in ipairs(opts) do
			if o == optVal then
				found = i
				break
			end
		end
		idx = found
		local selected = opts[idx]
		btn.Text = selected .. "  ▸"
		if fireCb and cb then
			cb(selected)
		end
		if triggerSave and scheduleAutoSave then
			scheduleAutoSave()
		end
	end

	btn.MouseButton1Click:Connect(function()
		local nextIdx = (idx % #opts) + 1
		setOpt(opts[nextIdx], true, true)
	end)

	table.insert(uiSyncList, function()
		local nextOpt = stateKey and State[stateKey] or opts[idx]
		setOpt(nextOpt, true, false)
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
	local bSt = addStroke(b, Theme.Accent, 1, 0.35)
	table.insert(themedInputs, b)
	table.insert(themedStrokes, bSt)
	b.MouseButton1Click:Connect(cb)
	return b
end

createTab("Aimbot", "🎯  Aimbot", 1)
createTab("Silent", "👻  Silent Aim", 2)
createTab("Rage", "🔥  Rage", 3)
createTab("ESP", "👁️  ESP", 4)
createTab("Skin3D", "🧍  Skin 3D", 5)
createTab("Visuals", "✨  Visuals / Extra", 6)
createTab("Settings", "⚙️  Settings", 7)

local aimPage = createPage("Aimbot")
local silentPage = createPage("Silent")
local ragePage = createPage("Rage")
local espPage = createPage("ESP")
local skinPage = createPage("Skin3D")
local visPage = createPage("Visuals")
local settingsPage = createPage("Settings")

-- Aimbot
addSection(aimPage, "Обычный аимбот (наводка камеры)", 1)
addToggle(aimPage, "Enable Aimbot", "Включает плавное наведение камеры на цель", State.AimEnabled, 2, function(v) State.AimEnabled = v end, "AimEnabled")
addCycle(aimPage, "Aim Mode", AIM_MODES, State.AimMode, 3, function(v) State.AimMode = v end, "AimMode")
addCycle(aimPage, "Target Part", TARGET_PARTS, State.TargetPartMode, 4, function(v) State.TargetPartMode = v end, "TargetPartMode")
addToggle(aimPage, "Hold RMB Only", "Наводить при зажатой правой кнопке мыши", State.AimHoldOnly, 5, function(v) State.AimHoldOnly = v end, "AimHoldOnly")

addSection(aimPage, "Настройки и проверки", 6)
addToggle(aimPage, "Show Aimbot FOV", "Показывает фиолетовый круг захвата Aimbot", State.FOVEnabled, 7, function(v) State.FOVEnabled = v end, "FOVEnabled")
addSlider(aimPage, "Aimbot FOV Radius", 35, 360, State.FOVRadius, 5, 8, function(v) State.FOVRadius = v end, "FOVRadius")
addSlider(aimPage, "Smoothness", 0.04, 1.0, State.Smoothness, 0.02, 9, function(v) State.Smoothness = v end, "Smoothness")
addSlider(aimPage, "Prediction", 0, 0.35, State.Prediction, 0.01, 10, function(v) State.Prediction = v end, "Prediction")
addToggle(aimPage, "Team Check", "Игнорировать тиммейтов и наводить на противников", State.TeamCheck, 11, function(v) State.TeamCheck = v end, "TeamCheck")
addToggle(aimPage, "Wall Check", "Обновляет видимость цели в реальном времени", State.WallCheck, 12, function(v) State.WallCheck = v end, "WallCheck")
addToggle(aimPage, "Sticky Target Lock", "Удерживать цель пока она жива и видима", State.StickyTarget, 13, function(v) State.StickyTarget = v end, "StickyTarget")
addSlider(aimPage, "Triggerbot Delay", 0.02, 0.3, State.TriggerDelay, 0.01, 14, function(v) State.TriggerDelay = v end, "TriggerDelay")

-- Silent Aim
addSection(silentPage, "Silent Aim (всегда активен без ПКМ)", 1)
addToggle(silentPage, "Enable Silent Aim", "Работает постоянно без ПКМ при стрельбе и зажиме", State.SilentEnabled, 2, function(v)
	State.SilentEnabled = v
end, "SilentEnabled")
addCycle(silentPage, "Магнитить пули в", SILENT_PARTS, State.SilentPart, 3, function(v)
	State.SilentPart = v
end, "SilentPart")
addToggle(silentPage, "Show Silent FOV Circle", "Голубой круг зоны детекта Silent Aim вокруг прицела", State.SilentFOVEnabled, 4, function(v)
	State.SilentFOVEnabled = v
end, "SilentFOVEnabled")
addSlider(silentPage, "Silent FOV Radius", 30, 420, State.SilentFOVRadius, 5, 5, function(v)
	State.SilentFOVRadius = v
end, "SilentFOVRadius")
addSlider(silentPage, "Hit Chance (%)", 10, 100, State.SilentHitChance, 5, 6, function(v)
	State.SilentHitChance = v
end, "SilentHitChance")
addSlider(silentPage, "Silent Prediction", 0, 0.35, State.SilentPrediction, 0.01, 7, function(v)
	State.SilentPrediction = v
end, "SilentPrediction")
addToggle(silentPage, "Silent Team Check", "Игнорировать игроков своей команды", State.SilentTeamCheck, 8, function(v)
	State.SilentTeamCheck = v
end, "SilentTeamCheck")
addToggle(silentPage, "Silent Wall Check", "Игнорировать стены если выключен", State.SilentWallCheck, 9, function(v)
	State.SilentWallCheck = v
end, "SilentWallCheck")

-- Rage
addSection(ragePage, "Боевые Rage-функции", 1)
addToggle(ragePage, "Hitbox Expander", "Увеличивает хитбоксы живых противников", State.HitboxEnabled, 2, function(v) State.HitboxEnabled = v end, "HitboxEnabled")
addCycle(ragePage, "Hitbox Part", HITBOX_PARTS, State.HitboxPart, 3, function(v) State.HitboxPart = v end, "HitboxPart")
addSlider(ragePage, "Hitbox Size", 2, 22, State.HitboxSize, 1, 4, function(v) State.HitboxSize = v end, "HitboxSize")
addSlider(ragePage, "Hitbox Transparency", 0.1, 1.0, State.HitboxTransparency, 0.05, 5, function(v) State.HitboxTransparency = v end, "HitboxTransparency")
addToggle(ragePage, "Rapid Fire", "Быстрая стрельба при удержании ЛКМ", State.RapidFireEnabled, 6, function(v) State.RapidFireEnabled = v end, "RapidFireEnabled")
addSlider(ragePage, "Rapid Fire Delay", 0.01, 0.25, State.RapidFireDelay, 0.01, 7, function(v) State.RapidFireDelay = v end, "RapidFireDelay")
addToggle(ragePage, "Auto Fire on Visible", "Авто-выстрел при появлении цели в FOV", State.AutoFireVisible, 8, function(v) State.AutoFireVisible = v end, "AutoFireVisible")
addToggle(ragePage, "Kill Aura (Close Range)", "Авто-удар оружием по врагам вблизи", State.KillAuraEnabled, 9, function(v) State.KillAuraEnabled = v end, "KillAuraEnabled")
addSlider(ragePage, "Kill Aura Range", 6, 35, State.KillAuraRange, 1, 10, function(v) State.KillAuraRange = v end, "KillAuraRange")
addToggle(ragePage, "Target Orbit", "Кружит вокруг ближайшего живого врага", State.OrbitTargetEnabled, 11, function(v) State.OrbitTargetEnabled = v end, "OrbitTargetEnabled")
addSlider(ragePage, "Orbit Radius", 4, 24, State.OrbitRadius, 1, 12, function(v) State.OrbitRadius = v end, "OrbitRadius")
addSlider(ragePage, "Orbit Speed", 1, 18, State.OrbitSpeed, 1, 13, function(v) State.OrbitSpeed = v end, "OrbitSpeed")

addSection(ragePage, "Anti-Aim и движение", 14)
addToggle(ragePage, "Spinbot (Anti-Aim)", "Быстрое вращение персонажа вокруг своей оси", State.SpinbotEnabled, 15, function(v) State.SpinbotEnabled = v end, "SpinbotEnabled")
addSlider(ragePage, "Spin Speed", 5, 100, State.SpinSpeed, 5, 16, function(v) State.SpinSpeed = v end, "SpinSpeed")
addToggle(ragePage, "Spectate Nearest Enemy", "Наводит камеру на ближайшего врага", State.SpectateNearest, 17, function(v) State.SpectateNearest = v end, "SpectateNearest")
addToggle(ragePage, "BunnyHop (Auto Jump)", "Автоматический прыжок на земле", State.BHopEnabled, 18, function(v) State.BHopEnabled = v end, "BHopEnabled")
addSlider(ragePage, "BHop Speed Boost", 1.0, 2.0, State.BHopBoost, 0.05, 19, function(v) State.BHopBoost = v end, "BHopBoost")
addToggle(ragePage, "CFrame Speed Hack", "Ускоренный рывок по направлению движения", State.CFrameSpeedEnabled, 20, function(v) State.CFrameSpeedEnabled = v end, "CFrameSpeedEnabled")
addSlider(ragePage, "CFrame Speed Mult", 1.0, 3.0, State.CFrameSpeedMult, 0.1, 21, function(v) State.CFrameSpeedMult = v end, "CFrameSpeedMult")
addToggle(ragePage, "Custom Gravity", "Меняет гравитацию в мире", State.GravityOverride, 22, function(v)
	State.GravityOverride = v
	applyGravity(v, State.GravityValue)
end, "GravityOverride")
addSlider(ragePage, "Gravity Value", 20, 250, State.GravityValue, 5, 23, function(v)
	State.GravityValue = v
	if State.GravityOverride then
		applyGravity(true, v)
	end
end, "GravityValue")
addToggle(ragePage, "Anti-Ragdoll / Recover", "Защита от падения в Ragdoll", State.AntiRagdollEnabled, 24, function(v) State.AntiRagdollEnabled = v end, "AntiRagdollEnabled")
addToggle(ragePage, "NoClip", "Прохождение сквозь стены и препятствия", State.NoClipEnabled, 25, function(v) State.NoClipEnabled = v end, "NoClipEnabled")
addToggle(ragePage, "Fly Mode", "Полёт на WASD + Space / LeftShift", State.FlyEnabled, 26, function(v) State.FlyEnabled = v end, "FlyEnabled")
addSlider(ragePage, "Fly Speed", 20, 150, State.FlySpeed, 5, 27, function(v) State.FlySpeed = v end, "FlySpeed")

-- ESP
addSection(espPage, "Все виды ESP", 1)
addToggle(espPage, "Master ESP", "Включает ESP для живых противников", State.ESPEnabled, 2, function(v) State.ESPEnabled = v end, "ESPEnabled")
addToggle(espPage, "Box ESP", "Полная 2D-рамка", State.BoxESP, 3, function(v) State.BoxESP = v end, "BoxESP")
addToggle(espPage, "Corner Box ESP", "Угловые рамки", State.CornerBoxESP, 4, function(v) State.CornerBoxESP = v end, "CornerBoxESP")
addToggle(espPage, "Tracer ESP", "Линии к противникам", State.TracerESP, 5, function(v) State.TracerESP = v end, "TracerESP")
addCycle(espPage, "Tracer Origin", TRACER_ORIGINS, State.TracerOrigin, 6, function(v) State.TracerOrigin = v end, "TracerOrigin")
addToggle(espPage, "Skeleton ESP", "Линии по суставам и частям тела", State.SkeletonESP, 7, function(v) State.SkeletonESP = v end, "SkeletonESP")
addToggle(espPage, "Name + HP + Distance", "Имя, здоровье и дистанция", State.InfoESP, 8, function(v) State.InfoESP = v end, "InfoESP")
addToggle(espPage, "ESP Team Check", "Скрывать игроков своей команды", State.ESPTeamCheck, 9, function(v) State.ESPTeamCheck = v end, "ESPTeamCheck")
addSlider(espPage, "Max ESP Distance", 100, 2500, State.ESPMaxDist, 50, 10, function(v) State.ESPMaxDist = v end, "ESPMaxDist")
addSlider(espPage, "ESP Smoothness", 0.08, 1.0, State.ESPSmoothness, 0.02, 11, function(v) State.ESPSmoothness = v end, "ESPSmoothness")

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
local skinCardStroke = addStroke(skinCard, Theme.Stroke, 1.2, 0.35)
table.insert(themedCards, skinCard)
table.insert(themedStrokes, skinCardStroke)

local vpFrame = Instance.new("ViewportFrame")
vpFrame.Size = UDim2.new(1, -16, 1, -44)
vpFrame.Position = UDim2.new(0, 8, 0, 8)
vpFrame.BackgroundColor3 = Theme.BgInput
vpFrame.BackgroundTransparency = 0.25
vpFrame.BorderSizePixel = 0
vpFrame.Parent = skinCard
addCorner(vpFrame, 10)
table.insert(themedInputs, vpFrame)

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

addToggle(skinPage, "Auto Rotate 3D Skin", "Автоматически вращает скин в окне", State.SkinAutoRotate, 3, function(v)
	State.SkinAutoRotate = v
end, "SkinAutoRotate")
addSlider(skinPage, "3D Rotation Speed", 5, 120, State.SkinRotateSpeed, 5, 4, function(v)
	State.SkinRotateSpeed = v
end, "SkinRotateSpeed")
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
addToggle(visPage, "Background Blur", "Размывает фон за меню", State.BlurEnabled, 2, function(v)
	State.BlurEnabled = v
	updateBlur()
end, "BlurEnabled")
addSlider(visPage, "Blur Size", 2, 32, State.BlurSize, 1, 3, function(v)
	State.BlurSize = v
	updateBlur()
end, "BlurSize")
addSlider(visPage, "Transparency", 0.05, 0.65, Theme.GlassAlpha, 0.05, 4, function(v)
	Theme.GlassAlpha = v
	hub.BackgroundTransparency = v
end)

addSection(visPage, "Дополнительные функции", 5)
addToggle(visPage, "Custom Crosshair", "Кастомный прицел по центру экрана", State.CrosshairEnabled, 6, function(v) State.CrosshairEnabled = v end, "CrosshairEnabled")
addSlider(visPage, "Crosshair Size", 4, 24, State.CrosshairSize, 1, 7, function(v) State.CrosshairSize = v end, "CrosshairSize")
addToggle(visPage, "Target Radar HUD", "Показывает число врагов и Silent-цель", State.RadarHudEnabled, 8, function(v) State.RadarHudEnabled = v end, "RadarHudEnabled")
addToggle(visPage, "Fullbright", "Яркое освещение без теней", State.FullbrightEnabled, 9, function(v)
	State.FullbrightEnabled = v
	applyFullbright(v)
end, "FullbrightEnabled")
addToggle(visPage, "Anti-AFK", "Защита от кика за бездействие", State.AntiAFKEnabled, 10, function(v) State.AntiAFKEnabled = v end, "AntiAFKEnabled")
addToggle(visPage, "Custom FOV", "Меняет угол обзора камеры", State.FOVOverride, 11, function(v) State.FOVOverride = v end, "FOVOverride")
addSlider(visPage, "Camera FOV", 60, 120, State.CustomFOV, 1, 12, function(v) State.CustomFOV = v end, "CustomFOV")
addToggle(visPage, "Custom WalkSpeed", "Меняет скорость бега", State.WalkSpeedBoost, 13, function(v) State.WalkSpeedBoost = v end, "WalkSpeedBoost")
addSlider(visPage, "WalkSpeed", 16, 75, State.WalkSpeedVal, 1, 14, function(v) State.WalkSpeedVal = v end, "WalkSpeedVal")

-- ============================================================================
-- CONFIG SYSTEM + AUTO-SAVE + SETTINGS TAB
-- ============================================================================
local memoryConfigs = {}
local autoSaveToken = 0
local syncingUI = false

local fovStroke = nil
local silentFovStroke = nil
local silentTargetPart = nil

local function applyColorTheme(themeName)
	local pal = COLOR_THEMES[themeName] or COLOR_THEMES["Astral Violet"]
	State.ColorTheme = themeName
	Theme.BgMain = pal.BgMain
	Theme.BgCard = pal.BgCard
	Theme.BgCardHover = pal.BgCardHover
	Theme.BgInput = pal.BgInput
	Theme.Stroke = pal.Stroke
	Theme.Accent = pal.Accent
	Theme.AccentBright = pal.AccentBright
	Theme.SilentAccent = pal.SilentAccent

	hub.BackgroundColor3 = Theme.BgMain
	splashBg.BackgroundColor3 = Theme.BgMain
	splashCard.BackgroundColor3 = Theme.BgCard
	glowOrb1.BackgroundColor3 = Theme.Accent
	glowOrb2.BackgroundColor3 = Theme.SilentAccent
	splashTag.TextColor3 = Theme.AccentBright
	splashPct.TextColor3 = Theme.AccentBright
	splashBarFill.BackgroundColor3 = Theme.AccentBright
	splashBarBg.BackgroundColor3 = Theme.BgInput
	splashStroke.Color = Theme.Stroke

	hubHeader.BackgroundColor3 = Theme.BgCard
	sideBar.BackgroundColor3 = Theme.BgCard
	triggerBtn.BackgroundColor3 = Theme.BgCard
	triggerBtn.TextColor3 = Theme.AccentBright
	radarCard.BackgroundColor3 = Theme.BgCard
	watermarkCard.BackgroundColor3 = Theme.BgCard
	statusBadge.BackgroundColor3 = Theme.BgInput
	minBtn.BackgroundColor3 = Theme.BgInput
	closeHubBtn.BackgroundColor3 = Theme.BgInput
	hubDot.BackgroundColor3 = Theme.AccentBright
	radarTitle.TextColor3 = Theme.AccentBright

	hubStroke.Color = Theme.Stroke
	trigStroke.Color = Theme.Accent
	radarStroke.Color = Theme.Stroke
	wmStroke.Color = Theme.Accent

	for _, f in ipairs(themedCards) do
		if f and f.Parent then
			f.BackgroundColor3 = Theme.BgCard
		end
	end
	for _, s in ipairs(themedStrokes) do
		if s and s.Parent then
			s.Color = Theme.Stroke
		end
	end
	for _, inp in ipairs(themedInputs) do
		if inp and inp.Parent then
			inp.BackgroundColor3 = inp:IsA("TextButton") and inp.BackgroundColor3 == Theme.BgCardHover and Theme.BgCardHover or Theme.BgInput
		end
	end
	for _, item in ipairs(themedAccents) do
		if item.obj and item.obj.Parent then
			item.obj[item.prop] = Theme[item.key]
		end
	end
	for id, tb in pairs(tabBtns) do
		local sel = (id == State.ActiveTab)
		tb.BackgroundColor3 = sel and Theme.BgCardHover or Theme.BgInput
		tb.TextColor3 = sel and Theme.TextMain or Theme.TextMuted
	end
	if fovStroke then
		fovStroke.Color = Theme.AccentBright
	end
	if silentFovStroke and not silentTargetPart then
		silentFovStroke.Color = Theme.SilentAccent
	end
	for _, bar in ipairs({ chTop, chBot, chLeft, chRight }) do
		bar.BackgroundColor3 = Theme.AccentBright
	end
end

local function applyCompactMode(compact)
	State.CompactMode = compact
	local targetSize = compact and HUB_COMPACT_SIZE or HUB_NORMAL_SIZE
	if State.Minimized then
		hub.Size = UDim2.new(targetSize.X.Scale, targetSize.X.Offset, 0, 48)
	else
		hub.Size = targetSize
	end
end

local function getConfigPath(profileName)
	local safe = tostring(profileName or "Default"):gsub("[^%w_%-]", "_")
	return "AstralHub/profile_" .. safe .. ".json"
end

local function serializeConfig()
	local payload = {}
	for k, v in pairs(DEFAULT_STATE) do
		if k ~= "HubReady" and k ~= "HubVisible" and k ~= "Minimized" then
			payload[k] = State[k]
		end
	end
	payload.GlassAlpha = Theme.GlassAlpha
	return HttpService:JSONEncode(payload)
end

local function syncAllUI()
	syncingUI = true
	for _, fn in ipairs(uiSyncList) do
		pcall(fn)
	end
	syncingUI = false
end

local function applySerializedConfig(rawJson, profileOverride)
	if typeof(rawJson) ~= "string" or rawJson == "" then
		return false
	end
	local ok, decoded = pcall(function()
		return HttpService:JSONDecode(rawJson)
	end)
	if not ok or typeof(decoded) ~= "table" then
		return false
	end

	for k, defVal in pairs(DEFAULT_STATE) do
		if k ~= "HubReady" and k ~= "HubVisible" and k ~= "Minimized" then
			if decoded[k] ~= nil and typeof(decoded[k]) == typeof(defVal) then
				State[k] = decoded[k]
			end
		end
	end
	if profileOverride then
		State.ConfigProfile = profileOverride
	end
	if typeof(decoded.GlassAlpha) == "number" then
		Theme.GlassAlpha = math.clamp(decoded.GlassAlpha, 0.05, 0.65)
		hub.BackgroundTransparency = Theme.GlassAlpha
	end

	applyColorTheme(State.ColorTheme)
	applyCompactMode(State.CompactMode)
	applyFullbright(State.FullbrightEnabled)
	applyGravity(State.GravityOverride, State.GravityValue)
	updateBlur()
	syncAllUI()
	return true
end

local function saveConfig(profileName, silentNotify)
	local prof = profileName or State.ConfigProfile or "Default"
	local encoded = serializeConfig()
	memoryConfigs[prof] = encoded

	local wroteFile = false
	if typeof(writefile) == "function" then
		pcall(function()
			if typeof(isfolder) == "function" and typeof(makefolder) == "function" then
				if not isfolder("AstralHub") then
					makefolder("AstralHub")
				end
			end
			writefile(getConfigPath(prof), encoded)
			wroteFile = true
		end)
	end

	if not silentNotify then
		pushNotify(
			"Конфиг сохранён",
			string.format("Профиль: %s (%s)", prof, wroteFile and "файл" or "память")
		)
	end
end

local function loadConfig(profileName, silentNotify)
	local prof = profileName or State.ConfigProfile or "Default"
	local raw = nil

	if typeof(isfile) == "function" and typeof(readfile) == "function" then
		pcall(function()
			local p = getConfigPath(prof)
			if isfile(p) then
				raw = readfile(p)
			end
		end)
	end

	if not raw then
		raw = memoryConfigs[prof]
	end

	if not raw then
		if not silentNotify then
			pushNotify("Конфиг не найден", "Профиль '" .. prof .. "' ещё не сохранён.", true)
		end
		return false
	end

	if applySerializedConfig(raw, prof) then
		if not silentNotify then
			pushNotify("Конфиг загружен", "Применён профиль: " .. prof)
		end
		return true
	else
		if not silentNotify then
			pushNotify("Ошибка конфига", "Не удалось прочитать профиль: " .. prof, true)
		end
		return false
	end
end

scheduleAutoSave = function()
	if syncingUI or not State.AutoSaveEnabled or not State.HubReady then
		return
	end
	autoSaveToken += 1
	local curToken = autoSaveToken
	task.delay(0.6, function()
		if curToken == autoSaveToken and State.AutoSaveEnabled then
			saveConfig(State.ConfigProfile, true)
		end
	end)
end

-- Settings Page Sections
addSection(settingsPage, "Конфиги и автосохранение", 1)
addCycle(settingsPage, "Config Profile", CONFIG_PROFILES, State.ConfigProfile, 2, function(v)
	State.ConfigProfile = v
	loadConfig(v, false)
end, "ConfigProfile")

addToggle(settingsPage, "Auto-Save Settings", "Автосохранение изменений с защитой от спама", State.AutoSaveEnabled, 3, function(v)
	State.AutoSaveEnabled = v
	if v then
		saveConfig(State.ConfigProfile, true)
	end
end, "AutoSaveEnabled")

addAction(settingsPage, "💾  Сохранить текущий конфиг", 4, function()
	saveConfig(State.ConfigProfile, false)
end)

addAction(settingsPage, "📂  Загрузить выбранный конфиг", 5, function()
	loadConfig(State.ConfigProfile, false)
end)

addAction(settingsPage, "↺  Сбросить настройки к дефолту", 6, function()
	local keepOpen = State.HubVisible
	local keepProfile = State.ConfigProfile
	State = cloneTable(DEFAULT_STATE)
	State.HubReady = true
	State.HubVisible = keepOpen
	State.ConfigProfile = keepProfile
	Theme.GlassAlpha = 0.22
	hub.BackgroundTransparency = Theme.GlassAlpha
	applyColorTheme(State.ColorTheme)
	applyCompactMode(State.CompactMode)
	applyFullbright(false)
	applyGravity(false, origGravity)
	updateBlur()
	syncAllUI()
	if State.AutoSaveEnabled then
		saveConfig(State.ConfigProfile, true)
	end
	pushNotify("Сброс выполнен", "Все параметры возвращены к значениям по умолчанию.")
end)

addSection(settingsPage, "Экспорт и импорт конфига (JSON)", 7)

local cfgBoxCard = Instance.new("Frame")
cfgBoxCard.Size = UDim2.new(1, 0, 0, 82)
cfgBoxCard.LayoutOrder = 8
cfgBoxCard.BackgroundColor3 = Theme.BgCard
cfgBoxCard.BackgroundTransparency = Theme.GlassAlpha
cfgBoxCard.Parent = settingsPage
addCorner(cfgBoxCard, 10)
local cfgBoxStroke = addStroke(cfgBoxCard, Theme.Stroke, 1, 0.45)
table.insert(themedCards, cfgBoxCard)
table.insert(themedStrokes, cfgBoxStroke)

local cfgBox = Instance.new("TextBox")
cfgBox.Size = UDim2.new(1, -16, 1, -16)
cfgBox.Position = UDim2.new(0, 8, 0, 8)
cfgBox.BackgroundColor3 = Theme.BgInput
cfgBox.BackgroundTransparency = 0.2
cfgBox.PlaceholderText = "Вставьте JSON-строку конфига сюда или нажмите Экспорт..."
cfgBox.PlaceholderColor3 = Theme.TextMuted
cfgBox.Text = ""
cfgBox.TextColor3 = Theme.TextMain
cfgBox.Font = Enum.Font.Code
cfgBox.TextSize = 11
cfgBox.MultiLine = true
cfgBox.TextWrapped = true
cfgBox.ClearTextOnFocus = false
cfgBox.Parent = cfgBoxCard
addCorner(cfgBox, 8)
table.insert(themedInputs, cfgBox)

addAction(settingsPage, "📤  Экспортировать конфиг в строку", 9, function()
	local raw = serializeConfig()
	cfgBox.Text = raw
	if typeof(setclipboard) == "function" then
		pcall(setclipboard, raw)
		pushNotify("Экспорт готов", "JSON скопирован в буфер обмена и вставлен в поле.")
	else
		pushNotify("Экспорт готов", "JSON сгенерирован в текстовом поле.")
	end
end)

addAction(settingsPage, "📥  Импортировать конфиг из строки", 10, function()
	if applySerializedConfig(cfgBox.Text, State.ConfigProfile) then
		if State.AutoSaveEnabled then
			saveConfig(State.ConfigProfile, true)
		end
		pushNotify("Импорт успешен", "Конфиг применён из строки.")
	else
		pushNotify("Ошибка импорта", "Некорректный JSON конфига.", true)
	end
end)

addSection(settingsPage, "Кастомизация, HUD и производительность", 11)
addCycle(settingsPage, "Color Theme", THEME_NAMES, State.ColorTheme, 12, function(v)
	applyColorTheme(v)
end, "ColorTheme")

addToggle(settingsPage, "Compact UI Mode", "Компактный размер главного окна меню", State.CompactMode, 13, function(v)
	applyCompactMode(v)
end, "CompactMode")

addToggle(settingsPage, "Notifications", "Показывать всплывающие уведомления", State.NotificationsEnabled, 14, function(v)
	State.NotificationsEnabled = v
end, "NotificationsEnabled")

addToggle(settingsPage, "Watermark HUD", "Верхняя панель с FPS и статусом хаба", State.WatermarkEnabled, 15, function(v)
	State.WatermarkEnabled = v
end, "WatermarkEnabled")

addToggle(settingsPage, "FPS Saver Mode", "Экономит ресурсы, когда меню закрыто", State.FPSSaverEnabled, 16, function(v)
	State.FPSSaverEnabled = v
end, "FPSSaverEnabled")

addAction(settingsPage, "🛑  Полная выгрузка ASTRAL HUB", 17, function()
	State.HubReady = false
	State.HubVisible = false
	splashActive = false
	State.FlyEnabled = false
	State.NoClipEnabled = false
	State.SpectateNearest = false
	State.SpinbotEnabled = false
	State.OrbitTargetEnabled = false
	applyFullbright(false)
	applyGravity(false, origGravity)
	if Camera then
		Camera.CameraType = Enum.CameraType.Custom
	end
	if blurEffect then
		blurEffect:Destroy()
	end
	if gui then
		gui:Destroy()
	end
end)

-- ============================================================================
-- WINDOW & SMOOTH AUTO-OPEN LOGIC
-- ============================================================================
local function setHub(open, instant)
	if not State.HubReady then
		return
	end
	State.HubVisible = open

	if open then
		hub.Visible = true
		if instant then
			hub.Position = UDim2.new(0.5, 0, 0.5, 0)
			hubScale.Scale = 1
		else
			hub.Position = UDim2.new(0.5, 0, 0.5, 22)
			hubScale.Scale = 0.94
			TweenService:Create(hub, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Position = UDim2.new(0.5, 0, 0.5, 0)
			}):Play()
			TweenService:Create(hubScale, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Scale = 1
			}):Play()
		end
		if State.ActiveTab == "Skin3D" and rebuildSkinPreview then
			rebuildSkinPreview()
		end
	else
		if instant then
			hub.Visible = false
			hubScale.Scale = 0.94
		else
			local outPos = TweenService:Create(hub, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
				Position = UDim2.new(0.5, 0, 0.5, 18)
			})
			local outScale = TweenService:Create(hubScale, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
				Scale = 0.95
			})
			outPos:Play()
			outScale:Play()
			outPos.Completed:Once(function()
				if not State.HubVisible then
					hub.Visible = false
				end
			end)
		end
	end

	updateBlur()
end

triggerBtn.MouseButton1Click:Connect(function()
	setHub(not State.HubVisible, false)
end)

minBtn.MouseButton1Click:Connect(function()
	State.Minimized = not State.Minimized
	sideBar.Visible = not State.Minimized
	bodyArea.Visible = not State.Minimized
	local baseSize = State.CompactMode and HUB_COMPACT_SIZE or HUB_NORMAL_SIZE
	hub.Size = State.Minimized and UDim2.new(baseSize.X.Scale, baseSize.X.Offset, 0, 48) or baseSize
	updateBlur()
end)

closeHubBtn.MouseButton1Click:Connect(function()
	setHub(false, false)
	pushNotify("ASTRAL HUB скрыт", "Нажмите RightShift или кнопку слева.")
end)

UserInputService.InputBegan:Connect(function(inp, gp)
	if gp or not State.HubReady then
		return
	end
	if inp.KeyCode == HUB_HOTKEY or inp.KeyCode == ALT_HOTKEY then
		setHub(not State.HubVisible, false)
	end
end)

LocalPlayer.Idled:Connect(function()
	if State.HubReady and State.AntiAFKEnabled then
		local cam = Workspace.CurrentCamera
		if cam then
			cam.CFrame = cam.CFrame * CFrame.Angles(0, math.rad(0.001), 0)
		end
	end
end)

-- Smooth ESP
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
		Bones = bones,
		HasSmooth = false,
		SmoothTL = Vector2.zero,
		SmoothSize = Vector2.zero,
		SmoothCenter = Vector2.zero,
		SmoothBot = Vector2.zero,
		SmoothBones = {}
	}
end

local function hideESPSet(s)
	s.HasSmooth = false
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

-- FOV Circles & Silent Aim v2 Hooks
local fovCircle = Instance.new("Frame")
fovCircle.Name = "AimbotFOVCircle"
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.Parent = gui
addCorner(fovCircle, 999)
fovStroke = addStroke(fovCircle, Theme.AccentBright, 1.5, 0.25)

local silentFovCircle = Instance.new("Frame")
silentFovCircle.Name = "SilentFOVCircle"
silentFovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
silentFovCircle.BackgroundTransparency = 1
silentFovCircle.Visible = false
silentFovCircle.Parent = gui
addCorner(silentFovCircle, 999)
silentFovStroke = addStroke(silentFovCircle, Theme.SilentAccent, 1.6, 0.2)

local lockedPart = nil
local silentTargetPart = nil
local silentTargetPos = nil
local silentTargetPlayerName = "None"
local silentRollCycle = 0

local lastShot = 0
local lastRapidShot = 0
local lastAuraHit = 0
local spinAngle = 0
local orbitAngle = 0
local flyBodyVel = nil
local espStepAccum = 0
local fpsAccum = 0
local fpsFrames = 0
local currentFPS = 60

local function canSeePart(fromPos, targetPart, targetChar, checkWall)
	if not checkWall or not targetPart then
		return true
	end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	local excludeList = {}
	if LocalPlayer.Character then
		table.insert(excludeList, LocalPlayer.Character)
	end
	if targetChar then
		table.insert(excludeList, targetChar)
	end
	params.FilterDescendantsInstances = excludeList
	params.IgnoreWater = true

	local dir = targetPart.Position - fromPos
	local res = Workspace:Raycast(fromPos, dir, params)
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

local function getAimReferenceScreenPos(mousePos, vp)
	if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
		return Vector2.new(vp.X * 0.5, vp.Y * 0.5)
	end
	return mousePos
end

local function updateSilentTarget(refPos)
	if not State.HubReady or not State.SilentEnabled then
		silentTargetPart = nil
		silentTargetPos = nil
		silentTargetPlayerName = "None"
		return
	end

	local bestPart = nil
	local bestPos = nil
	local bestName = "None"
	local bestScore = math.huge

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and not isTeammate(plr, State.SilentTeamCheck) then
			local alive = getAliveParts(plr.Character)
			if alive and plr.Character then
				local part, pointPos = getSilentBodyPoint(plr.Character, State.SilentPart)
				if part and pointPos then
					local predictedPos = pointPos + (part.AssemblyLinearVelocity * State.SilentPrediction)
					local sp, onScreen = Camera:WorldToViewportPoint(predictedPos)
					if onScreen and sp.Z > 0 then
						local screenD = (Vector2.new(sp.X, sp.Y) - refPos).Magnitude
						if screenD <= State.SilentFOVRadius then
							local checkOrigin = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head"))
								and LocalPlayer.Character.Head.Position
								or Camera.CFrame.Position
							if canSeePart(checkOrigin, part, plr.Character, State.SilentWallCheck) then
								local worldDist = (predictedPos - Camera.CFrame.Position).Magnitude
								local score = screenD + (worldDist * 0.12)
								if score < bestScore then
									bestScore = score
									bestPart = part
									bestPos = predictedPos
									bestName = plr.Name
								end
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

local function shouldApplySilentHit()
	if not State.HubReady or not State.SilentEnabled or not silentTargetPos or not silentTargetPart then
		return false
	end
	if not silentTargetPart.Parent then
		return false
	end
	if State.SilentHitChance >= 100 then
		return true
	end
	silentRollCycle = (silentRollCycle + 1) % 100
	return (silentRollCycle + 1) <= State.SilentHitChance
end

local function getSilentOrigin(rawOrigin)
	if typeof(rawOrigin) == "Vector3" then
		local distFromCam = (rawOrigin - Camera.CFrame.Position).Magnitude
		if distFromCam <= 24 then
			return rawOrigin
		end
	end
	return Camera.CFrame.Position
end

if typeof(hookmetamethod) == "function" and typeof(getnamecallmethod) == "function" then
	local oldNamecall
	oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
		local method = getnamecallmethod()
		local args = { ... }

		if not checkcaller() and shouldApplySilentHit() then
			if self == Workspace and method == "Raycast" and typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
				local origin = getSilentOrigin(args[1])
				local targetVec = silentTargetPos - origin
				if targetVec.Magnitude > 1e-3 then
					local scale = math.max(args[2].Magnitude / targetVec.Magnitude, 1.05)
					args[1] = origin
					args[2] = targetVec.Unit * (targetVec.Magnitude * scale + 4)
					return oldNamecall(self, unpack(args))
				end
			elseif self == Workspace and (method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRayWithWhitelist" or method == "FindPartOnRay") and typeof(args[1]) == "Ray" then
				local rawRay = args[1]
				local origin = getSilentOrigin(rawRay.Origin)
				local targetVec = silentTargetPos - origin
				if targetVec.Magnitude > 1e-3 then
					local rayLen = math.max(rawRay.Direction.Magnitude, targetVec.Magnitude + 4)
					args[1] = Ray.new(origin, targetVec.Unit * rayLen)
					return oldNamecall(self, unpack(args))
				end
			end
		end

		return oldNamecall(self, ...)
	end)

	local oldIndex
	oldIndex = hookmetamethod(game, "__index", function(self, key)
		if not checkcaller() and shouldApplySilentHit() and self == Mouse then
			if key == "Hit" then
				return CFrame.new(silentTargetPos)
			elseif key == "Target" then
				return silentTargetPart
			elseif key == "UnitRay" then
				local origin = Camera.CFrame.Position
				local dir = (silentTargetPos - origin)
				if dir.Magnitude > 1e-3 then
					return Ray.new(origin, dir.Unit)
				end
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
		return bestPart or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
	end
end

local function isPartValidForAim(part, char, plr, mousePos, maxFov)
	if not part or not part.Parent or not char then
		return false, math.huge
	end
	if isTeammate(plr, State.TeamCheck) then
		return false, math.huge
	end
	local alive = getAliveParts(char)
	if not alive then
		return false, math.huge
	end
	local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
	if not onScreen or sp.Z <= 0 then
		return false, math.huge
	end
	local fovDist = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
	if fovDist > maxFov then
		return false, math.huge
	end
	if not canSeePart(Camera.CFrame.Position, part, char, State.WallCheck) then
		return false, math.huge
	end
	return true, fovDist
end

local function findAimTarget(mousePos)
	if State.StickyTarget and lockedPart and lockedPart.Parent then
		local lockedChar = lockedPart:FindFirstAncestorOfClass("Model")
		local lockedPlr = lockedChar and Players:GetPlayerFromCharacter(lockedChar) or nil
		local lockedOk = isPartValidForAim(lockedPart, lockedChar, lockedPlr, mousePos, State.FOVRadius * 1.25)
		if lockedOk then
			return lockedPart
		end
		lockedPart = nil
	end

	local best = nil
	local bestDist = State.FOVRadius

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and not isTeammate(plr, State.TeamCheck) and plr.Character then
			local part = selectTargetPart(plr.Character, mousePos)
			local ok, fovDist = isPartValidForAim(part, plr.Character, plr, mousePos, State.FOVRadius)
			if ok and fovDist <= bestDist then
				bestDist = fovDist
				best = part
			end
		end
	end

	lockedPart = best
	return best
end

local function aimCameraAt(worldPos, alpha)
	if not Camera then
		return
	end
	local camPos = Camera.CFrame.Position
	if (worldPos - camPos).Magnitude < 1e-4 then
		return
	end
	if Camera.CameraType == Enum.CameraType.Scriptable then
		Camera.CameraType = Enum.CameraType.Custom
	end
	local goalCF = CFrame.lookAt(camPos, worldPos)
	if alpha and alpha < 1 then
		Camera.CFrame = Camera.CFrame:Lerp(goalCF, math.clamp(alpha, 0.02, 1))
	else
		Camera.CFrame = goalCF
	end
end

local function buildActiveSummary()
	local tags = {}
	if State.AimEnabled then table.insert(tags, "AIM") end
	if State.SilentEnabled then table.insert(tags, "SILENT") end
	if State.ESPEnabled then table.insert(tags, "ESP") end
	if State.FlyEnabled then table.insert(tags, "FLY") end
	if State.NoClipEnabled then table.insert(tags, "NOCLIP") end
	if #tags == 0 then
		return "IDLE"
	end
	return table.concat(tags, "+")
end

RunService.RenderStepped:Connect(function(dt)
	if not gui or not gui.Parent then
		return
	end
	Camera = Workspace.CurrentCamera
	if not Camera then
		return
	end

	fpsAccum += dt
	fpsFrames += 1
	if fpsAccum >= 0.4 then
		currentFPS = math.floor(fpsFrames / fpsAccum + 0.5)
		fpsAccum = 0
		fpsFrames = 0
	end

	watermarkCard.Visible = State.HubReady and State.WatermarkEnabled
	if watermarkCard.Visible then
		wmLabel.Text = string.format("✦ ASTRAL HUB  •  %s  •  %d FPS", buildActiveSummary(), currentFPS)
	end

	if State.HubReady and State.ActiveTab == "Skin3D" and State.SkinAutoRotate and not vpDragging then
		skinYaw = (skinYaw + State.SkinRotateSpeed * dt) % 360
		updateSkinCamera()
	end

	local mousePos = UserInputService:GetMouseLocation()
	local vp = Camera.ViewportSize
	local silentRefPos = getAimReferenceScreenPos(mousePos, vp)

	updateSilentTarget(silentRefPos)

	chHolder.Visible = State.HubReady and State.CrosshairEnabled
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

	fovCircle.Visible = State.HubReady and State.FOVEnabled and (State.AimEnabled or State.AutoFireVisible)
	if fovCircle.Visible then
		local diam = State.FOVRadius * 2
		fovCircle.Size = UDim2.new(0, diam, 0, diam)
		fovCircle.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
	end

	silentFovCircle.Visible = State.HubReady and State.SilentEnabled and State.SilentFOVEnabled
	if silentFovCircle.Visible then
		local sDiam = State.SilentFOVRadius * 2
		silentFovCircle.Size = UDim2.new(0, sDiam, 0, sDiam)
		silentFovCircle.Position = UDim2.new(0, silentRefPos.X, 0, silentRefPos.Y)
		silentFovStroke.Color = silentTargetPart and Theme.Success or Theme.SilentAccent
	end

	local myAlive, myHum, myHRP = getAliveParts(LocalPlayer.Character)
	local myChar = LocalPlayer.Character

	local nearestEnemyHRP = nil
	local nearestDist = math.huge
	local enemyCount = 0

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and not isTeammate(plr, State.TeamCheck) then
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

	radarCard.Visible = State.HubReady and State.RadarHudEnabled
	if radarCard.Visible then
		radarInfo.Text = string.format("Enemies: %d | Silent: %s", enemyCount, silentTargetPlayerName)
	end

	if State.HubReady then
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
					if plr ~= LocalPlayer and not isTeammate(plr, State.TeamCheck) then
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

	if State.HubReady and State.SpectateNearest and nearestEnemyHRP then
		Camera.CameraType = Enum.CameraType.Scriptable
		local backPos = nearestEnemyHRP.Position - (nearestEnemyHRP.CFrame.LookVector * 8) + Vector3.new(0, 3, 0)
		Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(backPos, nearestEnemyHRP.Position), 0.25)
	elseif Camera.CameraType == Enum.CameraType.Scriptable and not State.SpectateNearest then
		Camera.CameraType = Enum.CameraType.Custom
	end

	if State.HubReady and (State.AimEnabled or State.AutoFireVisible) then
		local rmb = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
		local activeAim = (not State.AimHoldOnly) or rmb or State.AutoFireVisible
		local part = activeAim and findAimTarget(mousePos) or nil

		if part then
			local predicted = part.Position + (part.AssemblyLinearVelocity * State.Prediction)

			if State.AimEnabled and ((not State.AimHoldOnly) or rmb) then
				if State.AimMode == "Camera" then
					aimCameraAt(predicted, State.Smoothness)
				elseif State.AimMode == "Snap" then
					aimCameraAt(predicted, 1)
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

	espStepAccum += dt
	local espInterval = (State.FPSSaverEnabled and not State.HubVisible) and 0.04 or 0
	if espStepAccum < espInterval then
		return
	end
	local stepDt = math.clamp(espStepAccum, 1 / 240, 0.1)
	espStepAccum = 0

	local espAlpha = math.clamp(State.ESPSmoothness * (stepDt * 60), 0.04, 1)

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

			local sameTeamAim = isTeammate(plr, State.TeamCheck)
			local sameTeamESP = isTeammate(plr, State.ESPTeamCheck)
			local alive, hum, hrp = getAliveParts(plr.Character)

			if plr.Character then
				local targetHB = (State.HitboxPart == "Head")
					and plr.Character:FindFirstChild("Head")
					or hrp
				if targetHB and targetHB:IsA("BasePart") then
					if State.HubReady and State.HitboxEnabled and alive and not sameTeamAim then
						targetHB.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
						targetHB.Transparency = State.HitboxTransparency
						targetHB.CanCollide = false
					else
						if targetHB.Name == "Head" then
							targetHB.Size = Vector3.new(2, 1, 1)
							targetHB.Transparency = 0
						elseif targetHB.Name == "HumanoidRootPart" then
							targetHB.Size = Vector3.new(2, 2, 1)
							targetHB.Transparency = 1
						end
					end
				end
			end

			if not State.HubReady or not State.ESPEnabled or sameTeamESP or not alive or not hum or not hrp then
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
						local targetTL = Vector2.new(rootSP.X - w * 0.5, topSP.Y)
						local targetSz = Vector2.new(w, h)
						local targetCenter = Vector2.new(rootSP.X, targetTL.Y - 13)
						local targetBot = Vector2.new(rootSP.X, botSP.Y)

						if not s.HasSmooth then
							s.HasSmooth = true
							s.SmoothTL = targetTL
							s.SmoothSize = targetSz
							s.SmoothCenter = targetCenter
							s.SmoothBot = targetBot
						else
							s.SmoothTL = s.SmoothTL:Lerp(targetTL, espAlpha)
							s.SmoothSize = s.SmoothSize:Lerp(targetSz, espAlpha)
							s.SmoothCenter = s.SmoothCenter:Lerp(targetCenter, espAlpha)
							s.SmoothBot = s.SmoothBot:Lerp(targetBot, espAlpha)
						end

						local tl = s.SmoothTL
						local sz = s.SmoothSize
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
							drawLine(s.Tracer, tracerOrigin, s.SmoothBot, 1.4, col)
						else
							s.Tracer.Visible = false
						end

						if State.InfoESP then
							local hpPct = math.clamp(math.floor((hum.Health / math.max(hum.MaxHealth, 1)) * 100 + 0.5), 0, 100)
							s.Tag.Text = string.format(" %s | %d%% HP | %dm ", plr.Name, hpPct, math.floor(dist3D))
							s.Tag.Size = UDim2.new(0, math.max(#s.Tag.Text * 6 + 10, 80), 0, 18)
							s.Tag.Position = UDim2.new(0, s.SmoothCenter.X - s.Tag.Size.X.Offset * 0.5, 0, s.SmoothCenter.Y)
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

							local joints = {
								head and head.Position or nil,
								torso and torso.Position or nil,
								lArm and lArm.Position or nil,
								rArm and rArm.Position or nil,
								lLeg and lLeg.Position or nil,
								rLeg and rLeg.Position or nil
							}
							local proj = {}
							for jIdx, wPos in ipairs(joints) do
								if wPos then
									local jSP, jVis = Camera:WorldToViewportPoint(wPos)
									if jVis and jSP.Z > 0 then
										local rawV = Vector2.new(jSP.X, jSP.Y)
										if not s.SmoothBones[jIdx] then
											s.SmoothBones[jIdx] = rawV
										else
											s.SmoothBones[jIdx] = s.SmoothBones[jIdx]:Lerp(rawV, espAlpha)
										end
										proj[jIdx] = s.SmoothBones[jIdx]
									else
										s.SmoothBones[jIdx] = nil
									end
								else
									s.SmoothBones[jIdx] = nil
								end
							end

							local idx = 1
							local function linkBone(aIdx, bIdx)
								local pA = proj[aIdx]
								local pB = proj[bIdx]
								if pA and pB and idx <= #s.Bones then
									drawLine(s.Bones[idx], pA, pB, 1.5, Theme.TextMain)
									idx += 1
								end
							end

							linkBone(1, 2)
							linkBone(2, 3)
							linkBone(2, 4)
							linkBone(2, 5)
							linkBone(2, 6)
						end
					end
				end
			end
		end
	end
end)

-- ============================================================================
-- BOOT SEQUENCE -> SPLASH -> SMOOTH AUTO OPEN
-- ============================================================================
local function setSplashProgress(targetPct, statusText)
	if not splashBg or not splashBg.Parent then
		return
	end
	splashStatus.Text = statusText
	splashPct.Text = string.format("%d%%", targetPct)
	TweenService:Create(splashBarFill, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Size = UDim2.new(math.clamp(targetPct / 100, 0, 1), 0, 1, 0)
	}):Play()
end

task.spawn(function()
	updateBlur()
	TweenService:Create(splashScale, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Scale = 1
	}):Play()

	setSplashProgress(25, "Загрузка сохранённого конфига...")
	loadConfig(State.ConfigProfile, true)
	task.wait(0.26)

	setSplashProgress(58, "Инициализация модулей Aimbot, Silent Aim и ESP...")
	applyCompactMode(State.CompactMode)
	sideBar.Visible = true
	bodyArea.Visible = true
	task.wait(0.26)

	setSplashProgress(86, "Подготовка 3D-превью скина и HUD...")
	if rebuildSkinPreview then
		rebuildSkinPreview()
	end
	task.wait(0.24)

	setSplashProgress(100, "Готово! Открываем ASTRAL HUB...")
	task.wait(0.28)

	State.HubReady = true
	triggerBtn.Visible = true
	splashActive = false

	if splashBg and splashBg.Parent then
		TweenService:Create(splashScale, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Scale = 1.05
		}):Play()
		local fadeBg = TweenService:Create(splashBg, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			BackgroundTransparency = 1
		})
		local fadeCard = TweenService:Create(splashCard, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			BackgroundTransparency = 1
		})
		for _, child in ipairs(splashCard:GetDescendants()) do
			if child:IsA("TextLabel") then
				TweenService:Create(child, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
			elseif child:IsA("Frame") then
				TweenService:Create(child, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
			end
		end
		glowOrb1.Visible = false
		glowOrb2.Visible = false
		fadeBg:Play()
		fadeCard:Play()
		fadeBg.Completed:Once(function()
			if splashBg and splashBg.Parent then
				splashBg:Destroy()
			end
		end)
	end

	setHub(true, false)
	pushNotify("ASTRAL HUB загружен", "Обновлённый Silent Aim v2 активен. Меню: RightShift")
end)
