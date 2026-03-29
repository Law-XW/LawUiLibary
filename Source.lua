local LawXW = {}
LawXW.__index = LawXW

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local CONFIG_KEY = "LawXW_Config"
local VERSION = "1.0.0"

local Theme = {
    Background   = Color3.fromRGB(12, 12, 12),
    Surface      = Color3.fromRGB(20, 20, 20),
    SurfaceAlt   = Color3.fromRGB(28, 28, 28),
    Border       = Color3.fromRGB(45, 45, 45),
    Accent       = Color3.fromRGB(255, 255, 255),
    AccentDim    = Color3.fromRGB(180, 180, 180),
    Text         = Color3.fromRGB(240, 240, 240),
    TextSub      = Color3.fromRGB(140, 140, 140),
    TextMuted    = Color3.fromRGB(80, 80, 80),
    Toggle_On    = Color3.fromRGB(255, 255, 255),
    Toggle_Off   = Color3.fromRGB(50, 50, 50),
    SliderFill   = Color3.fromRGB(255, 255, 255),
    SliderTrack  = Color3.fromRGB(40, 40, 40),
    Hover        = Color3.fromRGB(35, 35, 35),
    Selected     = Color3.fromRGB(50, 50, 50),
    Notification = Color3.fromRGB(18, 18, 18),
    Shadow       = Color3.fromRGB(0, 0, 0),
}

