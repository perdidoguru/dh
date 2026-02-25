--[[

DASH HUB Library by guru

]]

--// Core
local LucideIcons = loadstring( game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/src/Icons.lua") )()
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Library = {}

--// Globals
local player = Players.LocalPlayer
local mouse = player:GetMouse()

--// Themes.lua
Library.Theme = "Default"
Library.Themes = {
	["Default"] = {
		TabButtonSize = 54,
		Padding = 16,
		BackgroundColor = Color3.fromHex("#040c1f"),
		PanelsColor = Color3.fromHex("#040c1f"),
		BorderColor = Color3.fromHex("#0073ff"),
		AccentColor = Color3.fromHex("#103168"),
		PrimaryFontColor = Color3.fromHex("#e5e7eb"),
		SecondaryFontColor = Color3.fromHex("#9ca3af"),
		PrimaryRoundedCornerRadius = UDim.new(0,12),
	}
}

local ct = Library.Themes[Library.Theme]

--// Utils.lua
--// Globals
local lastTouch, touchPos = nil, nil

--// Connections
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        lastTouch = input
        touchPos = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == lastTouch then
        touchPos = input.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        if lastTouch ~= input then return end

        lastTouch = nil
    end
end)

--// Methods
local function build(className, parent, properties)
    local instance = Instance.new(className)

    for index, value in (properties or {}) do
        instance[index] = value
    end

    instance.Parent = parent

    return instance
end

local function animate(instance, time, properties)
    TweenService:Create(instance, TweenInfo.new(time), properties):Play()
end

local function icon(name)
    return LucideIcons and LucideIcons.assets["lucide-"..name] or ""
end

local function isTouchDown()
    return lastTouch ~= nil
end

local function getTouchPos()
    return isTouchDown() and touchPos or nil
end

--// Components.lua
local function buildWindow()
    local screenGui = build("ScreenGui", CoreGui, {
        ResetOnSpawn = false
    })

    local window = build("Frame", screenGui, {
        Size = UDim2.new(0, 600, 0, 340),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = ct.BackgroundColor,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
    })

    build("UIPadding", window, {
        PaddingTop = UDim.new(0, ct.Padding+10),
        PaddingBottom = UDim.new(0, ct.Padding+10),
        PaddingLeft = UDim.new(0, ct.Padding+10),
        PaddingRight = UDim.new(0, ct.Padding+10),
    })

    return window
end

local function buildHeader(window)
    --// title
    local title = build("TextLabel", window, {
        Text = "DASH HUB",
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 28),
        TextColor3 = ct.PrimaryFontColor,
        BackgroundTransparency = 1,
    })

    build("UIPadding", title, { PaddingBottom = UDim.new(0, 18) })

    --// subtitle
    local subtitle = build("TextLabel", window, {
        Text = "Death Ball",
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 28),
        TextColor3 = ct.SecondaryFontColor,
        TextTransparency = .5,
        BackgroundTransparency = 1,
    })

    build("UIPadding", subtitle, { PaddingTop = UDim.new(0, 18) })

    --// header
    local header = build("Frame", window, {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
    })

    local miniminizeButton = build("ImageButton", header, {
        Size = UDim2.new(0, 24, 0, 24),
        AnchorPoint = Vector2.new(1,.5),
        Position = UDim2.new(1, -3, .5, -1),
        BackgroundTransparency = 1,
        Image =  LucideIcons and LucideIcons.assets["lucide-minus"] or "",
        ZIndex = 11,
    })

    return header, title, subtitle, miniminizeButton
end

local function buildTabsList(window)
    local tabs = build("Frame", window, {
        Size = UDim2.new(0, ct.TabButtonSize, 1, -28-ct.Padding+4),
        Position = UDim2.new(0, 0, 0, 28+ct.Padding-4),
        BackgroundColor3 = ct.PanelsColor,
        BorderSizePixel = 0,
    })

    local tabsLayout = build("UIListLayout", tabs, {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 20),
    })

    build("UIPadding", tabs, {
        PaddingTop = UDim.new(0, 16),
        PaddingBottom = UDim.new(0, 16),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 24),
    })

    build("UIStroke", tabs, {
        Color = ct.BorderColor,
        Thickness = 1,
        Transparency = .95,
    })

    build("UICorner", tabs, { CornerRadius = ct.PrimaryRoundedCornerRadius })

    return tabs, tabsLayout
