local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local COLORS = {
    Background = Color3.fromRGB(8, 8, 8),
    Surface = Color3.fromRGB(14, 14, 14),
    Elevated = Color3.fromRGB(20, 20, 20),
    Border = Color3.fromRGB(35, 35, 35),
    BorderLight = Color3.fromRGB(50, 50, 50),
    Text = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(150, 150, 150),
    TextDim = Color3.fromRGB(90, 90, 90),
    Accent = Color3.fromRGB(255, 255, 255),
    AccentDim = Color3.fromRGB(180, 180, 180),
    Toggle = Color3.fromRGB(40, 40, 40),
    ToggleOn = Color3.fromRGB(220, 220, 220),
    Slider = Color3.fromRGB(30, 30, 30),
    SliderFill = Color3.fromRGB(200, 200, 200),
    Notification = Color3.fromRGB(16, 16, 16),
    Hover = Color3.fromRGB(28, 28, 28),
    Active = Color3.fromRGB(22, 22, 22),
}

local TWEEN_INFO = {
    Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Linear = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
}

local function Tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function CreateCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function CreatePadding(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, top or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.PaddingLeft = UDim.new(0, left or 0)
    p.PaddingRight = UDim.new(0, right or 0)
    p.Parent = parent
    return p
end

local function CreateStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or COLORS.Border
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

local function CreateGradient(parent, color0, color1, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color0 or Color3.fromRGB(25, 25, 25)),
        ColorSequenceKeypoint.new(1, color1 or Color3.fromRGB(10, 10, 10)),
    })
    g.Rotation = rotation or 90
    g.Parent = parent
    return g
end

local function CreateLabel(parent, text, size, color, weight, xAlignment)
    local l = Instance.new("TextLabel")
    l.Text = text or ""
    l.TextSize = size or 13
    l.TextColor3 = color or COLORS.Text
    l.Font = weight or Enum.Font.GothamMedium
    l.BackgroundTransparency = 1
    l.TextXAlignment = xAlignment or Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

local function MakeDraggable(frame, handle)
    local dragging = false
    local dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local NotificationHolder

local function InitNotifications(screenGui)
    NotificationHolder = Instance.new("Frame")
    NotificationHolder.Name = "Notifications"
    NotificationHolder.BackgroundTransparency = 1
    NotificationHolder.Position = UDim2.new(1, -320, 1, -20)
    NotificationHolder.Size = UDim2.new(0, 300, 0, 0)
    NotificationHolder.AnchorPoint = Vector2.new(0, 1)
    NotificationHolder.Parent = screenGui

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.Parent = NotificationHolder
end

function Library:Notify(options)
    options = options or {}
    local title = options.Title or "Notification"
    local desc = options.Description or ""
    local duration = options.Duration or 4

    local notif = Instance.new("Frame")
    notif.Name = "Notification"
    notif.BackgroundColor3 = COLORS.Notification
    notif.Size = UDim2.new(1, 0, 0, 0)
    notif.ClipsDescendants = true
    notif.Parent = NotificationHolder
    CreateCorner(notif, 10)
    CreateStroke(notif, COLORS.BorderLight, 1)
    CreateGradient(notif, Color3.fromRGB(22, 22, 22), Color3.fromRGB(12, 12, 12))

    local inner = Instance.new("Frame")
    inner.BackgroundTransparency = 1
    inner.Size = UDim2.new(1, 0, 0, 70)
    inner.Parent = notif
    CreatePadding(inner, 12, 12, 14, 14)

    local bar = Instance.new("Frame")
    bar.Name = "Bar"
    bar.BackgroundColor3 = COLORS.AccentDim
    bar.Position = UDim2.new(0, 0, 0, 0)
    bar.Size = UDim2.new(0, 3, 1, 0)
    bar.Parent = inner
    CreateCorner(bar, 2)

    local textHolder = Instance.new("Frame")
    textHolder.BackgroundTransparency = 1
    textHolder.Position = UDim2.new(0, 12, 0, 0)
    textHolder.Size = UDim2.new(1, -12, 1, 0)
    textHolder.Parent = inner

    local tLabel = CreateLabel(textHolder, title, 13, COLORS.Text, Enum.Font.GothamBold)
    tLabel.Size = UDim2.new(1, 0, 0, 18)
    tLabel.Position = UDim2.new(0, 0, 0, 0)

    local dLabel = CreateLabel(textHolder, desc, 12, COLORS.TextMuted, Enum.Font.Gotham)
    dLabel.Size = UDim2.new(1, 0, 0, 34)
    dLabel.Position = UDim2.new(0, 0, 0, 20)
    dLabel.TextWrapped = true

    local progress = Instance.new("Frame")
    progress.BackgroundColor3 = COLORS.Border
    progress.Position = UDim2.new(0, 0, 1, -2)
    progress.Size = UDim2.new(1, 0, 0, 2)
    progress.Parent = notif

    local progressFill = Instance.new("Frame")
    progressFill.BackgroundColor3 = COLORS.AccentDim
    progressFill.Size = UDim2.new(1, 0, 1, 0)
    progressFill.Parent = progress
    CreateCorner(progressFill, 1)

    Tween(notif, TWEEN_INFO.Spring, {Size = UDim2.new(1, 0, 0, 72)})
    Tween(progressFill, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 1, 0)})

    task.delay(duration, function()
        Tween(notif, TWEEN_INFO.Medium, {Size = UDim2.new(1, 0, 0, 0)})
        task.wait(0.3)
        notif:Destroy()
    end)
end

