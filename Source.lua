local LawXW = {}
LawXW.__index = LawXW

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local CONFIG = {
    Font = Enum.Font.GothamBold,
    FontLight = Enum.Font.Gotham,
    Primary = Color3.fromRGB(10, 10, 10),
    Secondary = Color3.fromRGB(18, 18, 18),
    Surface = Color3.fromRGB(24, 24, 24),
    Border = Color3.fromRGB(40, 40, 40),
    Accent = Color3.fromRGB(255, 255, 255),
    AccentDim = Color3.fromRGB(180, 180, 180),
    TextMain = Color3.fromRGB(240, 240, 240),
    TextSub = Color3.fromRGB(130, 130, 130),
    ToggleOn = Color3.fromRGB(220, 220, 220),
    ToggleOff = Color3.fromRGB(50, 50, 50),
    SliderFill = Color3.fromRGB(200, 200, 200),
    SliderBg = Color3.fromRGB(35, 35, 35),
    Hover = Color3.fromRGB(32, 32, 32),
    DropHover = Color3.fromRGB(36, 36, 36),
    Selected = Color3.fromRGB(45, 45, 45),
    NotifBg = Color3.fromRGB(16, 16, 16),
    WindowW = 480,
    WindowH = 360,
    TabH = 32,
    ItemH = 38,
    Padding = 10,
    Radius = 8,
    AnimSpeed = 0.18,
    ToggleKey = Enum.KeyCode.RightShift,
}

local SavedConfig = {}

local function tween(obj, props, t, style, dir)
    local ti = TweenInfo.new(t or CONFIG.AnimSpeed, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    TweenService:Create(obj, ti, props):Play()
end

local function makeShadow(parent, size)
    local s = Instance.new("ImageLabel")
    s.Name = "Shadow"
    s.AnchorPoint = Vector2.new(0.5, 0.5)
    s.BackgroundTransparency = 1
    s.Position = UDim2.new(0.5, 0, 0.5, 4)
    s.Size = UDim2.new(1, size or 30, 1, size or 30)
    s.ZIndex = parent.ZIndex - 1
    s.Image = "rbxassetid://6014261993"
    s.ImageColor3 = Color3.fromRGB(0, 0, 0)
    s.ImageTransparency = 0.5
    s.ScaleType = Enum.ScaleType.Slice
    s.SliceCenter = Rect.new(49, 49, 450, 450)
    s.Parent = parent
    return s
end

local function corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or CONFIG.Radius)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thick)
    local s = Instance.new("UIStroke")
    s.Color = color or CONFIG.Border
    s.Thickness = thick or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function pad(parent, all, top, bot, left, right)
    local p = Instance.new("UIPadding")
    if all then
        p.PaddingTop = UDim.new(0, all)
        p.PaddingBottom = UDim.new(0, all)
        p.PaddingLeft = UDim.new(0, all)
        p.PaddingRight = UDim.new(0, all)
    else
        p.PaddingTop = UDim.new(0, top or 0)
        p.PaddingBottom = UDim.new(0, bot or 0)
        p.PaddingLeft = UDim.new(0, left or 0)
        p.PaddingRight = UDim.new(0, right or 0)
    end
    p.Parent = parent
    return p
end

local function listLayout(parent, dir, spacing)
    local l = Instance.new("UIListLayout")
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Padding = UDim.new(0, spacing or 6)
    l.Parent = parent
    return l
end

local function label(parent, text, size, color, font, xalign)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text or ""
    l.TextSize = size or 13
    l.TextColor3 = color or CONFIG.TextMain
    l.Font = font or CONFIG.FontLight
    l.TextXAlignment = xalign or Enum.TextXAlignment.Left
    l.AutomaticSize = Enum.AutomaticSize.XY
    l.Parent = parent
    return l
end

local function frame(parent, bg, size, pos)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = bg or CONFIG.Surface
    f.Size = size or UDim2.new(1, 0, 0, 40)
    if pos then f.Position = pos end
    f.BorderSizePixel = 0
    f.Parent = parent
    return f
end