end

local function buildMainFrame(window)
    local mainFrame = build("Frame", window)
    mainFrame.Size = UDim2.new(1, -ct.TabButtonSize-ct.Padding, 1, -28-ct.Padding+4)
    mainFrame.Position = UDim2.new(0, ct.TabButtonSize+ct.Padding, 0, 28+ct.Padding-4)
    mainFrame.BackgroundColor3 = ct.PanelsColor
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true

   build("UIStroke", mainFrame, {
        Color = ct.BorderColor,
        Thickness = 1,
        Transparency = .95,
    })

    build("UICorner", mainFrame, { CornerRadius = ct.PrimaryRoundedCornerRadius })

    local mainLayout = build("UIPageLayout", mainFrame, {
        FillDirection = Enum.FillDirection.Vertical,
        EasingStyle = Enum.EasingStyle.Sine,
        EasingDirection = Enum.EasingDirection.Out,
        TweenTime = .3,
    })

    return mainFrame, mainLayout
end

local function buildTabAndPage(name, icon, tabsLayout, mainFrame)
    local tabFrame = build("Frame", tabsLayout.Parent, {
        Size = UDim2.new(1,16,1,16),
        BackgroundTransparency = 1,
        BackgroundColor3 = ct.BorderColor,
    })

    local tabButton = build("ImageButton", tabFrame, {
        Size = UDim2.new(1,0,1,0),
        Image = LucideIcons and LucideIcons.assets["lucide-"..icon] or "",
        ImageTransparency = .5,
        BackgroundTransparency = 1,
    })

    build("UIPadding", tabFrame, {
        PaddingTop = UDim.new(0,10),
        PaddingBottom = UDim.new(0,10),
        PaddingLeft = UDim.new(0,10),
        PaddingRight = UDim.new(0,10),
    })

    build("UICorner", tabFrame, { CornerRadius = ct.PrimaryRoundedCornerRadius })

	build("UIAspectRatioConstraint", tabFrame)

	local tabPage = build("ScrollingFrame", mainFrame, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(1, 0, 1, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    })

    build("UIPadding", tabPage, {
        PaddingTop = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
    })

    build("UIListLayout", tabPage, {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0,4),
    })

    return tabButton, tabPage
end

--// Elements
local function buildSection(tab, info)
    local label = Instance.new("TextLabel")
    label.Text = info.Title:upper()
    label.TextSize = 13
    label.TextTransparency = .7
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = ct.PrimaryFontColor
    label.Size = UDim2.new(1, 0, 0, 24)
    label.BackgroundTransparency = 1
    label.LayoutOrder = tab.__intern.order
    label.AutomaticSize = Enum.AutomaticSize.Y
    tab.__intern.order += 1

    local padding = Instance.new("UIPadding", label)
    padding.PaddingLeft = UDim.new(0,12)
    padding.PaddingRight = UDim.new(0,12)
    padding.PaddingTop = UDim.new(0,8)
    padding.PaddingBottom = UDim.new(0,8)

    return label
end

local function buildParagraph(tab, info)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.LayoutOrder = tab.__intern.order
    tab.__intern.order += 1

    local padding = Instance.new("UIPadding", frame)
    padding.PaddingLeft = UDim.new(0,12)
    padding.PaddingRight = UDim.new(0,12)
    padding.PaddingTop = UDim.new(0,8)
    padding.PaddingBottom = UDim.new(0,8)

    local UIListLayout = Instance.new("UIListLayout", frame)
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.Padding = UDim.new(0, 4)

    if info.Title then
        local title = Instance.new("TextLabel", frame)
        title.Text = info.Title
        title.TextSize = 14
        title.TextWrapped = true
        title.Font = Enum.Font.GothamMedium
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, 0, 0, title.TextBounds.Y)
        title.TextColor3 = ct.PrimaryFontColor
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.AutomaticSize = Enum.AutomaticSize.Y
    end

    local content = Instance.new("TextLabel", frame)
    content.Text = info.Description
    content.TextSize = 12
    content.TextWrapped = true
    content.Font = Enum.Font.GothamMedium
    content.BackgroundTransparency = 1
    content.Size = UDim2.new(1, 0, 0, content.TextBounds.Y)
    content.TextColor3 = ct.SecondaryFontColor
    content.TextTransparency = .5
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.AutomaticSize = Enum.AutomaticSize.Y

    return frame