local Tweens = {
    Fast   = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Slow   = TweenInfo.new(0.4,  Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.3,  Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
}

local function tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function makeRound(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = obj
    return corner
end

local function makeShadow(parent, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Theme.Shadow
    shadow.ImageTransparency = transparency or 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = parent
    return shadow
end

local function makePadding(obj, t, r, b, l)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop    = UDim.new(0, t or 8)
    pad.PaddingRight  = UDim.new(0, r or 8)
    pad.PaddingBottom = UDim.new(0, b or 8)
    pad.PaddingLeft   = UDim.new(0, l or 8)
    pad.Parent = obj
    return pad
end

local function makeStroke(obj, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj
    return stroke
end

local function makeLabel(parent, text, size, color, zindex)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = text or ""
    label.TextColor3 = color or Theme.Text
    label.TextSize = size or 14
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = zindex or 2
    label.Parent = parent
    return label
end

local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

local SavedConfig = {}
local function loadConfig()
    local ok, data = pcall(function()
        return game:GetService("DataStoreService")
    end)
    if not ok then return end
end

local function saveConfig(key, value)
    SavedConfig[key] = value
end

local function getConfig(key, default)
    return SavedConfig[key] ~= nil and SavedConfig[key] or default
end

local NotifHolder

local function showNotification(title, message, duration, ntype)
    if not NotifHolder then return end
    duration = duration or 4
    ntype = ntype or "info"

    local notif = Instance.new("Frame")
    notif.Name = "Notification"
    notif.Size = UDim2.new(1, 0, 0, 0)
    notif.BackgroundColor3 = Theme.Notification
    notif.BackgroundTransparency = 0
    notif.ClipsDescendants = true
    notif.AutomaticSize = Enum.AutomaticSize.None
    makeRound(notif, 8)
    makeStroke(notif, Theme.Border, 1)
    makeShadow(notif, 0.6)

    local accentBar = Instance.new("Frame")
    accentBar.Name = "Accent"
    accentBar.Size = UDim2.new(0, 3, 1, 0)
    accentBar.Position = UDim2.new(0, 0, 0, 0)
    accentBar.BackgroundColor3 = Theme.Accent
    accentBar.BorderSizePixel = 0
    makeRound(accentBar, 2)
    accentBar.Parent = notif

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -12, 1, 0)
    content.Position = UDim2.new(0, 12, 0, 0)
    content.BackgroundTransparency = 1
    content.Parent = notif

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -8, 0, 18)
    titleLabel.Position = UDim2.new(0, 8, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Notice"
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 3
    titleLabel.Parent = content

    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -8, 0, 30)
    msgLabel.Position = UDim2.new(0, 8, 0, 30)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message or ""
    msgLabel.TextColor3 = Theme.TextSub
    msgLabel.TextSize = 12
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true
    msgLabel.ZIndex = 3
    msgLabel.Parent = content

    notif.Size = UDim2.new(1, 0, 0, 0)
    notif.Parent = NotifHolder

    tween(notif, Tweens.Spring, {Size = UDim2.new(1, 0, 0, 72)})

    local bar = Instance.new("Frame")
    bar.Name = "ProgressBar"
    bar.Size = UDim2.new(1, 0, 0, 2)
    bar.Position = UDim2.new(0, 0, 1, -2)
    bar.BackgroundColor3 = Theme.Accent
    bar.BorderSizePixel = 0
    bar.ZIndex = 4
    bar.Parent = notif

    task.delay(0.3, function()
        tween(bar, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 2)})
    end)

    task.delay(duration + 0.3, function()
        tween(notif, Tweens.Medium, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
        task.delay(0.3, function()
            notif:Destroy()
        end)
    end)
end

local function showLoadingScreen(gui, callback)
    local overlay = Instance.new("Frame")
    overlay.Name = "LoadingScreen"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
    overlay.BackgroundTransparency = 0
    overlay.ZIndex = 100
    overlay.Parent = gui

    local center = Instance.new("Frame")
    center.Name = "Center"
    center.AnchorPoint = Vector2.new(0.5, 0.5)
    center.Position = UDim2.new(0.5, 0, 0.5, 0)
    center.Size = UDim2.new(0, 220, 0, 90)
    center.BackgroundTransparency = 1
    center.ZIndex = 101
    center.Parent = overlay

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(1, 0, 0, 36)
    logo.Position = UDim2.new(0, 0, 0, 0)
    logo.BackgroundTransparency = 1
    logo.Text = "Law-XW"
    logo.TextColor3 = Theme.Accent
    logo.TextSize = 30
    logo.Font = Enum.Font.GothamBold
    logo.TextXAlignment = Enum.TextXAlignment.Center
    logo.ZIndex = 102
    logo.TextTransparency = 1
    logo.Parent = center

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 16)
    sub.Position = UDim2.new(0, 0, 0, 38)
    sub.BackgroundTransparency = 1
    sub.Text = "Loading Law-XW..."
    sub.TextColor3 = Theme.TextSub
    sub.TextSize = 12
    sub.Font = Enum.Font.Gotham
    sub.TextXAlignment = Enum.TextXAlignment.Center
    sub.ZIndex = 102
    sub.TextTransparency = 1
    sub.Parent = center

    local trackBg = Instance.new("Frame")
    trackBg.Size = UDim2.new(1, 0, 0, 3)
    trackBg.Position = UDim2.new(0, 0, 0, 72)
    trackBg.BackgroundColor3 = Theme.SurfaceAlt
    trackBg.BorderSizePixel = 0
    trackBg.ZIndex = 102
    makeRound(trackBg, 2)
    trackBg.Parent = center

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 103
    makeRound(fill, 2)
    fill.Parent = trackBg

    tween(logo, Tweens.Slow, {TextTransparency = 0})
    task.wait(0.3)
    tween(sub, Tweens.Slow, {TextTransparency = 0})
    task.wait(0.2)
    tween(fill, TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
    task.wait(1.4)

    tween(overlay, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
    task.wait(0.3)
    tween(logo, Tweens.Medium, {TextTransparency = 1})
    tween(sub, Tweens.Medium, {TextTransparency = 1})
    task.wait(0.3)
    overlay:Destroy()

    if callback then callback() end
end

function LawXW.new(opts)
    opts = opts or {}

    local self = setmetatable({}, LawXW)
    self.Flags         = {}
    self.Tabs          = {}
    self.ActiveTab     = nil
    self.Visible       = true
    self.ToggleKey     = opts.ToggleKey or Enum.KeyCode.RightShift
    self.Title         = opts.Title or "Law-XW"
    self.Width         = opts.Width or 500
    self.Height        = opts.Height or 380
    self._connections  = {}

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LawXW_" .. HttpService:GenerateGUID(false):sub(1, 8)
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 999
    screenGui.Parent = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or PlayerGui
    self._gui = screenGui

    NotifHolder = Instance.new("Frame")
    NotifHolder.Name = "Notifications"
    NotifHolder.AnchorPoint = Vector2.new(1, 1)
    NotifHolder.Position = UDim2.new(1, -18, 1, -18)
    NotifHolder.Size = UDim2.new(0, 280, 1, -36)
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.ZIndex = 200
    local notifLayout = Instance.new("UIListLayout")
    notifLayout.FillDirection = Enum.FillDirection.Vertical
    notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notifLayout.Padding = UDim.new(0, 8)
    notifLayout.Parent = NotifHolder
    NotifHolder.Parent = screenGui

    local windowWidth = isMobile() and math.min(self.Width, 340) or self.Width
    local windowHeight = self.Height

    local window = Instance.new("Frame")
    window.Name = "Window"
    window.AnchorPoint = Vector2.new(0.5, 0.5)
    window.Position = UDim2.new(0.5, 0, 0.5, 0)
    window.Size = UDim2.new(0, windowWidth, 0, windowHeight)
    window.BackgroundColor3 = Theme.Background
    window.BackgroundTransparency = 0
    window.BorderSizePixel = 0
    window.ClipsDescendants = false
    window.ZIndex = 2
    makeRound(window, 10)
    makeStroke(window, Theme.Border, 1, 0)
    makeShadow(window, 0.3)
    window.Parent = screenGui
    self._window = window

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 44)
    titleBar.BackgroundColor3 = Theme.Surface
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 3
    makeRound(titleBar, 10)
    titleBar.Parent = window

    local titleBarFix = Instance.new("Frame")
    titleBarFix.Size = UDim2.new(1, 0, 0.5, 0)
    titleBarFix.Position = UDim2.new(0, 0, 0.5, 0)
    titleBarFix.BackgroundColor3 = Theme.Surface
    titleBarFix.BorderSizePixel = 0
    titleBarFix.ZIndex = 3
    titleBarFix.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 14, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = self.Title
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 15
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 4
    titleLabel.Parent = titleBar

    local versionLabel = Instance.new("TextLabel")
    versionLabel.Name = "Version"
    versionLabel.Size = UDim2.new(0, 60, 1, 0)
    versionLabel.Position = UDim2.new(0, 14 + titleLabel.TextBounds.X + 8, 0, 0)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "v" .. VERSION
    versionLabel.TextColor3 = Theme.TextMuted
    versionLabel.TextSize = 11
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.TextXAlignment = Enum.TextXAlignment.Left
    versionLabel.ZIndex = 4
    versionLabel.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.AnchorPoint = Vector2.new(1, 0.5)
    closeBtn.Position = UDim2.new(1, -12, 0.5, 0)
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.BackgroundColor3 = Theme.SurfaceAlt
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Theme.TextSub
    closeBtn.TextSize = 13
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 4
    makeRound(closeBtn, 6)
    closeBtn.Parent = titleBar

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeBtn"
    minimizeBtn.AnchorPoint = Vector2.new(1, 0.5)
    minimizeBtn.Position = UDim2.new(1, -46, 0.5, 0)
    minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
    minimizeBtn.BackgroundColor3 = Theme.SurfaceAlt
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = "–"
    minimizeBtn.TextColor3 = Theme.TextSub
    minimizeBtn.TextSize = 15
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.ZIndex = 4
    makeRound(minimizeBtn, 6)
    minimizeBtn.Parent = titleBar

    local isMinimized = false
    local fullSize = UDim2.new(0, windowWidth, 0, windowHeight)
    local miniSize = UDim2.new(0, windowWidth, 0, 44)

    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            tween(window, Tweens.Smooth, {Size = miniSize})
            minimizeBtn.Text = "□"
        else
            tween(window, Tweens.Smooth, {Size = fullSize})
            minimizeBtn.Text = "–"
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        tween(window, Tweens.Medium, {Size = UDim2.new(0, windowWidth, 0, 0), BackgroundTransparency = 1})
        task.delay(0.3, function()
            screenGui:Destroy()
        end)
    end)

    for _, btn in ipairs({closeBtn, minimizeBtn}) do
        btn.MouseEnter:Connect(function()
            tween(btn, Tweens.Fast, {BackgroundColor3 = Theme.Hover})
            tween(btn, Tweens.Fast, {TextColor3 = Theme.Text})
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, Tweens.Fast, {BackgroundColor3 = Theme.SurfaceAlt})
            tween(btn, Tweens.Fast, {TextColor3 = Theme.TextSub})
        end)
    end

    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Position = UDim2.new(0, 0, 0, 44)
    tabBar.Size = UDim2.new(0, 110, 1, -44)
    tabBar.BackgroundColor3 = Theme.Surface
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 3
    tabBar.ClipsDescendants = true
    tabBar.Parent = window
    self._tabBar = tabBar

    local tabBarFix = Instance.new("Frame")
    tabBarFix.Size = UDim2.new(0.5, 0, 1, 0)
    tabBarFix.BackgroundColor3 = Theme.Surface
    tabBarFix.BorderSizePixel = 0
    tabBarFix.ZIndex = 3
    tabBarFix.Parent = tabBar

    local tabDivider = Instance.new("Frame")
    tabDivider.Name = "Divider"
    tabDivider.AnchorPoint = Vector2.new(1, 0)
    tabDivider.Position = UDim2.new(1, 0, 0, 0)
    tabDivider.Size = UDim2.new(0, 1, 1, 0)
    tabDivider.BackgroundColor3 = Theme.Border
    tabDivider.BorderSizePixel = 0
    tabDivider.ZIndex = 3
    tabDivider.Parent = tabBar

    local tabList = Instance.new("Frame")
    tabList.Name = "TabList"
    tabList.Size = UDim2.new(1, 0, 1, 0)
    tabList.BackgroundTransparency = 1
    tabList.ZIndex = 4
    tabList.Parent = tabBar

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.FillDirection = Enum.FillDirection.Vertical
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 2)
    tabListLayout.Parent = tabList
    makePadding(tabList, 8, 6, 8, 6)

    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Position = UDim2.new(0, 110, 0, 44)
    contentArea.Size = UDim2.new(1, -110, 1, -44)
    contentArea.BackgroundColor3 = Theme.Background
    contentArea.BorderSizePixel = 0
    contentArea.ClipsDescendants = true
    contentArea.ZIndex = 2
    contentArea.Parent = window
    self._contentArea = contentArea

    self._tabList = tabList

    local dragging = false
    local dragInput, dragStart, startPos

    local function updateDrag(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        tween(window, TweenInfo.new(0.04, Enum.EasingStyle.Linear), {Position = newPos})
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)

    local mobileToggle
    if isMobile() then
        mobileToggle = Instance.new("TextButton")
        mobileToggle.Name = "MobileToggle"
        mobileToggle.AnchorPoint = Vector2.new(0, 1)
        mobileToggle.Position = UDim2.new(0, 12, 1, -12)
        mobileToggle.Size = UDim2.new(0, 52, 0, 52)
        mobileToggle.BackgroundColor3 = Theme.Surface
        mobileToggle.BorderSizePixel = 0
        mobileToggle.Text = "☰"
        mobileToggle.TextColor3 = Theme.Text
        mobileToggle.TextSize = 22
        mobileToggle.Font = Enum.Font.GothamBold
        mobileToggle.ZIndex = 150
        makeRound(mobileToggle, 14)
        makeStroke(mobileToggle, Theme.Border, 1)
        makeShadow(mobileToggle, 0.4)
        mobileToggle.Parent = screenGui

        mobileToggle.MouseButton1Click:Connect(function()
            self.Visible = not self.Visible
            if self.Visible then
                window.Visible = true
                window.BackgroundTransparency = 1
                tween(window, Tweens.Spring, {BackgroundTransparency = 0})
            else
                tween(window, Tweens.Medium, {BackgroundTransparency = 1})
                task.delay(0.3, function()
                    window.Visible = false
                end)
            end
        end)
    end

    local conn = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == self.ToggleKey then
            self.Visible = not self.Visible
            if self.Visible then
                window.Visible = true
                tween(window, Tweens.Spring, {BackgroundTransparency = 0, Size = fullSize})
            else
                tween(window, Tweens.Medium, {BackgroundTransparency = 1})
                task.delay(0.3, function()
                    window.Visible = false
                end)
            end
        end
    end)
    table.insert(self._connections, conn)

    window.BackgroundTransparency = 1
    window.Size = UDim2.new(0, windowWidth, 0, 0)

    local function finishLoad()
        tween(window, Tweens.Spring, {
            BackgroundTransparency = 0,
            Size = UDim2.new(0, windowWidth, 0, windowHeight)
        })
    end

    task.spawn(function()
        showLoadingScreen(screenGui, finishLoad)
    end)

    self.Notification = function(title, msg, dur, t)
        showNotification(title, msg, dur, t)
    end

    return self