local function scrollFrame(parent, size)
    local sf = Instance.new("ScrollingFrame")
    sf.BackgroundTransparency = 1
    sf.Size = size or UDim2.new(1, 0, 1, 0)
    sf.BorderSizePixel = 0
    sf.ScrollBarThickness = 3
    sf.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    sf.CanvasSize = UDim2.new(0, 0, 0, 0)
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.ScrollingDirection = Enum.ScrollingDirection.Y
    sf.ElasticBehavior = Enum.ElasticBehavior.Never
    sf.Parent = parent
    return sf
end

local function button(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = CONFIG.Surface
    btn.Size = UDim2.new(1, 0, 0, CONFIG.ItemH)
    btn.Text = text or "Button"
    btn.TextColor3 = CONFIG.TextMain
    btn.TextSize = 13
    btn.Font = CONFIG.FontLight
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.Parent = parent

    corner(btn)
    stroke(btn)

    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundColor3 = CONFIG.Hover})
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundColor3 = CONFIG.Surface})
    end)
    btn.MouseButton1Down:Connect(function()
        tween(btn, {BackgroundColor3 = CONFIG.Selected}, 0.08)
    end)
    btn.MouseButton1Up:Connect(function()
        tween(btn, {BackgroundColor3 = CONFIG.Hover}, 0.08)
        if callback then callback() end
    end)

    -- Touch support
    btn.TouchTap:Connect(function()
        tween(btn, {BackgroundColor3 = CONFIG.Selected}, 0.08)
        task.delay(0.12, function()
            tween(btn, {BackgroundColor3 = CONFIG.Surface})
            if callback then callback() end
        end)
    end)

    return btn
end

local NotifContainer = nil

local function initNotifContainer()
    if NotifContainer and NotifContainer.Parent then return end
    local sc = Instance.new("ScreenGui")
    sc.Name = "LawXW_Notifs"
    sc.ResetOnSpawn = false
    sc.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sc.DisplayOrder = 9999
    pcall(function() sc.Parent = CoreGui end)
    if not sc.Parent then sc.Parent = LocalPlayer.PlayerGui end

    NotifContainer = Instance.new("Frame")
    NotifContainer.Name = "Container"
    NotifContainer.BackgroundTransparency = 1
    NotifContainer.AnchorPoint = Vector2.new(1, 1)
    NotifContainer.Position = UDim2.new(1, -16, 1, -16)
    NotifContainer.Size = UDim2.new(0, 280, 1, -32)
    NotifContainer.Parent = sc

    local l = Instance.new("UIListLayout")
    l.FillDirection = Enum.FillDirection.Vertical
    l.VerticalAlignment = Enum.VerticalAlignment.Bottom
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Padding = UDim.new(0, 8)
    l.Parent = NotifContainer
end

function LawXW:Notify(title, text, duration)
    initNotifContainer()
    duration = duration or 4

    local nf = Instance.new("Frame")
    nf.BackgroundColor3 = CONFIG.NotifBg
    nf.Size = UDim2.new(1, 0, 0, 64)
    nf.BackgroundTransparency = 1
    nf.ClipsDescendants = true
    nf.Parent = NotifContainer

    corner(nf)
    stroke(nf, CONFIG.Border)

    local bar = Instance.new("Frame")
    bar.BackgroundColor3 = CONFIG.Accent
    bar.Size = UDim2.new(0, 3, 1, 0)
    bar.BorderSizePixel = 0
    bar.Parent = nf
    corner(bar, 2)

    local inner = Instance.new("Frame")
    inner.BackgroundTransparency = 1
    inner.Size = UDim2.new(1, -18, 1, 0)
    inner.Position = UDim2.new(0, 14, 0, 0)
    inner.Parent = nf

    local tl = label(inner, title or "Notice", 13, CONFIG.TextMain, CONFIG.Font)
    tl.Position = UDim2.new(0, 0, 0, 10)
    tl.Size = UDim2.new(1, 0, 0, 16)
    tl.AutomaticSize = Enum.AutomaticSize.None
    tl.TextTruncate = Enum.TextTruncate.AtEnd

    local tx = label(inner, text or "", 11, CONFIG.TextSub, CONFIG.FontLight)
    tx.Position = UDim2.new(0, 0, 0, 30)
    tx.Size = UDim2.new(1, 0, 0, 24)
    tx.AutomaticSize = Enum.AutomaticSize.None
    tx.TextWrapped = true
    tx.TextTruncate = Enum.TextTruncate.AtEnd

    tween(nf, {BackgroundTransparency = 0}, 0.2)

    task.delay(duration, function()
        tween(nf, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)}, 0.3)
        task.delay(0.35, function()
            nf:Destroy()
        end)
    end)