end

local function buildButton(tab, info)
    --// div
    local frame = Instance.new("TextButton")
    frame.Text = ""
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.LayoutOrder = tab.__intern.order
    frame.BackgroundColor3 = ct.BorderColor
    tab.__intern.order += 1

    local padding = Instance.new("UIPadding", frame)
    padding.PaddingLeft = UDim.new(0,12)
    padding.PaddingRight = UDim.new(0,12)
    padding.PaddingTop = UDim.new(0,8)
    padding.PaddingBottom = UDim.new(0,8)

    local UICorner = Instance.new("UICorner", frame)
    UICorner.CornerRadius = ct.PrimaryRoundedCornerRadius

    local UIStroke = Instance.new("UIStroke", frame)
    UIStroke.Transparency = 1
    UIStroke.Color = ct.BorderColor
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local UIListLayout = Instance.new("UIListLayout", frame)
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.Padding = UDim.new(0, 4)

    --// title
    local title = Instance.new("TextLabel", frame)
    title.Text = info.Title
    title.TextSize = 14
    title.TextWrapped = true
    title.Font = Enum.Font.GothamMedium
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, title.TextBounds.Y)
    title.TextColor3 = ct.PrimaryFontColor
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.AutomaticSize = Enum.AutomaticSize.Y

    --// description
    local content = Instance.new("TextLabel", frame)
    content.Text = info.Description
    content.TextSize = 12
    content.TextWrapped = true
    content.Font = Enum.Font.GothamMedium
    content.BackgroundTransparency = 1
    content.Size = UDim2.new(1, 0, 0, content.TextBounds.Y)
    content.TextColor3 = ct.SecondaryFontColor
    content.TextTransparency = .5
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.AutomaticSize = Enum.AutomaticSize.Y

    return frame
end

local function buildToggle(tab, info)
    --// div
    local div = Instance.new("TextButton")
    div.Text = ""
    div.Size = UDim2.new(1, 0, 0, 0)
    div.BackgroundTransparency = 1
    div.AutomaticSize = Enum.AutomaticSize.Y
    div.LayoutOrder = tab.__intern.order
    div.BackgroundColor3 = ct.BorderColor
    tab.__intern.order += 1

    local list = Instance.new("Frame", div)
    list.Size = UDim2.new(1,-32,0,0)
    list.AutomaticSize = Enum.AutomaticSize.Y
    list.BackgroundTransparency = 1

    --// extra
    local padding = Instance.new("UIPadding", div)
    padding.PaddingLeft = UDim.new(0,12)
    padding.PaddingRight = UDim.new(0,12)
    padding.PaddingTop = UDim.new(0,8)
    padding.PaddingBottom = UDim.new(0,8)

    local corner = Instance.new("UICorner", div)
    corner.CornerRadius = ct.PrimaryRoundedCornerRadius

    local stroke = Instance.new("UIStroke", div)
    stroke.Transparency = 1
    stroke.Color = ct.BorderColor
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local listLayout = Instance.new("UIListLayout", list)
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.Padding = UDim.new(0, 4)

    --// title
    local title = Instance.new("TextLabel", list)
    title.Text = info.Title
    title.TextSize = 14
    title.TextWrapped = true
    title.Font = Enum.Font.GothamMedium
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, title.TextBounds.Y)
    title.TextColor3 = ct.PrimaryFontColor
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.AutomaticSize = Enum.AutomaticSize.Y

    --// description
    local content = Instance.new("TextLabel", list)
    content.Text = info.Description
    content.TextSize = 12
    content.TextWrapped = true
    content.Font = Enum.Font.GothamMedium
    content.BackgroundTransparency = 1
    content.Size = UDim2.new(1, 0, 0, content.TextBounds.Y)
    content.TextColor3 = ct.SecondaryFontColor
    content.TextTransparency = .5
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.AutomaticSize = Enum.AutomaticSize.Y

    --// toggle visual
    local visual = Instance.new("Frame", div)
    visual.Size = UDim2.new(0,22,0,22)
    visual.BackgroundTransparency = 1
    visual.AnchorPoint = Vector2.new(1,.5)
    visual.Position = UDim2.new(1,0,.5,0)

    local vcorner = Instance.new("UICorner", visual)
    vcorner.CornerRadius = UDim.new(0,6)

    local vstroke = Instance.new("UIStroke", visual)
    vstroke.Color = ct.BorderColor
    vstroke.Transparency = .95

    local enabled = Instance.new("ImageLabel", visual)
    enabled.AnchorPoint = Vector2.new(.5,.5)
    enabled.Position = UDim2.new(.5,0,.5,0)
    enabled.Size = UDim2.new(1,0,1,0)
    enabled.BackgroundColor3 = ct.AccentColor
    enabled.ImageColor3 = ct.SecondaryFontColor
    enabled.Image = icon("check")

    local ecorner = Instance.new("UICorner", enabled)
    ecorner.CornerRadius = UDim.new(0,6)

    local escale = Instance.new("UIScale", enabled)
    escale.Scale = info.Default and 1 or 0

    return div, escale
