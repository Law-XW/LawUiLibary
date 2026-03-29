local Library = {}
Library.__index = Library
Library.Version = "1.0.0"
Library.Theme = {
	Background = Color3.fromRGB(10, 10, 10),
	Topbar = Color3.fromRGB(14, 14, 14),
	Sidebar = Color3.fromRGB(12, 12, 12),
	Panel = Color3.fromRGB(18, 18, 18),
	Panel2 = Color3.fromRGB(22, 22, 22),
	Stroke = Color3.fromRGB(70, 70, 70),
	StrokeSoft = Color3.fromRGB(40, 40, 40),
	Text = Color3.fromRGB(245, 245, 245),
	TextDim = Color3.fromRGB(170, 170, 170),
	White = Color3.fromRGB(245, 245, 245),
	Black = Color3.fromRGB(10, 10, 10),
	Accent = Color3.fromRGB(235, 235, 235),
	Accent2 = Color3.fromRGB(200, 200, 200)
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

local function create(className, props)
	local obj = Instance.new(className)
	for i, v in pairs(props or {}) do
		obj[i] = v
	end
	return obj
end

local function tween(obj, time, props, style, dir)
	local info = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
	local t = TweenService:Create(obj, info, props)
	t:Play()
	return t
end

local function roundCorner(parent, radius)
	local c = create("UICorner", {
		CornerRadius = UDim.new(0, radius or 10),
		Parent = parent
	})
	return c
end

local function stroke(parent, transparency, thickness)
	return create("UIStroke", {
		Color = Library.Theme.Stroke,
		Transparency = transparency or 0.4,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent
	})
end

local function padding(parent, left, right, top, bottom)
	return create("UIPadding", {
		PaddingLeft = UDim.new(0, left or 0),
		PaddingRight = UDim.new(0, right or 0),
		PaddingTop = UDim.new(0, top or 0),
		PaddingBottom = UDim.new(0, bottom or 0),
		Parent = parent
	})
end

local function safeParentGui(gui)
	if syn and syn.protect_gui then
		pcall(function()
			syn.protect_gui(gui)
		end)
	end

	local ok = pcall(function()
		gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
	end)

	if not ok then
		pcall(function()
			gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
		end)
	end
end

local function roundNumber(n, step)
	step = step or 1
	return math.floor((n / step) + 0.5) * step
end

local function setText(obj, text)
	if obj and obj:IsA("TextLabel") or obj and obj:IsA("TextButton") then
		obj.Text = tostring(text)
	end
end

function Library:CreateWindow(info)
	info = info or {}

	local window = setmetatable({}, self)
	window.Info = info
	window.Title = info.Title or "Law-XW"
	window.SubTitle = info.SubTitle or "Minimal UI Library"
	window.Keybind = info.Keybind or Enum.KeyCode.RightShift
	window.ConfigEnabled = info.ConfigEnabled ~= false
	window.ConfigFolder = info.ConfigFolder or "LawXW"
	window.ConfigName = info.ConfigName or "Default"
	window.AutoLoadConfig = info.AutoLoadConfig or false
	window.AutoSaveConfig = info.AutoSaveConfig or false
	window.Flags = {}
	window.Setters = {}
	window.NotifIndex = 0
	window.Tabs = {}
	window.CurrentTab = nil
	window.Visible = true

	local mobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	local w = info.Size and info.Size.X or (mobile and 520 or 640)
	local h = info.Size and info.Size.Y or (mobile and 380 or 470)
	local sidebarW = mobile and 112 or 142
	local topH = mobile and 42 or 46

	local gui = create("ScreenGui", {
		Name = "LawXW_" .. tostring(math.random(1000, 9999)),
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ClipToDeviceSafeArea = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	})
	safeParentGui(gui)
	window.Gui = gui

	local loader = create("CanvasGroup", {
		Name = "Loader",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		GroupTransparency = 0,
		Parent = gui
	})

	local loaderDim = create("Frame", {
		Name = "Dim",
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.05,
		Size = UDim2.fromScale(1, 1),
		Parent = loader
	})

	local loaderCard = create("Frame", {
		Name = "Card",
		BackgroundColor3 = Library.Theme.Panel,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(mobile and 320 or 380, mobile and 150 or 170),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = loader
	})
	roundCorner(loaderCard, 16)
	stroke(loaderCard, 0.5, 1)

	local loaderTitle = create("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -30, 0, 36),
		Position = UDim2.fromOffset(15, 24),
		Font = Enum.Font.GothamSemibold,
		Text = "Loading Law-XW...",
		TextColor3 = Library.Theme.Text,
		TextSize = mobile and 18 or 20,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = loaderCard
	})

	local loaderSub = create("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -30, 0, 20),
		Position = UDim2.fromOffset(15, 58),
		Font = Enum.Font.Gotham,
		Text = "Preparing interface",
		TextColor3 = Library.Theme.TextDim,
		TextSize = mobile and 12 or 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = loaderCard
	})

	local barBack = create("Frame", {
		BackgroundColor3 = Library.Theme.Black,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -30, 0, 10),
		Position = UDim2.fromOffset(15, mobile and 104 or 116),
		Parent = loaderCard
	})
	roundCorner(barBack, 999)
	stroke(barBack, 0.8, 1)

	local barFill = create("Frame", {
		BackgroundColor3 = Library.Theme.White,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 1, 0),
		Parent = barBack
	})
	roundCorner(barFill, 999)

	local loaderPct = create("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -30, 0, 18),
		Position = UDim2.fromOffset(15, mobile and 120 or 132),
		Font = Enum.Font.GothamMedium,
		Text = "0%",
		TextColor3 = Library.Theme.TextDim,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = loaderCard
	})

	local main = create("CanvasGroup", {
		Name = "Main",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		GroupTransparency = 1,
		Parent = gui
	})

	local shadow = create("Frame", {
		Name = "Shadow",
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.55,
		Size = UDim2.fromOffset(w + 24, h + 24),
		Position = UDim2.new(0.5, -(w / 2) - 12, 0.5, -(h / 2) - 12),
		BorderSizePixel = 0,
		Parent = main
	})
	roundCorner(shadow, 18)

	local windowFrame = create("Frame", {
		Name = "Window",
		BackgroundColor3 = Library.Theme.Background,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(w, h),
		Position = UDim2.new(0.5, -w / 2, 0.5, -h / 2),
		Parent = main
	})
	roundCorner(windowFrame, 18)
	stroke(windowFrame, 0.55, 1)

	local topbar = create("Frame", {
		Name = "Topbar",
		BackgroundColor3 = Library.Theme.Topbar,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, topH),
		Parent = windowFrame
	})
	roundCorner(topbar, 18)

	local topbarFix = create("Frame", {
		BackgroundColor3 = Library.Theme.Topbar,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 18),
		Position = UDim2.new(0, 0, 1, -18),
		Parent = topbar
	})

	local title = create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(16, 6),
		Size = UDim2.new(1, -120, 0, 20),
		Font = Enum.Font.GothamSemibold,
		Text = window.Title,
		TextColor3 = Library.Theme.Text,
		TextSize = mobile and 18 or 20,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = topbar
	})

	local subtitle = create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(16, 24),
		Size = UDim2.new(1, -120, 0, 16),
		Font = Enum.Font.Gotham,
		Text = window.SubTitle,
		TextColor3 = Library.Theme.TextDim,
		TextSize = mobile and 11 or 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = topbar
	})

	local mobileToggle = create("TextButton", {
		Name = "MobileToggle",
		AutoButtonColor = false,
		Text = "LX",
		Font = Enum.Font.GothamSemibold,
		TextColor3 = Library.Theme.White,
		TextSize = 14,
		BackgroundColor3 = Library.Theme.Panel2,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(40, 40),
		Position = UDim2.new(1, -52, 1, -56),
		Parent = main,
		Visible = mobile
	})
	roundCorner(mobileToggle, 20)
	stroke(mobileToggle, 0.6, 1)

	local sidebar = create("Frame", {
		Name = "Sidebar",
		BackgroundColor3 = Library.Theme.Sidebar,
		BorderSizePixel = 0,
		Size = UDim2.new(0, sidebarW, 1, -topH),
		Position = UDim2.new(0, 0, 0, topH),
		Parent = windowFrame
	})
	roundCorner(sidebar, 0)

	local sidebarTop = create("Frame", {
		BackgroundColor3 = Library.Theme.Sidebar,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 18),
		Parent = sidebar
	})

	local sidebarList = create("ScrollingFrame", {
		Name = "TabList",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, -18),
		Position = UDim2.new(0, 0, 0, 18),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Library.Theme.White,
		ScrollBarImageTransparency = 0.45,
		Parent = sidebar
	})

	local sidebarPadding = padding(sidebarList, 10, 10, 8, 8)
	local sidebarLayout = create("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = sidebarList
	})

	local pagesHolder = create("Frame", {
		Name = "PagesHolder",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -sidebarW, 1, -topH),
		Position = UDim2.new(0, sidebarW, 0, topH),
		Parent = windowFrame,
		ClipsDescendants = true
	})

	local notifHolder = create("Frame", {
		Name = "Notifications",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0, mobile and 280 or 320, 0, 1),
		Position = UDim2.new(1, -(mobile and 290 or 330), 0, 16),
		AnchorPoint = Vector2.new(0, 0),
		Parent = main
	})

	local notifLayout = create("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Parent = notifHolder
	})

	local notifPadding = padding(notifHolder, 0, 0, 0, 0)

	window.Gui = gui
	window.MainGroup = main
	window.WindowFrame = windowFrame
	window.PagesHolder = pagesHolder
	window.NotifHolder = notifHolder
	window.MobileToggle = mobileToggle
	window.Sidebar = sidebar

	local drag = false
	local dragInput
	local dragStart
	local startPos

	topbar.Active = true
	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			drag = true
			dragStart = input.Position
			startPos = windowFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					drag = false
				end
			end)
		end
	end)

	topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if drag and input == dragInput then
			local delta = input.Position - dragStart
			windowFrame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
			shadow.Position = UDim2.new(
				windowFrame.Position.X.Scale,
				windowFrame.Position.X.Offset - 12,
				windowFrame.Position.Y.Scale,
				windowFrame.Position.Y.Offset - 12
			)
		end
	end)

	local function refreshShadow()
		shadow.Position = UDim2.new(
			windowFrame.Position.X.Scale,
			windowFrame.Position.X.Offset - 12,
			windowFrame.Position.Y.Scale,
			windowFrame.Position.Y.Offset - 12
		)
	end

	local function setVisible(state)
		window.Visible = state
		windowFrame.Visible = state
		shadow.Visible = state
		sidebar.Visible = state
		pagesHolder.Visible = state
		if state then
			tween(main, 0.18, {GroupTransparency = 0})
		else
			main.GroupTransparency = 1
		end
	end

	local function toggleVisible()
		window.Visible = not window.Visible
		setVisible(window.Visible)
	end

	window:SetVisible = setVisible
	window:Toggle = toggleVisible

	mobileToggle.MouseButton1Click:Connect(toggleVisible)

	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then
			return
		end
		if input.KeyCode == window.Keybind then
			toggleVisible()
		end
	end)

	function window:_register(flag, setter, getter)
		if not flag or flag == "" then
			return
		end
		self.Setters[flag] = setter
		if getter ~= nil then
			self.Flags[flag] = getter
		end
	end

	function window:Notify(text, duration)
		duration = duration or 2.5
		self.NotifIndex += 1

		local card = create("CanvasGroup", {
			BackgroundColor3 = Library.Theme.Panel,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			GroupTransparency = 1,
			LayoutOrder = -self.NotifIndex,
			Parent = self.NotifHolder
		})
		roundCorner(card, 12)
		stroke(card, 0.55, 1)
		padding(card, 12, 12, 10, 10)

		local t1 = create("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 18),
			Font = Enum.Font.GothamSemibold,
			Text = window.Title,
			TextColor3 = Library.Theme.Text,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = card
		})

		local t2 = create("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 20),
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Font = Enum.Font.Gotham,
			Text = tostring(text),
			TextWrapped = true,
			TextColor3 = Library.Theme.TextDim,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Parent = card
		})

		local appear = tween(card, 0.18, {GroupTransparency = 0})
		card.Position = UDim2.fromOffset(0, -8)

		local posTween = tween(card, 0.22, {Position = UDim2.fromOffset(0, 0)})

		task.delay(duration, function()
			if card and card.Parent then
				tween(card, 0.18, {GroupTransparency = 1})
				tween(card, 0.18, {Position = UDim2.fromOffset(0, -8)})
				task.wait(0.2)
				if card and card.Parent then
					card:Destroy()
				end
			end
		end)
	end

	function window:_configPath(name)
		return tostring(self.ConfigFolder) .. "/" .. tostring(name or self.ConfigName) .. ".json"
	end

	function window:SaveConfig(name)
		if not writefile or not makefolder then
			return false
		end

		local path = self:_configPath(name)
		pcall(function()
			makefolder(self.ConfigFolder)
		end)

		local encoded = HttpService:JSONEncode(self.Flags)
		local ok = pcall(function()
			writefile(path, encoded)
		end)

		return ok
	end

	function window:LoadConfig(name)
		if not readfile or not isfile then
			return false
		end

		local path = self:_configPath(name)
		if not isfile(path) then
			return false
		end

		local ok, decoded = pcall(function()
			return HttpService:JSONDecode(readfile(path))
		end)

		if ok and type(decoded) == "table" then
			for flag, value in pairs(decoded) do
				if self.Setters[flag] then
					pcall(self.Setters[flag], value)
				end
			end
			return true
		end

		return false
	end

	window._tabsLayout = sidebarLayout
	window._pages = {}
	window._selectedTab = nil

	local function updateCanvas(page, contentFrame, layout)
		local function sync()
			page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 14)
		end
		sync()
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(sync)
	end

	local function buildSectionControls(section)
		local function registerControlFlag(flag, value, setter)
			if flag then
				window:_register(flag, setter, value)
			end
		end

		local sectionObject = {}

		function sectionObject:CreateButton(opts)
			opts = opts or {}
			local text = opts.Text or "Button"
			local callback = opts.Callback or function() end

			local row = create("Frame", {
				BackgroundColor3 = Library.Theme.Panel,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 42),
				Parent = section.Inner
			})
			roundCorner(row, 12)
			stroke(row, 0.62, 1)

			local btn = create("TextButton", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				AutoButtonColor = false,
				Font = Enum.Font.GothamSemibold,
				Text = tostring(text),
				TextColor3 = Library.Theme.Text,
				TextSize = 14,
				Parent = row
			})

			btn.MouseEnter:Connect(function()
				tween(row, 0.12, {BackgroundColor3 = Library.Theme.Panel2})
			end)

			btn.MouseLeave:Connect(function()
				tween(row, 0.12, {BackgroundColor3 = Library.Theme.Panel})
			end)

			btn.MouseButton1Click:Connect(function()
				pcall(callback)
			end)

			return row
		end

		function sectionObject:CreateToggle(opts)
			opts = opts or {}
			local text = opts.Text or "Toggle"
			local default = opts.Default or false
			local callback = opts.Callback or function() end
			local flag = opts.Flag or text

			local row = create("Frame", {
				BackgroundColor3 = Library.Theme.Panel,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 48),
				Parent = section.Inner
			})
			roundCorner(row, 12)
			stroke(row, 0.62, 1)

			local lbl = create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(14, 0),
				Size = UDim2.new(1, -84, 1, 0),
				Font = Enum.Font.GothamSemibold,
				Text = tostring(text),
				TextColor3 = Library.Theme.Text,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = row
			})

			local holder = create("Frame", {
				BackgroundColor3 = default and Library.Theme.White or Library.Theme.Black,
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(46, 24),
				Position = UDim2.new(1, -58, 0.5, -12),
				Parent = row
			})
			roundCorner(holder, 999)
			stroke(holder, 0.7, 1)

			local knob = create("Frame", {
				BackgroundColor3 = default and Library.Theme.Black or Library.Theme.White,
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(18, 18),
				Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
				Parent = holder
			})
			roundCorner(knob, 999)

			local state = default and true or false

			local function apply(v, silent)
				state = v and true or false
				if state then
					tween(holder, 0.16, {BackgroundColor3 = Library.Theme.White})
					tween(knob, 0.16, {Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = Library.Theme.Black})
				else
					tween(holder, 0.16, {BackgroundColor3 = Library.Theme.Black})
					tween(knob, 0.16, {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Library.Theme.White})
				end
				window.Flags[flag] = state
				if not silent then
					pcall(callback, state)
					if window.AutoSaveConfig then
						task.spawn(function()
							window:SaveConfig()
						end)
					end
				end
			end

			row.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					apply(not state, false)
				end
			end)

			row.MouseEnter:Connect(function()
				tween(row, 0.12, {BackgroundColor3 = Library.Theme.Panel2})
			end)

			row.MouseLeave:Connect(function()
				tween(row, 0.12, {BackgroundColor3 = Library.Theme.Panel})
			end)

			registerControlFlag(flag, state, apply)
			apply(state, true)

			local control = {}
			function control:SetValue(v, silent)
				apply(v, silent)
			end
			function control:GetValue()
				return state
			end
			return control
		end

		function sectionObject:CreateSlider(opts)
			opts = opts or {}
			local text = opts.Text or "Slider"
			local min = tonumber(opts.Min) or 0
			local max = tonumber(opts.Max) or 100
			local default = tonumber(opts.Default) or min
			local increment = tonumber(opts.Increment) or 1
			local callback = opts.Callback or function() end
			local flag = opts.Flag or text

			local row = create("Frame", {
				BackgroundColor3 = Library.Theme.Panel,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 70),
				Parent = section.Inner
			})
			roundCorner(row, 12)
			stroke(row, 0.62, 1)

			local lbl = create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(14, 10),
				Size = UDim2.new(1, -110, 0, 16),
				Font = Enum.Font.GothamSemibold,
				Text = tostring(text),
				TextColor3 = Library.Theme.Text,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = row
			})

			local valueLabel = create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -88, 0, 10),
				Size = UDim2.fromOffset(74, 16),
				Font = Enum.Font.GothamMedium,
				Text = tostring(default),
				TextColor3 = Library.Theme.TextDim,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Right,
				Parent = row
			})

			local barBack = create("Frame", {
				BackgroundColor3 = Library.Theme.Black,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(14, 38),
				Size = UDim2.new(1, -28, 0, 10),
				Parent = row
			})
			roundCorner(barBack, 999)
			stroke(barBack, 0.78, 1)

			local fill = create("Frame", {
				BackgroundColor3 = Library.Theme.White,
				BorderSizePixel = 0,
				Size = UDim2.new(0, 0, 1, 0),
				Parent = barBack
			})
			roundCorner(fill, 999)

			local knob = create("Frame", {
				BackgroundColor3 = Library.Theme.White,
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(16, 16),
				Position = UDim2.new(0, -8, 0.5, -8),
				Parent = barBack
			})
			roundCorner(knob, 999)
			stroke(knob, 0.85, 1)

			local dragging = false
			local value = default

			local function applyVisual(v, silent)
				local clamped = math.clamp(v, min, max)
				local stepped = roundNumber(clamped, increment)
				value = math.clamp(stepped, min, max)

				local alpha = (value - min) / (max - min)
				alpha = math.clamp(alpha, 0, 1)

				tween(fill, 0.08, {Size = UDim2.new(alpha, 0, 1, 0)})
				tween(knob, 0.08, {Position = UDim2.new(alpha, -8, 0.5, -8)})
				setText(valueLabel, tostring(value))
				window.Flags[flag] = value

				if not silent then
					pcall(callback, value)
					if window.AutoSaveConfig then
						task.spawn(function()
							window:SaveConfig()
						end)
					end
				end
			end

			local function updateFromInput(input)
				local mouseX = input.Position.X
				local rel = (mouseX - barBack.AbsolutePosition.X) / barBack.AbsoluteSize.X
				rel = math.clamp(rel, 0, 1)
				local raw = min + (max - min) * rel
				applyVisual(raw, false)
			end

			barBack.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					updateFromInput(input)
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					updateFromInput(input)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)

			registerControlFlag(flag, value, applyVisual)
			applyVisual(default, true)

			local control = {}
			function control:SetValue(v, silent)
				applyVisual(v, silent)
			end
			function control:GetValue()
				return value
			end
			return control
		end

		function sectionObject:CreateDropdown(opts)
			opts = opts or {}
			local text = opts.Text or "Dropdown"
			local list = opts.Options or {}
			local default = opts.Default or list[1]
			local callback = opts.Callback or function() end
			local flag = opts.Flag or text

			local row = create("Frame", {
				BackgroundColor3 = Library.Theme.Panel,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 42),
				ClipsDescendants = true,
				Parent = section.Inner
			})
			roundCorner(row, 12)
			stroke(row, 0.62, 1)

			local button = create("TextButton", {
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				Size = UDim2.fromScale(1, 1),
				Text = "",
				Parent = row
			})

			local lbl = create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(14, 0),
				Size = UDim2.new(0.65, -16, 1, 0),
				Font = Enum.Font.GothamSemibold,
				Text = tostring(text),
				TextColor3 = Library.Theme.Text,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = row
			})

			local selectedLabel = create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -180, 0, 0),
				Size = UDim2.fromOffset(140, 42),
				Font = Enum.Font.GothamMedium,
				Text = tostring(default or "None"),
				TextColor3 = Library.Theme.TextDim,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Right,
				Parent = row
			})

			local arrow = create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -28, 0, 0),
				Size = UDim2.fromOffset(16, 42),
				Font = Enum.Font.GothamSemibold,
				Text = "⌄",
				TextColor3 = Library.Theme.Text,
				TextSize = 16,
				Parent = row
			})

			local listWrap = create("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0, 42),
				Size = UDim2.new(1, 0, 0, 0),
				ClipsDescendants = true,
				Visible = false,
				Parent = row
			})

			local scroller = create("ScrollingFrame", {
				BackgroundColor3 = Library.Theme.Panel2,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				ScrollBarThickness = 3,
				ScrollBarImageColor3 = Library.Theme.White,
				ScrollBarImageTransparency = 0.4,
				Parent = listWrap
			})
			roundCorner(scroller, 10)
			stroke(scroller, 0.72, 1)
			padding(scroller, 6, 6, 6, 6)

			local optionLayout = create("UIListLayout", {
				Padding = UDim.new(0, 6),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = scroller
			})

			local open = false
			local current = default or list[1]

			local function refreshCanvas()
				scroller.CanvasSize = UDim2.fromOffset(0, optionLayout.AbsoluteContentSize.Y + 4)
			end
			refreshCanvas()
			optionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshCanvas)

			local function closeDropdown()
				if not open then
					return
				end
				open = false
				tween(arrow, 0.16, {Rotation = 0})
				local t = tween(listWrap, 0.18, {Size = UDim2.new(1, 0, 0, 0)})
				t.Completed:Connect(function()
					if row and row.Parent and not open then
						listWrap.Visible = false
					end
				end)
			end

			local function openDropdown()
				if open then
					return
				end
				open = true
				listWrap.Visible = true
				tween(arrow, 0.16, {Rotation = 180})
				local openHeight = math.clamp(#list * 30 + 12, 36, 160)
				tween(listWrap, 0.18, {Size = UDim2.new(1, 0, 0, openHeight)})
			end

			local function setValue(v, silent)
				if v == nil then
					return
				end
				current = v
				setText(selectedLabel, tostring(v))
				window.Flags[flag] = v
				if not silent then
					pcall(callback, v)
					if window.AutoSaveConfig then
						task.spawn(function()
							window:SaveConfig()
						end)
					end
				end
			end

			button.MouseButton1Click:Connect(function()
				if open then
					closeDropdown()
				else
					openDropdown()
				end
			end)

			row.MouseEnter:Connect(function()
				tween(row, 0.12, {BackgroundColor3 = Library.Theme.Panel2})
			end)

			row.MouseLeave:Connect(function()
				tween(row, 0.12, {BackgroundColor3 = Library.Theme.Panel})
			end)

			for i, option in ipairs(list) do
				local opt = create("TextButton", {
					BackgroundColor3 = Library.Theme.Panel,
					BorderSizePixel = 0,
					AutoButtonColor = false,
					Size = UDim2.new(1, 0, 0, 28),
					Font = Enum.Font.GothamMedium,
					Text = tostring(option),
					TextColor3 = Library.Theme.Text,
					TextSize = 13,
					Parent = scroller
				})
				roundCorner(opt, 8)
				stroke(opt, 0.8, 1)

				opt.MouseEnter:Connect(function()
					tween(opt, 0.11, {BackgroundColor3 = Library.Theme.White, TextColor3 = Library.Theme.Black})
				end)

				opt.MouseLeave:Connect(function()
					if current == option then
						tween(opt, 0.11, {BackgroundColor3 = Library.Theme.White, TextColor3 = Library.Theme.Black})
					else
						tween(opt, 0.11, {BackgroundColor3 = Library.Theme.Panel, TextColor3 = Library.Theme.Text})
					end
				end)

				opt.MouseButton1Click:Connect(function()
					setValue(option, false)
					closeDropdown()
				end)

				if current == option then
					opt.BackgroundColor3 = Library.Theme.White
					opt.TextColor3 = Library.Theme.Black
				end
			end

			registerControlFlag(flag, current, setValue)
			setValue(current or default, true)

			local control = {}
			function control:SetValue(v, silent)
				setValue(v, silent)
			end
			function control:GetValue()
				return current
			end
			return control
		end

		return sectionObject
	end

	function window:CreateTab(tabName)
		local tab = {}
		tab.Name = tabName
		tab.Controls = {}
		tab.Sections = {}

		local tabButton = create("TextButton", {
			BackgroundColor3 = Library.Theme.Panel,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Size = UDim2.new(1, 0, 0, mobile and 38 or 40),
			Font = Enum.Font.GothamSemibold,
			Text = tostring(tabName),
			TextColor3 = Library.Theme.Text,
			TextSize = 13,
			Parent = sidebarList
		})
		roundCorner(tabButton, 10)
		stroke(tabButton, 0.72, 1)

		local leftBar = create("Frame", {
			BackgroundColor3 = Library.Theme.White,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 3, 0, 18),
			Position = UDim2.new(0, 8, 0.5, -9),
			Visible = false,
			Parent = tabButton
		})
		roundCorner(leftBar, 999)

		local tabLabel = create("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(16, 0),
			Size = UDim2.new(1, -24, 1, 0),
			Font = Enum.Font.GothamSemibold,
			Text = tostring(tabName),
			TextColor3 = Library.Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = tabButton
		})

		local page = create("ScrollingFrame", {
			Name = tabName .. "_Page",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = false,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollBarThickness = 4,
			ScrollBarImageColor3 = Library.Theme.White,
			ScrollBarImageTransparency = 0.45,
			Parent = pagesHolder
		})
		padding(page, 10, 12, 10, 10)

		local pageLayout = create("UIListLayout", {
			Padding = UDim.new(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = page
		})

		local function syncCanvas()
			page.CanvasSize = UDim2.fromOffset(0, pageLayout.AbsoluteContentSize.Y + 12)
		end
		syncCanvas()
		pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(syncCanvas)

		local autoSection
		local function ensureAutoSection()
			if autoSection then
				return autoSection
			end
			autoSection = tab:CreateSection("")
			return autoSection
		end

		function tab:SetVisible(v)
			page.Visible = v
			leftBar.Visible = v
			if v then
				tabButton.BackgroundColor3 = Library.Theme.White
				tabLabel.TextColor3 = Library.Theme.Black
			else
				tabButton.BackgroundColor3 = Library.Theme.Panel
				tabLabel.TextColor3 = Library.Theme.Text
			end
		end

		function tab:CreateSection(sectionTitle)
			local section = {}
			section.Title = sectionTitle or ""

			local sectionFrame = create("Frame", {
				BackgroundColor3 = Library.Theme.Panel,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Parent = page
			})
			roundCorner(sectionFrame, 14)
			stroke(sectionFrame, 0.65, 1)
			padding(sectionFrame, 12, 12, 12, 12)

			local sectionList = create("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Parent = sectionFrame
			})

			local listLayout = create("UIListLayout", {
				Padding = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = sectionList
			})

			if sectionTitle and sectionTitle ~= "" then
				local header = create("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 18),
					Font = Enum.Font.GothamSemibold,
					Text = tostring(sectionTitle),
					TextColor3 = Library.Theme.Text,
					TextSize = 14,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = sectionList
				})
			end

			local inner = create("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Parent = sectionList
			})

			local innerLayout = create("UIListLayout", {
				Padding = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = inner
			})

			section.Frame = sectionFrame
			section.Inner = inner

			local function wrap(controlBuilder)
				return controlBuilder
			end

			function section:CreateButton(opts)
				return buildSectionControls(section).CreateButton(opts)
			end

			function section:CreateToggle(opts)
				return buildSectionControls(section).CreateToggle(opts)
			end

			function section:CreateSlider(opts)
				return buildSectionControls(section).CreateSlider(opts)
			end

			function section:CreateDropdown(opts)
				return buildSectionControls(section).CreateDropdown(opts)
			end

			return section
		end

		local controlApi = buildSectionControls({
			Inner = ensureAutoSection().Inner
		})

		function tab:CreateButton(opts)
			return ensureAutoSection():CreateButton(opts)
		end

		function tab:CreateToggle(opts)
			return ensureAutoSection():CreateToggle(opts)
		end

		function tab:CreateSlider(opts)
			return ensureAutoSection():CreateSlider(opts)
		end

		function tab:CreateDropdown(opts)
			return ensureAutoSection():CreateDropdown(opts)
		end

		tab.Page = page
		tab.Button = tabButton
		table.insert(self.Tabs, tab)

		tabButton.MouseEnter:Connect(function()
			if self.CurrentTab ~= tab then
				tween(tabButton, 0.12, {BackgroundColor3 = Library.Theme.Panel2})
			end
		end)

		tabButton.MouseLeave:Connect(function()
			if self.CurrentTab ~= tab then
				tween(tabButton, 0.12, {BackgroundColor3 = Library.Theme.Panel})
			end
		end)

		tabButton.MouseButton1Click:Connect(function()
			for _, t in ipairs(self.Tabs) do
				t:SetVisible(t == tab)
				if t ~= tab then
					t.Page.Visible = false
				end
			end
			self.CurrentTab = tab
			page.Visible = true
		end)

		if not self.CurrentTab then
			self.CurrentTab = tab
			tab:SetVisible(true)
			page.Visible = true
		end

		return tab
	end

	function window:SelectTab(tab)
		if not tab then
			return
		end
		for _, t in ipairs(self.Tabs) do
			t:SetVisible(t == tab)
			t.Page.Visible = t == tab
		end
		self.CurrentTab = tab
	end

	local function startLoading()
		task.spawn(function()
			local total = 100
			for i = 0, total do
				local a = i / total
				barFill.Size = UDim2.new(a, 0, 1, 0)
				setText(loaderPct, tostring(i) .. "%")
				if i < 35 then
					setText(loaderSub, "Preparing interface")
				elseif i < 70 then
					setText(loaderSub, "Building elements")
				else
					setText(loaderSub, "Finishing")
				end
				task.wait(0.012)
			end

			task.wait(0.12)
			tween(loader, 0.25, {GroupTransparency = 1})
			tween(main, 0.35, {GroupTransparency = 0})
			task.wait(0.3)
			if loader then
				loader:Destroy()
			end
		end)
	end

	startLoading()

	if window.AutoLoadConfig then
		task.spawn(function()
			window:LoadConfig()
		end)
	end

	window:Notify("Law-XW loaded", 2)

	return window
end

return Library