end

function LawXW:AddTab(opts)
    opts = opts or {}
    local name = opts.Name or ("Tab " .. (#self.Tabs + 1))
    local icon = opts.Icon or ""

    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = "Tab_" .. name
    tabBtn.Size = UDim2.new(1, 0, 0, isMobile() and 38 or 32)
    tabBtn.BackgroundColor3 = Theme.Background
    tabBtn.BackgroundTransparency = 1
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = (icon ~= "" and icon .. "  " or "") .. name
    tabBtn.TextColor3 = Theme.TextSub
    tabBtn.TextSize = isMobile() and 13 or 12
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.ZIndex = 5
    tabBtn.LayoutOrder = #self.Tabs + 1
    makePadding(tabBtn, 0, 0, 0, 8)
    makeRound(tabBtn, 6)
    tabBtn.Parent = self._tabList

    local tabIndicator = Instance.new("Frame")
    tabIndicator.Name = "Indicator"
    tabIndicator.Size = UDim2.new(0, 3, 0.6, 0)
    tabIndicator.AnchorPoint = Vector2.new(0, 0.5)
    tabIndicator.Position = UDim2.new(0, -6, 0.5, 0)
    tabIndicator.BackgroundColor3 = Theme.Accent
    tabIndicator.BorderSizePixel = 0
    tabIndicator.BackgroundTransparency = 1
    makeRound(tabIndicator, 2)
    tabIndicator.Parent = tabBtn

    local content = Instance.new("ScrollingFrame")
    content.Name = "Content_" .. name
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = Theme.Border
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Visible = false
    content.ZIndex = 3
    content.Parent = self._contentArea

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.FillDirection = Enum.FillDirection.Vertical
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 6)
    contentLayout.Parent = content
    makePadding(content, 10, 10, 10, 10)

    local tab = {
        Name       = name,
        _btn       = tabBtn,
        _indicator = tabIndicator,
        _content   = content,
        _layout    = contentLayout,
        _sections  = {},
        _order     = 0,
    }

    tabBtn.MouseButton1Click:Connect(function()
        self:_selectTab(tab)
    end)

    tabBtn.MouseEnter:Connect(function()
        if self.ActiveTab ~= tab then
            tween(tabBtn, Tweens.Fast, {BackgroundTransparency = 0.7, TextColor3 = Theme.AccentDim})
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if self.ActiveTab ~= tab then
            tween(tabBtn, Tweens.Fast, {BackgroundTransparency = 1, TextColor3 = Theme.TextSub})
        end
    end)

    table.insert(self.Tabs, tab)

    if #self.Tabs == 1 then
        self:_selectTab(tab)
    end

    local tabApi = {}

    function tabApi:AddSection(sectionOpts)
        sectionOpts = sectionOpts or {}
        local sName = sectionOpts.Name

        local sectionFrame = Instance.new("Frame")
        sectionFrame.Name = "Section"
        sectionFrame.Size = UDim2.new(1, 0, 0, 0)
        sectionFrame.BackgroundColor3 = Theme.Surface
        sectionFrame.BorderSizePixel = 0
        sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
        sectionFrame.LayoutOrder = tab._order
        tab._order = tab._order + 1
        makeRound(sectionFrame, 8)
        makeStroke(sectionFrame, Theme.Border, 1)
        sectionFrame.Parent = content

        local innerPad = makePadding(sectionFrame, 10, 10, 10, 10)

        local sectionLayout = Instance.new("UIListLayout")
        sectionLayout.FillDirection = Enum.FillDirection.Vertical
        sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
        sectionLayout.Padding = UDim.new(0, 6)
        sectionLayout.Parent = sectionFrame

        local headerOffset = 0
        if sName then
            local sHeader = Instance.new("TextLabel")
            sHeader.Size = UDim2.new(1, 0, 0, 18)
            sHeader.BackgroundTransparency = 1
            sHeader.Text = sName:upper()
            sHeader.TextColor3 = Theme.TextMuted
            sHeader.TextSize = 10
            sHeader.Font = Enum.Font.GothamBold
            sHeader.TextXAlignment = Enum.TextXAlignment.Left
            sHeader.LayoutOrder = -1
            sHeader.ZIndex = 3
            sHeader.Parent = sectionFrame

            local sep = Instance.new("Frame")
            sep.Size = UDim2.new(1, 0, 0, 1)
            sep.BackgroundColor3 = Theme.Border
            sep.BorderSizePixel = 0
            sep.LayoutOrder = 0
            sep.ZIndex = 3
            sep.Parent = sectionFrame
        end

        local sectionRef = {_frame = sectionFrame, _order = 100}

        local function nextOrder()
            sectionRef._order = sectionRef._order + 1
            return sectionRef._order
        end

        local sectionApi = {}

        function sectionApi:AddButton(bOpts)
            bOpts = bOpts or {}
            local bName     = bOpts.Name or "Button"
            local bDesc     = bOpts.Description
            local bCallback = bOpts.Callback or function() end

            local btnFrame = Instance.new("TextButton")
            btnFrame.Name = "Button_" .. bName
            btnFrame.Size = UDim2.new(1, 0, 0, isMobile() and 44 or 36)
            btnFrame.BackgroundColor3 = Theme.SurfaceAlt
            btnFrame.BorderSizePixel = 0
            btnFrame.Text = ""
            btnFrame.LayoutOrder = nextOrder()
            btnFrame.ZIndex = 3
            makeRound(btnFrame, 6)
            btnFrame.Parent = sectionFrame

            local btnLabel = makeLabel(btnFrame, bName, 13, Theme.Text, 4)
            btnLabel.Size = UDim2.new(1, -16, 1, 0)
            btnLabel.Position = UDim2.new(0, 12, 0, 0)
            btnLabel.TextXAlignment = Enum.TextXAlignment.Left

            if bDesc then
                btnLabel.Size = UDim2.new(1, -16, 0, 18)
                btnLabel.Position = UDim2.new(0, 12, 0, 4)
                local descLabel = makeLabel(btnFrame, bDesc, 11, Theme.TextSub, 4)
                descLabel.Size = UDim2.new(1, -16, 0, 14)
                descLabel.Position = UDim2.new(0, 12, 0, 22)
            end

            local arrowLabel = makeLabel(btnFrame, "›", 18, Theme.TextMuted, 4)
            arrowLabel.AnchorPoint = Vector2.new(1, 0.5)
            arrowLabel.Position = UDim2.new(1, -10, 0.5, 0)
            arrowLabel.Size = UDim2.new(0, 16, 0, 20)
            arrowLabel.TextXAlignment = Enum.TextXAlignment.Center

            btnFrame.MouseEnter:Connect(function()
                tween(btnFrame, Tweens.Fast, {BackgroundColor3 = Theme.Hover})
                tween(arrowLabel, Tweens.Fast, {TextColor3 = Theme.Text})
            end)
            btnFrame.MouseLeave:Connect(function()
                tween(btnFrame, Tweens.Fast, {BackgroundColor3 = Theme.SurfaceAlt})
                tween(arrowLabel, Tweens.Fast, {TextColor3 = Theme.TextMuted})
            end)
            btnFrame.MouseButton1Down:Connect(function()
                tween(btnFrame, Tweens.Fast, {BackgroundColor3 = Theme.Selected})
            end)
            btnFrame.MouseButton1Up:Connect(function()
                tween(btnFrame, Tweens.Fast, {BackgroundColor3 = Theme.Hover})
                task.spawn(bCallback)
            end)

            return btnFrame
        end

        function sectionApi:AddToggle(tOpts)
            tOpts = tOpts or {}
            local tName     = tOpts.Name or "Toggle"
            local tDefault  = tOpts.Default or false
            local tFlag     = tOpts.Flag
            local tCallback = tOpts.Callback or function() end

            local state = tFlag and getConfig(tFlag, tDefault) or tDefault

            local rowFrame = Instance.new("Frame")
            rowFrame.Name = "Toggle_" .. tName
            rowFrame.Size = UDim2.new(1, 0, 0, isMobile() and 44 or 36)
            rowFrame.BackgroundColor3 = Theme.SurfaceAlt
            rowFrame.BorderSizePixel = 0
            rowFrame.LayoutOrder = nextOrder()
            rowFrame.ZIndex = 3
            makeRound(rowFrame, 6)
            rowFrame.Parent = sectionFrame

            local rowLabel = makeLabel(rowFrame, tName, 13, Theme.Text, 4)
            rowLabel.Size = UDim2.new(1, -70, 1, 0)
            rowLabel.Position = UDim2.new(0, 12, 0, 0)

            local pill = Instance.new("Frame")
            pill.Name = "Pill"
            pill.AnchorPoint = Vector2.new(1, 0.5)
            pill.Position = UDim2.new(1, -12, 0.5, 0)
            pill.Size = UDim2.new(0, 40, 0, 22)
            pill.BackgroundColor3 = state and Theme.Toggle_On or Theme.Toggle_Off
            pill.BorderSizePixel = 0
            pill.ZIndex = 4
            makeRound(pill, 11)
            makeStroke(pill, Theme.Border, 1)
            pill.Parent = rowFrame

            local knob = Instance.new("Frame")
            knob.Name = "Knob"
            knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.Position = state and UDim2.new(1, -12, 0.5, 0) or UDim2.new(0, 12, 0.5, 0)
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.BackgroundColor3 = Theme.Text
            knob.BorderSizePixel = 0
            knob.ZIndex = 5
            makeRound(knob, 8)
            knob.Parent = pill

            local function updateVisual(s)
                tween(pill, Tweens.Medium, {BackgroundColor3 = s and Theme.Toggle_On or Theme.Toggle_Off})
                tween(knob, Tweens.Spring, {
                    Position = s and UDim2.new(1, -12, 0.5, 0) or UDim2.new(0, 12, 0.5, 0),
                    BackgroundColor3 = s and Theme.Background or Theme.Text
                })
                tween(pill, Tweens.Medium, {BackgroundColor3 = s and Theme.Toggle_On or Theme.Toggle_Off})
            end

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.ZIndex = 6
            btn.Parent = rowFrame

            btn.MouseButton1Click:Connect(function()
                state = not state
                updateVisual(state)
                if tFlag then saveConfig(tFlag, state) end
                task.spawn(tCallback, state)
            end)

            btn.MouseEnter:Connect(function()
                tween(rowFrame, Tweens.Fast, {BackgroundColor3 = Theme.Hover})
            end)
            btn.MouseLeave:Connect(function()
                tween(rowFrame, Tweens.Fast, {BackgroundColor3 = Theme.SurfaceAlt})
            end)

            local toggleApi = {}
            function toggleApi:Set(value)
                state = value
                updateVisual(state)
                if tFlag then saveConfig(tFlag, state) end
                task.spawn(tCallback, state)
            end
            function toggleApi:Get() return state end

            if tFlag then
                tab._sections[tFlag] = toggleApi
            end
            return toggleApi
        end

        function sectionApi:AddSlider(sOpts)
            sOpts = sOpts or {}
            local sName     = sOpts.Name or "Slider"
            local sMin      = sOpts.Min or 0
            local sMax      = sOpts.Max or 100
            local sDefault  = sOpts.Default or sMin
            local sFlag     = sOpts.Flag
            local sSuffix   = sOpts.Suffix or ""
            local sCallback = sOpts.Callback or function() end
            local sDec      = sOpts.Decimals or 0

            local value = sFlag and getConfig(sFlag, sDefault) or sDefault
            value = math.clamp(value, sMin, sMax)

            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = "Slider_" .. sName
            sliderFrame.Size = UDim2.new(1, 0, 0, isMobile() and 56 or 48)
            sliderFrame.BackgroundColor3 = Theme.SurfaceAlt
            sliderFrame.BorderSizePixel = 0
            sliderFrame.LayoutOrder = nextOrder()
            sliderFrame.ZIndex = 3
            makeRound(sliderFrame, 6)
            sliderFrame.Parent = sectionFrame

            local topRow = Instance.new("Frame")
            topRow.Size = UDim2.new(1, 0, 0, 22)
            topRow.Position = UDim2.new(0, 0, 0, 0)
            topRow.BackgroundTransparency = 1
            topRow.ZIndex = 4
            topRow.Parent = sliderFrame

            local sliderNameLabel = makeLabel(topRow, sName, 13, Theme.Text, 4)
            sliderNameLabel.Size = UDim2.new(1, -70, 1, 0)
            sliderNameLabel.Position = UDim2.new(0, 12, 0, 0)

            local valueDisplay = Instance.new("Frame")
            valueDisplay.AnchorPoint = Vector2.new(1, 0.5)
            valueDisplay.Position = UDim2.new(1, -12, 0.5, 0)
            valueDisplay.Size = UDim2.new(0, 56, 0, 20)
            valueDisplay.BackgroundColor3 = Theme.Background
            valueDisplay.BorderSizePixel = 0
            valueDisplay.ZIndex = 4
            makeRound(valueDisplay, 4)
            valueDisplay.Parent = topRow

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(1, 0, 1, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.TextColor3 = Theme.AccentDim
            valueLabel.TextSize = 12
            valueLabel.Font = Enum.Font.GothamMedium
            valueLabel.ZIndex = 5
            valueLabel.Parent = valueDisplay

            local trackContainer = Instance.new("Frame")
            trackContainer.Size = UDim2.new(1, -24, 0, 6)
            trackContainer.Position = UDim2.new(0, 12, 0, 30)
            trackContainer.BackgroundColor3 = Theme.SliderTrack
            trackContainer.BorderSizePixel = 0
            trackContainer.ZIndex = 4
            makeRound(trackContainer, 3)
            trackContainer.Parent = sliderFrame

            local fillBar = Instance.new("Frame")
            fillBar.Name = "Fill"
            fillBar.Size = UDim2.new(0, 0, 1, 0)
            fillBar.BackgroundColor3 = Theme.SliderFill
            fillBar.BorderSizePixel = 0
            fillBar.ZIndex = 5
            makeRound(fillBar, 3)
            fillBar.Parent = trackContainer

            local handle = Instance.new("Frame")
            handle.Name = "Handle"
            handle.AnchorPoint = Vector2.new(0.5, 0.5)
            handle.Position = UDim2.new(0, 0, 0.5, 0)
            handle.Size = UDim2.new(0, isMobile() and 18 or 14, 0, isMobile() and 18 or 14)
            handle.BackgroundColor3 = Theme.Accent
            handle.BorderSizePixel = 0
            handle.ZIndex = 6
            makeRound(handle, isMobile() and 9 or 7)
            makeStroke(handle, Theme.Background, 2)
            handle.Parent = trackContainer

            local function formatValue(v)
                if sDec == 0 then
                    return tostring(math.round(v)) .. sSuffix
                else
                    return string.format("%." .. sDec .. "f", v) .. sSuffix
                end
            end

            local function setSliderValue(v, animate)
                v = math.clamp(v, sMin, sMax)
                if sDec == 0 then v = math.round(v) end
                value = v
                local pct = (v - sMin) / (sMax - sMin)
                valueLabel.Text = formatValue(v)
                if animate then
                    tween(fillBar, Tweens.Fast, {Size = UDim2.new(pct, 0, 1, 0)})
                    tween(handle, Tweens.Fast, {Position = UDim2.new(pct, 0, 0.5, 0)})
                else
                    fillBar.Size = UDim2.new(pct, 0, 1, 0)
                    handle.Position = UDim2.new(pct, 0, 0.5, 0)
                end
            end

            setSliderValue(value, false)

            local draggingSlider = false

            local function onSliderInput(input)
                local rel = input.Position.X - trackContainer.AbsolutePosition.X
                local width = trackContainer.AbsoluteSize.X
                local pct = math.clamp(rel / width, 0, 1)
                local newVal = sMin + pct * (sMax - sMin)
                if sDec == 0 then newVal = math.round(newVal) end
                if newVal ~= value then
                    setSliderValue(newVal, false)
                    if sFlag then saveConfig(sFlag, newVal) end
                    task.spawn(sCallback, newVal)
                end
            end

            trackContainer.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                    onSliderInput(input)
                end
            end)

            handle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider then
                    if input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch then
                        onSliderInput(input)
                    end
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = false
                end
            end)

            sliderFrame.MouseEnter:Connect(function()
                tween(sliderFrame, Tweens.Fast, {BackgroundColor3 = Theme.Hover})
                tween(handle, Tweens.Fast, {Size = UDim2.new(0, (isMobile() and 20 or 16), 0, (isMobile() and 20 or 16))})
            end)
            sliderFrame.MouseLeave:Connect(function()
                if not draggingSlider then
                    tween(sliderFrame, Tweens.Fast, {BackgroundColor3 = Theme.SurfaceAlt})
                    tween(handle, Tweens.Fast, {Size = UDim2.new(0, (isMobile() and 18 or 14), 0, (isMobile() and 18 or 14))})
                end
            end)

            local sliderApi = {}
            function sliderApi:Set(v)
                setSliderValue(v, true)
                if sFlag then saveConfig(sFlag, v) end
                task.spawn(sCallback, v)
            end
            function sliderApi:Get() return value end

            if sFlag then
                tab._sections[sFlag] = sliderApi
            end
            return sliderApi
        end

        function sectionApi:AddDropdown(dOpts)
            dOpts = dOpts or {}
            local dName     = dOpts.Name or "Dropdown"
            local dOptions  = dOpts.Options or {}
            local dDefault  = dOpts.Default or (dOptions[1] or "")
            local dFlag     = dOpts.Flag
            local dCallback = dOpts.Callback or function() end
            local dMulti    = dOpts.Multi or false

            local selected = dFlag and getConfig(dFlag, dDefault) or dDefault
            local isOpen = false
            local MAX_VISIBLE = 5
            local ITEM_H = isMobile() and 38 or 32

            local dropFrame = Instance.new("Frame")
            dropFrame.Name = "Dropdown_" .. dName
            dropFrame.Size = UDim2.new(1, 0, 0, isMobile() and 44 or 36)
            dropFrame.BackgroundColor3 = Theme.SurfaceAlt
            dropFrame.BorderSizePixel = 0
            dropFrame.LayoutOrder = nextOrder()
            dropFrame.ZIndex = 10
            dropFrame.ClipsDescendants = false
            makeRound(dropFrame, 6)
            dropFrame.Parent = sectionFrame

            local headerBtn = Instance.new("TextButton")
            headerBtn.Size = UDim2.new(1, 0, 0, isMobile() and 44 or 36)
            headerBtn.BackgroundTransparency = 1
            headerBtn.Text = ""
            headerBtn.ZIndex = 11
            headerBtn.Parent = dropFrame

            local selLabel = makeLabel(dropFrame, tostring(selected), 13, Theme.Text, 11)
            selLabel.Size = UDim2.new(1, -40, 1, 0)
            selLabel.Position = UDim2.new(0, 12, 0, 0)
            selLabel.TextTruncate = Enum.TextTruncate.AtEnd

            local dNameLabel = makeLabel(dropFrame, dName, 10, Theme.TextMuted, 11)
            dNameLabel.Size = UDim2.new(1, -12, 0, 12)
            dNameLabel.Position = UDim2.new(0, 12, 0, 4)
            selLabel.Position = UDim2.new(0, 12, 0, 16)
            selLabel.Size = UDim2.new(1, -40, 0, 18)
            if dOpts.Name then
                dropFrame.Size = UDim2.new(1, 0, 0, isMobile() and 52 or 44)
                headerBtn.Size = UDim2.new(1, 0, 0, isMobile() and 52 or 44)
            else
                dNameLabel.Visible = false
                selLabel.Position = UDim2.new(0, 12, 0, 0)
                selLabel.Size = UDim2.new(1, -40, 1, 0)
            end

            local arrowIcon = makeLabel(dropFrame, "▾", 14, Theme.TextSub, 11)
            arrowIcon.AnchorPoint = Vector2.new(1, 0.5)
            arrowIcon.Position = UDim2.new(1, -12, 0.5, 0)
            arrowIcon.Size = UDim2.new(0, 16, 0, 16)
            arrowIcon.TextXAlignment = Enum.TextXAlignment.Center

            local dropList = Instance.new("Frame")
            dropList.Name = "DropList"
            dropList.Position = UDim2.new(0, 0, 1, 4)
            dropList.Size = UDim2.new(1, 0, 0, 0)
            dropList.BackgroundColor3 = Theme.Surface
            dropList.BorderSizePixel = 0
            dropList.ClipsDescendants = true
            dropList.ZIndex = 20
            makeRound(dropList, 8)
            makeStroke(dropList, Theme.Border, 1)
            makeShadow(dropList, 0.4)
            dropList.Parent = dropFrame

            local dropScroll = Instance.new("ScrollingFrame")
            dropScroll.Size = UDim2.new(1, 0, 1, 0)
            dropScroll.BackgroundTransparency = 1
            dropScroll.BorderSizePixel = 0
            dropScroll.ScrollBarThickness = 3
            dropScroll.ScrollBarImageColor3 = Theme.Border
            dropScroll.CanvasSize = UDim2.new(0, 0, 0, #dOptions * ITEM_H)
            dropScroll.ZIndex = 21
            dropScroll.Parent = dropList

            local listLayout = Instance.new("UIListLayout")
            listLayout.FillDirection = Enum.FillDirection.Vertical
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            listLayout.Parent = dropScroll

            local optionBtns = {}
            for i, opt in ipairs(dOptions) do
                local optBtn = Instance.new("TextButton")
                optBtn.Name = "Opt_" .. tostring(opt)
                optBtn.Size = UDim2.new(1, 0, 0, ITEM_H)
                optBtn.BackgroundColor3 = Theme.Surface
                optBtn.BackgroundTransparency = (tostring(opt) == tostring(selected)) and 0.7 or 1
                optBtn.BorderSizePixel = 0
                optBtn.Text = ""
                optBtn.LayoutOrder = i
                optBtn.ZIndex = 22
                optBtn.Parent = dropScroll

                local optLabel = makeLabel(optBtn, tostring(opt), 12, Theme.Text, 23)
                optLabel.Size = UDim2.new(1, -32, 1, 0)
                optLabel.Position = UDim2.new(0, 12, 0, 0)

                local checkIcon = makeLabel(optBtn, "✓", 12, Theme.AccentDim, 23)
                checkIcon.AnchorPoint = Vector2.new(1, 0.5)
                checkIcon.Position = UDim2.new(1, -10, 0.5, 0)
                checkIcon.Size = UDim2.new(0, 14, 0, 14)
                checkIcon.TextXAlignment = Enum.TextXAlignment.Center
                checkIcon.Visible = tostring(opt) == tostring(selected)

                optBtn.MouseEnter:Connect(function()
                    tween(optBtn, Tweens.Fast, {BackgroundColor3 = Theme.Hover, BackgroundTransparency = 0})
                end)
                optBtn.MouseLeave:Connect(function()
                    local isSel = tostring(opt) == tostring(selected)
                    tween(optBtn, Tweens.Fast, {
                        BackgroundColor3 = Theme.Surface,
                        BackgroundTransparency = isSel and 0.7 or 1
                    })
                end)
                optBtn.MouseButton1Click:Connect(function()
                    local prev = selected
                    selected = opt
                    selLabel.Text = tostring(opt)

                    for _, b in ipairs(optionBtns) do
                        local bOpt = b._opt
                        local bCheck = b._check
                        local isSel2 = tostring(bOpt) == tostring(selected)
                        bCheck.Visible = isSel2
                        tween(b._btn, Tweens.Fast, {
                            BackgroundColor3 = Theme.Surface,
                            BackgroundTransparency = isSel2 and 0.7 or 1
                        })
                    end

                    if dFlag then saveConfig(dFlag, selected) end
                    task.spawn(dCallback, selected)

                    isOpen = false
                    tween(dropList, Tweens.Smooth, {Size = UDim2.new(1, 0, 0, 0)})
                    tween(arrowIcon, Tweens.Fast, {Rotation = 0, TextColor3 = Theme.TextSub})
                end)

                table.insert(optionBtns, {_btn = optBtn, _opt = opt, _check = checkIcon})
            end

            local targetH = math.min(#dOptions, MAX_VISIBLE) * ITEM_H
            headerBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    tween(dropList, Tweens.Smooth, {Size = UDim2.new(1, 0, 0, targetH)})
                    tween(arrowIcon, Tweens.Fast, {Rotation = 180, TextColor3 = Theme.Text})
                else
                    tween(dropList, Tweens.Smooth, {Size = UDim2.new(1, 0, 0, 0)})
                    tween(arrowIcon, Tweens.Fast, {Rotation = 0, TextColor3 = Theme.TextSub})
                end
            end)

            headerBtn.MouseEnter:Connect(function()
                tween(dropFrame, Tweens.Fast, {BackgroundColor3 = Theme.Hover})
            end)
            headerBtn.MouseLeave:Connect(function()
                tween(dropFrame, Tweens.Fast, {BackgroundColor3 = Theme.SurfaceAlt})
            end)

            local dropApi = {}
            function dropApi:Set(val)
                selected = val
                selLabel.Text = tostring(val)
                for _, b in ipairs(optionBtns) do
                    b._check.Visible = tostring(b._opt) == tostring(val)
                    b._btn.BackgroundTransparency = tostring(b._opt) == tostring(val) and 0.7 or 1
                end
                if dFlag then saveConfig(dFlag, val) end
                task.spawn(dCallback, val)
            end
            function dropApi:Get() return selected end
            function dropApi:Refresh(newOptions)
                for _, b in ipairs(optionBtns) do b._btn:Destroy() end
                optionBtns = {}
                dOptions = newOptions
                dropScroll.CanvasSize = UDim2.new(0, 0, 0, #dOptions * ITEM_H)
                for i, opt in ipairs(dOptions) do
                    local ob = Instance.new("TextButton")
                    ob.Size = UDim2.new(1, 0, 0, ITEM_H)
                    ob.BackgroundColor3 = Theme.Surface
                    ob.BackgroundTransparency = 1
                    ob.BorderSizePixel = 0
                    ob.Text = ""
                    ob.LayoutOrder = i
                    ob.ZIndex = 22
                    ob.Parent = dropScroll
                    local ol = makeLabel(ob, tostring(opt), 12, Theme.Text, 23)
                    ol.Size = UDim2.new(1, -32, 1, 0)
                    ol.Position = UDim2.new(0, 12, 0, 0)
                    local oc = makeLabel(ob, "✓", 12, Theme.AccentDim, 23)
                    oc.AnchorPoint = Vector2.new(1, 0.5)
                    oc.Position = UDim2.new(1, -10, 0.5, 0)
                    oc.Size = UDim2.new(0, 14, 0, 14)
                    oc.TextXAlignment = Enum.TextXAlignment.Center
                    oc.Visible = false
                    ob.MouseEnter:Connect(function() tween(ob, Tweens.Fast, {BackgroundColor3 = Theme.Hover, BackgroundTransparency = 0}) end)
                    ob.MouseLeave:Connect(function() tween(ob, Tweens.Fast, {BackgroundColor3 = Theme.Surface, BackgroundTransparency = 1}) end)
                    ob.MouseButton1Click:Connect(function()
                        selected = opt
                        selLabel.Text = tostring(opt)
                        for _, b2 in ipairs(optionBtns) do
                            b2._check.Visible = tostring(b2._opt) == tostring(opt)
                            tween(b2._btn, Tweens.Fast, {BackgroundTransparency = tostring(b2._opt) == tostring(opt) and 0.7 or 1})
                        end
                        isOpen = false
                        tween(dropList, Tweens.Smooth, {Size = UDim2.new(1, 0, 0, 0)})
                        tween(arrowIcon, Tweens.Fast, {Rotation = 0})
                        if dFlag then saveConfig(dFlag, opt) end
                        task.spawn(dCallback, opt)
                    end)
                    table.insert(optionBtns, {_btn = ob, _opt = opt, _check = oc})
                end
            end

            if dFlag then
                tab._sections[dFlag] = dropApi
            end
            return dropApi
        end

        function sectionApi:AddLabel(lOpts)
            lOpts = lOpts or {}
            local lText  = lOpts.Text or ""
            local lColor = lOpts.Color or Theme.TextSub

            local lbl = Instance.new("TextLabel")
            lbl.Name = "Label"
            lbl.Size = UDim2.new(1, 0, 0, isMobile() and 36 or 28)
            lbl.BackgroundTransparency = 1
            lbl.Text = lText
            lbl.TextColor3 = lColor
            lbl.TextSize = 12
            lbl.Font = Enum.Font.Gotham
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextWrapped = true
            lbl.ZIndex = 3
            lbl.LayoutOrder = nextOrder()
            makePadding(lbl, 0, 0, 0, 12)
            lbl.Parent = sectionFrame

            local lblApi = {}
            function lblApi:Set(t) lbl.Text = t end
            function lblApi:SetColor(c) lbl.TextColor3 = c end
            return lblApi
        end

        function sectionApi:AddSeparator()
            local sep = Instance.new("Frame")
            sep.Size = UDim2.new(1, 0, 0, 1)
            sep.BackgroundColor3 = Theme.Border
            sep.BorderSizePixel = 0
            sep.ZIndex = 3
            sep.LayoutOrder = nextOrder()
            sep.Parent = sectionFrame
        end

        return sectionApi
    end

    return tabApi
end

function LawXW:_selectTab(tab)
    if self.ActiveTab == tab then return end

    if self.ActiveTab then
        local prev = self.ActiveTab
        tween(prev._btn, Tweens.Fast, {BackgroundTransparency = 1, TextColor3 = Theme.TextSub})
        tween(prev._indicator, Tweens.Fast, {BackgroundTransparency = 1})
        prev._content.Visible = false
    end

    self.ActiveTab = tab
    tween(tab._btn, Tweens.Fast, {BackgroundTransparency = 0, TextColor3 = Theme.Text})
    tab._btn.BackgroundColor3 = Theme.Selected
    tween(tab._indicator, Tweens.Fast, {BackgroundTransparency = 0})
    tab._content.Visible = true
end

function LawXW:GetFlag(flag)
    for _, t in ipairs(self.Tabs) do
        if t._sections[flag] then
            return t._sections[flag]:Get()
        end
    end
    return getConfig(flag)
end

function LawXW:Notify(title, msg, dur, ntype)
    showNotification(title, msg, dur, ntype)
end

function LawXW:Destroy()
    for _, c in ipairs(self._connections) do
        c:Disconnect()
    end
    self._gui:Destroy()
end

return LawXW