end

local function buildSlider(tab, info)
    --// div
    local div = Instance.new("TextButton")
    div.Text = ""
    div.Size = UDim2.new(1, 0, 0, 0)
    div.BackgroundTransparency = 1
    div.AutomaticSize = Enum.AutomaticSize.Y
    div.LayoutOrder = tab.__intern.order
    div.BackgroundColor3 = ct.BorderColor
    tab.__intern.order += 1

    local list = Instance.new("Frame", div)
    list.Size = UDim2.new(1,-172,0,0)
    list.AutomaticSize = Enum.AutomaticSize.Y
    list.BackgroundTransparency = 1

    --// extra
    local padding = Instance.new("UIPadding", div)
    padding.PaddingLeft = UDim.new(0,12)
    padding.PaddingRight = UDim.new(0,12)
    padding.PaddingTop = UDim.new(0,8)
    padding.PaddingBottom = UDim.new(0,8)

    local corner = Instance.new("UICorner", div)
    corner.CornerRadius = ct.PrimaryRoundedCornerRadius

    local stroke = Instance.new("UIStroke", div)
    stroke.Transparency = 1
    stroke.Color = ct.BorderColor
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local listLayout = Instance.new("UIListLayout", list)
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.Padding = UDim.new(0, 4)

    --// title
    local title = Instance.new("TextLabel", list)
    title.Text = info.Title
    title.TextSize = 14
    title.TextWrapped = true
    title.Font = Enum.Font.GothamMedium
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, title.TextBounds.Y)
    title.TextColor3 = ct.PrimaryFontColor
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.AutomaticSize = Enum.AutomaticSize.Y

    --// description
    local content = Instance.new("TextLabel", list)
    content.Text = info.Description
    content.TextSize = 12
    content.TextWrapped = true
    content.Font = Enum.Font.GothamMedium
    content.BackgroundTransparency = 1
    content.Size = UDim2.new(1, 0, 0, content.TextBounds.Y)
    content.TextColor3 = ct.SecondaryFontColor
    content.TextTransparency = .5
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.AutomaticSize = Enum.AutomaticSize.Y

    --// toggle visual
    local visual = Instance.new("TextButton", div)
    visual.Size = UDim2.new(0,128,0,6)
    visual.BackgroundTransparency = 1
    visual.AnchorPoint = Vector2.new(1,.5)
    visual.Position = UDim2.new(1,0,.5,0)
    visual.Text = ""
    visual.BorderSizePixel = 0

    local vcorner = Instance.new("UICorner", visual)
    vcorner.CornerRadius = UDim.new(0,4)

    local vstroke = Instance.new("UIStroke", visual)
    vstroke.Color = ct.BorderColor
    vstroke.Transparency = .95
    vstroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local current = Instance.new("Frame", visual)
    current.AnchorPoint = Vector2.new(.5,.5)
    current.Position = UDim2.new(0,0,.5,0)
    current.Size = UDim2.new(0,6,0,16)
    current.BackgroundColor3 = ct.AccentColor

    local ccorner = Instance.new("UICorner", current)
    ccorner.CornerRadius = UDim.new(0,2)

    local fill = Instance.new("Frame", visual)
    fill.Size = UDim2.new(0,0,1,0)
    fill.BackgroundColor3 = ct.AccentColor

    local fcorner = Instance.new("UICorner", fill)
    fcorner.CornerRadius = UDim.new(0,4)

    local area = Instance.new("TextButton", visual)
    area.Text = ""
    area.Size = UDim2.new(1,16,1,16)
    area.AnchorPoint = Vector2.new(.5,.5)
    area.Position = UDim2.new(.5,0,.5,0)
    area.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", visual)
    label.TextXAlignment = Enum.TextXAlignment.Right
    label.BackgroundTransparency = 1
    label.TextSize = 14
    label.Position = UDim2.new(0,-12,0,0)
    label.AnchorPoint = Vector2.new(1,0)
    label.Size = UDim2.new(0,0,1,0)
    label.AutomaticSize = Enum.AutomaticSize.X
    label.TextColor3 = ct.SecondaryFontColor
    label.Font = Enum.Font.GothamMedium
    label.TextTransparency = .5

    --// preset
    local scale = (info.Default or 50) / (info.Max or 100)

    fill.Size = UDim2.new(math.clamp(scale,0,1),0,1,0)
    current.Position = UDim2.new(math.clamp(scale,0,1),0,.5,0)
    label.Text = info.Default or 50

    return div, visual, fill, current, area, label
