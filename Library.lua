local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local Themes = {
    Dark = {
        Background    = Color3.fromRGB(10, 10, 10),
        Surface       = Color3.fromRGB(16, 16, 16),
        Elevated      = Color3.fromRGB(24, 24, 24),
        Header        = Color3.fromRGB(13, 13, 13),
        Border        = Color3.fromRGB(38, 38, 38),
        BorderLight   = Color3.fromRGB(58, 58, 58),
        Text          = Color3.fromRGB(242, 242, 242),
        TextMuted     = Color3.fromRGB(140, 140, 140),
        TextDim       = Color3.fromRGB(75, 75, 75),
        Accent        = Color3.fromRGB(230, 230, 230),
        AccentDim     = Color3.fromRGB(160, 160, 160),
        Toggle        = Color3.fromRGB(42, 42, 42),
        ToggleOn      = Color3.fromRGB(210, 210, 210),
        SliderTrack   = Color3.fromRGB(32, 32, 32),
        SliderFill    = Color3.fromRGB(195, 195, 195),
        Notif         = Color3.fromRGB(18, 18, 18),
        Hover         = Color3.fromRGB(26, 26, 26),
        Active        = Color3.fromRGB(20, 20, 20),
        TabActive     = Color3.fromRGB(22, 22, 22),
        TabHighlight  = Color3.fromRGB(190, 190, 190),
        ScrollBar     = Color3.fromRGB(50, 50, 50),
        Grad0         = Color3.fromRGB(20, 20, 20),
        Grad1         = Color3.fromRGB(10, 10, 10),
        ShadowColor   = Color3.fromRGB(0, 0, 0),
    },
    Darker = {
        Background    = Color3.fromRGB(5, 5, 5),
        Surface       = Color3.fromRGB(10, 10, 10),
        Elevated      = Color3.fromRGB(16, 16, 16),
        Header        = Color3.fromRGB(8, 8, 8),
        Border        = Color3.fromRGB(28, 28, 28),
        BorderLight   = Color3.fromRGB(45, 45, 45),
        Text          = Color3.fromRGB(235, 235, 235),
        TextMuted     = Color3.fromRGB(120, 120, 120),
        TextDim       = Color3.fromRGB(60, 60, 60),
        Accent        = Color3.fromRGB(210, 210, 210),
        AccentDim     = Color3.fromRGB(140, 140, 140),
        Toggle        = Color3.fromRGB(30, 30, 30),
        ToggleOn      = Color3.fromRGB(200, 200, 200),
        SliderTrack   = Color3.fromRGB(22, 22, 22),
        SliderFill    = Color3.fromRGB(180, 180, 180),
        Notif         = Color3.fromRGB(10, 10, 10),
        Hover         = Color3.fromRGB(18, 18, 18),
        Active        = Color3.fromRGB(14, 14, 14),
        TabActive     = Color3.fromRGB(14, 14, 14),
        TabHighlight  = Color3.fromRGB(170, 170, 170),
        ScrollBar     = Color3.fromRGB(38, 38, 38),
        Grad0         = Color3.fromRGB(12, 12, 12),
        Grad1         = Color3.fromRGB(5, 5, 5),
        ShadowColor   = Color3.fromRGB(0, 0, 0),
    },
    Slate = {
        Background    = Color3.fromRGB(10, 12, 18),
        Surface       = Color3.fromRGB(16, 19, 28),
        Elevated      = Color3.fromRGB(22, 26, 38),
        Header        = Color3.fromRGB(13, 15, 22),
        Border        = Color3.fromRGB(38, 44, 62),
        BorderLight   = Color3.fromRGB(55, 64, 88),
        Text          = Color3.fromRGB(220, 224, 240),
        TextMuted     = Color3.fromRGB(130, 140, 170),
        TextDim       = Color3.fromRGB(70, 80, 110),
        Accent        = Color3.fromRGB(180, 195, 255),
        AccentDim     = Color3.fromRGB(120, 140, 210),
        Toggle        = Color3.fromRGB(35, 42, 60),
        ToggleOn      = Color3.fromRGB(160, 180, 255),
        SliderTrack   = Color3.fromRGB(28, 33, 50),
        SliderFill    = Color3.fromRGB(150, 170, 240),
        Notif         = Color3.fromRGB(16, 19, 28),
        Hover         = Color3.fromRGB(24, 28, 42),
        Active        = Color3.fromRGB(18, 22, 34),
        TabActive     = Color3.fromRGB(20, 24, 36),
        TabHighlight  = Color3.fromRGB(150, 170, 240),
        ScrollBar     = Color3.fromRGB(50, 60, 90),
        Grad0         = Color3.fromRGB(20, 24, 36),
        Grad1         = Color3.fromRGB(10, 12, 18),
        ShadowColor   = Color3.fromRGB(0, 0, 10),
    },
    Crimson = {
        Background    = Color3.fromRGB(12, 8, 8),
        Surface       = Color3.fromRGB(18, 12, 12),
        Elevated      = Color3.fromRGB(26, 17, 17),
        Header        = Color3.fromRGB(14, 9, 9),
        Border        = Color3.fromRGB(50, 28, 28),
        BorderLight   = Color3.fromRGB(72, 38, 38),
        Text          = Color3.fromRGB(240, 220, 220),
        TextMuted     = Color3.fromRGB(160, 110, 110),
        TextDim       = Color3.fromRGB(90, 55, 55),
        Accent        = Color3.fromRGB(230, 80, 80),
        AccentDim     = Color3.fromRGB(180, 60, 60),
        Toggle        = Color3.fromRGB(45, 20, 20),
        ToggleOn      = Color3.fromRGB(210, 70, 70),
        SliderTrack   = Color3.fromRGB(35, 18, 18),
        SliderFill    = Color3.fromRGB(200, 65, 65),
        Notif         = Color3.fromRGB(18, 10, 10),
        Hover         = Color3.fromRGB(28, 17, 17),
        Active        = Color3.fromRGB(22, 13, 13),
        TabActive     = Color3.fromRGB(24, 14, 14),
        TabHighlight  = Color3.fromRGB(200, 60, 60),
        ScrollBar     = Color3.fromRGB(60, 30, 30),
        Grad0         = Color3.fromRGB(22, 13, 13),
        Grad1         = Color3.fromRGB(12, 7, 7),
        ShadowColor   = Color3.fromRGB(8, 0, 0),
    },
}

local CurrentTheme = "Dark"
local T = Themes[CurrentTheme]
local ThemeListeners = {}

local function OnThemeChange(fn)
    table.insert(ThemeListeners, fn)
end

local function ApplyTheme(name)
    if not Themes[name] then return end
    CurrentTheme = name
    T = Themes[name]
    for _, fn in ipairs(ThemeListeners) do
        pcall(fn, T)
    end
end

Library.Themes = Themes
Library.ApplyTheme = ApplyTheme

