local Library = {}
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Http = game:GetService("HttpService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local CoreGui
pcall(function() CoreGui = game:GetService("CoreGui") end)
local TargetGui = CoreGui or LP:WaitForChild("PlayerGui")

local Theme = {
    Main = Color3.fromRGB(25, 25, 30),
    Second = Color3.fromRGB(35, 35, 40),
    Accent = Color3.fromRGB(0, 150, 255),
    Text = Color3.fromRGB(255, 255, 255),
    DarkText = Color3.fromRGB(180, 180, 180),
    Outline = Color3.fromRGB(50, 50, 55)
}

local function Create(className, properties)
    local inst = Instance.new(className)
    for k, v in pairs(properties) do
        inst[k] = v
    end
    return inst
end

local function MakeDraggable(topbar, main)
    local dragging = false
    local dragInput, mousePos, framePos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            main.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

function Library:CreateWindow(options)
    local config = {
        Title = options.Title or "UI Library",
        Keybind = options.Keybind or Enum.KeyCode.RightShift
    }
    
    local Screen = Create("ScreenGui", {
        Name = Http:GenerateGUID(),
        Parent = TargetGui,
        ResetOnSpawn = false
    })
    
    local MainFrame = Create("Frame", {
        Size = UDim2.new(0, 500, 0, 350),
        Position = UDim2.new(0.5, -250, 0.5, -175),
        BackgroundColor3 = Theme.Main,
        BorderSizePixel = 0,
        Parent = Screen,
        ClipsDescendants = true
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = MainFrame})
    
    local Topbar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.Second,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Topbar})
    Create("Frame", {Size = UDim2.new(1, 0, 0, 8), Position = UDim2.new(0, 0, 1, -8), BackgroundColor3 = Theme.Second, BorderSizePixel = 0, Parent = Topbar})
    
    local TitleLabel = Create("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Title,
        TextColor3 = Theme.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Topbar
    })
    
    MakeDraggable(Topbar, MainFrame)
    
    local TabContainer = Create("Frame", {
        Size = UDim2.new(0, 130, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Theme.Second,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    local TabList = Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5), Parent = TabContainer})
    Create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = TabContainer})
    
    local ContentContainer = Create("Frame", {
        Size = UDim2.new(1, -130, 1, -40),
        Position = UDim2.new(0, 130, 0, 40),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    local MobileToggle = Create("TextButton", {
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0.5, -25, 0, 20),
        BackgroundColor3 = Theme.Accent,
        Text = "UI",
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = Screen,
        Visible = UIS.TouchEnabled
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = MobileToggle})
    
    local guiVisible = true
    local function ToggleUI()
        guiVisible = not guiVisible
        MainFrame.Visible = guiVisible
    end
    
    MobileToggle.MouseButton1Click:Connect(ToggleUI)
    UIS.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == config.Keybind then
            ToggleUI()
        end
    end)
    
    local NotifyContainer = Create("Frame", {
        Size = UDim2.new(0, 250, 1, -50),
        Position = UDim2.new(1, -270, 0, 25),
        BackgroundTransparency = 1,
        Parent = Screen
    })
    Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), VerticalAlignment = Enum.VerticalAlignment.Bottom, Parent = NotifyContainer})
    
    local Window = {
        CurrentTab = nil,
        Configs = {}
    }
    
    function Window:Notify(title, text, duration)
        duration = duration or 3
        local notif = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 60),
            BackgroundColor3 = Theme.Second,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            Parent = NotifyContainer
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = notif})
        local nTitle = Create("TextLabel", {Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 5), BackgroundTransparency = 1, Text = title, TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, Parent = notif})
        local nText = Create("TextLabel", {Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 30), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, Parent = notif})
        
        TS:Create(notif, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        TS:Create(nTitle, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        TS:Create(nText, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        
        task.delay(duration, function()
            TS:Create(notif, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TS:Create(nTitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TS:Create(nText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            task.wait(0.3)
            notif:Destroy()
        end)
    end
    
    function Window:SaveConfig(name)
        if writefile then
            local success, encoded = pcall(Http.JSONEncode, Http, self.Configs)
            if success then
                writefile(name .. ".json", encoded)
                self:Notify("Config", "Saved configuration.", 3)
            end
        end
    end
    
    function Window:CreateTab(name)
        local tabBtn = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Theme.Main,
            Text = name,
            TextColor3 = Theme.DarkText,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            AutoButtonColor = false,
            Parent = TabContainer
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = tabBtn})
        
        local tabContent = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = ContentContainer
        })
        local contentLayout = Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = tabContent})
        Create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), Parent = tabContent})
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        tabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(ContentContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    TS:Create(child, TweenInfo.new(0.2), {TextColor3 = Theme.DarkText, BackgroundColor3 = Theme.Main}):Play()
                end
            end
            tabContent.Visible = true
            TS:Create(tabBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Text, BackgroundColor3 = Theme.Accent}):Play()
        end)
        
        if not Window.CurrentTab then
            Window.CurrentTab = tabContent
            tabContent.Visible = true
            tabBtn.TextColor3 = Theme.Text
            tabBtn.BackgroundColor3 = Theme.Accent
        end
        
        local Tab = {}
        
        function Tab:CreateLabel(text)
            local label = Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = tabContent
            })
        end
        
        function Tab:CreateButton(text, callback)
            local btn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Theme.Second,
                Text = text,
                TextColor3 = Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                AutoButtonColor = false,
                Parent = tabContent
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn})
            
            btn.MouseEnter:Connect(function() TS:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Outline}):Play() end)
            btn.MouseLeave:Connect(function() TS:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Second}):Play() end)
            btn.MouseButton1Click:Connect(function()
                TS:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play()
                task.wait(0.1)
                TS:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Second}):Play()
                callback()
            end)
        end
        
        function Tab:CreateToggle(text, default, callback)
            local state = default
            local tglFrame = Create("TextButton", {Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Theme.Second, Text = "", AutoButtonColor = false, Parent = tabContent})
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = tglFrame})
            
            local label = Create("TextLabel", {Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = tglFrame})
            local indicator = Create("Frame", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -30, 0.5, -10), BackgroundColor3 = state and Theme.Accent or Theme.Main, Parent = tglFrame})
            Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = indicator})
            
            local function fire()
                state = not state
                TS:Create(indicator, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Theme.Main}):Play()
                callback(state)
            end
            
            tglFrame.MouseButton1Click:Connect(fire)
            if state then callback(state) end
        end
        
        function Tab:CreateSlider(text, min, max, default, callback)
            local val = default
            local sliderFrame = Create("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = Theme.Second, Parent = tabContent})
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = sliderFrame})
            
            local label = Create("TextLabel", {Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = sliderFrame})
            local valLabel = Create("TextLabel", {Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = tostring(val), TextColor3 = Theme.DarkText, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Right, Parent = sliderFrame})
            
            local sliderBg = Create("TextButton", {Size = UDim2.new(1, -20, 0, 6), Position = UDim2.new(0, 10, 0, 32), BackgroundColor3 = Theme.Main, Text = "", AutoButtonColor = false, Parent = sliderFrame})
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sliderBg})
            
            local sliderFill = Create("Frame", {Size = UDim2.new((val - min) / (max - min), 0, 1, 0), BackgroundColor3 = Theme.Accent, Parent = sliderBg})
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sliderFill})
            
            local dragging = false
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            RS.RenderStepped:Connect(function()
                if dragging then
                    local mouseX = UIS:GetMouseLocation().X
                    local relative = math.clamp((mouseX - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    val = math.floor(min + ((max - min) * relative))
                    TS:Create(sliderFill, TweenInfo.new(0.1), {Size = UDim2.new(relative, 0, 1, 0)}):Play()
                    valLabel.Text = tostring(val)
                    callback(val)
                end
            end)
            callback(val)
        end
        
        function Tab:CreateDropdown(text, options, callback)
            local dropFrame = Create("Frame", {Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Theme.Second, ClipsDescendants = true, Parent = tabContent})
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = dropFrame})
            
            local dropBtn = Create("TextButton", {Size = UDim2.new(1, 0, 0, 35), BackgroundTransparency = 1, Text = "", Parent = dropFrame})
            local label = Create("TextLabel", {Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = dropBtn})
            local icon = Create("TextLabel", {Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(1, -30, 0, 0), BackgroundTransparency = 1, Text = "+", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 16, Parent = dropBtn})
            
            local dropList = Create("ScrollingFrame", {Size = UDim2.new(1, 0, 1, -35), Position = UDim2.new(0, 0, 0, 35), BackgroundTransparency = 1, ScrollBarThickness = 2, CanvasSize = UDim2.new(0, 0, 0, #options * 30), Parent = dropFrame})
            Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Parent = dropList})
            
            local open = false
            dropBtn.MouseButton1Click:Connect(function()
                open = not open
                TS:Create(dropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, open and (35 + math.clamp(#options * 30, 0, 120)) or 35)}):Play()
                icon.Text = open and "-" or "+"
            end)
            
            for _, opt in pairs(options) do
                local optBtn = Create("TextButton", {Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Theme.Main, Text = opt, TextColor3 = Theme.DarkText, Font = Enum.Font.Gotham, TextSize = 14, AutoButtonColor = false, Parent = dropList})
                optBtn.MouseButton1Click:Connect(function()
                    label.Text = text .. " : " .. opt
                    open = false
                    TS:Create(dropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 35)}):Play()
                    icon.Text = "+"
                    callback(opt)
                end)
            end
        end
        
        function Tab:CreateKeybind(text, defaultKey, callback)
            local key = defaultKey
            local bindBtn = Create("TextButton", {Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Theme.Second, Text = "", AutoButtonColor = false, Parent = tabContent})
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = bindBtn})
            
            local label = Create("TextLabel", {Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = bindBtn})
            local keyLabel = Create("TextLabel", {Size = UDim2.new(0, 80, 0, 25), Position = UDim2.new(1, -90, 0.5, -12.5), BackgroundColor3 = Theme.Main, Text = key.Name, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, Parent = bindBtn})
            Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = keyLabel})
            
            local binding = false
            bindBtn.MouseButton1Click:Connect(function()
                binding = true
                keyLabel.Text = "..."
            end)
            
            UIS.InputBegan:Connect(function(input)
                if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    key = input.KeyCode
                    keyLabel.Text = key.Name
                    binding = false
                elseif not binding and input.KeyCode == key then
                    callback()
                end
            end)
        end
        
        return Tab
    end
    
    return Window
end

return Library
