local LawXW = {}
LawXW.__index = LawXW

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

function LawXW:Create()
    local self = setmetatable({}, LawXW)

    local gui = Instance.new("ScreenGui")
    gui.Name = "Law-XW"
    gui.ResetOnSpawn = false
    gui.Parent = game.CoreGui

    -- Loading Screen
    local loading = Instance.new("Frame", gui)
    loading.Size = UDim2.fromScale(1,1)
    loading.BackgroundColor3 = Color3.fromRGB(0,0,0)

    local text = Instance.new("TextLabel", loading)
    text.Size = UDim2.fromScale(1,1)
    text.Text = "Loading Law-XW..."
    text.TextColor3 = Color3.fromRGB(255,255,255)
    text.BackgroundTransparency = 1
    text.TextScaled = true

    local bar = Instance.new("Frame", loading)
    bar.Size = UDim2.fromScale(0,0.02)
    bar.Position = UDim2.fromScale(0,0.9)
    bar.BackgroundColor3 = Color3.fromRGB(255,255,255)

    Tween(bar, {Size = UDim2.fromScale(1,0.02)}, 2)
    task.wait(2)

    Tween(loading, {BackgroundTransparency = 1}, 0.5)
    task.wait(0.5)
    loading:Destroy()

    -- Main Window
    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromOffset(500,350)
    main.Position = UDim2.fromScale(0.5,0.5)
    main.AnchorPoint = Vector2.new(0.5,0.5)
    main.BackgroundColor3 = Color3.fromRGB(20,20,20)
    main.BackgroundTransparency = 0.1

    Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)

    local shadow = Instance.new("ImageLabel", main)
    shadow.Size = UDim2.fromScale(1,1)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageTransparency = 0.7

    -- Dragging
    local dragging, dragInput, startPos, startFrame

    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = input.Position
            startFrame = main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - startPos
            main.Position = startFrame + UDim2.fromOffset(delta.X, delta.Y)
        end
    end)

    -- Toggle Key
    UserInputService.InputBegan:Connect(function(input, gpe)
        if input.KeyCode == Enum.KeyCode.RightShift and not gpe then
            main.Visible = not main.Visible
        end
    end)

    -- Tab Container
    local tabs = Instance.new("Frame", main)
    tabs.Size = UDim2.fromOffset(120,350)
    tabs.BackgroundTransparency = 1

    local content = Instance.new("Frame", main)
    content.Position = UDim2.fromOffset(130,0)
    content.Size = UDim2.fromOffset(370,350)
    content.BackgroundTransparency = 1

    local UIList = Instance.new("UIListLayout", tabs)
    UIList.Padding = UDim.new(0,5)

    self.Tabs = {}
    self.Container = content

    function self:CreateTab(name)
        local tab = {}

        local button = Instance.new("TextButton", tabs)
        button.Size = UDim2.fromOffset(110,40)
        button.Text = name
        button.BackgroundColor3 = Color3.fromRGB(30,30,30)
        button.TextColor3 = Color3.fromRGB(255,255,255)

        Instance.new("UICorner", button)

        local frame = Instance.new("ScrollingFrame", content)
        frame.Size = UDim2.fromScale(1,1)
        frame.CanvasSize = UDim2.new(0,0,0,0)
        frame.Visible = false
        frame.BackgroundTransparency = 1

        local layout = Instance.new("UIListLayout", frame)
        layout.Padding = UDim.new(0,10)

        button.MouseButton1Click:Connect(function()
            for _,v in pairs(content:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            frame.Visible = true
        end)

        function tab:AddButton(text, callback)
            local btn = Instance.new("TextButton", frame)
            btn.Size = UDim2.new(1,-10,0,40)
            btn.Text = text
            btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
            btn.TextColor3 = Color3.fromRGB(255,255,255)

            Instance.new("UICorner", btn)

            btn.MouseButton1Click:Connect(callback)
        end

        function tab:AddToggle(text, callback)
            local state = false

            local holder = Instance.new("Frame", frame)
            holder.Size = UDim2.new(1,-10,0,40)
            holder.BackgroundTransparency = 1

            local label = Instance.new("TextLabel", holder)
            label.Text = text
            label.Size = UDim2.fromScale(0.7,1)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.new(1,1,1)

            local toggle = Instance.new("Frame", holder)
            toggle.Size = UDim2.fromOffset(50,25)
            toggle.Position = UDim2.new(1,-60,0.5,-12)
            toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)

            Instance.new("UICorner", toggle)

            local knob = Instance.new("Frame", toggle)
            knob.Size = UDim2.fromOffset(20,20)
            knob.Position = UDim2.fromOffset(2,2)
            knob.BackgroundColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", knob)

            toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    state = not state
                    Tween(knob, {Position = state and UDim2.fromOffset(28,2) or UDim2.fromOffset(2,2)})
                    callback(state)
                end
            end)
        end

        function tab:AddSlider(text, min, max, callback)
            local value = min

            local frameS = Instance.new("Frame", frame)
            frameS.Size = UDim2.new(1,-10,0,50)
            frameS.BackgroundTransparency = 1

            local label = Instance.new("TextLabel", frameS)
            label.Text = text.." : "..value
            label.Size = UDim2.fromScale(1,0.5)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.new(1,1,1)

            local bar = Instance.new("Frame", frameS)
            bar.Size = UDim2.new(1,0,0,8)
            bar.Position = UDim2.fromScale(0,0.7)
            bar.BackgroundColor3 = Color3.fromRGB(60,60,60)

            Instance.new("UICorner", bar)

            local fill = Instance.new("Frame", bar)
            fill.Size = UDim2.fromScale(0,1)
            fill.BackgroundColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", fill)

            local dragging = false

            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)

            UserInputService.InputEnded:Connect(function()
                dragging = false
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging then
                    local pos = (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
                    pos = math.clamp(pos,0,1)

                    value = math.floor(min + (max-min)*pos)
                    label.Text = text.." : "..value

                    Tween(fill, {Size = UDim2.fromScale(pos,1)}, 0.1)
                    callback(value)
                end
            end)
        end

        function tab:AddDropdown(text, list, callback)
            local open = false

            local holder = Instance.new("Frame", frame)
            holder.Size = UDim2.new(1,-10,0,40)
            holder.BackgroundColor3 = Color3.fromRGB(40,40,40)
            Instance.new("UICorner", holder)

            local label = Instance.new("TextLabel", holder)
            label.Text = text
            label.Size = UDim2.fromScale(1,1)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.new(1,1,1)

            local drop = Instance.new("Frame", holder)
            drop.Position = UDim2.fromScale(0,1)
            drop.Size = UDim2.new(1,0,0,0)
            drop.ClipsDescendants = true
            drop.BackgroundColor3 = Color3.fromRGB(30,30,30)

            Instance.new("UICorner", drop)

            local layout = Instance.new("UIListLayout", drop)

            holder.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    open = not open
                    Tween(drop, {Size = open and UDim2.new(1,0,0,#list*30) or UDim2.new(1,0,0,0)})
                end
            end)

            for _,v in pairs(list) do
                local opt = Instance.new("TextButton", drop)
                opt.Size = UDim2.new(1,0,0,30)
                opt.Text = v
                opt.BackgroundColor3 = Color3.fromRGB(50,50,50)
                opt.TextColor3 = Color3.new(1,1,1)

                opt.MouseButton1Click:Connect(function()
                    label.Text = text.." : "..v
                    callback(v)
                end)
            end
        end

        return tab
    end

    function self:Notify(text)
        local notif = Instance.new("TextLabel", gui)
        notif.Size = UDim2.fromOffset(200,50)
        notif.Position = UDim2.fromScale(1,-0.1)
        notif.Text = text
        notif.BackgroundColor3 = Color3.fromRGB(0,0,0)
        notif.TextColor3 = Color3.new(1,1,1)

        Instance.new("UICorner", notif)

        Tween(notif, {Position = UDim2.fromScale(0.8,0.9)}, 0.3)
        task.wait(2)
        Tween(notif, {Position = UDim2.fromScale(1,1)}, 0.3)
        task.wait(0.3)
        notif:Destroy()
    end

    return self
end

return LawXW
