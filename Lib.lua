local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local Themes = {
	Default = {
		Background = Color3.fromRGB(10, 10, 15),
		SecondaryBackground = Color3.fromRGB(15, 15, 22),
		TertiaryBackground = Color3.fromRGB(20, 20, 30),
		Accent = Color3.fromRGB(80, 120, 255),
		AccentDark = Color3.fromRGB(50, 80, 200),
		AccentGlow = Color3.fromRGB(100, 140, 255),
		Text = Color3.fromRGB(240, 240, 255),
		SubText = Color3.fromRGB(140, 140, 180),
		Border = Color3.fromRGB(35, 35, 55),
		Success = Color3.fromRGB(60, 200, 100),
		Warning = Color3.fromRGB(255, 180, 50),
		Error = Color3.fromRGB(255, 70, 70),
		Gradient1 = Color3.fromRGB(80, 120, 255),
		Gradient2 = Color3.fromRGB(180, 80, 255),
		ScrollBar = Color3.fromRGB(50, 50, 80),
		Shadow = Color3.fromRGB(0, 0, 5),
		TabActive = Color3.fromRGB(80, 120, 255),
		TabInactive = Color3.fromRGB(25, 25, 40),
	},
	Crimson = {
		Background = Color3.fromRGB(12, 8, 8),
		SecondaryBackground = Color3.fromRGB(18, 10, 10),
		TertiaryBackground = Color3.fromRGB(25, 14, 14),
		Accent = Color3.fromRGB(220, 50, 80),
		AccentDark = Color3.fromRGB(160, 30, 55),
		AccentGlow = Color3.fromRGB(255, 80, 100),
		Text = Color3.fromRGB(255, 235, 235),
		SubText = Color3.fromRGB(180, 130, 130),
		Border = Color3.fromRGB(50, 25, 25),
		Success = Color3.fromRGB(60, 200, 100),
		Warning = Color3.fromRGB(255, 180, 50),
		Error = Color3.fromRGB(255, 70, 70),
		Gradient1 = Color3.fromRGB(220, 50, 80),
		Gradient2 = Color3.fromRGB(255, 100, 50),
		ScrollBar = Color3.fromRGB(70, 30, 30),
		Shadow = Color3.fromRGB(5, 0, 0),
		TabActive = Color3.fromRGB(220, 50, 80),
		TabInactive = Color3.fromRGB(30, 15, 15),
	},
	Emerald = {
		Background = Color3.fromRGB(6, 12, 10),
		SecondaryBackground = Color3.fromRGB(8, 18, 14),
		TertiaryBackground = Color3.fromRGB(10, 24, 18),
		Accent = Color3.fromRGB(40, 200, 120),
		AccentDark = Color3.fromRGB(25, 140, 80),
		AccentGlow = Color3.fromRGB(60, 220, 140),
		Text = Color3.fromRGB(220, 255, 240),
		SubText = Color3.fromRGB(120, 175, 145),
		Border = Color3.fromRGB(20, 50, 35),
		Success = Color3.fromRGB(40, 200, 120),
		Warning = Color3.fromRGB(255, 180, 50),
		Error = Color3.fromRGB(255, 70, 70),
		Gradient1 = Color3.fromRGB(40, 200, 120),
		Gradient2 = Color3.fromRGB(20, 180, 200),
		ScrollBar = Color3.fromRGB(20, 60, 40),
		Shadow = Color3.fromRGB(0, 5, 2),
		TabActive = Color3.fromRGB(40, 200, 120),
		TabInactive = Color3.fromRGB(10, 30, 20),
	},
}

Library.Themes = Themes
Library.ActiveTheme = Themes.Default
Library.Windows = {}
Library.Notifications = nil
Library._connections = {}

local function Tween(instance, properties, duration, style, direction)
	style = style or Enum.EasingStyle.Quart
	direction = direction or Enum.EasingDirection.Out
	local info = TweenInfo.new(duration or 0.3, style, direction)
	local tween = TweenService:Create(instance, info, properties)
	tween:Play()
	return tween
end

local function MakeDraggable(frame, handle)
	handle = handle or frame
	local dragging = false
	local dragInput, dragStart, startPos

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

local function CreateUICorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	corner.Parent = parent
	return corner
end

local function CreateUIStroke(parent, color, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or Library.ActiveTheme.Border
	stroke.Thickness = thickness or 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = parent
	return stroke
end

local function CreateUIPadding(parent, top, right, bottom, left)
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, top or 8)
	padding.PaddingRight = UDim.new(0, right or 8)
	padding.PaddingBottom = UDim.new(0, bottom or 8)
	padding.PaddingLeft = UDim.new(0, left or 8)
	padding.Parent = parent
	return padding
end

local function CreateGradient(parent, color1, color2, rotation)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, color1 or Library.ActiveTheme.Gradient1),
		ColorSequenceKeypoint.new(1, color2 or Library.ActiveTheme.Gradient2),
	})
	gradient.Rotation = rotation or 135
	gradient.Parent = parent
	return gradient
end

local function TypewriterEffect(label, text, speed)
	speed = speed or 0.04
	label.Text = ""
	task.spawn(function()
		for i = 1, #text do
			label.Text = string.sub(text, 1, i)
			task.wait(speed)
		end
	end)
end

local function CreateShadow(parent)
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.BackgroundTransparency = 1
	shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
	shadow.Size = UDim2.new(1, 24, 1, 24)
	shadow.ZIndex = parent.ZIndex - 1
	shadow.Image = "rbxassetid://6014261993"
	shadow.ImageColor3 = Library.ActiveTheme.Shadow
	shadow.ImageTransparency = 0.5
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(49, 49, 450, 450)
	shadow.Parent = parent
	return shadow
end

local NotificationSystem = {}
NotificationSystem.__index = NotificationSystem

function NotificationSystem.new(screenGui)
	local self = setmetatable({}, NotificationSystem)
	self.Container = Instance.new("Frame")
	self.Container.Name = "Notifications"
	self.Container.BackgroundTransparency = 1
	self.Container.Position = UDim2.new(1, -20, 1, -20)
	self.Container.AnchorPoint = Vector2.new(1, 1)
	self.Container.Size = UDim2.new(0, 300, 1, -20)
	self.Container.Parent = screenGui
	self.Container.ZIndex = 100

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	layout.Padding = UDim.new(0, 8)
	layout.Parent = self.Container

	return self
end