end

local function buildKeybind(tab, info)
    --// div (main container for the keybind)
    local div = Instance.new("TextButton")
    div.Text = ""
    div.Size = UDim2.new(1, 0, 0, 0)
    div.BackgroundTransparency = 1
    div.AutomaticSize = Enum.AutomaticSize.Y
    div.LayoutOrder = tab.__intern.order
    div.BackgroundColor3 = ct.BorderColor -- This will be used for hover/active state
    tab.__intern.order += 1

    -- Container for title and description, respecting the -32 width
    local textContainer = Instance.new("Frame", div)
    textContainer.Size = UDim2.new(1, -96, 0, 0) -- Full width minus 32 for key display
    textContainer.AutomaticSize = Enum.AutomaticSize.Y
    textContainer.BackgroundTransparency = 1
    textContainer.Position = UDim2.new(0, 0, 0, 0)

    local textLayout = Instance.new("UIListLayout", textContainer)
    textLayout.FillDirection = Enum.FillDirection.Vertical
    textLayout.Padding = UDim.new(0, 4)

    --// extra padding for the main div
    local padding = Instance.new("UIPadding", div)
    padding.PaddingLeft = UDim.new(0,12)
    padding.PaddingRight = UDim.new(0,12)
    padding.PaddingTop = UDim.new(0,8)
    padding.PaddingBottom = UDim.new(0,8)

    local corner = Instance.new("UICorner", div)
    corner.CornerRadius = ct.PrimaryRoundedCornerRadius

    local stroke = Instance.new("UIStroke", div)
    stroke.Transparency = 1
    stroke.Color = ct.BorderColor
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    --// title
    local title = Instance.new("TextLabel", textContainer)
    title.Text = info.Title
    title.TextSize = 14
    title.TextWrapped = true
    title.Font = Enum.Font.GothamMedium
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, title.TextBounds.Y)
    title.TextColor3 = ct.PrimaryFontColor
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.AutomaticSize = Enum.AutomaticSize.Y

    --// description
    local content = Instance.new("TextLabel", textContainer)
    content.Text = info.Description
    content.TextSize = 12
    content.TextWrapped = true
    content.Font = Enum.Font.GothamMedium
    content.BackgroundTransparency = 1
    content.Size = UDim2.new(1, 0, 0, content.TextBounds.Y)
    content.TextColor3 = ct.SecondaryFontColor
    content.TextTransparency = .5
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.AutomaticSize = Enum.AutomaticSize.Y

    -- Key display label
    local keyLabel = Instance.new("TextLabel", div)
    keyLabel.Name = "KeyDisplay"
    keyLabel.Text = tostring(info.Default and info.Default.Name or "...")
    keyLabel.TextSize = 14
    keyLabel.Font = Enum.Font.GothamMedium
    keyLabel.TextColor3 = ct.SecondaryFontColor -- Changed to secondaryfontcolor
    keyLabel.BackgroundTransparency = 1
    keyLabel.Size = UDim2.new(0, 0, 1, 0) -- Auto size X, full height
    keyLabel.AutomaticSize = Enum.AutomaticSize.X
    keyLabel.Position = UDim2.new(1, -12, 0.5, 0) -- Position to the right, with padding
    keyLabel.AnchorPoint = Vector2.new(1, 0.5)
    keyLabel.TextXAlignment = Enum.TextXAlignment.Right

    return div, title, keyLabel