function Library:CreateWindow(options)
    options = options or {}
    local title = options.Title or "Library"

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LawLibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true

    local ok = pcall(function()
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end)
    if not ok then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    InitNotifications(ScreenGui)

    local WindowFrame = Instance.new("Frame")
    WindowFrame.Name = "Window"
    WindowFrame.BackgroundColor3 = COLORS.Background
    WindowFrame.Position = UDim2.new(0.5, -310, 0.5, -200)
    WindowFrame.Size = UDim2.new(0, 620, 0, 400)
    WindowFrame.ClipsDescendants = false
    WindowFrame.Parent = ScreenGui
    CreateCorner(WindowFrame, 12)
    CreateStroke(WindowFrame, COLORS.Border, 1)
    CreateGradient(WindowFrame, Color3.fromRGB(18, 18, 18), Color3.fromRGB(8, 8, 8))

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.4
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.ZIndex = -1
    Shadow.Parent = WindowFrame

    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = COLORS.Surface
    TitleBar.Size = UDim2.new(1, 0, 0, 48)
    TitleBar.Parent = WindowFrame
    CreateCorner(TitleBar, 12)
    CreateGradient(TitleBar, Color3.fromRGB(22, 22, 22), Color3.fromRGB(14, 14, 14))

    local TitleBarBottom = Instance.new("Frame")
    TitleBarBottom.BackgroundColor3 = COLORS.Surface
    TitleBarBottom.Position = UDim2.new(0, 0, 0.5, 0)
    TitleBarBottom.Size = UDim2.new(1, 0, 0.5, 0)
    TitleBarBottom.BorderSizePixel = 0
    TitleBarBottom.Parent = TitleBar

    local TitleSeparator = Instance.new("Frame")
    TitleSeparator.BackgroundColor3 = COLORS.Border
    TitleSeparator.Position = UDim2.new(0, 0, 1, 0)
    TitleSeparator.Size = UDim2.new(1, 0, 0, 1)
    TitleSeparator.Parent = TitleBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 18, 0, 0)
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Text = title
    TitleLabel.TextSize = 15
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = COLORS.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.BackgroundColor3 = COLORS.Elevated
    CloseBtn.Position = UDim2.new(1, -38, 0.5, -11)
    CloseBtn.Size = UDim2.new(0, 22, 0, 22)
    CloseBtn.Text = ""
    CloseBtn.Parent = TitleBar
    CreateCorner(CloseBtn, 6)
    CreateStroke(CloseBtn, COLORS.Border, 1)

    local CloseIcon = CreateLabel(CloseBtn, "✕", 11, COLORS.TextMuted, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    CloseIcon.Size = UDim2.new(1, 0, 1, 0)
    CloseIcon.TextYAlignment = Enum.TextYAlignment.Center

    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.BackgroundColor3 = COLORS.Surface
    TabBar.Position = UDim2.new(0, 0, 0, 48)
    TabBar.Size = UDim2.new(0, 140, 1, -48)
    TabBar.Parent = WindowFrame
    CreateGradient(TabBar, Color3.fromRGB(16, 16, 16), Color3.fromRGB(10, 10, 10))

    local TabBarRight = Instance.new("Frame")
    TabBarRight.BackgroundColor3 = COLORS.Border
    TabBarRight.Position = UDim2.new(1, 0, 0, 0)
    TabBarRight.Size = UDim2.new(0, 1, 1, 0)
    TabBarRight.Parent = TabBar

    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.BackgroundTransparency = 1
    TabList.Position = UDim2.new(0, 0, 0, 8)
    TabList.Size = UDim2.new(1, 0, 1, -16)
    TabList.ScrollBarThickness = 0
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.Parent = TabBar
    CreatePadding(TabList, 0, 0, 8, 8)

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.Parent = TabList

    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 16)
    end)

    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 141, 0, 48)
    ContentArea.Size = UDim2.new(1, -141, 1, -48)
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = WindowFrame

    MakeDraggable(WindowFrame, TitleBar)

    local WindowOpen = true
    local ActiveTab = nil
    local Tabs = {}

    local function AnimateTypewriter(label, text)
        task.spawn(function()
            while label and label.Parent do
                for i = 1, #text do
                    if not (label and label.Parent) then return end
                    label.Text = string.sub(text, 1, i)
                    task.wait(0.07)
                end
                task.wait(1.2)
                for i = #text, 0, -1 do
                    if not (label and label.Parent) then return end
                    label.Text = string.sub(text, 1, i)
                    task.wait(0.04)
                end
                task.wait(0.4)
            end
        end)
    end

    AnimateTypewriter(TitleLabel, title)

    local function SetWindowVisible(visible)
        WindowOpen = visible
        if visible then
            WindowFrame.Visible = true
            WindowFrame.Size = UDim2.new(0, 620, 0, 0)
            Tween(WindowFrame, TWEEN_INFO.Spring, {Size = UDim2.new(0, 620, 0, 400)})
        else
            Tween(WindowFrame, TWEEN_INFO.Medium, {Size = UDim2.new(0, 620, 0, 0)})
            task.delay(0.3, function()
                if not WindowOpen then
                    WindowFrame.Visible = false
                end
            end)
        end
    end

    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, TWEEN_INFO.Fast, {BackgroundColor3 = Color3.fromRGB(50, 20, 20)})
        Tween(CloseIcon, TWEEN_INFO.Fast, {TextColor3 = Color3.fromRGB(220, 80, 80)})
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Elevated})
        Tween(CloseIcon, TWEEN_INFO.Fast, {TextColor3 = COLORS.TextMuted})
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        SetWindowVisible(false)
    end)

    if not IsMobile then
        UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.RightControl then
                SetWindowVisible(not WindowOpen)
            end
        end)
    else
        local MobileBtn = Instance.new("TextButton")
        MobileBtn.Name = "MobileToggle"
        MobileBtn.BackgroundColor3 = COLORS.Surface
        MobileBtn.Size = UDim2.new(0, 48, 0, 48)
        MobileBtn.Position = UDim2.new(0, 20, 0.5, -24)
        MobileBtn.Text = "☰"
        MobileBtn.TextSize = 20
        MobileBtn.Font = Enum.Font.GothamBold
        MobileBtn.TextColor3 = COLORS.Text
        MobileBtn.Parent = ScreenGui
        CreateCorner(MobileBtn, 12)
        CreateStroke(MobileBtn, COLORS.Border, 1)
        CreateGradient(MobileBtn, Color3.fromRGB(24, 24, 24), Color3.fromRGB(12, 12, 12))

        MakeDraggable(MobileBtn, MobileBtn)

        MobileBtn.MouseButton1Click:Connect(function()
            SetWindowVisible(not WindowOpen)
        end)
    end

    SetWindowVisible(true)
    WindowFrame.Size = UDim2.new(0, 620, 0, 0)
    Tween(WindowFrame, TWEEN_INFO.Spring, {Size = UDim2.new(0, 620, 0, 400)})

    local Window = {}

    function Window:CreateTab(tabName, tabIcon)
        local Tab = {}

        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName
        TabBtn.BackgroundColor3 = COLORS.Background
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 0, 34)
        TabBtn.Text = ""
        TabBtn.Parent = TabList
        CreateCorner(TabBtn, 7)

        local TabBtnHighlight = Instance.new("Frame")
        TabBtnHighlight.BackgroundColor3 = COLORS.Border
        TabBtnHighlight.Position = UDim2.new(0, 0, 0, 0)
        TabBtnHighlight.Size = UDim2.new(0, 2, 1, 0)
        TabBtnHighlight.BackgroundTransparency = 1
        TabBtnHighlight.Parent = TabBtn
        CreateCorner(TabBtnHighlight, 1)

        local TabBtnLabel = CreateLabel(TabBtn, tabName, 12, COLORS.TextMuted, Enum.Font.GothamMedium)
        TabBtnLabel.Size = UDim2.new(1, -14, 1, 0)
        TabBtnLabel.Position = UDim2.new(0, 12, 0, 0)

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.BackgroundTransparency = 1
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = COLORS.Border
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentArea
        CreatePadding(TabContent, 12, 12, 12, 12)

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.Parent = TabContent

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 24)
        end)

        local function SelectTab()
            if ActiveTab then
                ActiveTab.Content.Visible = false
                Tween(ActiveTab.Btn, TWEEN_INFO.Fast, {BackgroundTransparency = 1})
                Tween(ActiveTab.BtnLabel, TWEEN_INFO.Fast, {TextColor3 = COLORS.TextMuted})
                Tween(ActiveTab.Highlight, TWEEN_INFO.Fast, {BackgroundTransparency = 1})
            end
            ActiveTab = {Content = TabContent, Btn = TabBtn, BtnLabel = TabBtnLabel, Highlight = TabBtnHighlight}
            TabContent.Visible = true
            Tween(TabBtn, TWEEN_INFO.Fast, {BackgroundTransparency = 0, BackgroundColor3 = COLORS.Elevated})
            Tween(TabBtnLabel, TWEEN_INFO.Fast, {TextColor3 = COLORS.Text})
            Tween(TabBtnHighlight, TWEEN_INFO.Fast, {BackgroundTransparency = 0, BackgroundColor3 = COLORS.AccentDim})
        end

        TabBtn.MouseButton1Click:Connect(SelectTab)

        TabBtn.MouseEnter:Connect(function()
            if ActiveTab and ActiveTab.Btn == TabBtn then return end
            Tween(TabBtn, TWEEN_INFO.Fast, {BackgroundTransparency = 0.6, BackgroundColor3 = COLORS.Elevated})
            Tween(TabBtnLabel, TWEEN_INFO.Fast, {TextColor3 = COLORS.AccentDim})
        end)

        TabBtn.MouseLeave:Connect(function()
            if ActiveTab and ActiveTab.Btn == TabBtn then return end
            Tween(TabBtn, TWEEN_INFO.Fast, {BackgroundTransparency = 1})
            Tween(TabBtnLabel, TWEEN_INFO.Fast, {TextColor3 = COLORS.TextMuted})
        end)

        if not ActiveTab then
            SelectTab()
        end

        local ElementOrder = 0

        local function NextOrder()
            ElementOrder = ElementOrder + 1
            return ElementOrder
        end

        local function CreateElementBase(height)
            local el = Instance.new("Frame")
            el.BackgroundColor3 = COLORS.Surface
            el.Size = UDim2.new(1, 0, 0, height)
            el.LayoutOrder = NextOrder()
            el.Parent = TabContent
            CreateCorner(el, 8)
            CreateStroke(el, COLORS.Border, 1)
            CreateGradient(el, Color3.fromRGB(18, 18, 18), Color3.fromRGB(12, 12, 12))
            return el
        end

        function Tab:CreateSection(options)
            options = options or {}
            local name = options.Name or "Section"

            local sectionFrame = Instance.new("Frame")
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.Size = UDim2.new(1, 0, 0, 20)
            sectionFrame.LayoutOrder = NextOrder()
            sectionFrame.Parent = TabContent

            local sectionLine = Instance.new("Frame")
            sectionLine.BackgroundColor3 = COLORS.Border
            sectionLine.Position = UDim2.new(0, 0, 0.5, 0)
            sectionLine.Size = UDim2.new(1, 0, 0, 1)
            sectionLine.Parent = sectionFrame

            local sectionLabel = CreateLabel(sectionLine, name, 10, COLORS.TextDim, Enum.Font.GothamBold)
            sectionLabel.BackgroundColor3 = COLORS.Background
            sectionLabel.BackgroundTransparency = 0
            sectionLabel.Size = UDim2.new(0, 0, 0, 14)
            sectionLabel.AutomaticSize = Enum.AutomaticSize.X
            sectionLabel.Position = UDim2.new(0, 8, -0.5, 0)
            CreatePadding(sectionLabel, 0, 0, 6, 6)
        end

        function Tab:CreateButton(options)
            options = options or {}
            local name = options.Name or "Button"
            local callback = options.Callback or function() end

            local el = CreateElementBase(42)

            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.Size = UDim2.new(1, 0, 1, 0)
            inner.Parent = el
            CreatePadding(inner, 0, 0, 14, 14)

            local lbl = CreateLabel(inner, name, 13, COLORS.Text, Enum.Font.GothamMedium)
            lbl.Size = UDim2.new(1, -30, 1, 0)

            local arrow = CreateLabel(inner, "›", 18, COLORS.TextDim, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
            arrow.Size = UDim2.new(0, 20, 1, 0)
            arrow.Position = UDim2.new(1, -20, 0, 0)

            local btn = Instance.new("TextButton")
            btn.BackgroundTransparency = 1
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.Text = ""
            btn.Parent = el

            btn.MouseEnter:Connect(function()
                Tween(el, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Hover})
                Tween(arrow, TWEEN_INFO.Fast, {TextColor3 = COLORS.Text, Position = UDim2.new(1, -16, 0, 0)})
            end)
            btn.MouseLeave:Connect(function()
                Tween(el, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Surface})
                Tween(arrow, TWEEN_INFO.Fast, {TextColor3 = COLORS.TextDim, Position = UDim2.new(1, -20, 0, 0)})
            end)
            btn.MouseButton1Down:Connect(function()
                Tween(el, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Active})
            end)
            btn.MouseButton1Up:Connect(function()
                Tween(el, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Hover})
            end)
            btn.MouseButton1Click:Connect(function()
                task.spawn(callback)
            end)
        end

        function Tab:CreateToggle(options)
            options = options or {}
            local name = options.Name or "Toggle"
            local default = options.Default or false
            local callback = options.Callback or function() end

            local toggled = default
            local el = CreateElementBase(42)

            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.Size = UDim2.new(1, 0, 1, 0)
            inner.Parent = el
            CreatePadding(inner, 0, 0, 14, 14)

            local lbl = CreateLabel(inner, name, 13, COLORS.Text, Enum.Font.GothamMedium)
            lbl.Size = UDim2.new(1, -50, 1, 0)

            local toggleBg = Instance.new("Frame")
            toggleBg.BackgroundColor3 = toggled and COLORS.ToggleOn or COLORS.Toggle
            toggleBg.Position = UDim2.new(1, -42, 0.5, -10)
            toggleBg.Size = UDim2.new(0, 38, 0, 20)
            toggleBg.Parent = inner
            CreateCorner(toggleBg, 10)
            CreateStroke(toggleBg, COLORS.BorderLight, 1)

            local toggleCircle = Instance.new("Frame")
            toggleCircle.BackgroundColor3 = toggled and Color3.fromRGB(20, 20, 20) or COLORS.TextDim
            toggleCircle.Position = toggled and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            toggleCircle.Size = UDim2.new(0, 14, 0, 14)
            toggleCircle.Parent = toggleBg
            CreateCorner(toggleCircle, 7)

            local function UpdateToggle(state)
                toggled = state
                Tween(toggleBg, TWEEN_INFO.Fast, {BackgroundColor3 = toggled and COLORS.ToggleOn or COLORS.Toggle})
                Tween(toggleCircle, TWEEN_INFO.Fast, {
                    Position = toggled and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
                    BackgroundColor3 = toggled and Color3.fromRGB(20, 20, 20) or COLORS.TextDim
                })
                task.spawn(callback, toggled)
            end

            local btn = Instance.new("TextButton")
            btn.BackgroundTransparency = 1
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.Text = ""
            btn.Parent = el

            btn.MouseEnter:Connect(function()
                Tween(el, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Hover})
            end)
            btn.MouseLeave:Connect(function()
                Tween(el, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Surface})
            end)
            btn.MouseButton1Click:Connect(function()
                UpdateToggle(not toggled)
            end)

            if default then
                UpdateToggle(true)
            end

            local ToggleObj = {}
            function ToggleObj:Set(val)
                UpdateToggle(val)
            end
            function ToggleObj:Get()
                return toggled
            end
            return ToggleObj
        end

        function Tab:CreateSlider(options)
            options = options or {}
            local name = options.Name or "Slider"
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local callback = options.Callback or function() end
            local suffix = options.Suffix or ""

            local value = math.clamp(default, min, max)
            local el = CreateElementBase(56)

            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.Size = UDim2.new(1, 0, 1, 0)
            inner.Parent = el
            CreatePadding(inner, 10, 10, 14, 14)

            local topRow = Instance.new("Frame")
            topRow.BackgroundTransparency = 1
            topRow.Size = UDim2.new(1, 0, 0, 18)
            topRow.Parent = inner

            local lbl = CreateLabel(topRow, name, 13, COLORS.Text, Enum.Font.GothamMedium)
            lbl.Size = UDim2.new(1, -60, 1, 0)

            local valLabel = CreateLabel(topRow, tostring(value) .. suffix, 12, COLORS.TextMuted, Enum.Font.Gotham, Enum.TextXAlignment.Right)
            valLabel.Size = UDim2.new(0, 55, 1, 0)
            valLabel.Position = UDim2.new(1, -55, 0, 0)

            local track = Instance.new("Frame")
            track.BackgroundColor3 = COLORS.Slider
            track.Position = UDim2.new(0, 0, 1, -12)
            track.Size = UDim2.new(1, 0, 0, 5)
            track.Parent = inner
            CreateCorner(track, 3)
            CreateStroke(track, COLORS.Border, 1)

            local fill = Instance.new("Frame")
            fill.BackgroundColor3 = COLORS.SliderFill
            fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            fill.Parent = track
            CreateCorner(fill, 3)

            local thumb = Instance.new("Frame")
            thumb.BackgroundColor3 = COLORS.Text
            thumb.AnchorPoint = Vector2.new(0.5, 0.5)
            thumb.Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
            thumb.Size = UDim2.new(0, 13, 0, 13)
            thumb.Parent = track
            CreateCorner(thumb, 7)
            CreateStroke(thumb, COLORS.Border, 1)

            local gradient = Instance.new("UIGradient")
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180)),
            })
            gradient.Parent = fill

            local isDragging = false

            local function UpdateSlider(pct)
                pct = math.clamp(pct, 0, 1)
                value = math.round(min + (max - min) * pct)
                valLabel.Text = tostring(value) .. suffix
                Tween(fill, TWEEN_INFO.Linear, {Size = UDim2.new(pct, 0, 1, 0)})
                Tween(thumb, TWEEN_INFO.Linear, {Position = UDim2.new(pct, 0, 0.5, 0)})
                task.spawn(callback, value)
            end

            local trackBtn = Instance.new("TextButton")
            trackBtn.BackgroundTransparency = 1
            trackBtn.Size = UDim2.new(1, 0, 0, 20)
            trackBtn.Position = UDim2.new(0, 0, 1, -18)
            trackBtn.Text = ""
            trackBtn.Parent = inner

            trackBtn.MouseButton1Down:Connect(function()
                isDragging = true
                Tween(thumb, TWEEN_INFO.Fast, {Size = UDim2.new(0, 16, 0, 16)})
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if isDragging then
                        isDragging = false
                        Tween(thumb, TWEEN_INFO.Fast, {Size = UDim2.new(0, 13, 0, 13)})
                    end
                end
            end)

            RunService.RenderStepped:Connect(function()
                if isDragging then
                    local trackPos = track.AbsolutePosition.X
                    local trackSize = track.AbsoluteSize.X
                    local mouseX = UserInputService:GetMouseLocation().X
                    local pct = (mouseX - trackPos) / trackSize
                    UpdateSlider(pct)
                end
            end)

            UpdateSlider((value - min) / (max - min))

            local SliderObj = {}
            function SliderObj:Set(val)
                local pct = (math.clamp(val, min, max) - min) / (max - min)
                UpdateSlider(pct)
            end
            function SliderObj:Get()
                return value
            end
            return SliderObj
        end

        function Tab:CreateTextbox(options)
            options = options or {}
            local name = options.Name or "Textbox"
            local placeholder = options.Placeholder or "Enter text..."
            local default = options.Default or ""
            local callback = options.Callback or function() end

            local el = CreateElementBase(56)

            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.Size = UDim2.new(1, 0, 1, 0)
            inner.Parent = el
            CreatePadding(inner, 10, 10, 14, 14)

            local lbl = CreateLabel(inner, name, 13, COLORS.Text, Enum.Font.GothamMedium)
            lbl.Size = UDim2.new(1, 0, 0, 16)

            local inputBg = Instance.new("Frame")
            inputBg.BackgroundColor3 = COLORS.Background
            inputBg.Position = UDim2.new(0, 0, 1, -22)
            inputBg.Size = UDim2.new(1, 0, 0, 22)
            inputBg.Parent = inner
            CreateCorner(inputBg, 6)
            CreateStroke(inputBg, COLORS.Border, 1)

            local tb = Instance.new("TextBox")
            tb.BackgroundTransparency = 1
            tb.Size = UDim2.new(1, 0, 1, 0)
            tb.Text = default
            tb.PlaceholderText = placeholder
            tb.TextSize = 12
            tb.Font = Enum.Font.Gotham
            tb.TextColor3 = COLORS.Text
            tb.PlaceholderColor3 = COLORS.TextDim
            tb.TextXAlignment = Enum.TextXAlignment.Left
            tb.Parent = inputBg
            CreatePadding(tb, 0, 0, 8, 8)

            tb.Focused:Connect(function()
                Tween(inputBg, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Elevated})
                CreateStroke(inputBg, COLORS.BorderLight, 1)
            end)
            tb.FocusLost:Connect(function(enterPressed)
                Tween(inputBg, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Background})
                if enterPressed then
                    task.spawn(callback, tb.Text)
                end
            end)

            local TbObj = {}
            function TbObj:Set(val)
                tb.Text = val
            end
            function TbObj:Get()
                return tb.Text
            end
            return TbObj
        end

        function Tab:CreateKeybind(options)
            options = options or {}
            local name = options.Name or "Keybind"
            local default = options.Default or Enum.KeyCode.Unknown
            local callback = options.Callback or function() end

            local currentKey = default
            local listening = false

            local el = CreateElementBase(42)

            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.Size = UDim2.new(1, 0, 1, 0)
            inner.Parent = el
            CreatePadding(inner, 0, 0, 14, 14)

            local lbl = CreateLabel(inner, name, 13, COLORS.Text, Enum.Font.GothamMedium)
            lbl.Size = UDim2.new(1, -90, 1, 0)

            local keyBg = Instance.new("TextButton")
            keyBg.BackgroundColor3 = COLORS.Background
            keyBg.Position = UDim2.new(1, -82, 0.5, -12)
            keyBg.Size = UDim2.new(0, 78, 0, 24)
            keyBg.Text = ""
            keyBg.Parent = inner
            CreateCorner(keyBg, 6)
            CreateStroke(keyBg, COLORS.Border, 1)

            local keyLabel = CreateLabel(keyBg, currentKey.Name, 11, COLORS.TextMuted, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
            keyLabel.Size = UDim2.new(1, 0, 1, 0)
            keyLabel.TextYAlignment = Enum.TextYAlignment.Center

            keyBg.MouseButton1Click:Connect(function()
                listening = not listening
                if listening then
                    keyLabel.Text = "..."
                    Tween(keyBg, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Elevated})
                else
                    keyLabel.Text = currentKey.Name
                    Tween(keyBg, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Background})
                end
            end)

            UserInputService.InputBegan:Connect(function(input, gp)
                if gp then return end
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    currentKey = input.KeyCode
                    keyLabel.Text = currentKey.Name
                    Tween(keyBg, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Background})
                elseif not listening and input.KeyCode == currentKey then
                    task.spawn(callback, currentKey)
                end
            end)

            local KbObj = {}
            function KbObj:Set(key)
                currentKey = key
                keyLabel.Text = key.Name
            end
            function KbObj:Get()
                return currentKey
            end
            return KbObj
        end

        function Tab:CreateDropdown(options)
            options = options or {}
            local name = options.Name or "Dropdown"
            local items = options.Items or {}
            local default = options.Default or (items[1] or "")
            local callback = options.Callback or function() end

            local selected = default
            local isOpen = false

            local el = Instance.new("Frame")
            el.BackgroundColor3 = COLORS.Surface
            el.Size = UDim2.new(1, 0, 0, 42)
            el.LayoutOrder = NextOrder()
            el.ClipsDescendants = false
            el.ZIndex = 10
            el.Parent = TabContent
            CreateCorner(el, 8)
            CreateStroke(el, COLORS.Border, 1)
            CreateGradient(el, Color3.fromRGB(18, 18, 18), Color3.fromRGB(12, 12, 12))

            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.Size = UDim2.new(1, 0, 0, 42)
            inner.ZIndex = 10
            inner.Parent = el
            CreatePadding(inner, 0, 0, 14, 14)

            local lbl = CreateLabel(inner, name, 13, COLORS.Text, Enum.Font.GothamMedium)
            lbl.Size = UDim2.new(0.5, 0, 1, 0)
            lbl.ZIndex = 10

            local selectedLabel = CreateLabel(inner, selected, 12, COLORS.TextMuted, Enum.Font.Gotham, Enum.TextXAlignment.Right)
            selectedLabel.Size = UDim2.new(0.5, -22, 1, 0)
            selectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
            selectedLabel.ZIndex = 10

            local arrow = CreateLabel(inner, "⌄", 14, COLORS.TextDim, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
            arrow.Size = UDim2.new(0, 18, 1, 0)
            arrow.Position = UDim2.new(1, -18, 0, 0)
            arrow.ZIndex = 10

            local dropdown = Instance.new("Frame")
            dropdown.BackgroundColor3 = COLORS.Elevated
            dropdown.Position = UDim2.new(0, 0, 1, 4)
            dropdown.Size = UDim2.new(1, 0, 0, 0)
            dropdown.ClipsDescendants = true
            dropdown.ZIndex = 20
            dropdown.Visible = false
            dropdown.Parent = el
            CreateCorner(dropdown, 8)
            CreateStroke(dropdown, COLORS.Border, 1)

            local dropLayout = Instance.new("UIListLayout")
            dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dropLayout.Parent = dropdown

            local function BuildItems()
                for _, child in pairs(dropdown:GetChildren()) do
                    if child:IsA("Frame") then child:Destroy() end
                end
                for i, item in ipairs(items) do
                    local itemBtn = Instance.new("TextButton")
                    itemBtn.BackgroundColor3 = selected == item and COLORS.Surface or Color3.fromRGB(0,0,0)
                    itemBtn.BackgroundTransparency = selected == item and 0 or 1
                    itemBtn.Size = UDim2.new(1, 0, 0, 32)
                    itemBtn.Text = ""
                    itemBtn.ZIndex = 20
                    itemBtn.Parent = dropdown

                    local itemLabel = CreateLabel(itemBtn, item, 12, selected == item and COLORS.Text or COLORS.TextMuted, Enum.Font.Gotham)
                    itemLabel.Size = UDim2.new(1, 0, 1, 0)
                    itemLabel.ZIndex = 20
                    CreatePadding(itemLabel, 0, 0, 12, 0)

                    itemBtn.MouseEnter:Connect(function()
                        if selected ~= item then
                            Tween(itemBtn, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Hover, BackgroundTransparency = 0})
                        end
                    end)
                    itemBtn.MouseLeave:Connect(function()
                        if selected ~= item then
                            Tween(itemBtn, TWEEN_INFO.Fast, {BackgroundTransparency = 1})
                        end
                    end)
                    itemBtn.MouseButton1Click:Connect(function()
                        selected = item
                        selectedLabel.Text = item
                        isOpen = false
                        Tween(dropdown, TWEEN_INFO.Fast, {Size = UDim2.new(1, 0, 0, 0)})
                        dropdown.Visible = false
                        Tween(arrow, TWEEN_INFO.Fast, {Rotation = 0})
                        BuildItems()
                        task.spawn(callback, selected)
                    end)
                end
            end

            BuildItems()

            local headerBtn = Instance.new("TextButton")
            headerBtn.BackgroundTransparency = 1
            headerBtn.Size = UDim2.new(1, 0, 0, 42)
            headerBtn.Text = ""
            headerBtn.ZIndex = 15
            headerBtn.Parent = el

            headerBtn.MouseEnter:Connect(function()
                Tween(el, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Hover})
            end)
            headerBtn.MouseLeave:Connect(function()
                Tween(el, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Surface})
            end)

            headerBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    dropdown.Visible = true
                    local targetHeight = math.min(#items * 32, 160)
                    Tween(dropdown, TWEEN_INFO.Fast, {Size = UDim2.new(1, 0, 0, targetHeight)})
                    Tween(arrow, TWEEN_INFO.Fast, {Rotation = 180})
                else
                    Tween(dropdown, TWEEN_INFO.Fast, {Size = UDim2.new(1, 0, 0, 0)})
                    Tween(arrow, TWEEN_INFO.Fast, {Rotation = 0})
                    task.delay(0.2, function()
                        if not isOpen then dropdown.Visible = false end
                    end)
                end
            end)

            local DdObj = {}
            function DdObj:Set(val)
                selected = val
                selectedLabel.Text = val
                BuildItems()
            end
            function DdObj:Get()
                return selected
            end
            function DdObj:AddItem(item)
                table.insert(items, item)
                BuildItems()
            end
            return DdObj
        end

        function Tab:CreateSearchableDropdown(options)
            options = options or {}
            local name = options.Name or "Search Dropdown"
            local items = options.Items or {}
            local default = options.Default or ""
            local callback = options.Callback or function() end

            local selected = default
            local isOpen = false
            local searchQuery = ""

            local el = Instance.new("Frame")
            el.BackgroundColor3 = COLORS.Surface
            el.Size = UDim2.new(1, 0, 0, 42)
            el.LayoutOrder = NextOrder()
            el.ClipsDescendants = false
            el.ZIndex = 9
            el.Parent = TabContent
            CreateCorner(el, 8)
            CreateStroke(el, COLORS.Border, 1)
            CreateGradient(el, Color3.fromRGB(18, 18, 18), Color3.fromRGB(12, 12, 12))

            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.Size = UDim2.new(1, 0, 0, 42)
            inner.ZIndex = 9
            inner.Parent = el
            CreatePadding(inner, 0, 0, 14, 14)

            local lbl = CreateLabel(inner, name, 13, COLORS.Text, Enum.Font.GothamMedium)
            lbl.Size = UDim2.new(0.5, 0, 1, 0)
            lbl.ZIndex = 9

            local selectedLabel = CreateLabel(inner, selected ~= "" and selected or "Select...", 12, COLORS.TextMuted, Enum.Font.Gotham, Enum.TextXAlignment.Right)
            selectedLabel.Size = UDim2.new(0.5, -22, 1, 0)
            selectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
            selectedLabel.ZIndex = 9

            local arrow = CreateLabel(inner, "⌄", 14, COLORS.TextDim, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
            arrow.Size = UDim2.new(0, 18, 1, 0)
            arrow.Position = UDim2.new(1, -18, 0, 0)
            arrow.ZIndex = 9

            local dropdown = Instance.new("Frame")
            dropdown.BackgroundColor3 = COLORS.Elevated
            dropdown.Position = UDim2.new(0, 0, 1, 4)
            dropdown.Size = UDim2.new(1, 0, 0, 0)
            dropdown.ClipsDescendants = true
            dropdown.ZIndex = 20
            dropdown.Visible = false
            dropdown.Parent = el
            CreateCorner(dropdown, 8)
            CreateStroke(dropdown, COLORS.Border, 1)

            local searchBg = Instance.new("Frame")
            searchBg.BackgroundColor3 = COLORS.Background
            searchBg.Size = UDim2.new(1, 0, 0, 32)
            searchBg.ZIndex = 20
            searchBg.Parent = dropdown
            CreateStroke(searchBg, COLORS.Border, 1)
            CreatePadding(searchBg, 0, 0, 8, 8)

            local searchBox = Instance.new("TextBox")
            searchBox.BackgroundTransparency = 1
            searchBox.Size = UDim2.new(1, 0, 1, 0)
            searchBox.PlaceholderText = "Search..."
            searchBox.Text = ""
            searchBox.TextSize = 12
            searchBox.Font = Enum.Font.Gotham
            searchBox.TextColor3 = COLORS.Text
            searchBox.PlaceholderColor3 = COLORS.TextDim
            searchBox.TextXAlignment = Enum.TextXAlignment.Left
            searchBox.ZIndex = 20
            searchBox.Parent = searchBg

            local itemScroll = Instance.new("ScrollingFrame")
            itemScroll.BackgroundTransparency = 1
            itemScroll.Position = UDim2.new(0, 0, 0, 32)
            itemScroll.Size = UDim2.new(1, 0, 1, -32)
            itemScroll.ScrollBarThickness = 2
            itemScroll.ScrollBarImageColor3 = COLORS.Border
            itemScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
            itemScroll.ZIndex = 20
            itemScroll.Parent = dropdown

            local itemLayout = Instance.new("UIListLayout")
            itemLayout.SortOrder = Enum.SortOrder.LayoutOrder
            itemLayout.Parent = itemScroll

            itemLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                itemScroll.CanvasSize = UDim2.new(0, 0, 0, itemLayout.AbsoluteContentSize.Y)
            end)

            local function RebuildItems(query)
                for _, c in pairs(itemScroll:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                for _, item in ipairs(items) do
                    if query == "" or string.lower(item):find(string.lower(query), 1, true) then
                        local itemBtn = Instance.new("TextButton")
                        itemBtn.BackgroundTransparency = selected == item and 0 or 1
                        itemBtn.BackgroundColor3 = COLORS.Surface
                        itemBtn.Size = UDim2.new(1, 0, 0, 30)
                        itemBtn.Text = ""
                        itemBtn.ZIndex = 20
                        itemBtn.Parent = itemScroll

                        local itemLabel = CreateLabel(itemBtn, item, 12, selected == item and COLORS.Text or COLORS.TextMuted, Enum.Font.Gotham)
                        itemLabel.Size = UDim2.new(1, 0, 1, 0)
                        itemLabel.ZIndex = 20
                        CreatePadding(itemLabel, 0, 0, 12, 0)

                        itemBtn.MouseButton1Click:Connect(function()
                            selected = item
                            selectedLabel.Text = item
                            searchBox.Text = ""
                            isOpen = false
                            Tween(dropdown, TWEEN_INFO.Fast, {Size = UDim2.new(1, 0, 0, 0)})
                            dropdown.Visible = false
                            Tween(arrow, TWEEN_INFO.Fast, {Rotation = 0})
                            RebuildItems("")
                            task.spawn(callback, selected)
                        end)
                    end
                end
            end

            searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                RebuildItems(searchBox.Text)
            end)

            RebuildItems("")

            local headerBtn = Instance.new("TextButton")
            headerBtn.BackgroundTransparency = 1
            headerBtn.Size = UDim2.new(1, 0, 0, 42)
            headerBtn.Text = ""
            headerBtn.ZIndex = 14
            headerBtn.Parent = el

            headerBtn.MouseEnter:Connect(function()
                Tween(el, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Hover})
            end)
            headerBtn.MouseLeave:Connect(function()
                Tween(el, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Surface})
            end)

            headerBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    dropdown.Visible = true
                    Tween(dropdown, TWEEN_INFO.Fast, {Size = UDim2.new(1, 0, 0, 164)})
                    Tween(arrow, TWEEN_INFO.Fast, {Rotation = 180})
                    searchBox:CaptureFocus()
                else
                    Tween(dropdown, TWEEN_INFO.Fast, {Size = UDim2.new(1, 0, 0, 0)})
                    Tween(arrow, TWEEN_INFO.Fast, {Rotation = 0})
                    task.delay(0.2, function()
                        if not isOpen then dropdown.Visible = false end
                    end)
                end
            end)

            local SddObj = {}
            function SddObj:Set(val)
                selected = val
                selectedLabel.Text = val
                RebuildItems("")
            end
            function SddObj:Get()
                return selected
            end
            return SddObj
        end

        function Tab:CreateMultiDropdown(options)
            options = options or {}
            local name = options.Name or "Multi Dropdown"
            local items = options.Items or {}
            local default = options.Default or {}
            local callback = options.Callback or function() end

            local selected = {}
            for _, v in ipairs(default) do
                selected[v] = true
            end

            local isOpen = false

            local el = Instance.new("Frame")
            el.BackgroundColor3 = COLORS.Surface
            el.Size = UDim2.new(1, 0, 0, 42)
            el.LayoutOrder = NextOrder()
            el.ClipsDescendants = false
            el.ZIndex = 8
            el.Parent = TabContent
            CreateCorner(el, 8)
            CreateStroke(el, COLORS.Border, 1)
            CreateGradient(el, Color3.fromRGB(18, 18, 18), Color3.fromRGB(12, 12, 12))

            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.Size = UDim2.new(1, 0, 0, 42)
            inner.ZIndex = 8
            inner.Parent = el
            CreatePadding(inner, 0, 0, 14, 14)

            local lbl = CreateLabel(inner, name, 13, COLORS.Text, Enum.Font.GothamMedium)
            lbl.Size = UDim2.new(0.5, 0, 1, 0)
            lbl.ZIndex = 8

            local selectedLabel = CreateLabel(inner, "None", 12, COLORS.TextMuted, Enum.Font.Gotham, Enum.TextXAlignment.Right)
            selectedLabel.Size = UDim2.new(0.5, -22, 1, 0)
            selectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
            selectedLabel.ZIndex = 8

            local arrow = CreateLabel(inner, "⌄", 14, COLORS.TextDim, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
            arrow.Size = UDim2.new(0, 18, 1, 0)
            arrow.Position = UDim2.new(1, -18, 0, 0)
            arrow.ZIndex = 8

            local dropdown = Instance.new("Frame")
            dropdown.BackgroundColor3 = COLORS.Elevated
            dropdown.Position = UDim2.new(0, 0, 1, 4)
            dropdown.Size = UDim2.new(1, 0, 0, 0)
            dropdown.ClipsDescendants = true
            dropdown.ZIndex = 20
            dropdown.Visible = false
            dropdown.Parent = el
            CreateCorner(dropdown, 8)
            CreateStroke(dropdown, COLORS.Border, 1)

            local dropLayout = Instance.new("UIListLayout")
            dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dropLayout.Parent = dropdown

            local function GetSelectedText()
                local parts = {}
                for k, v in pairs(selected) do
                    if v then table.insert(parts, k) end
                end
                if #parts == 0 then return "None" end
                if #parts > 2 then return #parts .. " selected" end
                return table.concat(parts, ", ")
            end

            local function BuildItems()
                for _, c in pairs(dropdown:GetChildren()) do
                    if c:IsA("Frame") then c:Destroy() end
                end
                for _, item in ipairs(items) do
                    local itemFrame = Instance.new("Frame")
                    itemFrame.BackgroundColor3 = selected[item] and COLORS.Surface or Color3.fromRGB(0,0,0)
                    itemFrame.BackgroundTransparency = selected[item] and 0 or 1
                    itemFrame.Size = UDim2.new(1, 0, 0, 32)
                    itemFrame.ZIndex = 20
                    itemFrame.Parent = dropdown

                    local checkBg = Instance.new("Frame")
                    checkBg.BackgroundColor3 = selected[item] and COLORS.ToggleOn or COLORS.Toggle
                    checkBg.Position = UDim2.new(1, -28, 0.5, -8)
                    checkBg.Size = UDim2.new(0, 16, 0, 16)
                    checkBg.ZIndex = 20
                    checkBg.Parent = itemFrame
                    CreateCorner(checkBg, 4)
                    CreateStroke(checkBg, COLORS.BorderLight, 1)

                    local checkMark = CreateLabel(checkBg, selected[item] and "✓" or "", 10, Color3.fromRGB(20,20,20), Enum.Font.GothamBold, Enum.TextXAlignment.Center)
                    checkMark.Size = UDim2.new(1, 0, 1, 0)
                    checkMark.ZIndex = 20
                    checkMark.TextYAlignment = Enum.TextYAlignment.Center

                    local itemLabel = CreateLabel(itemFrame, item, 12, selected[item] and COLORS.Text or COLORS.TextMuted, Enum.Font.Gotham)
                    itemLabel.Size = UDim2.new(1, -36, 1, 0)
                    itemLabel.ZIndex = 20
                    CreatePadding(itemLabel, 0, 0, 12, 0)

                    local itemBtn = Instance.new("TextButton")
                    itemBtn.BackgroundTransparency = 1
                    itemBtn.Size = UDim2.new(1, 0, 1, 0)
                    itemBtn.Text = ""
                    itemBtn.ZIndex = 21
                    itemBtn.Parent = itemFrame

                    itemBtn.MouseButton1Click:Connect(function()
                        selected[item] = not selected[item]
                        selectedLabel.Text = GetSelectedText()
                        BuildItems()
                        local result = {}
                        for k, v in pairs(selected) do
                            if v then table.insert(result, k) end
                        end
                        task.spawn(callback, result)
                    end)
                end
            end

            BuildItems()

            local headerBtn = Instance.new("TextButton")
            headerBtn.BackgroundTransparency = 1
            headerBtn.Size = UDim2.new(1, 0, 0, 42)
            headerBtn.Text = ""
            headerBtn.ZIndex = 13
            headerBtn.Parent = el

            headerBtn.MouseEnter:Connect(function()
                Tween(el, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Hover})
            end)
            headerBtn.MouseLeave:Connect(function()
                Tween(el, TWEEN_INFO.Fast, {BackgroundColor3 = COLORS.Surface})
            end)

            headerBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    dropdown.Visible = true
                    local h = math.min(#items * 32, 160)
                    Tween(dropdown, TWEEN_INFO.Fast, {Size = UDim2.new(1, 0, 0, h)})
                    Tween(arrow, TWEEN_INFO.Fast, {Rotation = 180})
                else
                    Tween(dropdown, TWEEN_INFO.Fast, {Size = UDim2.new(1, 0, 0, 0)})
                    Tween(arrow, TWEEN_INFO.Fast, {Rotation = 0})
                    task.delay(0.2, function()
                        if not isOpen then dropdown.Visible = false end
                    end)
                end
            end)

            local MddObj = {}
            function MddObj:Get()
                local result = {}
                for k, v in pairs(selected) do
                    if v then table.insert(result, k) end
                end
                return result
            end
            function MddObj:Set(values)
                selected = {}
                for _, v in ipairs(values) do selected[v] = true end
                selectedLabel.Text = GetSelectedText()
                BuildItems()
            end
            return MddObj
        end

        function Tab:CreateLabel(options)
            options = options or {}
            local text = options.Text or "Label"

            local el = Instance.new("Frame")
            el.BackgroundTransparency = 1
            el.Size = UDim2.new(1, 0, 0, 26)
            el.LayoutOrder = NextOrder()
            el.Parent = TabContent
            CreatePadding(el, 0, 0, 4, 4)

            local lbl = CreateLabel(el, text, 12, COLORS.TextMuted, Enum.Font.GothamMedium)
            lbl.Size = UDim2.new(1, 0, 1, 0)

            local LabelObj = {}
            function LabelObj:Set(newText)
                lbl.Text = newText
            end
            function LabelObj:Get()
                return lbl.Text
            end
            return LabelObj
        end

        function Tab:CreateParagraph(options)
            options = options or {}
            local heading = options.Title or ""
            local body = options.Content or ""

            local el = CreateElementBase(0)
            el.AutomaticSize = Enum.AutomaticSize.Y
            el.ClipsDescendants = false

            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.AutomaticSize = Enum.AutomaticSize.Y
            inner.Size = UDim2.new(1, 0, 0, 0)
            inner.Parent = el
            CreatePadding(inner, 12, 12, 14, 14)

            local innerLayout = Instance.new("UIListLayout")
            innerLayout.SortOrder = Enum.SortOrder.LayoutOrder
            innerLayout.Padding = UDim.new(0, 4)
            innerLayout.Parent = inner

            if heading ~= "" then
                local hdr = CreateLabel(inner, heading, 13, COLORS.Text, Enum.Font.GothamBold)
                hdr.Size = UDim2.new(1, 0, 0, 16)
                hdr.LayoutOrder = 0
            end

            local bodyLabel = CreateLabel(inner, body, 12, COLORS.TextMuted, Enum.Font.Gotham)
            bodyLabel.Size = UDim2.new(1, 0, 0, 0)
            bodyLabel.AutomaticSize = Enum.AutomaticSize.Y
            bodyLabel.TextWrapped = true
            bodyLabel.LayoutOrder = 1

            local PObj = {}
            function PObj:SetContent(newBody)
                bodyLabel.Text = newBody
            end
            function PObj:SetTitle(newTitle)
                if heading ~= "" then end
            end
            return PObj
        end

        Tabs[tabName] = Tab
        return Tab
    end

    return Window
end

return Library