function NotificationSystem:Send(options)
	local theme = Library.ActiveTheme
	options = options or {}
	local title = options.Title or "Notification"
	local content = options.Content or ""
	local duration = options.Duration or 4
	local notifType = options.Type or "Info"

	local typeColor = theme.Accent
	if notifType == "Success" then typeColor = theme.Success
	elseif notifType == "Warning" then typeColor = theme.Warning
	elseif notifType == "Error" then typeColor = theme.Error
	end

	local notif = Instance.new("Frame")
	notif.Name = "Notification"
	notif.BackgroundColor3 = theme.SecondaryBackground
	notif.Size = UDim2.new(1, 0, 0, 0)
	notif.AutomaticSize = Enum.AutomaticSize.Y
	notif.ClipsDescendants = true
	notif.ZIndex = 100
	CreateUICorner(notif, 10)
	CreateUIStroke(notif, theme.Border, 1)
	notif.Parent = self.Container

	local accentBar = Instance.new("Frame")
	accentBar.Name = "AccentBar"
	accentBar.BackgroundColor3 = typeColor
	accentBar.Position = UDim2.new(0, 0, 0, 0)
	accentBar.Size = UDim2.new(0, 3, 1, 0)
	accentBar.ZIndex = 101
	CreateUICorner(accentBar, 3)
	accentBar.Parent = notif

	local inner = Instance.new("Frame")
	inner.BackgroundTransparency = 1
	inner.Position = UDim2.new(0, 12, 0, 0)
	inner.Size = UDim2.new(1, -16, 0, 0)
	inner.AutomaticSize = Enum.AutomaticSize.Y
	inner.ZIndex = 101
	inner.Parent = notif
	CreateUIPadding(inner, 10, 8, 10, 4)

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 4)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = inner

	local titleLabel = Instance.new("TextLabel")
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.new(1, 0, 0, 16)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = title
	titleLabel.TextColor3 = typeColor
	titleLabel.TextSize = 13
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 102
	titleLabel.LayoutOrder = 1
	titleLabel.Parent = inner

	local contentLabel = Instance.new("TextLabel")
	contentLabel.BackgroundTransparency = 1
	contentLabel.Size = UDim2.new(1, 0, 0, 0)
	contentLabel.AutomaticSize = Enum.AutomaticSize.Y
	contentLabel.Font = Enum.Font.Gotham
	contentLabel.Text = content
	contentLabel.TextColor3 = theme.SubText
	contentLabel.TextSize = 12
	contentLabel.TextXAlignment = Enum.TextXAlignment.Left
	contentLabel.TextWrapped = true
	contentLabel.ZIndex = 102
	contentLabel.LayoutOrder = 2
	contentLabel.Parent = inner

	local progressBg = Instance.new("Frame")
	progressBg.BackgroundColor3 = theme.TertiaryBackground
	progressBg.Position = UDim2.new(0, 12, 1, -3)
	progressBg.Size = UDim2.new(1, -16, 0, 2)
	progressBg.ZIndex = 102
	CreateUICorner(progressBg, 2)
	progressBg.Parent = notif

	local progressFill = Instance.new("Frame")
	progressFill.BackgroundColor3 = typeColor
	progressFill.Size = UDim2.new(1, 0, 1, 0)
	progressFill.ZIndex = 103
	CreateUICorner(progressFill, 2)
	progressFill.Parent = progressBg

	notif.BackgroundTransparency = 1
	Tween(notif, {BackgroundTransparency = 0}, 0.3)

	task.spawn(function()
		Tween(progressFill, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
		task.wait(duration)
		Tween(notif, {BackgroundTransparency = 1}, 0.3)
		task.wait(0.3)
		notif:Destroy()
	end)
end

local Window = {}
Window.__index = Window

function Library:CreateWindow(options)
	local theme = self.ActiveTheme
	options = options or {}
	local title = options.Title or "Law.cc"
	local toggleKey = options.ToggleKey or Enum.KeyCode.RightControl
	local size = options.Size or UDim2.new(0, 600, 0, 440)

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "LawCC_" .. title
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 999

	local success = pcall(function()
		screenGui.Parent = CoreGui
	end)
	if not success then
		screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end

	local notifSystem = NotificationSystem.new(screenGui)
	Library.Notifications = notifSystem

	local windowFrame = Instance.new("Frame")
	windowFrame.Name = "Window"
	windowFrame.BackgroundColor3 = theme.Background
	windowFrame.Position = UDim2.new(0.5, -300, 0.5, -220)
	windowFrame.Size = size
	windowFrame.ZIndex = 10
	windowFrame.ClipsDescendants = false
	CreateUICorner(windowFrame, 12)
	CreateUIStroke(windowFrame, theme.Border, 1)
	CreateShadow(windowFrame)
	windowFrame.Parent = screenGui

	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.BackgroundColor3 = theme.SecondaryBackground
	topBar.Size = UDim2.new(1, 0, 0, 44)
	topBar.ZIndex = 11
	CreateUICorner(topBar, 12)
	topBar.Parent = windowFrame

	local topBarFix = Instance.new("Frame")
	topBarFix.BackgroundColor3 = theme.SecondaryBackground
	topBarFix.Position = UDim2.new(0, 0, 0.5, 0)
	topBarFix.Size = UDim2.new(1, 0, 0.5, 0)
	topBarFix.ZIndex = 11
	topBarFix.Parent = topBar

	local topGradient = Instance.new("Frame")
	topGradient.BackgroundTransparency = 1
	topGradient.Size = UDim2.new(1, 0, 1, 0)
	topGradient.ZIndex = 12
	topGradient.Parent = topBar
	CreateGradient(topGradient, theme.Gradient1, theme.Gradient2, 90)
	topGradient.BackgroundTransparency = 0
	topGradient.BackgroundColor3 = Color3.new(1, 1, 1)

	local topGradientInstance = topGradient:FindFirstChildOfClass("UIGradient")
	if topGradientInstance then
		topGradientInstance.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.85),
			NumberSequenceKeypoint.new(1, 1),
		})
	end

	CreateUICorner(topGradient, 12)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.BackgroundTransparency = 1
	titleLabel.Position = UDim2.new(0, 16, 0, 0)
	titleLabel.Size = UDim2.new(1, -80, 1, 0)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = ""
	titleLabel.TextColor3 = theme.Text
	titleLabel.TextSize = 15
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 13
	titleLabel.Parent = topBar

	local accentDot = Instance.new("Frame")
	accentDot.Name = "AccentDot"
	accentDot.AnchorPoint = Vector2.new(0, 0.5)
	accentDot.BackgroundColor3 = theme.Accent
	accentDot.Position = UDim2.new(0, 16, 0.5, 0)
	accentDot.Size = UDim2.new(0, 6, 0, 6)
	accentDot.ZIndex = 14
	CreateUICorner(accentDot, 50)
	accentDot.Parent = topBar

	titleLabel.Position = UDim2.new(0, 30, 0, 0)

	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.AnchorPoint = Vector2.new(1, 0.5)
	closeButton.BackgroundColor3 = theme.TertiaryBackground
	closeButton.Position = UDim2.new(1, -12, 0.5, 0)
	closeButton.Size = UDim2.new(0, 24, 0, 24)
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Text = "✕"
	closeButton.TextColor3 = theme.SubText
	closeButton.TextSize = 11
	closeButton.ZIndex = 13
	CreateUICorner(closeButton, 6)
	closeButton.Parent = topBar

	local tabContainer = Instance.new("Frame")
	tabContainer.Name = "TabContainer"
	tabContainer.BackgroundColor3 = theme.SecondaryBackground
	tabContainer.Position = UDim2.new(0, 0, 0, 44)
	tabContainer.Size = UDim2.new(0, 150, 1, -44)
	tabContainer.ZIndex = 11
	tabContainer.ClipsDescendants = true
	tabContainer.Parent = windowFrame

	local tabFix = Instance.new("Frame")
	tabFix.BackgroundColor3 = theme.SecondaryBackground
	tabFix.Size = UDim2.new(1, 10, 1, 0)
	tabFix.ZIndex = 11
	tabFix.Parent = tabContainer

	local tabList = Instance.new("ScrollingFrame")
	tabList.Name = "TabList"
	tabList.BackgroundTransparency = 1
	tabList.Position = UDim2.new(0, 0, 0, 0)
	tabList.Size = UDim2.new(1, 0, 1, 0)
	tabList.ScrollBarThickness = 2
	tabList.ScrollBarImageColor3 = theme.ScrollBar
	tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabList.ZIndex = 12
	tabList.Parent = tabContainer

	local tabListLayout = Instance.new("UIListLayout")
	tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabListLayout.Padding = UDim.new(0, 4)
	tabListLayout.Parent = tabList
	CreateUIPadding(tabList, 8, 8, 8, 8)

	tabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabList.CanvasSize = UDim2.new(0, 0, 0, tabListLayout.AbsoluteContentSize.Y + 16)
	end)

	local dividerLine = Instance.new("Frame")
	dividerLine.BackgroundColor3 = theme.Border
	dividerLine.Position = UDim2.new(0, 150, 0, 44)
	dividerLine.Size = UDim2.new(0, 1, 1, -44)
	dividerLine.ZIndex = 12
	dividerLine.Parent = windowFrame

	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"
	contentArea.BackgroundTransparency = 1
	contentArea.Position = UDim2.new(0, 151, 0, 44)
	contentArea.Size = UDim2.new(1, -151, 1, -44)
	contentArea.ZIndex = 11
	contentArea.ClipsDescendants = true
	contentArea.Parent = windowFrame

	MakeDraggable(windowFrame, topBar)

	local self = setmetatable({}, Window)
	self.ScreenGui = screenGui
	self.Frame = windowFrame
	self.TopBar = topBar
	self.TabList = tabList
	self.ContentArea = contentArea
	self.Tabs = {}
	self.ActiveTab = nil
	self.Visible = true
	self.Theme = theme
	self.Title = title
	self.NotifSystem = notifSystem

	windowFrame.BackgroundTransparency = 1
	topBar.BackgroundTransparency = 1
	windowFrame.Size = UDim2.new(size.X.Scale, size.X.Offset, 0, 0)
	Tween(windowFrame, {BackgroundTransparency = 0, Size = size}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	task.delay(0.2, function()
		topBar.BackgroundTransparency = 0
		TypewriterEffect(titleLabel, title, 0.05)
	end)

	closeButton.MouseEnter:Connect(function()
		Tween(closeButton, {BackgroundColor3 = theme.Error, TextColor3 = theme.Text}, 0.2)
	end)
	closeButton.MouseLeave:Connect(function()
		Tween(closeButton, {BackgroundColor3 = theme.TertiaryBackground, TextColor3 = theme.SubText}, 0.2)
	end)
	closeButton.MouseButton1Click:Connect(function()
		self:SetVisible(false)
	end)

	if not IsMobile then
		local conn = UserInputService.InputBegan:Connect(function(input, processed)
			if not processed and input.KeyCode == toggleKey then
				self:SetVisible(not self.Visible)
			end
		end)
		table.insert(Library._connections, conn)
	else
		local mobileBtn = Instance.new("TextButton")
		mobileBtn.Name = "MobileToggle"
		mobileBtn.BackgroundColor3 = theme.Accent
		mobileBtn.Size = UDim2.new(0, 54, 0, 54)
		mobileBtn.Position = UDim2.new(0, 20, 0.5, -27)
		mobileBtn.Font = Enum.Font.GothamBold
		mobileBtn.Text = "⚡"
		mobileBtn.TextSize = 22
		mobileBtn.TextColor3 = Color3.new(1, 1, 1)
		mobileBtn.ZIndex = 200
		CreateUICorner(mobileBtn, 14)
		CreateUIStroke(mobileBtn, theme.AccentGlow, 1.5)
		mobileBtn.Parent = screenGui

		local mobileBtnGradient = Instance.new("Frame")
		mobileBtnGradient.BackgroundColor3 = Color3.new(1, 1, 1)
		mobileBtnGradient.Size = UDim2.new(1, 0, 1, 0)
		mobileBtnGradient.ZIndex = 201
		mobileBtnGradient.BackgroundTransparency = 0
		CreateUICorner(mobileBtnGradient, 14)
		CreateGradient(mobileBtnGradient, theme.Gradient1, theme.Gradient2, 135)
		local mobileGrad = mobileBtnGradient:FindFirstChildOfClass("UIGradient")
		if mobileGrad then
			mobileGrad.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.4),
				NumberSequenceKeypoint.new(1, 0.7),
			})
		end
		mobileBtnGradient.Parent = mobileBtn

		MakeDraggable(mobileBtn)

		mobileBtn.MouseButton1Click:Connect(function()
			self:SetVisible(not self.Visible)
		end)
	end

	table.insert(Library.Windows, self)
	return self