end

--// Tab.lua
local Tab = {}
Tab.__index = Tab

function Tab.__create(window, name, icon, button, page)
    local self = setmetatable({}, Tab)

    self.__intern = {
        --// gui
        button      = button,
        page        = page,
        --// values
        order       = 0,
    }

    return self
end

function Tab:AddSection(info)
    local guiElement = buildSection(self, info)
    guiElement.Parent = self.__intern.page
end

function Tab:AddParagraph(info)
    local guiElement = buildParagraph(self, info)
    guiElement.Parent = self.__intern.page
end

function Tab:AddButton(info)
    --// gui element
    local guiElement = buildButton(self, info)
    guiElement.Parent = self.__intern.page

    --// element
    local element = {
        Callback = info.Callback,
    }

    function element:Call()
        if element.Callback then
            element.Callback()
        end
    end

    --// connections
    guiElement.MouseEnter:Connect(function()
        animate(guiElement, .2, {
            BackgroundTransparency = .975
        })
        animate(guiElement.UIStroke, .2, {
            Transparency = .95
        })
    end)

    guiElement.MouseLeave:Connect(function()
        animate(guiElement, .2, {
            BackgroundTransparency = 1
        })
        animate(guiElement.UIStroke, .2, {
            Transparency = 1
        })
    end)

    guiElement.MouseButton1Down:Connect(function()
        element:Call()
    end)

    return element
end

function Tab:AddToggle(info)
    --// gui element
    local guiElement, scale = buildToggle(self, info)
    guiElement.Parent = self.__intern.page

    --// element
    local element = {
        Callback = info.Callback
    }
    local active = info.Default or false

    function element:Call(state)
        active = state or not active

        if active then
            animate(scale, .2, {
                Scale = 1
            })
        else
            animate(scale, .2, {
                Scale = 0
            })
        end

        if element.Callback then
            element.Callback(active)
        end
    end

    --// connections
    guiElement.MouseEnter:Connect(function()
        animate(guiElement, .2, {
            BackgroundTransparency = .975
        })
        animate(guiElement.UIStroke, .2, {
            Transparency = .95
        })
    end)

    guiElement.MouseLeave:Connect(function()
        animate(guiElement, .2, {
            BackgroundTransparency = 1
        })
        animate(guiElement.UIStroke, .2, {
            Transparency = 1
        })
    end)

    guiElement.MouseButton1Down:Connect(function()
        element:Call()
    end)

    return element
end

