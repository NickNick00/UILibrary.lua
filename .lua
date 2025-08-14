-- UILibrary.lua (Este é o conteúdo que irá para o GitHub)
-- Esta é a biblioteca que será carregada remotamente.

local UILibrary = {}
UILibrary.__index = UILibrary

local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function UILibrary.new()
	local self = setmetatable({}, UILibrary)

	pcall(function() CoreGui:FindFirstChild("FTF_MainScreenGui"):Destroy() end)
	
	self.Toggles = {}
	self.Pages = {}
	
	self.screenGui = Instance.new("ScreenGui", CoreGui)
	self.screenGui.Name = "FTF_MainScreenGui"
	self.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

	local mainFrame = Instance.new("Frame", self.screenGui)
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 380, 0, 420)
	mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	mainFrame.ClipsDescendants = true
	Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
	Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(50, 50, 50)
	self.mainFrame = mainFrame

	local topbar = Instance.new("Frame", mainFrame)
	topbar.Name = "Topbar"
	topbar.Size = UDim2.new(1, 0, 0, 35)
	topbar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, 8)
	local topbarLayout = Instance.new("UIListLayout", topbar)
	topbarLayout.FillDirection = Enum.FillDirection.Horizontal
	topbarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	topbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	local topbarPadding = Instance.new("UIPadding", topbar)
	topbarPadding.PaddingLeft = UDim.new(0, 12)
	topbarPadding.PaddingRight = UDim.new(0, 12)

	local title = Instance.new("TextLabel", topbar)
	title.Name = "Title"; title.Size = UDim2.new(1, -95, 1, 0); title.BackgroundTransparency = 1; title.Font = Enum.Font.SourceSansBold; title.Text = "FREE THE FACILITY"; title.TextColor3 = Color3.fromRGB(255, 255, 255); title.TextSize = 16; title.TextXAlignment = Enum.TextXAlignment.Left; title.LayoutOrder = 1

	local controls = Instance.new("Frame", topbar)
	controls.Name = "Controls"; controls.Size = UDim2.new(0, 85, 1, 0); controls.BackgroundTransparency = 1; controls.LayoutOrder = 2
	local controlsLayout = Instance.new("UIListLayout", controls)
	controlsLayout.FillDirection = Enum.FillDirection.Horizontal; controlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right; controlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center; controlsLayout.Padding = UDim.new(0, 10)

	local settingsButton = Instance.new("TextButton", controls)
	settingsButton.LayoutOrder = 3; settingsButton.Size = UDim2.new(0, 20, 0, 20); settingsButton.BackgroundTransparency = 1; settingsButton.Font = Enum.Font.SourceSansBold; settingsButton.Text = "⚙"; settingsButton.TextColor3 = Color3.fromRGB(150, 150, 150); settingsButton.TextSize = 18

	local minimizeButton = Instance.new("TextButton", controls)
	minimizeButton.LayoutOrder = 2; minimizeButton.Size = UDim2.new(0, 20, 0, 20); minimizeButton.BackgroundTransparency = 1; minimizeButton.Font = Enum.Font.SourceSansBold; minimizeButton.Text = "—"; minimizeButton.TextColor3 = Color3.fromRGB(150, 150, 150); minimizeButton.TextSize = 18

	local closeButton = Instance.new("TextButton", controls)
	closeButton.LayoutOrder = 1; closeButton.Size = UDim2.new(0, 20, 0, 20); closeButton.BackgroundTransparency = 1; closeButton.Font = Enum.Font.SourceSansBold; closeButton.Text = "X"; closeButton.TextColor3 = Color3.fromRGB(150, 150, 150); closeButton.TextSize = 18

	local tabsContainer = Instance.new("Frame", mainFrame)
	tabsContainer.Name = "TabsContainer"; tabsContainer.Size = UDim2.new(1, 0, 0, 40); tabsContainer.Position = UDim2.new(0, 0, 0, 35); tabsContainer.BackgroundTransparency = 1
	local tabsLayout = Instance.new("UIListLayout", tabsContainer)
	tabsLayout.FillDirection = Enum.FillDirection.Horizontal; tabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center; tabsLayout.Padding = UDim.new(0, 15)
	Instance.new("UIPadding", tabsContainer).PaddingLeft = UDim.new(0, 12)
	self.tabsContainer = tabsContainer

	local separator = Instance.new("Frame", mainFrame)
	separator.Name = "Separator"; separator.Size = UDim2.new(1, -24, 0, 1); separator.Position = UDim2.new(0.5, 0, 0, 75); separator.AnchorPoint = Vector2.new(0.5, 0); separator.BackgroundColor3 = Color3.fromRGB(50, 50, 50); separator.BorderSizePixel = 0

	local body = Instance.new("Frame", mainFrame)
	body.Name = "Body"; body.Size = UDim2.new(1, 0, 1, -76); body.Position = UDim2.new(0, 0, 0, 76); body.BackgroundTransparency = 1; body.ClipsDescendants = true
	self.body = body

	local dragHandle = Instance.new("Frame", mainFrame)
	dragHandle.Name = "DragHandle"; dragHandle.Size = UDim2.new(0, 60, 0, 5); dragHandle.Position = UDim2.new(0.5, 0, 1, -10); dragHandle.AnchorPoint = Vector2.new(0.5, 1); dragHandle.BackgroundColor3 = Color3.fromRGB(80, 80, 80); dragHandle.BorderSizePixel = 0
	Instance.new("UICorner", dragHandle).CornerRadius = UDim.new(1, 0)

	local originalSize = mainFrame.Size
	settingsButton.MouseButton1Click:Connect(function() self:SetActiveTab(self.Pages["Settings"]) end)
	closeButton.MouseButton1Click:Connect(function() self.screenGui:Destroy() end)
	local isMinimized = false
	minimizeButton.MouseButton1Click:Connect(function()
		isMinimized = not isMinimized
		body.Visible, tabsContainer.Visible, separator.Visible, dragHandle.Visible = not isMinimized, not isMinimized, not isMinimized, not isMinimized
		local nY = isMinimized and 35 or originalSize.Y.Offset
		mainFrame:TweenSize(UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, nY), "Out", "Quad", 0.2, true)
	end)

	local draggingWindow, windowDragInput, windowDragStart, windowStartPos = false, nil, nil, nil
	local function UpdateWindowPosition(input)
		local delta = input.Position - windowDragStart
		mainFrame.Position = UDim2.new(windowStartPos.X.Scale, windowStartPos.X.Offset + delta.X, windowStartPos.Y.Scale, windowStartPos.Y.Offset + delta.Y)
	end
	local function EnableWindowDrag(element)
		element.InputBegan:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not draggingWindow then
				draggingWindow, windowDragStart, windowStartPos, windowDragInput = true, input.Position, mainFrame.Position, input
			end
		end)
	end
	UserInputService.InputChanged:Connect(function(input)
		if draggingWindow and windowDragInput and input.UserInputType == windowDragInput.UserInputType then
			UpdateWindowPosition(input)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if draggingWindow and windowDragInput and input.UserInputType == windowDragInput.UserInputType then
			draggingWindow, windowDragInput = false, nil
		end
	end)
	EnableWindowDrag(topbar)
	EnableWindowDrag(dragHandle)

	local settingsPage = self:CreateTab("Settings")
	settingsPage.button.Visible = false
	local heightSlider = settingsPage:CreateSlider("Altura", 250, 600, 420, function(value)
		mainFrame.Size = UDim2.new(0, mainFrame.Size.X.Offset, 0, value)
		originalSize = mainFrame.Size
	end)
	local widthSlider = settingsPage:CreateSlider("Largura", 300, 800, 380, function(value)
		mainFrame.Size = UDim2.new(0, value, 0, mainFrame.Size.Y.Offset)
		originalSize = mainFrame.Size
	end)
	local resetDefaults = settingsPage:CreateButton("Resetar Padrões", function()
		heightSlider:SetValue(420)
		widthSlider:SetValue(380)
	end)
	resetDefaults.BackgroundColor3 = Color3.fromRGB(90, 40, 40)

	return self