end

function Window:SetVisible(visible)
	self.Visible = visible
	if visible then
		self.Frame.Visible = true
		Tween(self.Frame, {BackgroundTransparency = 0}, 0.25)
		TypewriterEffect(self.TopBar:FindFirstChild("Title") or Instance.new("TextLabel"), self.Title, 0.05)
	else
		local t = Tween(self.Frame, {BackgroundTransparency = 1}, 0.25)
		t.Completed:Connect(function()
			self.Frame.Visible = false
		end)
	end
end

function Window:Notify(options)
	self.NotifSystem:Send(options)
end

function Window:CreateTab(options)
	local theme = self.Theme
	options = options or {}
	local name = options.Name or "Tab"
	local icon = options.Icon or ""

	local tabButton = Instance.new("TextButton")
	tabButton.Name = name .. "Tab"
	tabButton.BackgroundColor3 = theme.TabInactive
	tabButton.Size = UDim2.new(1, 0, 0, 34)
	tabButton.Font = Enum.Font.Gotham
	tabButton.TextColor3 = theme.SubText
	tabButton.TextSize = 13
	tabButton.Text = (icon ~= "" and icon .. "  " or "") .. name
	tabButton.TextXAlignment = Enum.TextXAlignment.Left
	tabButton.ZIndex = 13
	tabButton.LayoutOrder = #self.Tabs + 1
	CreateUICorner(tabButton, 8)
	CreateUIPadding(tabButton, 0, 8, 0, 12)
	tabButton.Parent = self.TabList

	local activeIndicator = Instance.new("Frame")
	activeIndicator.Name = "Indicator"
	activeIndicator.AnchorPoint = Vector2.new(0, 0.5)
	activeIndicator.BackgroundColor3 = theme.Accent
	activeIndicator.Position = UDim2.new(0, 0, 0.5, 0)
	activeIndicator.Size = UDim2.new(0, 0, 0, 16)
	activeIndicator.ZIndex = 14
	CreateUICorner(activeIndicator, 3)
	activeIndicator.Parent = tabButton

	local tabPage = Instance.new("ScrollingFrame")
	tabPage.Name = name .. "Page"
	tabPage.BackgroundTransparency = 1
	tabPage.Size = UDim2.new(1, 0, 1, 0)
	tabPage.ScrollBarThickness = 3
	tabPage.ScrollBarImageColor3 = theme.ScrollBar
	tabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabPage.ZIndex = 12
	tabPage.Visible = false
	tabPage.Parent = self.ContentArea

	local pageLayout = Instance.new("UIListLayout")
	pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	pageLayout.Padding = UDim.new(0, 8)
	pageLayout.Parent = tabPage
	CreateUIPadding(tabPage, 12, 12, 12, 12)

	pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabPage.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 24)
	end)

	local Tab = {}
	Tab.Button = tabButton
	Tab.Page = tabPage
	Tab.Name = name
	Tab._order = 0

	function Tab:Select()
		for _, t in ipairs(self._window.Tabs) do
			Tween(t.Button, {BackgroundColor3 = theme.TabInactive, TextColor3 = theme.SubText}, 0.2)
			local ind = t.Button:FindFirstChild("Indicator")
			if ind then Tween(ind, {Size = UDim2.new(0, 0, 0, 16)}, 0.2) end
			t.Page.Visible = false
		end
		Tween(tabButton, {BackgroundColor3 = theme.TabActive, TextColor3 = theme.Text}, 0.2)
		local ind = tabButton:FindFirstChild("Indicator")
		if ind then Tween(ind, {Size = UDim2.new(0, 3, 0, 16)}, 0.2) end
		tabPage.Visible = true
		self._window.ActiveTab = self
	end

	Tab._window = self

	tabButton.MouseButton1Click:Connect(function()
		Tab:Select()
	end)

	tabButton.MouseEnter:Connect(function()
		if self.ActiveTab ~= Tab then
			Tween(tabButton, {BackgroundColor3 = theme.TertiaryBackground}, 0.15)
		end
	end)

	tabButton.MouseLeave:Connect(function()
		if self.ActiveTab ~= Tab then
			Tween(tabButton, {BackgroundColor3 = theme.TabInactive}, 0.15)
		end
	end)

	table.insert(self.Tabs, Tab)

	if #self.Tabs == 1 then
		Tab:Select()
	end

	function Tab:CreateSection(options)
		local sectionOpts = options or {}
		local sectionName = sectionOpts.Name or "Section"

		local sectionFrame = Instance.new("Frame")
		sectionFrame.Name = sectionName .. "Section"
		sectionFrame.BackgroundColor3 = theme.SecondaryBackground
		sectionFrame.Size = UDim2.new(1, 0, 0, 0)
		sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
		sectionFrame.ZIndex = 13
		sectionFrame.LayoutOrder = Tab._order
		Tab._order += 1
		CreateUICorner(sectionFrame, 10)
		CreateUIStroke(sectionFrame, theme.Border, 1)
		sectionFrame.Parent = tabPage

		local sectionContent = Instance.new("Frame")
		sectionContent.BackgroundTransparency = 1
		sectionContent.Size = UDim2.new(1, 0, 0, 0)
		sectionContent.AutomaticSize = Enum.AutomaticSize.Y
		sectionContent.ZIndex = 14
		sectionContent.Parent = sectionFrame
		CreateUIPadding(sectionContent, 8, 10, 8, 10)

		local sectionLayout = Instance.new("UIListLayout")
		sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
		sectionLayout.Padding = UDim.new(0, 6)
		sectionLayout.Parent = sectionContent

		local headerFrame = Instance.new("Frame")
		headerFrame.BackgroundTransparency = 1
		headerFrame.Size = UDim2.new(1, 0, 0, 24)
		headerFrame.ZIndex = 14
		headerFrame.LayoutOrder = 0
		headerFrame.Parent = sectionContent

		local headerLine = Instance.new("Frame")
		headerLine.BackgroundColor3 = theme.Border
		headerLine.AnchorPoint = Vector2.new(0, 0.5)
		headerLine.Position = UDim2.new(0, 0, 0.5, 0)
		headerLine.Size = UDim2.new(1, 0, 0, 1)
		headerLine.ZIndex = 14
		headerLine.Parent = headerFrame

		local headerLabel = Instance.new("TextLabel")
		headerLabel.BackgroundColor3 = theme.SecondaryBackground
		headerLabel.AnchorPoint = Vector2.new(0, 0.5)
		headerLabel.Position = UDim2.new(0, 0, 0.5, 0)
		headerLabel.Size = UDim2.new(0, 0, 0, 18)
		headerLabel.AutomaticSize = Enum.AutomaticSize.X
		headerLabel.Font = Enum.Font.GothamBold
		headerLabel.Text = " " .. sectionName .. " "
		headerLabel.TextColor3 = theme.Accent
		headerLabel.TextSize = 11
		headerLabel.ZIndex = 15
		CreateUIPadding(headerLabel, 0, 4, 0, 0)
		headerLabel.Parent = headerFrame

		local Section = {}
		Section._order = 1
		Section._frame = sectionContent
		Section._tab = Tab

		local function MakeElementBase(elementOpts)
			local label = elementOpts.Name or "Element"
			local desc = elementOpts.Description or ""

			local row = Instance.new("Frame")
			row.BackgroundTransparency = 1
			row.Size = UDim2.new(1, 0, 0, 36)
			row.ZIndex = 15
			row.LayoutOrder = Section._order
			Section._order += 1
			row.Parent = sectionContent

			local labelEl = Instance.new("TextLabel")
			labelEl.BackgroundTransparency = 1
			labelEl.Position = UDim2.new(0, 0, 0, 0)
			labelEl.Size = UDim2.new(0.55, 0, 1, 0)
			labelEl.Font = Enum.Font.Gotham
			labelEl.Text = label
			labelEl.TextColor3 = theme.Text
			labelEl.TextSize = 13
			labelEl.TextXAlignment = Enum.TextXAlignment.Left
			labelEl.ZIndex = 15
			labelEl.Parent = row

			if desc ~= "" then
				labelEl.Size = UDim2.new(0.55, 0, 0.5, 0)
				local descEl = Instance.new("TextLabel")
				descEl.BackgroundTransparency = 1
				descEl.Position = UDim2.new(0, 0, 0.5, 0)
				descEl.Size = UDim2.new(0.55, 0, 0.5, 0)
				descEl.Font = Enum.Font.Gotham
				descEl.Text = desc
				descEl.TextColor3 = theme.SubText
				descEl.TextSize = 11
				descEl.TextXAlignment = Enum.TextXAlignment.Left
				descEl.ZIndex = 15
				descEl.Parent = row
			end

			return row
		end

		function Section:AddButton(opts)
			opts = opts or {}
			local label = opts.Name or "Button"
			local callback = opts.Callback or function() end

			local row = Instance.new("Frame")
			row.BackgroundTransparency = 1
			row.Size = UDim2.new(1, 0, 0, 36)
			row.ZIndex = 15
			row.LayoutOrder = Section._order
			Section._order += 1
			row.Parent = sectionContent

			local btn = Instance.new("TextButton")
			btn.BackgroundColor3 = theme.TertiaryBackground
			btn.Size = UDim2.new(1, 0, 1, 0)
			btn.Font = Enum.Font.GothamBold
			btn.Text = label
			btn.TextColor3 = theme.Text
			btn.TextSize = 13
			btn.ZIndex = 15
			CreateUICorner(btn, 8)
			CreateUIStroke(btn, theme.Border, 1)
			btn.Parent = row

			local btnGrad = Instance.new("Frame")
			btnGrad.BackgroundColor3 = Color3.new(1,1,1)
			btnGrad.Size = UDim2.new(1,0,1,0)
			btnGrad.ZIndex = 16
			btnGrad.BackgroundTransparency = 0.85
			CreateUICorner(btnGrad, 8)
			CreateGradient(btnGrad, theme.Gradient1, theme.Gradient2, 135)
			btnGrad.Parent = btn

			btn.MouseEnter:Connect(function()
				Tween(btn, {BackgroundColor3 = theme.Accent}, 0.2)
				Tween(btnGrad, {BackgroundTransparency = 0.6}, 0.2)
			end)
			btn.MouseLeave:Connect(function()
				Tween(btn, {BackgroundColor3 = theme.TertiaryBackground}, 0.2)
				Tween(btnGrad, {BackgroundTransparency = 0.85}, 0.2)
			end)
			btn.MouseButton1Down:Connect(function()
				Tween(btn, {BackgroundColor3 = theme.AccentDark}, 0.1)
			end)
			btn.MouseButton1Up:Connect(function()
				Tween(btn, {BackgroundColor3 = theme.Accent}, 0.1)
			end)
			btn.MouseButton1Click:Connect(function()
				callback()
			end)

			local Button = {}
			function Button:SetText(text)
				btn.Text = text
			end
			return Button
		end

		function Section:AddToggle(opts)
			opts = opts or {}
			local label = opts.Name or "Toggle"
			local default = opts.Default or false
			local callback = opts.Callback or function() end

			local row = MakeElementBase(opts)
			row.Size = UDim2.new(1, 0, 0, 36)

			local togBg = Instance.new("Frame")
			togBg.AnchorPoint = Vector2.new(1, 0.5)
			togBg.BackgroundColor3 = default and theme.Accent or theme.TertiaryBackground
			togBg.Position = UDim2.new(1, 0, 0.5, 0)
			togBg.Size = UDim2.new(0, 44, 0, 22)
			togBg.ZIndex = 15
			CreateUICorner(togBg, 11)
			CreateUIStroke(togBg, theme.Border, 1)
			togBg.Parent = row

			local togKnob = Instance.new("Frame")
			togKnob.AnchorPoint = Vector2.new(0, 0.5)
			togKnob.BackgroundColor3 = Color3.new(1, 1, 1)
			togKnob.Position = default and UDim2.new(0, 24, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
			togKnob.Size = UDim2.new(0, 18, 0, 18)
			togKnob.ZIndex = 16
			CreateUICorner(togKnob, 9)
			togKnob.Parent = togBg

			local state = default
			local Toggle = {Value = state}

			local function SetState(newState, silent)
				state = newState
				Toggle.Value = state
				Tween(togBg, {BackgroundColor3 = state and theme.Accent or theme.TertiaryBackground}, 0.2)
				Tween(togKnob, {Position = state and UDim2.new(0, 24, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}, 0.2)
				if not silent then callback(state) end
			end

			togBg.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					SetState(not state)
				end
			end)
			togBg.MouseEnter:Connect(function()
				Tween(togBg, {BackgroundColor3 = state and theme.AccentGlow or theme.Border}, 0.15)
			end)
			togBg.MouseLeave:Connect(function()
				Tween(togBg, {BackgroundColor3 = state and theme.Accent or theme.TertiaryBackground}, 0.15)
			end)

			function Toggle:Set(val)
				SetState(val, true)
			end

			return Toggle
		end

		function Section:AddSlider(opts)
			opts = opts or {}
			local label = opts.Name or "Slider"
			local min = opts.Min or 0
			local max = opts.Max or 100
			local default = opts.Default or min
			local suffix = opts.Suffix or ""
			local callback = opts.Callback or function() end

			local row = Instance.new("Frame")
			row.BackgroundTransparency = 1
			row.Size = UDim2.new(1, 0, 0, 48)
			row.ZIndex = 15
			row.LayoutOrder = Section._order
			Section._order += 1
			row.Parent = sectionContent

			local labelEl = Instance.new("TextLabel")
			labelEl.BackgroundTransparency = 1
			labelEl.Size = UDim2.new(1, 0, 0, 20)
			labelEl.Font = Enum.Font.Gotham
			labelEl.Text = label
			labelEl.TextColor3 = theme.Text
			labelEl.TextSize = 13
			labelEl.TextXAlignment = Enum.TextXAlignment.Left
			labelEl.ZIndex = 15
			labelEl.Parent = row

			local valueLabel = Instance.new("TextLabel")
			valueLabel.BackgroundTransparency = 1
			valueLabel.AnchorPoint = Vector2.new(1, 0)
			valueLabel.Position = UDim2.new(1, 0, 0, 0)
			valueLabel.Size = UDim2.new(0, 80, 0, 20)
			valueLabel.Font = Enum.Font.GothamBold
			valueLabel.Text = tostring(default) .. suffix
			valueLabel.TextColor3 = theme.Accent
			valueLabel.TextSize = 13
			valueLabel.TextXAlignment = Enum.TextXAlignment.Right
			valueLabel.ZIndex = 15
			valueLabel.Parent = row

			local track = Instance.new("Frame")
			track.BackgroundColor3 = theme.TertiaryBackground
			track.Position = UDim2.new(0, 0, 0, 26)
			track.Size = UDim2.new(1, 0, 0, 8)
			track.ZIndex = 15
			CreateUICorner(track, 4)
			track.Parent = row

			local fill = Instance.new("Frame")
			fill.BackgroundColor3 = theme.Accent
			fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			fill.ZIndex = 16
			CreateUICorner(fill, 4)
			local fillGrad = Instance.new("Frame")
			fillGrad.BackgroundColor3 = Color3.new(1,1,1)
			fillGrad.Size = UDim2.new(1,0,1,0)
			fillGrad.BackgroundTransparency = 0.5
			fillGrad.ZIndex = 17
			CreateUICorner(fillGrad, 4)
			CreateGradient(fillGrad, theme.Gradient1, theme.Gradient2, 90)
			fillGrad.Parent = fill
			fill.Parent = track

			local knob = Instance.new("Frame")
			knob.AnchorPoint = Vector2.new(0.5, 0.5)
			knob.BackgroundColor3 = Color3.new(1, 1, 1)
			knob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
			knob.Size = UDim2.new(0, 14, 0, 14)
			knob.ZIndex = 18
			CreateUICorner(knob, 7)
			CreateUIStroke(knob, theme.Accent, 2)
			knob.Parent = track

			local Slider = {Value = default}
			local dragging = false

			local function UpdateSlider(x)
				local absPos = track.AbsolutePosition.X
				local absSize = track.AbsoluteSize.X
				local ratio = math.clamp((x - absPos) / absSize, 0, 1)
				local value = math.floor(min + (max - min) * ratio)
				Slider.Value = value
				valueLabel.Text = tostring(value) .. suffix
				fill.Size = UDim2.new(ratio, 0, 1, 0)
				knob.Position = UDim2.new(ratio, 0, 0.5, 0)
				callback(value)
			end

			track.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					UpdateSlider(input.Position.X)
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					UpdateSlider(input.Position.X)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)

			function Slider:Set(val)
				local ratio = math.clamp((val - min) / (max - min), 0, 1)
				Slider.Value = val
				valueLabel.Text = tostring(val) .. suffix
				fill.Size = UDim2.new(ratio, 0, 1, 0)
				knob.Position = UDim2.new(ratio, 0, 0.5, 0)
			end

			return Slider
		end

		function Section:AddInput(opts)
			opts = opts or {}
			local label = opts.Name or "Input"
			local placeholder = opts.Placeholder or "Enter text..."
			local default = opts.Default or ""
			local callback = opts.Callback or function() end

			local row = Instance.new("Frame")
			row.BackgroundTransparency = 1
			row.Size = UDim2.new(1, 0, 0, 54)
			row.ZIndex = 15
			row.LayoutOrder = Section._order
			Section._order += 1
			row.Parent = sectionContent

			local labelEl = Instance.new("TextLabel")
			labelEl.BackgroundTransparency = 1
			labelEl.Size = UDim2.new(1, 0, 0, 18)
			labelEl.Font = Enum.Font.Gotham
			labelEl.Text = label
			labelEl.TextColor3 = theme.Text
			labelEl.TextSize = 13
			labelEl.TextXAlignment = Enum.TextXAlignment.Left
			labelEl.ZIndex = 15
			labelEl.Parent = row

			local inputBg = Instance.new("Frame")
			inputBg.BackgroundColor3 = theme.TertiaryBackground
			inputBg.Position = UDim2.new(0, 0, 0, 22)
			inputBg.Size = UDim2.new(1, 0, 0, 28)
			inputBg.ZIndex = 15
			CreateUICorner(inputBg, 7)
			CreateUIStroke(inputBg, theme.Border, 1)
			inputBg.Parent = row

			local inputBox = Instance.new("TextBox")
			inputBox.BackgroundTransparency = 1
			inputBox.Position = UDim2.new(0, 8, 0, 0)
			inputBox.Size = UDim2.new(1, -16, 1, 0)
			inputBox.Font = Enum.Font.Gotham
			inputBox.Text = default
			inputBox.PlaceholderText = placeholder
			inputBox.PlaceholderColor3 = theme.SubText
			inputBox.TextColor3 = theme.Text
			inputBox.TextSize = 13
			inputBox.TextXAlignment = Enum.TextXAlignment.Left
			inputBox.ClearTextOnFocus = false
			inputBox.ZIndex = 16
			inputBox.Parent = inputBg

			local stroke = inputBg:FindFirstChildOfClass("UIStroke")
			inputBox.Focused:Connect(function()
				if stroke then Tween(stroke, {Color = theme.Accent}, 0.2) end
			end)
			inputBox.FocusLost:Connect(function(enter)
				if stroke then Tween(stroke, {Color = theme.Border}, 0.2) end
				callback(inputBox.Text, enter)
			end)

			local Input = {Value = default}
			function Input:Set(text)
				inputBox.Text = text
				Input.Value = text
			end
			function Input:Get()
				return inputBox.Text
			end

			return Input
		end

		function Section:AddDropdown(opts)
			opts = opts or {}
			local label = opts.Name or "Dropdown"
			local options = opts.Options or {}
			local default = opts.Default or (options[1] or "Select...")
			local callback = opts.Callback or function() end

			local row = Instance.new("Frame")
			row.BackgroundTransparency = 1
			row.Size = UDim2.new(1, 0, 0, 54)
			row.ZIndex = 15
			row.ClipsDescendants = false
			row.LayoutOrder = Section._order
			Section._order += 1
			row.Parent = sectionContent

			local labelEl = Instance.new("TextLabel")
			labelEl.BackgroundTransparency = 1
			labelEl.Size = UDim2.new(1, 0, 0, 18)
			labelEl.Font = Enum.Font.Gotham
			labelEl.Text = label
			labelEl.TextColor3 = theme.Text
			labelEl.TextSize = 13
			labelEl.TextXAlignment = Enum.TextXAlignment.Left
			labelEl.ZIndex = 15
			labelEl.Parent = row

			local dropBtn = Instance.new("TextButton")
			dropBtn.BackgroundColor3 = theme.TertiaryBackground
			dropBtn.Position = UDim2.new(0, 0, 0, 22)
			dropBtn.Size = UDim2.new(1, 0, 0, 28)
			dropBtn.Font = Enum.Font.Gotham
			dropBtn.Text = " " .. default
			dropBtn.TextColor3 = theme.Text
			dropBtn.TextSize = 13
			dropBtn.TextXAlignment = Enum.TextXAlignment.Left
			dropBtn.ZIndex = 20
			CreateUICorner(dropBtn, 7)
			CreateUIStroke(dropBtn, theme.Border, 1)
			dropBtn.Parent = row

			local arrowLabel = Instance.new("TextLabel")
			arrowLabel.BackgroundTransparency = 1
			arrowLabel.AnchorPoint = Vector2.new(1, 0.5)
			arrowLabel.Position = UDim2.new(1, -8, 0.5, 0)
			arrowLabel.Size = UDim2.new(0, 16, 0, 16)
			arrowLabel.Font = Enum.Font.GothamBold
			arrowLabel.Text = "▾"
			arrowLabel.TextColor3 = theme.SubText
			arrowLabel.TextSize = 13
			arrowLabel.ZIndex = 21
			arrowLabel.Parent = dropBtn

			local dropList = Instance.new("Frame")
			dropList.BackgroundColor3 = theme.SecondaryBackground
			dropList.Position = UDim2.new(0, 0, 1, 4)
			dropList.Size = UDim2.new(1, 0, 0, 0)
			dropList.ZIndex = 50
			dropList.Visible = false
			dropList.ClipsDescendants = true
			CreateUICorner(dropList, 7)
			CreateUIStroke(dropList, theme.Border, 1)
			dropList.Parent = row

			local dropScroll = Instance.new("ScrollingFrame")
			dropScroll.BackgroundTransparency = 1
			dropScroll.Size = UDim2.new(1, 0, 1, 0)
			dropScroll.ScrollBarThickness = 2
			dropScroll.ScrollBarImageColor3 = theme.ScrollBar
			dropScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
			dropScroll.ZIndex = 51
			dropScroll.Parent = dropList

			local dropLayout = Instance.new("UIListLayout")
			dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
			dropLayout.Padding = UDim.new(0, 2)
			dropLayout.Parent = dropScroll
			CreateUIPadding(dropScroll, 4, 4, 4, 4)

			local isOpen = false
			local currentValue = default
			local Dropdown = {Value = default}

			local function Refresh()
				for _, child in ipairs(dropScroll:GetChildren()) do
					if child:IsA("TextButton") then child:Destroy() end
				end

				for _, option in ipairs(options) do
					local optBtn = Instance.new("TextButton")
					optBtn.BackgroundColor3 = (option == currentValue) and theme.Accent or theme.TertiaryBackground
					optBtn.Size = UDim2.new(1, 0, 0, 28)
					optBtn.Font = Enum.Font.Gotham
					optBtn.Text = " " .. option
					optBtn.TextColor3 = (option == currentValue) and theme.Text or theme.SubText
					optBtn.TextSize = 13
					optBtn.TextXAlignment = Enum.TextXAlignment.Left
					optBtn.ZIndex = 52
					CreateUICorner(optBtn, 6)
					optBtn.Parent = dropScroll

					optBtn.MouseEnter:Connect(function()
						if option ~= currentValue then
							Tween(optBtn, {BackgroundColor3 = theme.Border}, 0.1)
						end
					end)
					optBtn.MouseLeave:Connect(function()
						if option ~= currentValue then
							Tween(optBtn, {BackgroundColor3 = theme.TertiaryBackground}, 0.1)
						end
					end)
					optBtn.MouseButton1Click:Connect(function()
						currentValue = option
						Dropdown.Value = option
						dropBtn.Text = " " .. option
						callback(option)
						isOpen = false
						Tween(dropList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
						task.delay(0.2, function() dropList.Visible = false end)
						Refresh()
					end)
				end

				dropLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					dropScroll.CanvasSize = UDim2.new(0, 0, 0, dropLayout.AbsoluteContentSize.Y + 8)
				end)
			end

			Refresh()

			dropBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				if isOpen then
					local height = math.min(#options * 30 + 8, 150)
					dropList.Visible = true
					Tween(dropList, {Size = UDim2.new(1, 0, 0, height)}, 0.25, Enum.EasingStyle.Back)
					Tween(arrowLabel, {Rotation = 180}, 0.2)
				else
					Tween(dropList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
					Tween(arrowLabel, {Rotation = 0}, 0.2)
					task.delay(0.2, function() dropList.Visible = false end)
				end
			end)

			function Dropdown:Set(val)
				currentValue = val
				Dropdown.Value = val
				dropBtn.Text = " " .. val
				Refresh()
			end

			function Dropdown:SetOptions(newOptions)
				options = newOptions
				Refresh()
			end

			return Dropdown
		end

		function Section:AddMultiDropdown(opts)
			opts = opts or {}
			local label = opts.Name or "Multi Select"
			local options = opts.Options or {}
			local default = opts.Default or {}
			local callback = opts.Callback or function() end

			local selected = {}
			for _, v in ipairs(default) do selected[v] = true end

			local row = Instance.new("Frame")
			row.BackgroundTransparency = 1
			row.Size = UDim2.new(1, 0, 0, 54)
			row.ZIndex = 15
			row.ClipsDescendants = false
			row.LayoutOrder = Section._order
			Section._order += 1
			row.Parent = sectionContent

			local labelEl = Instance.new("TextLabel")
			labelEl.BackgroundTransparency = 1
			labelEl.Size = UDim2.new(1, 0, 0, 18)
			labelEl.Font = Enum.Font.Gotham
			labelEl.Text = label
			labelEl.TextColor3 = theme.Text
			labelEl.TextSize = 13
			labelEl.TextXAlignment = Enum.TextXAlignment.Left
			labelEl.ZIndex = 15
			labelEl.Parent = row

			local dropBtn = Instance.new("TextButton")
			dropBtn.BackgroundColor3 = theme.TertiaryBackground
			dropBtn.Position = UDim2.new(0, 0, 0, 22)
			dropBtn.Size = UDim2.new(1, 0, 0, 28)
			dropBtn.Font = Enum.Font.Gotham
			dropBtn.TextColor3 = theme.Text
			dropBtn.TextSize = 12
			dropBtn.TextXAlignment = Enum.TextXAlignment.Left
			dropBtn.ZIndex = 20
			CreateUICorner(dropBtn, 7)
			CreateUIStroke(dropBtn, theme.Border, 1)
			dropBtn.Parent = row

			local arrowLabel = Instance.new("TextLabel")
			arrowLabel.BackgroundTransparency = 1
			arrowLabel.AnchorPoint = Vector2.new(1, 0.5)
			arrowLabel.Position = UDim2.new(1, -8, 0.5, 0)
			arrowLabel.Size = UDim2.new(0, 16, 0, 16)
			arrowLabel.Font = Enum.Font.GothamBold
			arrowLabel.Text = "▾"
			arrowLabel.TextColor3 = theme.SubText
			arrowLabel.TextSize = 13
			arrowLabel.ZIndex = 21
			arrowLabel.Parent = dropBtn

			local dropList = Instance.new("Frame")
			dropList.BackgroundColor3 = theme.SecondaryBackground
			dropList.Position = UDim2.new(0, 0, 1, 4)
			dropList.Size = UDim2.new(1, 0, 0, 0)
			dropList.ZIndex = 50
			dropList.Visible = false
			dropList.ClipsDescendants = true
			CreateUICorner(dropList, 7)
			CreateUIStroke(dropList, theme.Border, 1)
			dropList.Parent = row

			local dropScroll = Instance.new("ScrollingFrame")
			dropScroll.BackgroundTransparency = 1
			dropScroll.Size = UDim2.new(1, 0, 1, 0)
			dropScroll.ScrollBarThickness = 2
			dropScroll.ScrollBarImageColor3 = theme.ScrollBar
			dropScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
			dropScroll.ZIndex = 51
			dropScroll.Parent = dropList

			local dropLayout = Instance.new("UIListLayout")
			dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
			dropLayout.Padding = UDim.new(0, 2)
			dropLayout.Parent = dropScroll
			CreateUIPadding(dropScroll, 4, 4, 4, 4)

			local MultiDropdown = {}
			MultiDropdown.Value = selected

			local function GetText()
				local keys = {}
				for k, v in pairs(selected) do if v then table.insert(keys, k) end end
				if #keys == 0 then return " None selected" end
				return " " .. table.concat(keys, ", ")
			end

			local function Refresh()
				for _, child in ipairs(dropScroll:GetChildren()) do
					if child:IsA("Frame") then child:Destroy() end
				end

				for _, option in ipairs(options) do
					local isSelected = selected[option] == true

					local optRow = Instance.new("Frame")
					optRow.BackgroundColor3 = isSelected and theme.Accent or theme.TertiaryBackground
					optRow.Size = UDim2.new(1, 0, 0, 28)
					optRow.ZIndex = 52
					CreateUICorner(optRow, 6)
					optRow.Parent = dropScroll

					local btn = Instance.new("TextButton")
					btn.BackgroundTransparency = 1
					btn.Size = UDim2.new(1, 0, 1, 0)
					btn.Font = Enum.Font.Gotham
					btn.Text = " " .. option
					btn.TextColor3 = isSelected and theme.Text or theme.SubText
					btn.TextSize = 13
					btn.TextXAlignment = Enum.TextXAlignment.Left
					btn.ZIndex = 53
					btn.Parent = optRow

					local checkLabel = Instance.new("TextLabel")
					checkLabel.BackgroundTransparency = 1
					checkLabel.AnchorPoint = Vector2.new(1, 0.5)
					checkLabel.Position = UDim2.new(1, -8, 0.5, 0)
					checkLabel.Size = UDim2.new(0, 16, 0, 16)
					checkLabel.Font = Enum.Font.GothamBold
					checkLabel.Text = isSelected and "✓" or ""
					checkLabel.TextColor3 = theme.Text
					checkLabel.TextSize = 12
					checkLabel.ZIndex = 53
					checkLabel.Parent = optRow

					btn.MouseButton1Click:Connect(function()
						selected[option] = not (selected[option] == true)
						MultiDropdown.Value = selected
						dropBtn.Text = GetText()
						local result = {}
						for k, v in pairs(selected) do if v then table.insert(result, k) end end
						callback(result)
						Refresh()
					end)
				end

				dropLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					dropScroll.CanvasSize = UDim2.new(0, 0, 0, dropLayout.AbsoluteContentSize.Y + 8)
				end)
			end

			dropBtn.Text = GetText()
			Refresh()

			local isOpen = false
			dropBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				if isOpen then
					local height = math.min(#options * 30 + 8, 150)
					dropList.Visible = true
					Tween(dropList, {Size = UDim2.new(1, 0, 0, height)}, 0.25, Enum.EasingStyle.Back)
					Tween(arrowLabel, {Rotation = 180}, 0.2)
				else
					Tween(dropList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
					Tween(arrowLabel, {Rotation = 0}, 0.2)
					task.delay(0.2, function() dropList.Visible = false end)
				end
			end)

			return MultiDropdown
		end

		function Section:AddKeybind(opts)
			opts = opts or {}
			local label = opts.Name or "Keybind"
			local default = opts.Default or Enum.KeyCode.Unknown
			local callback = opts.Callback or function() end

			local row = MakeElementBase(opts)
			row.Size = UDim2.new(1, 0, 0, 36)

			local keybindBtn = Instance.new("TextButton")
			keybindBtn.AnchorPoint = Vector2.new(1, 0.5)
			keybindBtn.BackgroundColor3 = theme.TertiaryBackground
			keybindBtn.Position = UDim2.new(1, 0, 0.5, 0)
			keybindBtn.Size = UDim2.new(0, 90, 0, 24)
			keybindBtn.Font = Enum.Font.GothamBold
			keybindBtn.TextColor3 = theme.Accent
			keybindBtn.TextSize = 11
			keybindBtn.ZIndex = 15
			CreateUICorner(keybindBtn, 6)
			CreateUIStroke(keybindBtn, theme.Border, 1)
			keybindBtn.Parent = row

			local currentKey = default
			local listening = false
			local Keybind = {Value = default}

			keybindBtn.Text = default.Name

			local conn
			keybindBtn.MouseButton1Click:Connect(function()
				listening = true
				keybindBtn.Text = "..."
				keybindBtn.TextColor3 = theme.Warning
				Tween(keybindBtn, {BackgroundColor3 = theme.TertiaryBackground}, 0.1)
				if conn then conn:Disconnect() end
				conn = UserInputService.InputBegan:Connect(function(input, processed)
					if listening and input.UserInputType == Enum.UserInputType.Keyboard then
						listening = false
						currentKey = input.KeyCode
						Keybind.Value = input.KeyCode
						keybindBtn.Text = input.KeyCode.Name
						keybindBtn.TextColor3 = theme.Accent
						Tween(keybindBtn, {BackgroundColor3 = theme.TertiaryBackground}, 0.1)
						callback(input.KeyCode)
						if conn then conn:Disconnect() end
					end
				end)
			end)

			UserInputService.InputBegan:Connect(function(input, processed)
				if not processed and not listening and input.KeyCode == currentKey then
					callback(currentKey)
				end
			end)

			function Keybind:Set(key)
				currentKey = key
				Keybind.Value = key
				keybindBtn.Text = key.Name
			end

			return Keybind
		end

		function Section:AddLabel(opts)
			opts = opts or {}
			local text = opts.Name or opts.Text or "Label"

			local labelEl = Instance.new("TextLabel")
			labelEl.BackgroundTransparency = 1
			labelEl.Size = UDim2.new(1, 0, 0, 0)
			labelEl.AutomaticSize = Enum.AutomaticSize.Y
			labelEl.Font = Enum.Font.Gotham
			labelEl.Text = text
			labelEl.TextColor3 = theme.SubText
			labelEl.TextSize = 12
			labelEl.TextXAlignment = Enum.TextXAlignment.Left
			labelEl.TextWrapped = true
			labelEl.ZIndex = 15
			labelEl.LayoutOrder = Section._order
			Section._order += 1
			labelEl.Parent = sectionContent

			local Label = {}
			function Label:Set(newText)
				labelEl.Text = newText
			end
			return Label
		end

		function Section:AddParagraph(opts)
			opts = opts or {}
			local title = opts.Title or ""
			local content = opts.Content or ""

			local frame = Instance.new("Frame")
			frame.BackgroundTransparency = 1
			frame.Size = UDim2.new(1, 0, 0, 0)
			frame.AutomaticSize = Enum.AutomaticSize.Y
			frame.ZIndex = 15
			frame.LayoutOrder = Section._order
			Section._order += 1
			frame.Parent = sectionContent

			local layout = Instance.new("UIListLayout")
			layout.Padding = UDim.new(0, 4)
			layout.SortOrder = Enum.SortOrder.LayoutOrder
			layout.Parent = frame

			if title ~= "" then
				local titleEl = Instance.new("TextLabel")
				titleEl.BackgroundTransparency = 1
				titleEl.Size = UDim2.new(1, 0, 0, 0)
				titleEl.AutomaticSize = Enum.AutomaticSize.Y
				titleEl.Font = Enum.Font.GothamBold
				titleEl.Text = title
				titleEl.TextColor3 = theme.Text
				titleEl.TextSize = 13
				titleEl.TextXAlignment = Enum.TextXAlignment.Left
				titleEl.TextWrapped = true
				titleEl.ZIndex = 15
				titleEl.LayoutOrder = 1
				titleEl.Parent = frame
			end

			local contentEl = Instance.new("TextLabel")
			contentEl.BackgroundTransparency = 1
			contentEl.Size = UDim2.new(1, 0, 0, 0)
			contentEl.AutomaticSize = Enum.AutomaticSize.Y
			contentEl.Font = Enum.Font.Gotham
			contentEl.Text = content
			contentEl.TextColor3 = theme.SubText
			contentEl.TextSize = 12
			contentEl.TextXAlignment = Enum.TextXAlignment.Left
			contentEl.TextWrapped = true
			contentEl.ZIndex = 15
			contentEl.LayoutOrder = 2
			contentEl.Parent = frame

			local Paragraph = {}
			function Paragraph:Set(newTitle, newContent)
				if newTitle then
					local t = frame:FindFirstChild("TextLabel")
					if t then t.Text = newTitle end
				end
				contentEl.Text = newContent or content
			end
			return Paragraph
		end

		function Section:AddDivider()
			local divider = Instance.new("Frame")
			divider.BackgroundColor3 = theme.Border
			divider.Size = UDim2.new(1, 0, 0, 1)
			divider.ZIndex = 15
			divider.LayoutOrder = Section._order
			Section._order += 1
			divider.Parent = sectionContent
			return divider
		end

		function Section:AddColorPicker(opts)
			opts = opts or {}
			local label = opts.Name or "Color Picker"
			local default = opts.Default or Color3.fromRGB(255, 100, 100)
			local callback = opts.Callback or function() end

			local row = Instance.new("Frame")
			row.BackgroundTransparency = 1
			row.Size = UDim2.new(1, 0, 0, 36)
			row.ZIndex = 15
			row.ClipsDescendants = false
			row.LayoutOrder = Section._order
			Section._order += 1
			row.Parent = sectionContent

			local labelEl = Instance.new("TextLabel")
			labelEl.BackgroundTransparency = 1
			labelEl.Size = UDim2.new(0.6, 0, 1, 0)
			labelEl.Font = Enum.Font.Gotham
			labelEl.Text = label
			labelEl.TextColor3 = theme.Text
			labelEl.TextSize = 13
			labelEl.TextXAlignment = Enum.TextXAlignment.Left
			labelEl.ZIndex = 15
			labelEl.Parent = row

			local colorPreview = Instance.new("TextButton")
			colorPreview.AnchorPoint = Vector2.new(1, 0.5)
			colorPreview.BackgroundColor3 = default
			colorPreview.Position = UDim2.new(1, 0, 0.5, 0)
			colorPreview.Size = UDim2.new(0, 50, 0, 22)
			colorPreview.Text = ""
			colorPreview.ZIndex = 15
			CreateUICorner(colorPreview, 6)
			CreateUIStroke(colorPreview, theme.Border, 1)
			colorPreview.Parent = row

			local pickerFrame = Instance.new("Frame")
			pickerFrame.BackgroundColor3 = theme.SecondaryBackground
			pickerFrame.Position = UDim2.new(0, 0, 1, 6)
			pickerFrame.Size = UDim2.new(1, 0, 0, 0)
			pickerFrame.ZIndex = 60
			pickerFrame.Visible = false
			pickerFrame.ClipsDescendants = true
			CreateUICorner(pickerFrame, 8)
			CreateUIStroke(pickerFrame, theme.Border, 1)
			pickerFrame.Parent = row

			local pickerInner = Instance.new("Frame")
			pickerInner.BackgroundTransparency = 1
			pickerInner.Size = UDim2.new(1, 0, 0, 130)
			pickerInner.ZIndex = 61
			pickerInner.Parent = pickerFrame

			local hueBar = Instance.new("Frame")
			hueBar.BackgroundColor3 = Color3.new(1, 1, 1)
			hueBar.Position = UDim2.new(0, 8, 0, 8)
			hueBar.Size = UDim2.new(1, -16, 0, 16)
			hueBar.ZIndex = 62
			CreateUICorner(hueBar, 4)

			local hueGrad = Instance.new("UIGradient")
			hueGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
				ColorSequenceKeypoint.new(1/6, Color3.fromHSV(1/6, 1, 1)),
				ColorSequenceKeypoint.new(2/6, Color3.fromHSV(2/6, 1, 1)),
				ColorSequenceKeypoint.new(3/6, Color3.fromHSV(3/6, 1, 1)),
				ColorSequenceKeypoint.new(4/6, Color3.fromHSV(4/6, 1, 1)),
				ColorSequenceKeypoint.new(5/6, Color3.fromHSV(5/6, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
			})
			hueGrad.Parent = hueBar
			hueBar.Parent = pickerInner

			local satValFrame = Instance.new("ImageLabel")
			satValFrame.BackgroundColor3 = Color3.new(1, 0, 0)
			satValFrame.Position = UDim2.new(0, 8, 0, 32)
			satValFrame.Size = UDim2.new(1, -16, 0, 80)
			satValFrame.ZIndex = 62
			satValFrame.Image = "rbxassetid://6020299385"
			CreateUICorner(satValFrame, 4)
			satValFrame.Parent = pickerInner

			local picker = Instance.new("Frame")
			picker.AnchorPoint = Vector2.new(0.5, 0.5)
			picker.BackgroundColor3 = Color3.new(1, 1, 1)
			picker.Position = UDim2.new(1, 0, 0, 0)
			picker.Size = UDim2.new(0, 10, 0, 10)
			picker.ZIndex = 64
			CreateUICorner(picker, 5)
			CreateUIStroke(picker, Color3.new(0, 0, 0), 1.5)
			picker.Parent = satValFrame

			local hueIndicator = Instance.new("Frame")
			hueIndicator.AnchorPoint = Vector2.new(0.5, 0.5)
			hueIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
			hueIndicator.Position = UDim2.new(0, 0, 0.5, 0)
			hueIndicator.Size = UDim2.new(0, 4, 1, 4)
			hueIndicator.ZIndex = 64
			CreateUICorner(hueIndicator, 2)
			hueIndicator.Parent = hueBar

			local ColorPicker = {Value = default}
			local h, s, v = Color3.toHSV(default)
			local isOpen = false

			local function UpdateColor()
				local color = Color3.fromHSV(h, s, v)
				ColorPicker.Value = color
				colorPreview.BackgroundColor3 = color
				satValFrame.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
				picker.Position = UDim2.new(s, 0, 1 - v, 0)
				hueIndicator.Position = UDim2.new(h, 0, 0.5, 0)
				callback(color)
			end

			local draggingHue = false
			local draggingSV = false

			hueBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingHue = true
					h = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
					UpdateColor()
				end
			end)

			satValFrame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingSV = true
					s = math.clamp((input.Position.X - satValFrame.AbsolutePosition.X) / satValFrame.AbsoluteSize.X, 0, 1)
					v = 1 - math.clamp((input.Position.Y - satValFrame.AbsolutePosition.Y) / satValFrame.AbsoluteSize.Y, 0, 1)
					UpdateColor()
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					if draggingHue then
						h = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
						UpdateColor()
					elseif draggingSV then
						s = math.clamp((input.Position.X - satValFrame.AbsolutePosition.X) / satValFrame.AbsoluteSize.X, 0, 1)
						v = 1 - math.clamp((input.Position.Y - satValFrame.AbsolutePosition.Y) / satValFrame.AbsoluteSize.Y, 0, 1)
						UpdateColor()
					end
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingHue = false
					draggingSV = false
				end
			end)

			colorPreview.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				if isOpen then
					pickerFrame.Visible = true
					Tween(pickerFrame, {Size = UDim2.new(1, 0, 0, 130)}, 0.25, Enum.EasingStyle.Back)
				else
					Tween(pickerFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
					task.delay(0.2, function() pickerFrame.Visible = false end)
				end
			end)

			UpdateColor()

			function ColorPicker:Set(color)
				h, s, v = Color3.toHSV(color)
				UpdateColor()
			end

			return ColorPicker
		end

		return Section
	end

	return Tab
end

function Library:SetTheme(themeName)
	local theme = self.Themes[themeName]
	if not theme then return end
	self.ActiveTheme = theme
end

function Library:Destroy()
	for _, conn in ipairs(self._connections) do
		conn:Disconnect()
	end
	for _, win in ipairs(self.Windows) do
		win.ScreenGui:Destroy()
	end
	self.Windows = {}
	self._connections = {}
end

return Library