function Tab:AddSlider(info)
    --// gui element
    local guiElement, div, fill, current, area, label = buildSlider(self, info)
    guiElement.Parent = self.__intern.page

    --// element
    local element = {
        Callback = info.Callback
    }
    local value = info.Default or 50
    local minValue, maxValue = info.Min or 0, info.Max or 100

    function element:Call(newValue)
        value = newValue
        if element.Callback then
            element.Callback(value)
        end
    end

    --// connections
    area.MouseButton1Down:Connect(function()
        while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or isTouchDown() do
            local pos = getTouchPos() or Vector3.new(mouse.X, mouse.Y, 0)
            local min, max = div.AbsolutePosition, div.AbsolutePosition + div.AbsoluteSize
            local scale = (pos.X - min.X) / (max.X - min.X)

            local newValue = minValue + (maxValue - minValue) * scale
            newValue = math.clamp(newValue, minValue, maxValue)
            newValue = math.round(newValue*10^(info.DecimalPlaces or 0))/10^(info.DecimalPlaces or 0)
            local newScale = (newValue - minValue) / (maxValue - minValue)

            fill.Size = UDim2.new(math.clamp(newScale,0,1),0,1,0)
            current.Position = UDim2.new(math.clamp(newScale,0,1),0,.5,0)

            if newValue ~= value then
                element:Call(newValue)
                label.Text = newValue
            end

            RunService.RenderStepped:Wait()
        end
    end)

    guiElement.MouseEnter:Connect(function()
        animate(guiElement, .2, {
            BackgroundTransparency = .975
        })
        animate(guiElement.UIStroke, .2, {
            Transparency = .95
        })
    end)

    guiElement.MouseLeave:Connect(function()
        animate(guiElement, .2, {
            BackgroundTransparency = 1
        })
        animate(guiElement.UIStroke, .2, {
            Transparency = 1
        })
    end)

    area.MouseEnter:Connect(function()
        animate(guiElement, .2, {
            BackgroundTransparency = .975
        })
        animate(guiElement.UIStroke, .2, {
            Transparency = .95
        })
        animate(current, .2, {
            Size = UDim2.new(0,8,0,20),
        })
    end)

    area.MouseLeave:Connect(function()
        animate(guiElement, .2, {
            BackgroundTransparency = 1
        })
        animate(guiElement.UIStroke, .2, {
            Transparency = 1
        })
        animate(current, .2, {
            Size = UDim2.new(0,6,0,16),
        })
    end)

    return element
end

function Tab:AddKeybind(info)
    --// gui element
    local guiElement, titleLabel, keyDisplayLabel = buildKeybind(self, info)
    guiElement.Parent = self.__intern.page

    --// element
    local element = {
        Callback = info.Callback, -- For key press state (true/false)
        ChangedCallback = info.ChangedCallback, -- For when the keybind itself changes
        Key = info.Default or Enum.KeyCode.Unknown,
        isSettingKey = false
    }

    -- Update the key display initially
    keyDisplayLabel.Text = tostring(element.Key.Name)

    -- Function to handle key press/release state
    local function handleKeyState(isPressed)
        if element.Callback then
            element.Callback(isPressed)
        end
    end

    --// connections
    guiElement.MouseEnter:Connect(function()
        if not element.isSettingKey then
            animate(guiElement, .2, {
                BackgroundTransparency = .975
            })
            animate(guiElement.UIStroke, .2, {
                Transparency = .95
            })
        end
    end)

    guiElement.MouseLeave:Connect(function()
        if not element.isSettingKey then
            animate(guiElement, .2, {
                BackgroundTransparency = 1
            })
            animate(guiElement.UIStroke, .2, {
                Transparency = 1
            })
        end
    end)

    guiElement.MouseButton1Down:Connect(function()
        if element.isSettingKey then return end -- Prevent re-entering key setting mode

        element.isSettingKey = true
        local originalKeyText = keyDisplayLabel.Text
        keyDisplayLabel.Text = "..." -- Changed to "..."
        titleLabel.TextTransparency = .5 -- Dim title while setting key

        local inputConnection
        inputConnection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                element.Key = input.KeyCode
                keyDisplayLabel.Text = tostring(input.KeyCode.Name) -- Display only key name
                titleLabel.TextTransparency = 0 -- Restore title transparency
                element.isSettingKey = false
                if element.ChangedCallback then -- Call ChangedCallback when keybind is altered
                    element.ChangedCallback(element.Key)
                end
                inputConnection:Disconnect()
            end
        end)
    end)

    -- Global input listener for the keybind itself (when active)
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == element.Key and not element.isSettingKey then
            handleKeyState(true) -- Key is pressed
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == element.Key and not element.isSettingKey then
            handleKeyState(false) -- Key is released
        end
    end)

    return element
end


--// Window.lua
local Window = {}
Window.__index = Window