end

function LawXW:SaveConfig(name, data)
    SavedConfig[name] = data
    if writefile then
        pcall(function()
            if not isfolder("LawXW") then makefolder("LawXW") end
            writefile("LawXW/" .. name .. ".json", game:GetService("HttpService"):JSONEncode(data))
        end)
    end
end

function LawXW:LoadConfig(name)
    if SavedConfig[name] then return SavedConfig[name] end
    if readfile then
        local ok, res = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile("LawXW/" .. name .. ".json"))
        end)
        if ok then return res end
    end
    return nil
end

function LawXW:CreateWindow(options)
    options = options or {}
    local title = options.Title or "Law-XW"
    local subtitle = options.Subtitle or ""
    local toggleKey = options.ToggleKey or CONFIG.ToggleKey

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LawXW_" .. title
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 100

    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

    -- Loading Screen
    local LoadGui = Instance.new("Frame")
    LoadGui.Name = "Loader"
    LoadGui.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
    LoadGui.Size = UDim2.new(1, 0, 1, 0)
    LoadGui.ZIndex = 200
    LoadGui.Parent = ScreenGui

    local loadInner = Instance.new("Frame")
    loadInner.BackgroundTransparency = 1
    loadInner.AnchorPoint = Vector2.new(0.5, 0.5)
    loadInner.Position = UDim2.new(0.5, 0, 0.5, 0)
    loadInner.Size = UDim2.new(0, 260, 0, 100)
    loadInner.ZIndex = 201
    loadInner.Parent = LoadGui

    local logoText = Instance.new("TextLabel")
    logoText.BackgroundTransparency = 1
    logoText.Size = UDim2.new(1, 0, 0, 36)
    logoText.Text = "LAW-XW"
    logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    logoText.TextSize = 28
    logoText.Font = CONFIG.Font
    logoText.TextXAlignment = Enum.TextXAlignment.Center
    logoText.TextTransparency = 1
    logoText.ZIndex = 202
    logoText.Parent = loadInner

    local loadSub = Instance.new("TextLabel")
    loadSub.BackgroundTransparency = 1
    loadSub.Position = UDim2.new(0, 0, 0, 40)
    loadSub.Size = UDim2.new(1, 0, 0, 18)
    loadSub.Text = "Loading Law-XW..."
    loadSub.TextColor3 = CONFIG.TextSub
    loadSub.TextSize = 11
    loadSub.Font = CONFIG.FontLight
    loadSub.TextXAlignment = Enum.TextXAlignment.Center
    loadSub.TextTransparency = 1
    loadSub.ZIndex = 202
    loadSub.Parent = loadInner

    local barBg = Instance.new("Frame")
    barBg.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    barBg.Position = UDim2.new(0, 0, 0, 68)
    barBg.Size = UDim2.new(1, 0, 0, 3)
    barBg.BorderSizePixel = 0
    barBg.ZIndex = 202
    barBg.BackgroundTransparency = 1
    barBg.Parent = loadInner
    corner(barBg, 2)

    local barFill = Instance.new("Frame")
    barFill.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 203
    barFill.Parent = barBg
    corner(barFill, 2)

    -- Animate loading screen
    task.spawn(function()
        task.wait(0.1)
        tween(logoText, {TextTransparency = 0}, 0.5)
        tween(loadSub, {TextTransparency = 0}, 0.5)
        tween(barBg, {BackgroundTransparency = 0}, 0.5)
        task.wait(0.4)
        tween(barFill, {Size = UDim2.new(0.6, 0, 1, 0)}, 0.6, Enum.EasingStyle.Quart)
        task.wait(0.7)
        tween(barFill, {Size = UDim2.new(1, 0, 1, 0)}, 0.4, Enum.EasingStyle.Quart)
        task.wait(0.5)
        tween(LoadGui, {BackgroundTransparency = 1}, 0.4)
        tween(logoText, {TextTransparency = 1}, 0.3)
        tween(loadSub, {TextTransparency = 1}, 0.3)
        tween(barBg, {BackgroundTransparency = 1}, 0.3)
        task.wait(0.45)
        LoadGui:Destroy()
    end)

    -- Main Window
    local Win = Instance.new("Frame")
    Win.Name = "Window"
    Win.BackgroundColor3 = CONFIG.Primary
    Win.AnchorPoint = Vector2.new(0.5, 0.5)
    Win.Position = UDim2.new(0.5, 0, 0.5, 0)
    Win.Size = UDim2.new(0, CONFIG.WindowW, 0, CONFIG.WindowH)
    Win.ClipsDescendants = true
    Win.BackgroundTransparency = 1
    Win.ZIndex = 10
    Win.Parent = ScreenGui

    corner(Win)
    stroke(Win, CONFIG.Border)
    makeShadow(Win, 40)

    task.delay(1.6, function()
        tween(Win, {BackgroundTransparency = 0}, 0.35)
    end)

    -- Draggable
    local dragging, dragStart, startPos = false, nil, nil

    local function dragInput(input)
        if dragging then
            local delta = input.Position - dragStart
            local np = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
            Win.Position = np
        end
    end

    -- Title bar
    local TitleBar = frame(Win, CONFIG.Secondary, UDim2.new(1, 0, 0, 46))
    TitleBar.ZIndex = 11

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 14, 0, 0)
    TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    TitleLabel.Text = title
    TitleLabel.TextColor3 = CONFIG.TextMain
    TitleLabel.TextSize = 15
    TitleLabel.Font = CONFIG.Font
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 12
    TitleLabel.Parent = TitleBar

    if subtitle ~= "" then
        local SubLabel = Instance.new("TextLabel")
        SubLabel.BackgroundTransparency = 1
        SubLabel.Position = UDim2.new(0, 14, 0, 26)
        SubLabel.Size = UDim2.new(0.7, 0, 0, 14)
        SubLabel.Text = subtitle
        SubLabel.TextColor3 = CONFIG.TextSub
        SubLabel.TextSize = 10
        SubLabel.Font = CONFIG.FontLight
        SubLabel.TextXAlignment = Enum.TextXAlignment.Left
        SubLabel.ZIndex = 12
        SubLabel.Parent = TitleBar
    end

    -- Drag logic
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Win.Position
        end
    end)
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput(input)
        end
    end)

    -- Divider under title
    local Div = frame(Win, CONFIG.Border, UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 0, 46))
    Div.ZIndex = 11

    -- Tab Bar
    local TabBar = frame(Win, CONFIG.Secondary, UDim2.new(1, 0, 0, CONFIG.TabH), UDim2.new(0, 0, 0, 47))
    TabBar.ZIndex = 11

    local TabList = Instance.new("Frame")
    TabList.BackgroundTransparency = 1
    TabList.Size = UDim2.new(1, 0, 1, 0)
    TabList.ZIndex = 12
    TabList.Parent = TabBar

    local tll = Instance.new("UIListLayout")
    tll.FillDirection = Enum.FillDirection.Horizontal
    tll.SortOrder = Enum.SortOrder.LayoutOrder
    tll.Padding = UDim.new(0, 0)
    tll.Parent = TabList

    -- Content area
    local ContentArea = frame(Win, CONFIG.Primary, UDim2.new(1, 0, 1, -80), UDim2.new(0, 0, 0, 80))
    ContentArea.ZIndex = 10
    ContentArea.ClipsDescendants = true

    -- Mobile toggle button (ScreenGui level)
    local MobileToggle = Instance.new("TextButton")
    MobileToggle.Name = "MobileToggle"
    MobileToggle.BackgroundColor3 = CONFIG.Secondary
    MobileToggle.Size = UDim2.new(0, 44, 0, 44)
    MobileToggle.Position = UDim2.new(0, 16, 1, -60)
    MobileToggle.Text = "☰"
    MobileToggle.TextColor3 = CONFIG.TextMain
    MobileToggle.TextSize = 20
    MobileToggle.Font = CONFIG.Font
    MobileToggle.ZIndex = 50
    MobileToggle.Parent = ScreenGui
    corner(MobileToggle)
    stroke(MobileToggle)
    makeShadow(MobileToggle, 16)

    local winVisible = true

    local function toggleWindow()
        winVisible = not winVisible
        if winVisible then
            Win.Visible = true
            tween(Win, {BackgroundTransparency = 0}, 0.22)
        else
            tween(Win, {BackgroundTransparency = 1}, 0.18)
            task.delay(0.2, function() if not winVisible then Win.Visible = false end end)
        end
    end

    MobileToggle.MouseButton1Click:Connect(toggleWindow)
    MobileToggle.TouchTap:Connect(toggleWindow)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == toggleKey then
            toggleWindow()
        end
    end)

    -- Tab system
    local tabs = {}
    local activeTab = nil

    local Window = {}

    function Window:AddTab(name)
        local tabBtn = Instance.new("TextButton")
        tabBtn.BackgroundColor3 = CONFIG.Secondary
        tabBtn.BackgroundTransparency = 0
        tabBtn.Size = UDim2.new(0, 90, 1, 0)
        tabBtn.Text = name
        tabBtn.TextColor3 = CONFIG.TextSub
        tabBtn.TextSize = 12
        tabBtn.Font = CONFIG.FontLight
        tabBtn.AutoButtonColor = false
        tabBtn.BorderSizePixel = 0
        tabBtn.ZIndex = 12
        tabBtn.Parent = TabList

        local tabIndicator = frame(tabBtn, CONFIG.Border, UDim2.new(1, 0, 0, 2), UDim2.new(0, 0, 1, -2))
        tabIndicator.ZIndex = 13

        local tabContent = frame(ContentArea, CONFIG.Primary, UDim2.new(1, 0, 1, 0))
        tabContent.Visible = false
        tabContent.ZIndex = 10

        local scroll = scrollFrame(tabContent)
        scroll.ZIndex = 11
        pad(scroll, nil, 0, 8, 0, 0)

        local itemList = Instance.new("Frame")
        itemList.BackgroundTransparency = 1
        itemList.Size = UDim2.new(1, 0, 0, 0)
        itemList.AutomaticSize = Enum.AutomaticSize.Y
        itemList.ZIndex = 12
        itemList.Parent = scroll

        local il = listLayout(itemList, nil, 4)
        pad(itemList, nil, 8, 8, 10, 10)

        local function activate()
            for _, t in ipairs(tabs) do
                t.btn.TextColor3 = CONFIG.TextSub
                t.btn.Font = CONFIG.FontLight
                tween(t.indicator, {BackgroundColor3 = CONFIG.Border})
                t.content.Visible = false
            end
            tabBtn.TextColor3 = CONFIG.TextMain
            tabBtn.Font = CONFIG.Font
            tween(tabIndicator, {BackgroundColor3 = CONFIG.Accent})
            tabContent.Visible = true
            activeTab = name
        end

        tabBtn.MouseButton1Click:Connect(activate)
        tabBtn.TouchTap:Connect(activate)

        local tabData = {btn = tabBtn, indicator = tabIndicator, content = tabContent, list = itemList}
        table.insert(tabs, tabData)

        if #tabs == 1 then
            activate()
        end

        local Tab = {}

        function Tab:AddSection(sectionName)
            local secFrame = Instance.new("Frame")
            secFrame.BackgroundTransparency = 1
            secFrame.Size = UDim2.new(1, 0, 0, 0)
            secFrame.AutomaticSize = Enum.AutomaticSize.Y
            secFrame.ZIndex = 12
            secFrame.Parent = itemList

            local secLabel = label(secFrame, sectionName, 10, CONFIG.TextSub, CONFIG.Font)
            secLabel.Size = UDim2.new(1, 0, 0, 18)
            secLabel.Position = UDim2.new(0, 0, 0, 0)
            secLabel.AutomaticSize = Enum.AutomaticSize.None
            secLabel.TextXAlignment = Enum.TextXAlignment.Left
            secLabel.ZIndex = 13
            secLabel.TextTransparency = 0.3

            local secDiv = frame(secFrame, CONFIG.Border, UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 0, 18))
            secDiv.ZIndex = 13

            local secItems = Instance.new("Frame")
            secItems.BackgroundTransparency = 1
            secItems.Position = UDim2.new(0, 0, 0, 24)
            secItems.Size = UDim2.new(1, 0, 0, 0)
            secItems.AutomaticSize = Enum.AutomaticSize.Y
            secItems.ZIndex = 12
            secItems.Parent = secFrame

            listLayout(secItems, nil, 4)

            local secList = Instance.new("UIListLayout")
            secList.FillDirection = Enum.FillDirection.Vertical
            secList.SortOrder = Enum.SortOrder.LayoutOrder
            secList.Padding = UDim.new(0, 0)
            secList.Parent = secFrame

            local Section = {}

            function Section:AddButton(text, callback)
                return Tab:AddButton(text, callback, secItems)
            end
            function Section:AddToggle(text, default, callback, id)
                return Tab:AddToggle(text, default, callback, id, secItems)
            end
            function Section:AddSlider(text, min, max, default, callback, id)
                return Tab:AddSlider(text, min, max, default, callback, id, secItems)
            end
            function Section:AddDropdown(text, options, default, callback, id)
                return Tab:AddDropdown(text, options, default, callback, id, secItems)
            end

            return Section
        end

        function Tab:AddButton(text, callback, parent)
            parent = parent or itemList
            local btn = button(parent, text, callback)
            btn.ZIndex = 13
            pad(btn, nil, 0, 0, 10, 10)
            local l = label(btn, text, 13, CONFIG.TextMain, CONFIG.FontLight)
            l.Position = UDim2.new(0, 10, 0, 0)
            l.Size = UDim2.new(1, -10, 1, 0)
            l.AutomaticSize = Enum.AutomaticSize.None
            l.ZIndex = 14
            btn.Text = ""
            return btn
        end

        function Tab:AddToggle(text, default, callback, id, parent)
            parent = parent or itemList
            local state = default or false

            local row = frame(parent, CONFIG.Surface, UDim2.new(1, 0, 0, CONFIG.ItemH))
            row.ZIndex = 13
            corner(row)
            stroke(row)

            local lbl = label(row, text, 13, CONFIG.TextMain, CONFIG.FontLight)
            lbl.Position = UDim2.new(0, 12, 0, 0)
            lbl.Size = UDim2.new(1, -56, 1, 0)
            lbl.AutomaticSize = Enum.AutomaticSize.None
            lbl.ZIndex = 14

            local toggleBg = frame(row, state and CONFIG.ToggleOn or CONFIG.ToggleOff, UDim2.new(0, 34, 0, 18), UDim2.new(1, -46, 0.5, -9))
            toggleBg.ZIndex = 14
            corner(toggleBg, 9)

            local toggleDot = frame(toggleBg, CONFIG.Primary, UDim2.new(0, 12, 0, 12), state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6))
            toggleDot.ZIndex = 15
            corner(toggleDot, 6)

            local tog = {}
            tog.Value = state

            local function setToggle(val, silent)
                tog.Value = val
                tween(toggleBg, {BackgroundColor3 = val and CONFIG.ToggleOn or CONFIG.ToggleOff}, 0.18)
                tween(toggleDot, {Position = val and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)}, 0.18)
                if not silent and callback then callback(val) end
                if id then SavedConfig[id] = val end
            end

            if id and SavedConfig[id] ~= nil then setToggle(SavedConfig[id], true) end

            local function onClick()
                setToggle(not tog.Value)
            end

            row.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    onClick()
                end
            end)

            tog.Set = function(val) setToggle(val, true) end
            return tog
        end

        function Tab:AddSlider(text, min, max, default, callback, id, parent)
            parent = parent or itemList
            min = min or 0
            max = max or 100
            default = default or min

            local sliderH = 52
            local row = frame(parent, CONFIG.Surface, UDim2.new(1, 0, 0, sliderH))
            row.ZIndex = 13
            corner(row)
            stroke(row)

            local lbl = label(row, text, 13, CONFIG.TextMain, CONFIG.FontLight)
            lbl.Position = UDim2.new(0, 12, 0, 8)
            lbl.Size = UDim2.new(0.7, 0, 0, 16)
            lbl.AutomaticSize = Enum.AutomaticSize.None
            lbl.ZIndex = 14

            local valLabel = label(row, tostring(default), 12, CONFIG.AccentDim, CONFIG.Font)
            valLabel.Position = UDim2.new(1, -44, 0, 8)
            valLabel.Size = UDim2.new(0, 40, 0, 16)
            valLabel.AutomaticSize = Enum.AutomaticSize.None
            valLabel.TextXAlignment = Enum.TextXAlignment.Right
            valLabel.ZIndex = 14

            local trackBg = frame(row, CONFIG.SliderBg, UDim2.new(1, -24, 0, 5), UDim2.new(0, 12, 0, 36))
            trackBg.ZIndex = 14
            corner(trackBg, 3)

            local pct = (default - min) / (max - min)
            local trackFill = frame(trackBg, CONFIG.SliderFill, UDim2.new(pct, 0, 1, 0))
            trackFill.ZIndex = 15
            corner(trackFill, 3)

            local handle = frame(trackBg, CONFIG.Accent, UDim2.new(0, 13, 0, 13), UDim2.new(pct, -7, 0.5, -7))
            handle.ZIndex = 16
            corner(handle, 7)

            local slider = {}
            slider.Value = default

            local function setValue(val, silent)
                val = math.clamp(math.round(val), min, max)
                slider.Value = val
                local p = (val - min) / (max - min)
                tween(trackFill, {Size = UDim2.new(p, 0, 1, 0)}, 0.07, Enum.EasingStyle.Linear)
                tween(handle, {Position = UDim2.new(p, -7, 0.5, -7)}, 0.07, Enum.EasingStyle.Linear)
                valLabel.Text = tostring(val)
                if not silent and callback then callback(val) end
                if id then SavedConfig[id] = val end
            end

            if id and SavedConfig[id] ~= nil then setValue(SavedConfig[id], true) end

            local sliding = false

            local function onInput(input)
                if not sliding then return end
                local absPos = trackBg.AbsolutePosition.X
                local absSize = trackBg.AbsoluteSize.X
                local relX = math.clamp(input.Position.X - absPos, 0, absSize)
                local p = relX / absSize
                local val = min + (max - min) * p
                setValue(val)
            end

            trackBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    onInput(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    onInput(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            slider.Set = function(val) setValue(val, true) end
            return slider
        end

        function Tab:AddDropdown(text, options, default, callback, id, parent)
            parent = parent or itemList
            options = options or {}
            local selected = default or (options[1] or "")

            local dropH = CONFIG.ItemH
            local row = frame(parent, CONFIG.Surface, UDim2.new(1, 0, 0, dropH))
            row.ZIndex = 13
            row.ClipsDescendants = false
            corner(row)
            stroke(row)

            local lbl = label(row, text, 13, CONFIG.TextMain, CONFIG.FontLight)
            lbl.Position = UDim2.new(0, 12, 0, 0)
            lbl.Size = UDim2.new(0.55, 0, 1, 0)
            lbl.AutomaticSize = Enum.AutomaticSize.None
            lbl.ZIndex = 14

            local selLabel = label(row, selected, 12, CONFIG.AccentDim, CONFIG.FontLight)
            selLabel.Position = UDim2.new(0.55, 0, 0, 0)
            selLabel.Size = UDim2.new(0.35, 0, 1, 0)
            selLabel.AutomaticSize = Enum.AutomaticSize.None
            selLabel.TextXAlignment = Enum.TextXAlignment.Right
            selLabel.ZIndex = 14
            selLabel.TextTruncate = Enum.TextTruncate.AtEnd

            local arrow = label(row, "▾", 14, CONFIG.TextSub, CONFIG.Font)
            arrow.Position = UDim2.new(1, -22, 0, 0)
            arrow.Size = UDim2.new(0, 18, 1, 0)
            arrow.AutomaticSize = Enum.AutomaticSize.None
            arrow.TextXAlignment = Enum.TextXAlignment.Center
            arrow.ZIndex = 14

            local optionH = 32
            local maxVisible = 5
            local listH = math.min(#options, maxVisible) * optionH

            local dropList = Instance.new("Frame")
            dropList.BackgroundColor3 = CONFIG.Secondary
            dropList.Position = UDim2.new(0, 0, 1, 4)
            dropList.Size = UDim2.new(1, 0, 0, 0)
            dropList.ClipsDescendants = true
            dropList.Visible = false
            dropList.ZIndex = 50
            dropList.Parent = row
            corner(dropList)
            stroke(dropList)
            makeShadow(dropList, 16)

            local dropScroll = scrollFrame(dropList, UDim2.new(1, 0, 1, 0))
            dropScroll.ZIndex = 51

            listLayout(dropScroll, nil, 0)

            local isOpen = false
            local drop = {}
            drop.Value = selected

            local function close()
                isOpen = false
                tween(dropList, {Size = UDim2.new(1, 0, 0, 0)}, 0.18)
                tween(arrow, {TextTransparency = 0.4}, 0.12)
                task.delay(0.2, function() if not isOpen then dropList.Visible = false end end)
            end

            local function open()
                isOpen = true
                dropList.Visible = true
                tween(dropList, {Size = UDim2.new(1, 0, 0, listH)}, 0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                tween(arrow, {TextTransparency = 0}, 0.12)
            end

            local function setValue(val, silent)
                drop.Value = val
                selLabel.Text = val
                if not silent and callback then callback(val) end
                if id then SavedConfig[id] = val end
                close()
            end

            if id and SavedConfig[id] ~= nil then setValue(SavedConfig[id], true) end

            for _, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.BackgroundColor3 = CONFIG.Secondary
                optBtn.BackgroundTransparency = 0
                optBtn.Size = UDim2.new(1, 0, 0, optionH)
                optBtn.Text = ""
                optBtn.AutoButtonColor = false
                optBtn.BorderSizePixel = 0
                optBtn.ZIndex = 52
                optBtn.Parent = dropScroll

                local optLbl = label(optBtn, opt, 12, opt == selected and CONFIG.TextMain or CONFIG.TextSub, CONFIG.FontLight)
                optLbl.Position = UDim2.new(0, 12, 0, 0)
                optLbl.Size = UDim2.new(1, -12, 1, 0)
                optLbl.AutomaticSize = Enum.AutomaticSize.None
                optLbl.ZIndex = 53

                local checkMark = label(optBtn, "✓", 11, CONFIG.Accent, CONFIG.Font)
                checkMark.Position = UDim2.new(1, -24, 0, 0)
                checkMark.Size = UDim2.new(0, 18, 1, 0)
                checkMark.AutomaticSize = Enum.AutomaticSize.None
                checkMark.TextXAlignment = Enum.TextXAlignment.Center
                checkMark.ZIndex = 53
                checkMark.Visible = (opt == selected)

                optBtn.MouseEnter:Connect(function()
                    tween(optBtn, {BackgroundColor3 = CONFIG.DropHover})
                end)
                optBtn.MouseLeave:Connect(function()
                    tween(optBtn, {BackgroundColor3 = CONFIG.Secondary})
                end)

                local function selectOpt()
                    for _, ch in ipairs(dropScroll:GetChildren()) do
                        if ch:IsA("TextButton") then
                            local cl = ch:FindFirstChildOfClass("TextLabel")
                            if cl then cl.TextColor3 = CONFIG.TextSub end
                            local ck = ch:FindFirstChild("TextLabel")
                        end
                    end
                    for _, ch in ipairs(dropScroll:GetChildren()) do
                        if ch:IsA("TextButton") then
                            local children = ch:GetChildren()
                            for _, c in ipairs(children) do
                                if c:IsA("TextLabel") then
                                    if c.Text == "✓" then c.Visible = (ch == optBtn) end
                                    if c.Text ~= "✓" then
                                        c.TextColor3 = ch == optBtn and CONFIG.TextMain or CONFIG.TextSub
                                    end
                                end
                            end
                        end
                    end
                    setValue(opt)
                end

                optBtn.MouseButton1Click:Connect(selectOpt)
                optBtn.TouchTap:Connect(selectOpt)
            end

            local function toggle()
                if isOpen then close() else open() end
            end

            row.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    toggle()
                end
            end)

            drop.Set = function(val) setValue(val, true) end
            return drop
        end

        function Tab:AddLabel(text)
            local lf = frame(itemList, CONFIG.Secondary, UDim2.new(1, 0, 0, 28))
            lf.ZIndex = 13
            corner(lf)
            local l = label(lf, text, 12, CONFIG.TextSub, CONFIG.FontLight)
            l.Position = UDim2.new(0, 12, 0, 0)
            l.Size = UDim2.new(1, -12, 1, 0)
            l.AutomaticSize = Enum.AutomaticSize.None
            l.ZIndex = 14
            return lf
        end

        return Tab
    end

    return Window
end

return LawXW
