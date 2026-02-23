--[[

DASH HUB Library by guru

]]

--// Core
local isStudio = false --game:GetService("RunService"):IsStudio()
local LucideIcons = loadstring( game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/src/Icons.lua") )()
local CoreGui = not isStudio and game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
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
		BackgroundColor = Color3.fromHex("030a1c"),
		PanelsColor = Color3.fromHex("030a1c"),
		BorderColor = Color3.fromHex("60A5FA"),
		AccentColor = Color3.fromHex("#162948"),
		PrimaryFontColor = Color3.fromHex("e5e7eb"),
		SecondaryFontColor = Color3.fromHex("9ca3af"),
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
    local screenGui = build("ScreenGui", CoreGui)

    local window = build("Frame", screenGui, {
        Size = UDim2.new(0, 600, 0, 340),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = ct.BackgroundColor,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
    })

    build("UIPadding", window, {
        PaddingTop = UDim.new(0, ct.Padding),
        PaddingBottom = UDim.new(0, ct.Padding),
        PaddingLeft = UDim.new(0, ct.Padding),
        PaddingRight = UDim.new(0, ct.Padding),
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

    build("ImageButton", header, {
        Size = UDim2.new(0, 24, 0, 24),
        AnchorPoint = Vector2.new(1,.5),
        Position = UDim2.new(1, -3, .5, -1),
        BackgroundTransparency = 1,
        Image =  LucideIcons and LucideIcons.assets["lucide-minus"] or "",
    })

    return header, title, subtitle
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

--// Window.lua
local Window = {}
Window.__index = Window

function Window.__create(info)
    local self = setmetatable({}, Window)

    local window = buildWindow()
    local header, title, subtitle = buildHeader(window)
    local tabs, tabsLayout = buildTabsList(window)
    local mainFrame, mainLayout = buildMainFrame(window)

    self.__intern = {
        --// Gui
        window      = window,
        header      = header,
        title       = title,
        subtitle    = subtitle,
        tabs        = tabs,
        tabsLayout  = tabsLayout,
        mainFrame   = mainFrame,
        mainLayout  = mainLayout,
        --// Objects
        tabObjects  = {},
    }

    return self
end

function Window:InsertTab(name, icon)
    local tabButton, tabPage = buildTabAndPage(name, icon, self.__intern.tabsLayout, self.__intern.mainFrame)
    local tab = Tab.__create(self, name, icon, tabButton, tabPage)

    self.__intern.tabObjects[name] = tab --! falta verifica├º├úo se existe

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

--// Main.lua
--// Methods
function Library:CreateWindow(info)
    return Window.__create(info)
end

--// Export
return Library