local EI = {
    Smooth   = TweenInfo.new(0.2,  Enum.EasingStyle.Quint,  Enum.EasingDirection.Out),
    Medium   = TweenInfo.new(0.28, Enum.EasingStyle.Quint,  Enum.EasingDirection.Out),
    Slow     = TweenInfo.new(0.4,  Enum.EasingStyle.Quint,  Enum.EasingDirection.Out),
    Enter    = TweenInfo.new(0.35, Enum.EasingStyle.Quint,  Enum.EasingDirection.Out),
    Linear   = TweenInfo.new(0.12, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
    Bounce   = TweenInfo.new(0.45, Enum.EasingStyle.Quint,  Enum.EasingDirection.Out),
}

local function Tw(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function Corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
    return c
end

local function Pad(p, t, b, l, r)
    local u = Instance.new("UIPadding")
    u.PaddingTop    = UDim.new(0, t or 0)
    u.PaddingBottom = UDim.new(0, b or 0)
    u.PaddingLeft   = UDim.new(0, l or 0)
    u.PaddingRight  = UDim.new(0, r or 0)
    u.Parent = p
    return u
end

local function Stroke(p, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color     = color or T.Border
    s.Thickness = thickness or 1
    s.Parent    = p
    return s
end

local function Grad(p, c0, c1, rot)
    local g = Instance.new("UIGradient")
    g.Color    = ColorSequence.new(c0, c1)
    g.Rotation = rot or 90
    g.Parent   = p
    return g
end

local function Lbl(p, txt, size, color, font, xAlign)
    local l = Instance.new("TextLabel")
    l.Text              = txt or ""
    l.TextSize          = size or 13
    l.TextColor3        = color or T.Text
    l.Font              = font or Enum.Font.GothamMedium
    l.BackgroundTransparency = 1
    l.TextXAlignment    = xAlign or Enum.TextXAlignment.Left
    l.TextYAlignment    = Enum.TextYAlignment.Center
    l.Parent            = p
    return l
end

local function MakeDraggable(frame, handle)
    local dragging, dragStart, startPos = false, nil, nil
    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = inp.Position
            startPos  = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local ScreenGui
local DropPortal
local NotifHolder
local ActiveDropdown = nil

local function CloseActiveDropdown()
    if ActiveDropdown then
        ActiveDropdown()
        ActiveDropdown = nil
    end
end

local function OpenDropPortal(anchorFrame, contentHeight, buildFn, onClose)
    CloseActiveDropdown()
    local abs = anchorFrame.AbsolutePosition
    local sz  = anchorFrame.AbsoluteSize

    local panel = Instance.new("Frame")
    panel.Name              = "DropPanel"
    panel.BackgroundColor3  = T.Elevated
    panel.Position          = UDim2.new(0, abs.X, 0, abs.Y + sz.Y + 4)
    panel.Size              = UDim2.new(0, sz.X, 0, 0)
    panel.ClipsDescendants  = true
    panel.ZIndex            = 200
    panel.Parent            = DropPortal
    Corner(panel, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color     = T.Border
    stroke.Thickness = 1
    stroke.ZIndex    = 200
    stroke.Parent    = panel

    buildFn(panel)

    Tw(panel, EI.Smooth, {Size = UDim2.new(0, sz.X, 0, contentHeight)})

    local function Close()
        Tw(panel, EI.Smooth, {Size = UDim2.new(0, sz.X, 0, 0)})
        task.delay(0.22, function()
            if panel and panel.Parent then panel:Destroy() end
        end)
        if onClose then onClose() end
    end

    ActiveDropdown = Close

    local conn
    conn = UserInputService.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            local mp = UserInputService:GetMouseLocation()
            local p  = panel.AbsolutePosition
            local ps = panel.AbsoluteSize
            local inside = mp.X >= p.X and mp.X <= p.X + ps.X and mp.Y >= p.Y and mp.Y <= p.Y + ps.Y
            local ap = anchorFrame.AbsolutePosition
            local as = anchorFrame.AbsoluteSize
            local inAnchor = mp.X >= ap.X and mp.X <= ap.X + as.X and mp.Y >= ap.Y and mp.Y <= ap.Y + as.Y
            if not inside and not inAnchor then
                conn:Disconnect()
                Close()
                ActiveDropdown = nil
            end
        end
    end)

    return Close
end

local function InitNotifications()
    NotifHolder = Instance.new("Frame")
    NotifHolder.Name                = "Notifications"
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.Position            = UDim2.new(1, -320, 1, -20)
    NotifHolder.Size                = UDim2.new(0, 300, 0, 0)
    NotifHolder.AnchorPoint         = Vector2.new(0, 1)
    NotifHolder.ZIndex              = 500
    NotifHolder.Parent              = ScreenGui

    local lay = Instance.new("UIListLayout")
    lay.SortOrder          = Enum.SortOrder.LayoutOrder
    lay.Padding            = UDim.new(0, 8)
    lay.VerticalAlignment  = Enum.VerticalAlignment.Bottom
    lay.Parent             = NotifHolder
end

function Library:Notify(opts)
    opts = opts or {}
    local title    = opts.Title or "Notice"
    local desc     = opts.Description or ""
    local duration = opts.Duration or 4

    local card = Instance.new("Frame")
    card.Name               = "Notif"
    card.BackgroundColor3   = T.Notif
    card.Size               = UDim2.new(1, 0, 0, 0)
    card.ClipsDescendants   = true
    card.ZIndex             = 500
    card.Parent             = NotifHolder
    Corner(card, 10)

    local stroke = Instance.new("UIStroke")
    stroke.Color   = T.Border
    stroke.Thickness = 1
    stroke.ZIndex  = 500
    stroke.Parent  = card

    Grad(card, T.Grad0, T.Grad1)

    local accentBar = Instance.new("Frame")
    accentBar.BackgroundColor3 = T.AccentDim
    accentBar.Size             = UDim2.new(0, 3, 1, 0)
    accentBar.ZIndex           = 501
    accentBar.Parent           = card
    Corner(accentBar, 2)

    local body = Instance.new("Frame")
    body.BackgroundTransparency = 1
    body.Position               = UDim2.new(0, 14, 0, 0)
    body.Size                   = UDim2.new(1, -14, 1, 0)
    body.ZIndex                 = 501
    body.Parent                 = card

    local tl = Lbl(body, title, 13, T.Text, Enum.Font.GothamBold)
    tl.Size     = UDim2.new(1, 0, 0, 18)
    tl.Position = UDim2.new(0, 0, 0, 12)
    tl.ZIndex   = 501

    local dl = Lbl(body, desc, 12, T.TextMuted, Enum.Font.Gotham)
    dl.Size        = UDim2.new(1, -10, 0, 0)
    dl.Position    = UDim2.new(0, 0, 0, 32)
    dl.AutomaticSize = Enum.AutomaticSize.Y
    dl.TextWrapped = true
    dl.ZIndex      = 501

    local prog = Instance.new("Frame")
    prog.BackgroundColor3 = T.Border
    prog.AnchorPoint      = Vector2.new(0, 1)
    prog.Position         = UDim2.new(0, 0, 1, 0)
    prog.Size             = UDim2.new(1, 0, 0, 2)
    prog.ZIndex           = 501
    prog.Parent           = card
    Corner(prog, 1)

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = T.AccentDim
    fill.Size             = UDim2.new(1, 0, 1, 0)
    fill.ZIndex           = 502
    fill.Parent           = prog
    Corner(fill, 1)

    task.wait()
    Tw(card, EI.Bounce, {Size = UDim2.new(1, 0, 0, 72)})
    Tw(fill, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 1, 0)})

    task.delay(duration, function()
        Tw(card, EI.Medium, {Size = UDim2.new(1, 0, 0, 0)})
        task.wait(0.32)
        if card and card.Parent then card:Destroy() end
    end)
end

function Library:CreateWindow(opts)
    opts = opts or {}
    local title    = opts.Title or "Library"
    local icon     = opts.Icon or "rbxassetid://0"
    local subtitle = opts.Subtitle or ""

    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name            = "LawLibrary"
    ScreenGui.ResetOnSpawn    = false
    ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset  = true
    ScreenGui.Parent          = LocalPlayer:WaitForChild("PlayerGui")

    DropPortal = Instance.new("Frame")
    DropPortal.Name                 = "DropPortal"
    DropPortal.BackgroundTransparency = 1
    DropPortal.Size                 = UDim2.new(1, 0, 1, 0)
    DropPortal.ZIndex               = 100
    DropPortal.Parent               = ScreenGui

    InitNotifications()

    local WIN_W, WIN_H = 660, 420

    local Win = Instance.new("Frame")
    Win.Name              = "Window"
    Win.BackgroundColor3  = T.Background
    Win.Position          = UDim2.new(0.5, -(WIN_W/2), 0.5, -(WIN_H/2))
    Win.Size              = UDim2.new(0, WIN_W, 0, 0)
    Win.ClipsDescendants  = false
    Win.Parent            = ScreenGui
    Corner(Win, 12)

    local winStroke = Stroke(Win, T.Border, 1)

    Grad(Win, T.Grad0, T.Grad1)

    local Shadow = Instance.new("ImageLabel")
    Shadow.BackgroundTransparency = 1
    Shadow.Image              = "rbxassetid://6014261993"
    Shadow.ImageColor3        = T.ShadowColor
    Shadow.ImageTransparency  = 0.45
    Shadow.Position           = UDim2.new(0, -24, 0, -24)
    Shadow.Size               = UDim2.new(1, 48, 1, 48)
    Shadow.SliceCenter        = Rect.new(49, 49, 450, 450)
    Shadow.ScaleType          = Enum.ScaleType.Slice
    Shadow.ZIndex             = 0
    Shadow.Parent             = Win

    local Header = Instance.new("Frame")
    Header.Name              = "Header"
    Header.BackgroundColor3  = T.Header
    Header.Size              = UDim2.new(1, 0, 0, 50)
    Header.ZIndex            = 2
    Header.Parent            = Win
    Corner(Header, 12)
    Grad(Header, Color3.fromRGB(T.Header.R*255+6, T.Header.G*255+6, T.Header.B*255+6), T.Header)

    local HeaderFloor = Instance.new("Frame")
    HeaderFloor.BackgroundColor3 = T.Header
    HeaderFloor.Position         = UDim2.new(0, 0, 0.5, 0)
    HeaderFloor.Size             = UDim2.new(1, 0, 0.5, 0)
    HeaderFloor.ZIndex           = 2
    HeaderFloor.Parent           = Header

    local HeaderLine = Instance.new("Frame")
    HeaderLine.BackgroundColor3 = T.Border
    HeaderLine.Position         = UDim2.new(0, 0, 1, 0)
    HeaderLine.Size             = UDim2.new(1, 0, 0, 1)
    HeaderLine.ZIndex           = 3
    HeaderLine.Parent           = Header

    local WinIcon = Instance.new("ImageLabel")
    WinIcon.BackgroundTransparency = 1
    WinIcon.Position               = UDim2.new(0, 14, 0.5, -9)
    WinIcon.Size                   = UDim2.new(0, 18, 0, 18)
    WinIcon.Image                  = icon
    WinIcon.ImageColor3            = T.AccentDim
    WinIcon.ZIndex                 = 3
    WinIcon.Parent                 = Header

    local TitleLbl = Lbl(Header, title, 14, T.Text, Enum.Font.GothamBold)
    TitleLbl.Position = UDim2.new(0, 38, 0, 0)
    TitleLbl.Size     = UDim2.new(0, 200, 1, 0)
    TitleLbl.ZIndex   = 3

    if subtitle ~= "" then
        local SubLbl = Lbl(Header, subtitle, 10, T.TextDim, Enum.Font.Gotham)
        SubLbl.Position = UDim2.new(0, 38, 0, 0)
        SubLbl.Size     = UDim2.new(0, 200, 1, 0)
        SubLbl.TextYAlignment = Enum.TextYAlignment.Bottom
        SubLbl.Position = UDim2.new(0, 40 + TitleLbl.TextBounds.X + 8, 0, 0)
        SubLbl.ZIndex   = 3
    end

    local function MakeHeaderBtn(offsetX, iconText, iconColor)
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = T.Elevated
        btn.BackgroundTransparency = 0.4
        btn.Position         = UDim2.new(1, -offsetX, 0.5, -12)
        btn.Size             = UDim2.new(0, 24, 0, 24)
        btn.Text             = ""
        btn.ZIndex           = 5
        btn.Parent           = Header
        Corner(btn, 6)
        Stroke(btn, T.Border, 1)

        local ic = Lbl(btn, iconText, 11, iconColor, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        ic.Size     = UDim2.new(1, 0, 1, 0)
        ic.ZIndex   = 6
        return btn, ic
    end

    local CloseBtn, CloseIc = MakeHeaderBtn(36, "✕", T.TextDim)
    local MinBtn, MinIc     = MakeHeaderBtn(66, "─", T.TextDim)

    CloseBtn.MouseEnter:Connect(function()
        Tw(CloseBtn, EI.Smooth, {BackgroundColor3 = Color3.fromRGB(160,40,40), BackgroundTransparency = 0})
        Tw(CloseIc, EI.Smooth, {TextColor3 = Color3.fromRGB(255,255,255)})
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tw(CloseBtn, EI.Smooth, {BackgroundColor3 = T.Elevated, BackgroundTransparency = 0.4})
        Tw(CloseIc, EI.Smooth, {TextColor3 = T.TextDim})
    end)

    MinBtn.MouseEnter:Connect(function()
        Tw(MinBtn, EI.Smooth, {BackgroundColor3 = T.Border, BackgroundTransparency = 0})
        Tw(MinIc, EI.Smooth, {TextColor3 = T.Text})
    end)
    MinBtn.MouseLeave:Connect(function()
        Tw(MinBtn, EI.Smooth, {BackgroundColor3 = T.Elevated, BackgroundTransparency = 0.4})
        Tw(MinIc, EI.Smooth, {TextColor3 = T.TextDim})
    end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Name             = "Sidebar"
    Sidebar.BackgroundColor3 = T.Surface
    Sidebar.Position         = UDim2.new(0, 0, 0, 50)
    Sidebar.Size             = UDim2.new(0, 148, 1, -50)
    Sidebar.ZIndex           = 2
    Sidebar.Parent           = Win
    Grad(Sidebar, T.Surface, T.Background)

    local SidebarLine = Instance.new("Frame")
    SidebarLine.BackgroundColor3 = T.Border
    SidebarLine.Position         = UDim2.new(1, 0, 0, 0)
    SidebarLine.Size             = UDim2.new(0, 1, 1, 0)
    SidebarLine.ZIndex           = 3
    SidebarLine.Parent           = Sidebar

    local SidebarCornerFix = Instance.new("Frame")
    SidebarCornerFix.BackgroundColor3 = T.Surface
    SidebarCornerFix.Position         = UDim2.new(0, 0, 0, 0)
    SidebarCornerFix.Size             = UDim2.new(1, 0, 0, 8)
    SidebarCornerFix.ZIndex           = 2
    SidebarCornerFix.Parent           = Sidebar

    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.BackgroundTransparency = 1
    TabScroll.Position               = UDim2.new(0, 0, 0, 6)
    TabScroll.Size                   = UDim2.new(1, 0, 1, -6)
    TabScroll.ScrollBarThickness     = 0
    TabScroll.CanvasSize             = UDim2.new(0,0,0,0)
    TabScroll.ZIndex                 = 3
    TabScroll.Parent                 = Sidebar
    Pad(TabScroll, 0, 8, 8, 8)

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding   = UDim.new(0, 3)
    TabLayout.Parent    = TabScroll

    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabScroll.CanvasSize = UDim2.new(0,0,0, TabLayout.AbsoluteContentSize.Y + 16)
    end)

    local ContentHolder = Instance.new("Frame")
    ContentHolder.Name               = "ContentHolder"
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Position           = UDim2.new(0, 149, 0, 50)
    ContentHolder.Size               = UDim2.new(1, -149, 1, -50)
    ContentHolder.ClipsDescendants   = true
    ContentHolder.ZIndex             = 2
    ContentHolder.Parent             = Win

    MakeDraggable(Win, Header)

    local WindowOpen = true
    local Minimized  = false
    local ActiveTab  = nil

    local function AnimateTypewriter(lbl, txt)
        task.spawn(function()
            while lbl and lbl.Parent do
                for i = 1, #txt do
                    if not (lbl and lbl.Parent) then return end
                    lbl.Text = txt:sub(1, i)
                    task.wait(0.065)
                end
                task.wait(1.4)
                for i = #txt, 0, -1 do
                    if not (lbl and lbl.Parent) then return end
                    lbl.Text = txt:sub(1, i)
                    task.wait(0.038)
                end
                task.wait(0.5)
            end
        end)
    end

    AnimateTypewriter(TitleLbl, title)

    local function SetVisible(v)
        WindowOpen = v
        if v then
            Win.Visible = true
            Win.Size    = UDim2.new(0, WIN_W, 0, 0)
            Tw(Win, EI.Bounce, {Size = UDim2.new(0, WIN_W, 0, WIN_H)})
        else
            CloseActiveDropdown()
            Tw(Win, EI.Medium, {Size = UDim2.new(0, WIN_W, 0, 0)})
            task.delay(0.32, function()
                if not WindowOpen then Win.Visible = false end
            end)
        end
    end

    CloseBtn.MouseButton1Click:Connect(function()
        SetVisible(false)
    end)

    MinBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            CloseActiveDropdown()
            Tw(Win, EI.Medium, {Size = UDim2.new(0, WIN_W, 0, 50)})
        else
            Tw(Win, EI.Bounce, {Size = UDim2.new(0, WIN_W, 0, WIN_H)})
        end
    end)

    if not IsMobile then
        UserInputService.InputBegan:Connect(function(inp, gp)
            if gp then return end
            if inp.KeyCode == Enum.KeyCode.RightControl then
                SetVisible(not WindowOpen)
            end
        end)
    else
        local MobBtn = Instance.new("TextButton")
        MobBtn.Name              = "MobileToggle"
        MobBtn.BackgroundColor3  = T.Surface
        MobBtn.Size              = UDim2.new(0, 50, 0, 50)
        MobBtn.Position          = UDim2.new(0, 16, 0.5, -25)
        MobBtn.Text              = ""
        MobBtn.ZIndex            = 50
        MobBtn.Parent            = ScreenGui
        Corner(MobBtn, 14)
        Stroke(MobBtn, T.Border, 1)
        Grad(MobBtn, T.Grad0, T.Grad1)

        local MobIc = Lbl(MobBtn, "≡", 22, T.Text, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        MobIc.Size   = UDim2.new(1, 0, 1, 0)
        MobIc.ZIndex = 51

        MakeDraggable(MobBtn, MobBtn)

        MobBtn.MouseButton1Click:Connect(function()
            SetVisible(not WindowOpen)
            MobIc.Text = WindowOpen and "✕" or "≡"
        end)
    end

    Win.Size    = UDim2.new(0, WIN_W, 0, 0)
    Win.Visible = true
    task.wait(0.05)
    Tw(Win, EI.Bounce, {Size = UDim2.new(0, WIN_W, 0, WIN_H)})

    local WindowObj = {}

    function WindowObj:CreateTab(tabName, tabIcon)
        tabIcon = tabIcon or "rbxassetid://0"
        local Tab = {}

        local TabBtn = Instance.new("TextButton")
        TabBtn.Name                  = "Tab_" .. tabName
        TabBtn.BackgroundColor3      = T.TabActive
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size                  = UDim2.new(1, 0, 0, 36)
        TabBtn.Text                  = ""
        TabBtn.ZIndex                = 4
        TabBtn.Parent                = TabScroll
        Corner(TabBtn, 7)

        local TabHighlight = Instance.new("Frame")
        TabHighlight.BackgroundColor3      = T.TabHighlight
        TabHighlight.BackgroundTransparency = 1
        TabHighlight.Position              = UDim2.new(0, 0, 0.1, 0)
        TabHighlight.Size                  = UDim2.new(0, 2, 0.8, 0)
        TabHighlight.ZIndex                = 5
        TabHighlight.Parent                = TabBtn
        Corner(TabHighlight, 1)

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position               = UDim2.new(0, 10, 0.5, -8)
        TabIcon.Size                   = UDim2.new(0, 16, 0, 16)
        TabIcon.Image                  = tabIcon
        TabIcon.ImageColor3            = T.TextMuted
        TabIcon.ZIndex                 = 5
        TabIcon.Parent                 = TabBtn

        local iconOffset = tabIcon ~= "rbxassetid://0" and 30 or 12

        local TabLbl = Lbl(TabBtn, tabName, 12, T.TextMuted, Enum.Font.GothamMedium)
        TabLbl.Position = UDim2.new(0, iconOffset, 0, 0)
        TabLbl.Size     = UDim2.new(1, -iconOffset - 6, 1, 0)
        TabLbl.ZIndex   = 5

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.BackgroundTransparency   = 1
        TabPage.Position                 = UDim2.new(0, 0, 0, 0)
        TabPage.Size                     = UDim2.new(1, 0, 1, 0)
        TabPage.ScrollBarThickness       = 3
        TabPage.ScrollBarImageColor3     = T.ScrollBar
        TabPage.CanvasSize               = UDim2.new(0,0,0,0)
        TabPage.Visible                  = false
        TabPage.ZIndex                   = 3
        TabPage.Parent                   = ContentHolder
        Pad(TabPage, 12, 12, 12, 12)

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding   = UDim.new(0, 7)
        PageLayout.Parent    = TabPage

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0,0,0, PageLayout.AbsoluteContentSize.Y + 24)
        end)

        local function Select()
            if ActiveTab then
                ActiveTab.Page.Visible = false
                Tw(ActiveTab.Btn,       EI.Smooth, {BackgroundTransparency = 1})
                Tw(ActiveTab.Lbl,       EI.Smooth, {TextColor3 = T.TextMuted})
                Tw(ActiveTab.Highlight, EI.Smooth, {BackgroundTransparency = 1})
                Tw(ActiveTab.Icon,      EI.Smooth, {ImageColor3 = T.TextMuted})
            end
            ActiveTab = {Page = TabPage, Btn = TabBtn, Lbl = TabLbl, Highlight = TabHighlight, Icon = TabIcon}
            TabPage.Visible = true
            Tw(TabBtn,       EI.Smooth, {BackgroundTransparency = 0, BackgroundColor3 = T.TabActive})
            Tw(TabLbl,       EI.Smooth, {TextColor3 = T.Text})
            Tw(TabHighlight, EI.Smooth, {BackgroundTransparency = 0, BackgroundColor3 = T.TabHighlight})
            Tw(TabIcon,      EI.Smooth, {ImageColor3 = T.TabHighlight})
        end

        TabBtn.MouseButton1Click:Connect(Select)
        TabBtn.MouseEnter:Connect(function()
            if ActiveTab and ActiveTab.Btn == TabBtn then return end
            Tw(TabBtn, EI.Smooth, {BackgroundTransparency = 0.65, BackgroundColor3 = T.TabActive})
            Tw(TabLbl, EI.Smooth, {TextColor3 = T.AccentDim})
        end)
        TabBtn.MouseLeave:Connect(function()
            if ActiveTab and ActiveTab.Btn == TabBtn then return end
            Tw(TabBtn, EI.Smooth, {BackgroundTransparency = 1})
            Tw(TabLbl, EI.Smooth, {TextColor3 = T.TextMuted})
        end)

        if not ActiveTab then Select() end

        local Order = 0
        local function NO()
            Order = Order + 1
            return Order
        end

        local function BaseEl(h, autoY)
            local f = Instance.new("Frame")
            f.BackgroundColor3 = T.Surface
            f.Size             = autoY and UDim2.new(1,0,0,h) or UDim2.new(1,0,0,h)
            f.LayoutOrder      = NO()
            f.ZIndex           = 4
            f.Parent           = TabPage
            Corner(f, 8)
            Stroke(f, T.Border, 1)
            Grad(f, T.Grad0, T.Grad1)
            return f
        end

        function Tab:CreateSection(opts)
            opts = opts or {}
            local name = opts.Name or "Section"
            local sf = Instance.new("Frame")
            sf.BackgroundTransparency = 1
            sf.Size        = UDim2.new(1,0,0,22)
            sf.LayoutOrder = NO()
            sf.ZIndex      = 4
            sf.Parent      = TabPage

            local line = Instance.new("Frame")
            line.BackgroundColor3 = T.Border
            line.Position         = UDim2.new(0,0,0.5,0)
            line.Size             = UDim2.new(1,0,0,1)
            line.ZIndex           = 4
            line.Parent           = sf

            local sLbl = Lbl(line, name:upper(), 9, T.TextDim, Enum.Font.GothamBold)
            sLbl.BackgroundColor3      = T.Background
            sLbl.BackgroundTransparency = 0
            sLbl.AnchorPoint           = Vector2.new(0,0.5)
            sLbl.AutomaticSize         = Enum.AutomaticSize.X
            sLbl.Size                  = UDim2.new(0,0,0,12)
            sLbl.Position              = UDim2.new(0,6,0.5,0)
            sLbl.ZIndex                = 5
            Pad(sLbl,0,0,5,5)
        end

        function Tab:CreateButton(opts)
            opts = opts or {}
            local name = opts.Name or "Button"
            local desc = opts.Description
            local cb   = opts.Callback or function() end
            local h    = desc and 52 or 42

            local el = BaseEl(h)

            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.Size  = UDim2.new(1,0,1,0)
            inner.ZIndex= 5
            inner.Parent= el
            Pad(inner,0,0,14,14)

            local nameLbl = Lbl(inner, name, 13, T.Text, Enum.Font.GothamMedium)
            nameLbl.Size     = UDim2.new(1,-22,0,18)
            nameLbl.Position = UDim2.new(0,0,0, desc and 8 or 0)
            nameLbl.ZIndex   = 5

            if desc then
                local dLbl = Lbl(inner, desc, 11, T.TextMuted, Enum.Font.Gotham)
                dLbl.Size     = UDim2.new(1,-22,0,14)
                dLbl.Position = UDim2.new(0,0,0,26)
                dLbl.ZIndex   = 5
            end

            local arrowLbl = Lbl(inner, "›", 20, T.TextDim, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
            arrowLbl.Size     = UDim2.new(0,18,1,0)
            arrowLbl.Position = UDim2.new(1,-18,0,0)
            arrowLbl.ZIndex   = 5

            local btn = Instance.new("TextButton")
            btn.BackgroundTransparency = 1
            btn.Size  = UDim2.new(1,0,1,0)
            btn.Text  = ""
            btn.ZIndex= 6
            btn.Parent= el

            btn.MouseEnter:Connect(function()
                Tw(el,       EI.Smooth, {BackgroundColor3 = T.Hover})
                Tw(arrowLbl, EI.Smooth, {TextColor3 = T.AccentDim, Position = UDim2.new(1,-14,0,0)})
            end)
            btn.MouseLeave:Connect(function()
                Tw(el,       EI.Smooth, {BackgroundColor3 = T.Surface})
                Tw(arrowLbl, EI.Smooth, {TextColor3 = T.TextDim, Position = UDim2.new(1,-18,0,0)})
            end)
            btn.MouseButton1Down:Connect(function()
                Tw(el, EI.Smooth, {BackgroundColor3 = T.Active})
            end)
            btn.MouseButton1Up:Connect(function()
                Tw(el, EI.Smooth, {BackgroundColor3 = T.Hover})
            end)
            btn.MouseButton1Click:Connect(function() task.spawn(cb) end)
        end

        function Tab:CreateToggle(opts)
            opts = opts or {}
            local name = opts.Name or "Toggle"
            local desc = opts.Description
            local def  = opts.Default or false
            local cb   = opts.Callback or function() end
            local h    = desc and 52 or 42

            local toggled = def
            local el = BaseEl(h)

            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.Size   = UDim2.new(1,0,1,0)
            inner.ZIndex = 5
            inner.Parent = el
            Pad(inner,0,0,14,14)

            local nameLbl = Lbl(inner, name, 13, T.Text, Enum.Font.GothamMedium)
            nameLbl.Size     = UDim2.new(1,-52,0,18)
            nameLbl.Position = UDim2.new(0,0,0, desc and 8 or 0)
            nameLbl.ZIndex   = 5

            if desc then
                local dLbl = Lbl(inner, desc, 11, T.TextMuted, Enum.Font.Gotham)
                dLbl.Size     = UDim2.new(1,-52,0,14)
                dLbl.Position = UDim2.new(0,0,0,26)
                dLbl.ZIndex   = 5
            end

            local pill = Instance.new("Frame")
            pill.BackgroundColor3 = toggled and T.ToggleOn or T.Toggle
            pill.AnchorPoint      = Vector2.new(1,0.5)
            pill.Position         = UDim2.new(1,0,0.5,0)
            pill.Size             = UDim2.new(0,40,0,22)
            pill.ZIndex           = 6
            pill.Parent           = inner
            Corner(pill, 11)
            Stroke(pill, T.BorderLight, 1)

            local knob = Instance.new("Frame")
            knob.BackgroundColor3 = toggled and T.Background or T.TextDim
            knob.AnchorPoint      = Vector2.new(0,0.5)
            knob.Position         = toggled and UDim2.new(1,-18,0.5,0) or UDim2.new(0,2,0.5,0)
            knob.Size             = UDim2.new(0,16,0,16)
            knob.ZIndex           = 7
            knob.Parent           = pill
            Corner(knob, 8)

            local function Update(state)
                toggled = state
                Tw(pill, EI.Smooth, {BackgroundColor3 = toggled and T.ToggleOn or T.Toggle})
                Tw(knob, EI.Smooth, {
                    Position     = toggled and UDim2.new(1,-18,0.5,0) or UDim2.new(0,2,0.5,0),
                    BackgroundColor3 = toggled and T.Background or T.TextDim,
                })
                task.spawn(cb, toggled)
            end

            local btn = Instance.new("TextButton")
            btn.BackgroundTransparency = 1
            btn.Size   = UDim2.new(1,0,1,0)
            btn.Text   = ""
            btn.ZIndex = 8
            btn.Parent = el
            btn.MouseEnter:Connect(function() Tw(el, EI.Smooth, {BackgroundColor3 = T.Hover}) end)
            btn.MouseLeave:Connect(function() Tw(el, EI.Smooth, {BackgroundColor3 = T.Surface}) end)
            btn.MouseButton1Click:Connect(function() Update(not toggled) end)

            local obj = {}
            function obj:Set(v) Update(v) end
            function obj:Get() return toggled end
            return obj
        end

        function Tab:CreateSlider(opts)
            opts = opts or {}
            local name   = opts.Name or "Slider"
            local min    = opts.Min or 0
            local max    = opts.Max or 100
            local def    = math.clamp(opts.Default or min, min, max)
            local suffix = opts.Suffix or ""
            local cb     = opts.Callback or function() end

            local value    = def
            local dragging = false
            local el = BaseEl(58)

            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.Size   = UDim2.new(1,0,1,0)
            inner.ZIndex = 5
            inner.Parent = el
            Pad(inner,10,10,14,14)

            local topRow = Instance.new("Frame")
            topRow.BackgroundTransparency = 1
            topRow.Size   = UDim2.new(1,0,0,18)
            topRow.ZIndex = 5
            topRow.Parent = inner

            local nameLbl = Lbl(topRow, name, 13, T.Text, Enum.Font.GothamMedium)
            nameLbl.Size  = UDim2.new(1,-60,1,0)
            nameLbl.ZIndex= 5

            local valLbl = Lbl(topRow, tostring(value)..suffix, 12, T.TextMuted, Enum.Font.Gotham, Enum.TextXAlignment.Right)
            valLbl.Size     = UDim2.new(0,55,1,0)
            valLbl.Position = UDim2.new(1,-55,0,0)
            valLbl.ZIndex   = 5

            local track = Instance.new("Frame")
            track.BackgroundColor3 = T.SliderTrack
            track.Position         = UDim2.new(0,0,1,-12)
            track.Size             = UDim2.new(1,0,0,5)
            track.ZIndex           = 6
            track.Parent           = inner
            Corner(track,3)
            Stroke(track, T.Border, 1)

            local fill = Instance.new("Frame")
            fill.BackgroundColor3 = T.SliderFill
            fill.Size             = UDim2.new((value-min)/(max-min),0,1,0)
            fill.ZIndex           = 7
            fill.Parent           = track
            Corner(fill,3)
            Grad(fill, T.Accent, T.AccentDim)

            local thumb = Instance.new("Frame")
            thumb.BackgroundColor3 = T.Text
            thumb.AnchorPoint      = Vector2.new(0.5,0.5)
            thumb.Position         = UDim2.new((value-min)/(max-min),0,0.5,0)
            thumb.Size             = UDim2.new(0,13,0,13)
            thumb.ZIndex           = 8
            thumb.Parent           = track
            Corner(thumb,7)
            Stroke(thumb, T.Border, 1)

            local hitbox = Instance.new("TextButton")
            hitbox.BackgroundTransparency = 1
            hitbox.AnchorPoint            = Vector2.new(0,0.5)
            hitbox.Position               = UDim2.new(0,0,0.5,0)
            hitbox.Size                   = UDim2.new(1,0,0,24)
            hitbox.Text                   = ""
            hitbox.ZIndex                 = 9
            hitbox.Parent                 = track

            local function SetVal(pct)
                pct   = math.clamp(pct,0,1)
                value = math.round(min + (max-min)*pct)
                valLbl.Text = tostring(value)..suffix
                Tw(fill,  EI.Linear, {Size = UDim2.new(pct,0,1,0)})
                Tw(thumb, EI.Linear, {Position = UDim2.new(pct,0,0.5,0)})
                task.spawn(cb, value)
            end

            hitbox.MouseButton1Down:Connect(function()
                dragging = true
                Tw(thumb, EI.Smooth, {Size = UDim2.new(0,16,0,16)})
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    if dragging then
                        dragging = false
                        Tw(thumb, EI.Smooth, {Size = UDim2.new(0,13,0,13)})
                    end
                end
            end)
            RunService.Heartbeat:Connect(function()
                if dragging then
                    local mx = UserInputService:GetMouseLocation().X
                    local tp = track.AbsolutePosition.X
                    local ts = track.AbsoluteSize.X
                    SetVal((mx - tp) / ts)
                end
            end)

            SetVal((value-min)/(max-min))

            local obj = {}
            function obj:Set(v) SetVal((math.clamp(v,min,max)-min)/(max-min)) end
            function obj:Get() return value end
            return obj
        end

        function Tab:CreateTextbox(opts)
            opts = opts or {}
            local name  = opts.Name or "Textbox"
            local ph    = opts.Placeholder or "Enter text..."
            local def   = opts.Default or ""
            local cb    = opts.Callback or function() end

            local el = BaseEl(58)

            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.Size   = UDim2.new(1,0,1,0)
            inner.ZIndex = 5
            inner.Parent = el
            Pad(inner,10,10,14,14)

            local nameLbl = Lbl(inner, name, 13, T.Text, Enum.Font.GothamMedium)
            nameLbl.Size   = UDim2.new(1,0,0,16)
            nameLbl.ZIndex = 5

            local inputBg = Instance.new("Frame")
            inputBg.BackgroundColor3 = T.Background
            inputBg.Position         = UDim2.new(0,0,1,-22)
            inputBg.Size             = UDim2.new(1,0,0,22)
            inputBg.ZIndex           = 6
            inputBg.Parent           = inner
            Corner(inputBg,6)
            local inputStroke = Stroke(inputBg, T.Border, 1)

            local tb = Instance.new("TextBox")
            tb.BackgroundTransparency = 1
            tb.Size             = UDim2.new(1,0,1,0)
            tb.Text             = def
            tb.PlaceholderText  = ph
            tb.TextSize         = 12
            tb.Font             = Enum.Font.Gotham
            tb.TextColor3       = T.Text
            tb.PlaceholderColor3= T.TextDim
            tb.TextXAlignment   = Enum.TextXAlignment.Left
            tb.ZIndex           = 7
            tb.Parent           = inputBg
            Pad(tb,0,0,8,8)

            tb.Focused:Connect(function()
                Tw(inputBg,    EI.Smooth, {BackgroundColor3 = T.Elevated})
                Tw(inputStroke, EI.Smooth, {Color = T.BorderLight})
            end)
            tb.FocusLost:Connect(function(enter)
                Tw(inputBg,    EI.Smooth, {BackgroundColor3 = T.Background})
                Tw(inputStroke, EI.Smooth, {Color = T.Border})
                if enter then task.spawn(cb, tb.Text) end
            end)

            local obj = {}
            function obj:Set(v) tb.Text = v end
            function obj:Get() return tb.Text end
            return obj
        end

        function Tab:CreateKeybind(opts)
            opts = opts or {}
            local name = opts.Name or "Keybind"
            local def  = opts.Default or Enum.KeyCode.Unknown
            local cb   = opts.Callback or function() end

            local cur      = def
            local listening= false
            local el = BaseEl(42)

            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.Size   = UDim2.new(1,0,1,0)
            inner.ZIndex = 5
            inner.Parent = el
            Pad(inner,0,0,14,14)

            local nameLbl = Lbl(inner, name, 13, T.Text, Enum.Font.GothamMedium)
            nameLbl.Size  = UDim2.new(1,-92,1,0)
            nameLbl.ZIndex= 5

            local kbg = Instance.new("TextButton")
            kbg.BackgroundColor3 = T.Background
            kbg.AnchorPoint      = Vector2.new(1,0.5)
            kbg.Position         = UDim2.new(1,0,0.5,0)
            kbg.Size             = UDim2.new(0,82,0,26)
            kbg.Text             = ""
            kbg.ZIndex           = 6
            kbg.Parent           = inner
            Corner(kbg,6)
            local kStroke = Stroke(kbg, T.Border, 1)

            local kLbl = Lbl(kbg, cur.Name, 11, T.TextMuted, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
            kLbl.Size   = UDim2.new(1,0,1,0)
            kLbl.ZIndex = 7

            kbg.MouseButton1Click:Connect(function()
                listening = not listening
                if listening then
                    kLbl.Text = "..."
                    Tw(kbg,    EI.Smooth, {BackgroundColor3 = T.Elevated})
                    Tw(kStroke, EI.Smooth, {Color = T.BorderLight})
                else
                    kLbl.Text = cur.Name
                    Tw(kbg,    EI.Smooth, {BackgroundColor3 = T.Background})
                    Tw(kStroke, EI.Smooth, {Color = T.Border})
                end
            end)

            UserInputService.InputBegan:Connect(function(inp, gp)
                if gp then return end
                if listening and inp.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    cur = inp.KeyCode
                    kLbl.Text = cur.Name
                    Tw(kbg,    EI.Smooth, {BackgroundColor3 = T.Background})
                    Tw(kStroke, EI.Smooth, {Color = T.Border})
                elseif not listening and inp.KeyCode == cur then
                    task.spawn(cb, cur)
                end
            end)

            local obj = {}
            function obj:Set(k) cur = k; kLbl.Text = k.Name end
            function obj:Get() return cur end
            return obj
        end

        local function MakeArrow(parent, zindex)
            local arr = Lbl(parent, "▼", 9, T.TextDim, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
            arr.Size     = UDim2.new(0,20,1,0)
            arr.Position = UDim2.new(1,-24,0,0)
            arr.ZIndex   = zindex or 6
            return arr
        end

        function Tab:CreateDropdown(opts)
            opts = opts or {}
            local name  = opts.Name or "Dropdown"
            local items = opts.Items or {}
            local def   = opts.Default or (items[1] or "")
            local cb    = opts.Callback or function() end

            local selected = def
            local isOpen   = false
            local closeDD  = nil

            local el = BaseEl(42)

            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.Size   = UDim2.new(1,0,1,0)
            inner.ZIndex = 5
            inner.Parent = el
            Pad(inner,0,0,14,14)

            local nameLbl = Lbl(inner, name, 13, T.Text, Enum.Font.GothamMedium)
            nameLbl.Size  = UDim2.new(0.5,0,1,0)
            nameLbl.ZIndex= 5

            local selLbl = Lbl(inner, selected ~= "" and selected or "Select...", 12, T.TextMuted, Enum.Font.Gotham, Enum.TextXAlignment.Right)
            selLbl.Size     = UDim2.new(0.5,-28,1,0)
            selLbl.Position = UDim2.new(0.5,0,0,0)
            selLbl.ZIndex   = 5

            local arr = MakeArrow(inner, 6)

            local function Close()
                isOpen = false
                Tw(arr, EI.Smooth, {Rotation = 0, TextColor3 = T.TextDim})
                Tw(el,  EI.Smooth, {BackgroundColor3 = T.Surface})
                if closeDD then closeDD() end
                closeDD = nil
            end

            local function Open()
                isOpen = true
                Tw(arr, EI.Smooth, {Rotation = 180, TextColor3 = T.AccentDim})
                Tw(el,  EI.Smooth, {BackgroundColor3 = T.Hover})

                local itemH = 34
                local total = math.min(#items * itemH, 170)

                closeDD = OpenDropPortal(el, total, function(panel)
                    local lay = Instance.new("UIListLayout")
                    lay.SortOrder = Enum.SortOrder.LayoutOrder
                    lay.Parent    = panel

                    for i, item in ipairs(items) do
                        local row = Instance.new("Frame")
                        row.BackgroundColor3      = T.Elevated
                        row.BackgroundTransparency = selected == item and 0 or 1
                        row.Size                  = UDim2.new(1,0,0,itemH)
                        row.ZIndex                = 201
                        row.Parent                = panel

                        local rowLbl = Lbl(row, item, 12, selected == item and T.Text or T.TextMuted, Enum.Font.GothamMedium)
                        rowLbl.Size     = UDim2.new(1,-36,1,0)
                        rowLbl.Position = UDim2.new(0,12,0,0)
                        rowLbl.ZIndex   = 202

                        if selected == item then
                            local chk = Lbl(row, "✓", 11, T.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
                            chk.Size     = UDim2.new(0,22,1,0)
                            chk.Position = UDim2.new(1,-26,0,0)
                            chk.ZIndex   = 202
                        end

                        local rowBtn = Instance.new("TextButton")
                        rowBtn.BackgroundTransparency = 1
                        rowBtn.Size   = UDim2.new(1,0,1,0)
                        rowBtn.Text   = ""
                        rowBtn.ZIndex = 203
                        rowBtn.Parent = row

                        rowBtn.MouseEnter:Connect(function()
                            if selected ~= item then
                                Tw(row,    EI.Smooth, {BackgroundTransparency = 0.5, BackgroundColor3 = T.Hover})
                                Tw(rowLbl, EI.Smooth, {TextColor3 = T.AccentDim})
                            end
                        end)
                        rowBtn.MouseLeave:Connect(function()
                            if selected ~= item then
                                Tw(row,    EI.Smooth, {BackgroundTransparency = 1})
                                Tw(rowLbl, EI.Smooth, {TextColor3 = T.TextMuted})
                            end
                        end)
                        rowBtn.MouseButton1Click:Connect(function()
                            selected    = item
                            selLbl.Text = item
                            Close()
                            task.spawn(cb, selected)
                        end)
                    end
                end, function()
                    isOpen = false
                    Tw(arr, EI.Smooth, {Rotation = 0, TextColor3 = T.TextDim})
                    Tw(el,  EI.Smooth, {BackgroundColor3 = T.Surface})
                end)
            end

            local hbtn = Instance.new("TextButton")
            hbtn.BackgroundTransparency = 1
            hbtn.Size   = UDim2.new(1,0,1,0)
            hbtn.Text   = ""
            hbtn.ZIndex = 7
            hbtn.Parent = el

            hbtn.MouseEnter:Connect(function()
                if not isOpen then Tw(el, EI.Smooth, {BackgroundColor3 = T.Hover}) end
            end)
            hbtn.MouseLeave:Connect(function()
                if not isOpen then Tw(el, EI.Smooth, {BackgroundColor3 = T.Surface}) end
            end)
            hbtn.MouseButton1Click:Connect(function()
                if isOpen then Close() else Open() end
            end)

            local obj = {}
            function obj:Set(v) selected = v; selLbl.Text = v end
            function obj:Get() return selected end
            function obj:Refresh(newItems) items = newItems end
            return obj
        end

        function Tab:CreateSearchableDropdown(opts)
            opts = opts or {}
            local name  = opts.Name or "Search Dropdown"
            local items = opts.Items or {}
            local def   = opts.Default or ""
            local cb    = opts.Callback or function() end

            local selected = def
            local isOpen   = false
            local closeDD  = nil

            local el = BaseEl(42)

            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.Size   = UDim2.new(1,0,1,0)
            inner.ZIndex = 5
            inner.Parent = el
            Pad(inner,0,0,14,14)

            local nameLbl = Lbl(inner, name, 13, T.Text, Enum.Font.GothamMedium)
            nameLbl.Size  = UDim2.new(0.5,0,1,0)
            nameLbl.ZIndex= 5

            local selLbl = Lbl(inner, selected ~= "" and selected or "Select...", 12, T.TextMuted, Enum.Font.Gotham, Enum.TextXAlignment.Right)
            selLbl.Size     = UDim2.new(0.5,-28,1,0)
            selLbl.Position = UDim2.new(0.5,0,0,0)
            selLbl.ZIndex   = 5

            local arr = MakeArrow(inner, 6)

            local function Close()
                isOpen = false
                Tw(arr, EI.Smooth, {Rotation = 0, TextColor3 = T.TextDim})
                Tw(el,  EI.Smooth, {BackgroundColor3 = T.Surface})
                if closeDD then closeDD() end
                closeDD = nil
            end

            local function Open()
                isOpen = true
                Tw(arr, EI.Smooth, {Rotation = 180, TextColor3 = T.AccentDim})
                Tw(el,  EI.Smooth, {BackgroundColor3 = T.Hover})

                closeDD = OpenDropPortal(el, 180, function(panel)
                    local searchBg = Instance.new("Frame")
                    searchBg.BackgroundColor3 = T.Background
                    searchBg.Size             = UDim2.new(1,0,0,34)
                    searchBg.ZIndex           = 201
                    searchBg.Parent           = panel
                    Pad(searchBg,0,0,8,8)
                    Corner(searchBg, 0)

                    local searchLine = Instance.new("Frame")
                    searchLine.BackgroundColor3 = T.Border
                    searchLine.Position         = UDim2.new(0,0,1,0)
                    searchLine.Size             = UDim2.new(1,0,0,1)
                    searchLine.ZIndex           = 202
                    searchLine.Parent           = searchBg

                    local stb = Instance.new("TextBox")
                    stb.BackgroundTransparency = 1
                    stb.Size                   = UDim2.new(1,0,1,0)
                    stb.PlaceholderText        = "Search..."
                    stb.Text                   = ""
                    stb.TextSize               = 12
                    stb.Font                   = Enum.Font.Gotham
                    stb.TextColor3             = T.Text
                    stb.PlaceholderColor3      = T.TextDim
                    stb.TextXAlignment         = Enum.TextXAlignment.Left
                    stb.ZIndex                 = 202
                    stb.Parent                 = searchBg

                    local scroll = Instance.new("ScrollingFrame")
                    scroll.BackgroundTransparency = 1
                    scroll.Position               = UDim2.new(0,0,0,34)
                    scroll.Size                   = UDim2.new(1,0,1,-34)
                    scroll.ScrollBarThickness      = 2
                    scroll.ScrollBarImageColor3    = T.ScrollBar
                    scroll.CanvasSize              = UDim2.new(0,0,0,0)
                    scroll.ZIndex                  = 201
                    scroll.Parent                  = panel

                    local lay = Instance.new("UIListLayout")
                    lay.SortOrder = Enum.SortOrder.LayoutOrder
                    lay.Parent    = scroll

                    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                        scroll.CanvasSize = UDim2.new(0,0,0, lay.AbsoluteContentSize.Y)
                    end)

                    local function Rebuild(q)
                        for _, c in pairs(scroll:GetChildren()) do
                            if c:IsA("Frame") then c:Destroy() end
                        end
                        for _, item in ipairs(items) do
                            if q == "" or item:lower():find(q:lower(), 1, true) then
                                local row = Instance.new("Frame")
                                row.BackgroundColor3      = T.Elevated
                                row.BackgroundTransparency = selected == item and 0 or 1
                                row.Size                  = UDim2.new(1,0,0,34)
                                row.ZIndex                = 202
                                row.Parent                = scroll

                                local rLbl = Lbl(row, item, 12, selected == item and T.Text or T.TextMuted, Enum.Font.GothamMedium)
                                rLbl.Size     = UDim2.new(1,-12,1,0)
                                rLbl.Position = UDim2.new(0,12,0,0)
                                rLbl.ZIndex   = 203

                                local rBtn = Instance.new("TextButton")
                                rBtn.BackgroundTransparency = 1
                                rBtn.Size   = UDim2.new(1,0,1,0)
                                rBtn.Text   = ""
                                rBtn.ZIndex = 204
                                rBtn.Parent = row

                                rBtn.MouseEnter:Connect(function()
                                    if selected ~= item then
                                        Tw(row,  EI.Smooth, {BackgroundTransparency = 0.5, BackgroundColor3 = T.Hover})
                                        Tw(rLbl, EI.Smooth, {TextColor3 = T.AccentDim})
                                    end
                                end)
                                rBtn.MouseLeave:Connect(function()
                                    if selected ~= item then
                                        Tw(row,  EI.Smooth, {BackgroundTransparency = 1})
                                        Tw(rLbl, EI.Smooth, {TextColor3 = T.TextMuted})
                                    end
                                end)
                                rBtn.MouseButton1Click:Connect(function()
                                    selected    = item
                                    selLbl.Text = item
                                    Close()
                                    task.spawn(cb, selected)
                                end)
                            end
                        end
                    end

                    stb:GetPropertyChangedSignal("Text"):Connect(function()
                        Rebuild(stb.Text)
                    end)
                    Rebuild("")
                    task.defer(function() stb:CaptureFocus() end)
                end, function()
                    isOpen = false
                    Tw(arr, EI.Smooth, {Rotation = 0, TextColor3 = T.TextDim})
                    Tw(el,  EI.Smooth, {BackgroundColor3 = T.Surface})
                end)
            end

            local hbtn = Instance.new("TextButton")
            hbtn.BackgroundTransparency = 1
            hbtn.Size   = UDim2.new(1,0,1,0)
            hbtn.Text   = ""
            hbtn.ZIndex = 7
            hbtn.Parent = el

            hbtn.MouseEnter:Connect(function()
                if not isOpen then Tw(el, EI.Smooth, {BackgroundColor3 = T.Hover}) end
            end)
            hbtn.MouseLeave:Connect(function()
                if not isOpen then Tw(el, EI.Smooth, {BackgroundColor3 = T.Surface}) end
            end)
            hbtn.MouseButton1Click:Connect(function()
                if isOpen then Close() else Open() end
            end)

            local obj = {}
            function obj:Set(v) selected = v; selLbl.Text = v end
            function obj:Get() return selected end
            return obj
        end

        function Tab:CreateMultiDropdown(opts)
            opts = opts or {}
            local name  = opts.Name or "Multi Dropdown"
            local items = opts.Items or {}
            local def   = opts.Default or {}
            local cb    = opts.Callback or function() end

            local sel  = {}
            for _, v in ipairs(def) do sel[v] = true end

            local isOpen  = false
            local closeDD = nil

            local el = BaseEl(42)

            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.Size   = UDim2.new(1,0,1,0)
            inner.ZIndex = 5
            inner.Parent = el
            Pad(inner,0,0,14,14)

            local nameLbl = Lbl(inner, name, 13, T.Text, Enum.Font.GothamMedium)
            nameLbl.Size  = UDim2.new(0.5,0,1,0)
            nameLbl.ZIndex= 5

            local selLbl = Lbl(inner, "None", 12, T.TextMuted, Enum.Font.Gotham, Enum.TextXAlignment.Right)
            selLbl.Size     = UDim2.new(0.5,-28,1,0)
            selLbl.Position = UDim2.new(0.5,0,0,0)
            selLbl.ZIndex   = 5

            local arr = MakeArrow(inner, 6)

            local function GetText()
                local parts = {}
                for k,v in pairs(sel) do if v then table.insert(parts,k) end end
                if #parts == 0 then return "None" end
                if #parts > 2  then return #parts.." selected" end
                return table.concat(parts,", ")
            end

            local function Close()
                isOpen = false
                Tw(arr, EI.Smooth, {Rotation = 0, TextColor3 = T.TextDim})
                Tw(el,  EI.Smooth, {BackgroundColor3 = T.Surface})
                if closeDD then closeDD() end
                closeDD = nil
            end

            local function Open()
                isOpen = true
                Tw(arr, EI.Smooth, {Rotation = 180, TextColor3 = T.AccentDim})
                Tw(el,  EI.Smooth, {BackgroundColor3 = T.Hover})

                local itemH = 34
                local total = math.min(#items * itemH, 170)

                closeDD = OpenDropPortal(el, total, function(panel)
                    local lay = Instance.new("UIListLayout")
                    lay.SortOrder = Enum.SortOrder.LayoutOrder
                    lay.Parent    = panel

                    local rowMap = {}

                    local function RefreshRows()
                        for item, row in pairs(rowMap) do
                            local on = sel[item]
                            Tw(row.bg,  EI.Smooth, {BackgroundColor3 = on and T.Elevated or T.Background, BackgroundTransparency = on and 0 or 1})
                            Tw(row.lbl, EI.Smooth, {TextColor3 = on and T.Text or T.TextMuted})
                            row.chk.Text = on and "✓" or ""
                            Tw(row.chk, EI.Smooth, {TextColor3 = on and T.Accent or T.TextDim})
                        end
                        selLbl.Text = GetText()
                    end

                    for _, item in ipairs(items) do
                        local row = Instance.new("Frame")
                        row.BackgroundColor3      = sel[item] and T.Elevated or T.Background
                        row.BackgroundTransparency = sel[item] and 0 or 1
                        row.Size                  = UDim2.new(1,0,0,itemH)
                        row.ZIndex                = 201
                        row.Parent                = panel

                        local rLbl = Lbl(row, item, 12, sel[item] and T.Text or T.TextMuted, Enum.Font.GothamMedium)
                        rLbl.Size     = UDim2.new(1,-38,1,0)
                        rLbl.Position = UDim2.new(0,12,0,0)
                        rLbl.ZIndex   = 202

                        local chk = Lbl(row, sel[item] and "✓" or "", 11, T.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
                        chk.Size     = UDim2.new(0,24,1,0)
                        chk.Position = UDim2.new(1,-28,0,0)
                        chk.ZIndex   = 202

                        rowMap[item] = {bg = row, lbl = rLbl, chk = chk}

                        local rBtn = Instance.new("TextButton")
                        rBtn.BackgroundTransparency = 1
                        rBtn.Size   = UDim2.new(1,0,1,0)
                        rBtn.Text   = ""
                        rBtn.ZIndex = 203
                        rBtn.Parent = row

                        rBtn.MouseEnter:Connect(function()
                            if not sel[item] then
                                Tw(row, EI.Smooth, {BackgroundTransparency = 0.6, BackgroundColor3 = T.Hover})
                            end
                        end)
                        rBtn.MouseLeave:Connect(function()
                            if not sel[item] then
                                Tw(row, EI.Smooth, {BackgroundTransparency = 1})
                            end
                        end)
                        rBtn.MouseButton1Click:Connect(function()
                            sel[item] = not sel[item]
                            RefreshRows()
                            local result = {}
                            for k,v in pairs(sel) do if v then table.insert(result,k) end end
                            task.spawn(cb, result)
                        end)
                    end
                end, function()
                    isOpen = false
                    Tw(arr, EI.Smooth, {Rotation = 0, TextColor3 = T.TextDim})
                    Tw(el,  EI.Smooth, {BackgroundColor3 = T.Surface})
                end)
            end

            local hbtn = Instance.new("TextButton")
            hbtn.BackgroundTransparency = 1
            hbtn.Size   = UDim2.new(1,0,1,0)
            hbtn.Text   = ""
            hbtn.ZIndex = 7
            hbtn.Parent = el

            hbtn.MouseEnter:Connect(function()
                if not isOpen then Tw(el, EI.Smooth, {BackgroundColor3 = T.Hover}) end
            end)
            hbtn.MouseLeave:Connect(function()
                if not isOpen then Tw(el, EI.Smooth, {BackgroundColor3 = T.Surface}) end
            end)
            hbtn.MouseButton1Click:Connect(function()
                if isOpen then Close() else Open() end
            end)

            local obj = {}
            function obj:Get()
                local result = {}
                for k,v in pairs(sel) do if v then table.insert(result,k) end end
                return result
            end
            function obj:Set(values)
                sel = {}
                for _,v in ipairs(values) do sel[v] = true end
                selLbl.Text = GetText()
            end
            return obj
        end

        function Tab:CreateLabel(opts)
            opts = opts or {}
            local txt = opts.Text or ""

            local el = Instance.new("Frame")
            el.BackgroundTransparency = 1
            el.Size        = UDim2.new(1,0,0,22)
            el.LayoutOrder = NO()
            el.ZIndex      = 4
            el.Parent      = TabPage
            Pad(el,0,0,4,4)

            local lbl = Lbl(el, txt, 12, T.TextMuted, Enum.Font.Gotham)
            lbl.Size   = UDim2.new(1,0,1,0)
            lbl.ZIndex = 5

            local obj = {}
            function obj:Set(v) lbl.Text = v end
            function obj:Get() return lbl.Text end
            return obj
        end

        function Tab:CreateParagraph(opts)
            opts = opts or {}
            local heading = opts.Title or ""
            local body    = opts.Content or ""

            local el = Instance.new("Frame")
            el.BackgroundColor3 = T.Surface
            el.AutomaticSize    = Enum.AutomaticSize.Y
            el.Size             = UDim2.new(1,0,0,0)
            el.LayoutOrder      = NO()
            el.ZIndex           = 4
            el.Parent           = TabPage
            Corner(el,8)
            Stroke(el, T.Border, 1)
            Grad(el, T.Grad0, T.Grad1)

            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.AutomaticSize = Enum.AutomaticSize.Y
            inner.Size          = UDim2.new(1,0,0,0)
            inner.ZIndex        = 5
            inner.Parent        = el
            Pad(inner,12,12,14,14)

            local iLay = Instance.new("UIListLayout")
            iLay.SortOrder = Enum.SortOrder.LayoutOrder
            iLay.Padding   = UDim.new(0,5)
            iLay.Parent    = inner

            if heading ~= "" then
                local hLbl = Lbl(inner, heading, 13, T.Text, Enum.Font.GothamBold)
                hLbl.Size        = UDim2.new(1,0,0,16)
                hLbl.LayoutOrder = 0
                hLbl.ZIndex      = 5
            end

            local bLbl = Lbl(inner, body, 12, T.TextMuted, Enum.Font.Gotham)
            bLbl.AutomaticSize = Enum.AutomaticSize.Y
            bLbl.Size          = UDim2.new(1,0,0,0)
            bLbl.TextWrapped   = true
            bLbl.LayoutOrder   = 1
            bLbl.ZIndex        = 5

            local obj = {}
            function obj:SetContent(v) bLbl.Text = v end
            function obj:SetTitle(v)
                if heading ~= "" then end
            end
            return obj
        end

        function Tab:CreateThemeChanger(opts)
            opts = opts or {}
            local name = opts.Name or "Theme"

            local themeNames = {}
            for k in pairs(Themes) do table.insert(themeNames, k) end
            table.sort(themeNames)

            return self:CreateDropdown({
                Name  = name,
                Items = themeNames,
                Default = CurrentTheme,
                Callback = function(v)
                    ApplyTheme(v)
                end,
            })
        end

        return Tab
    end

    function WindowObj:Notify(opts)
        Library:Notify(opts)
    end

    return WindowObj
end

return Library