end

function UILibrary:SetActiveTab(tab)
	for name, page in pairs(self.Pages) do
		page.frame.Visible = false
		page.button.TextColor3 = Color3.fromRGB(150, 150, 150)
		page.button.Font = Enum.Font.SourceSans
	end
	tab.frame.Visible = true
	tab.button.TextColor3 = Color3.fromRGB(255, 255, 255)
	tab.button.Font = Enum.Font.SourceSansBold
end

function UILibrary:CreateTab(name)
	local tab = {}
	tab.Parent = self
	local p = Instance.new("ScrollingFrame", self.body)
	p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.BorderSizePixel = 0; p.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80); p.ScrollBarThickness = 4; p.Visible = false
	local pl = Instance.new("UIListLayout", p)
	pl.Padding = UDim.new(0, 10); pl.HorizontalAlignment = Enum.HorizontalAlignment.Center
	Instance.new("UIPadding", p).PaddingTop = UDim.new(0, 12)
	tab.frame = p
	local tb = Instance.new("TextButton", self.tabsContainer)
	tb.Name = name; tb.AutomaticSize = Enum.AutomaticSize.X; tb.Size = UDim2.new(0, 0, 1, 0); tb.BackgroundTransparency = 1; tb.Font = Enum.Font.SourceSans; tb.Text = name; tb.TextColor3 = Color3.fromRGB(150, 150, 150); tb.TextSize = 16
	tb.MouseButton1Click:Connect(function() self:SetActiveTab(tab) end)
	tab.button = tb
	self.Pages[name] = tab
	if not self.firstTab then
		self.firstTab = tab
		self:SetActiveTab(tab)
	end
	function tab:CreateToggle(text, onEnable, onDisable)
		self.Parent.Toggles[text] = false
		local cd = Instance.new("TextButton", p)
		cd.Name = text; cd.Size = UDim2.new(1, -24, 0, 45); cd.BackgroundTransparency = 1; cd.Text = ""; cd.AutoButtonColor = false
		local bg = Instance.new("Frame", cd)
		bg.Size = UDim2.new(1, 0, 1, 0); bg.BackgroundColor3 = Color3.fromRGB(45, 45, 45); bg.BackgroundTransparency = 0.5
		Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 10)
		local st = Instance.new("UIStroke", bg); st.Color = Color3.fromRGB(25, 25, 25); st.Thickness = 1.5
		local l = Instance.new("TextLabel", bg)
		l.Size = UDim2.new(1, -50, 1, 0); l.Position = UDim2.new(0, 15, 0, 0); l.BackgroundTransparency = 1; l.Font = Enum.Font.SourceSans; l.Text = text; l.TextColor3 = Color3.fromRGB(220, 220, 220); l.TextSize = 16; l.TextXAlignment = Enum.TextXAlignment.Left
		local cb = Instance.new("Frame", bg)
		cb.Size = UDim2.new(0, 20, 0, 20); cb.Position = UDim2.new(1, -15, 0.5, 0); cb.AnchorPoint = Vector2.new(1, 0.5); cb.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		Instance.new("UICorner", cb).CornerRadius = UDim.new(0, 5); Instance.new("UIStroke", cb).Color = Color3.fromRGB(60, 60, 60)
		local cm = Instance.new("TextLabel", cb)
		cm.Size = UDim2.new(1, 0, 1, 0); cm.BackgroundTransparency = 1; cm.Font = Enum.Font.SourceSansBold; cm.Text = "✓"; cm.TextColor3 = Color3.fromRGB(255, 255, 255); cm.TextSize = 16; cm.Visible = false
		cd.MouseButton1Click:Connect(function()
			self.Parent.Toggles[text] = not self.Parent.Toggles[text]
			local state = self.Parent.Toggles[text]
			cm.Visible = state
			cb.BackgroundColor3 = state and Color3.fromRGB(57, 91, 201) or Color3.fromRGB(35, 35, 35)
			if state and onEnable then pcall(onEnable) elseif not state and onDisable then pcall(onDisable) end
		end)
		return cd
	end
	function tab:CreateButton(text, callback)
		local btn = Instance.new("TextButton", p)
		btn.Name = text .. "Button"; btn.Size = UDim2.new(1, -24, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(57, 91, 201); btn.Font = Enum.Font.SourceSansBold; btn.Text = text; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.TextSize = 16
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
		if callback then btn.MouseButton1Click:Connect(callback) end
		return btn
	end
	function tab:CreateSlider(text, min, max, default, callback)
		local container = Instance.new("Frame", p)
		container.Name = text .. "Slider"; container.Size = UDim2.new(1, -24, 0, 50); container.BackgroundTransparency = 1
		local layout = Instance.new("UIListLayout", container); layout.FillDirection = Enum.FillDirection.Vertical; layout.Padding = UDim.new(0, 5)
		local topFrame = Instance.new("Frame", container); topFrame.Size = UDim2.new(1, 0, 0, 20); topFrame.BackgroundTransparency = 1
		local topLayout = Instance.new("UIListLayout", topFrame); topLayout.FillDirection = Enum.FillDirection.Horizontal; topLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		local label = Instance.new("TextLabel", topFrame); label.Name = "Label"; label.Size = UDim2.new(0.7, 0, 1, 0); label.Font = Enum.Font.SourceSans; label.Text = text; label.TextColor3 = Color3.fromRGB(220, 220, 220); label.TextSize = 16; label.TextXAlignment = Enum.TextXAlignment.Left
		local valueLabel = Instance.new("TextLabel", topFrame); valueLabel.Name = "ValueLabel"; valueLabel.Size = UDim2.new(0.3, 0, 1, 0); valueLabel.Font = Enum.Font.SourceSansBold; valueLabel.TextColor3 = Color3.fromRGB(150, 150, 150); valueLabel.TextSize = 14; valueLabel.TextXAlignment = Enum.TextXAlignment.Right
		local sliderFrame = Instance.new("Frame", container); sliderFrame.Size = UDim2.new(1, 0, 0, 20); sliderFrame.BackgroundTransparency = 1
		local track = Instance.new("Frame", sliderFrame); track.Name = "Track"; track.Size = UDim2.new(1, 0, 0, 4); track.AnchorPoint = Vector2.new(0, 0.5); track.Position = UDim2.new(0, 0, 0.5, 0); track.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
		local handle = Instance.new("TextButton", track); handle.Name = "Handle"; handle.Size = UDim2.new(0, 16, 0, 16); handle.AnchorPoint = Vector2.new(0.5, 0.5); handle.Position = UDim2.new(0, 0, 0.5, 0); handle.BackgroundColor3 = Color3.fromRGB(57, 91, 201); handle.AutoButtonColor = false; handle.Text = ""; Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)
		local sliderObject = {}
		function sliderObject:UpdateFromPosition(inputPos)
			local trackSize = track.AbsoluteSize.X; local handleRadius = handle.AbsoluteSize.X / 2
			local relativeX = inputPos.X - track.AbsolutePosition.X - handleRadius
			local clampedX = math.clamp(relativeX, 0, trackSize - handleRadius * 2)
			local percentage = (trackSize - handleRadius * 2) > 0 and (clampedX / (trackSize - handleRadius * 2)) or 0
			local value = math.floor(min + percentage * (max - min) + 0.5)
			handle.Position = UDim2.new(percentage, 0, 0.5, 0)
			valueLabel.Text = tostring(value) .. "px"
			if callback then pcall(callback, value) end
		end
		function sliderObject:SetValue(value)
			local percentage = (max - min) > 0 and (value - min) / (max - min) or 0
			percentage = math.clamp(percentage, 0, 1)
			handle.Position = UDim2.new(percentage, 0, 0.5, 0)
			valueLabel.Text = tostring(math.floor(value + 0.5)) .. "px"
			if callback then pcall(callback, value) end
		end
		handle.InputBegan:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				tab.Parent.draggingSlider, tab.Parent.currentSliderInput = true, {input = input, object = sliderObject}
				UserInputService.ModalEnabled = true
			end
		end)
		sliderObject:SetValue(default)
		return sliderObject
	end
	return tab
end

local draggingSlider, currentSliderInput = false, nil
UserInputService.InputChanged:Connect(function(input)
	if draggingSlider and currentSliderInput and input.UserInputType == currentSliderInput.input.UserInputType then
		currentSliderInput.object:UpdateFromPosition(input)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if draggingSlider and currentSliderInput and input.UserInputType == currentSliderInput.input.UserInputType then
		draggingSlider, currentSliderInput = false, nil
		UserInputService.ModalEnabled = false
	end
end)

return UILibrary -- IMPORTANTE: Isso faz com que loadstring retorne a tabela UILibrary