function Window.__create(info)
    local self = setmetatable({}, Window)

    local window = buildWindow()
    local header, title, subtitle, miniminizeButton = buildHeader(window)
    local tabs, tabsLayout = buildTabsList(window)
    local mainFrame, mainLayout = buildMainFrame(window)

    local isDragging = false
    local dragStartPos = Vector2.new(0, 0)
    local initialWindowPos = UDim2.new(0, 0, 0, 0)

    self.__intern = {
        --// gui
        window          = window,
        header          = header,
        title           = title,
        subtitle        = subtitle,
        tabs            = tabs,
        tabsLayout      = tabsLayout,
        mainFrame       = mainFrame,
        mainLayout      = mainLayout,
        --// objects
        tabObjects      = {},
        toggleKeybind   = info.ToggleKeybind or Enum.KeyCode.M
    }

    local dragArea = Instance.new("Frame", window)
    dragArea.Name = "DragArea"
    dragArea.Size = UDim2.new(1, (ct.Padding+10)*2, 0, header.Size.Y.Offset+(ct.Padding)*2)
    dragArea.Position = UDim2.new(0, -(ct.Padding+10), 0, -(ct.Padding+10))
    dragArea.BackgroundTransparency = 1
    dragArea.ZIndex = 10

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStartPos = UserInputService:GetMouseLocation()
            initialWindowPos = window.Position
            input:Capture()
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end

        if input.KeyCode == self.__intern.toggleKeybind then
            window.Visible = not window.Visible
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local currentMousePos = UserInputService:GetMouseLocation()
            local delta = currentMousePos - dragStartPos

            window.Position = UDim2.new(
                initialWindowPos.X.Scale, initialWindowPos.X.Offset + delta.X,
                initialWindowPos.Y.Scale, initialWindowPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    miniminizeButton.MouseButton1Click:Connect(function()
        window.Visible = false
    end)

    return self
end

function Window:InsertTab(name, icon)
    local tabButton, tabPage = buildTabAndPage(name, icon, self.__intern.tabsLayout, self.__intern.mainFrame)
    local tab = Tab.__create(self, name, icon, tabButton, tabPage)

    if self.__intern.tabObjects[name] then
        error("Attempt to recreate an existing tab", name)
    end
    self.__intern.tabObjects[name] = tab

    tabButton.MouseButton1Down:Connect(function()
        self:SetActiveTab(tab)
    end)

    return tab
end

function Window:SetActiveTab(tab)
    task.defer(function()
        for _, _tab in self.__intern.tabObjects do
            _tab.__intern.button.ImageTransparency = .5
            _tab.__intern.button.Parent.BackgroundTransparency = 1
        end

        self.__intern.mainLayout:JumpTo(tab.__intern.page)

        tab.__intern.button.ImageTransparency = 0
        tab.__intern.button.Parent.BackgroundTransparency = .95
    end)
end

function Window:SetToggleKeybind(keycode)
    self.__intern.toggleKeybind = keycode
end

--// Worker.lua
local Worker = {}
Worker.__index = Worker

function Worker.__newindex(self, index, value)
    rawset(self, index, value)

    if typeof(self.Changes[index]) ~= "function" then
        return
    else
        self.Changes[index](value)
    end
end

function Worker.__create()
    local self = setmetatable({}, Worker)

    self.__intern = {
        connections = {},
    }

    self.Changes = {}

    return self
end

function Worker:Connect(label: string, event: RBXScriptSignal, callback: (any) -> nil)
    if self.__intern.connections[label] then
        error("Attemp to recreate an existing connection label", label)
    end

    self.__intern.connections[label] = event:Connect(callback)
end

function Worker:Disconnect(label: string)
    if self.__intern.connections[label] then
        self.__intern.connections[label]:Disconnect()
        self.__intern.connections[label] = nil
    end
end

function Worker:Destroy()
    for _, value in self.__intern.connections do
        value:Disconnect()
    end

    self.__intern = nil

    setmetatable(self, nil)
end

--// Main.lua
function Library:CreateWindow(info)
    return Window.__create(info or {})
end

function Library:CreateWorker()
    return Worker.__create()
end

--// Footer.lua
return Library
