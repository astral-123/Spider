local Library = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local Colors = {
    Background = Color3.fromRGB(0, 0, 0),
    Secondary  = Color3.fromRGB(11, 11, 11),
    Element    = Color3.fromRGB(17, 17, 17),
    Violet     = Color3.fromRGB(72, 40, 140),
    Text       = Color3.fromRGB(255, 255, 255),
    Border     = Color3.fromRGB(72, 40, 140),
}

local isVisible = true
local toggleKey = Enum.KeyCode.RightShift

function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name     or "Violet Hub"
    toggleKey        = config.ToggleKey or Enum.KeyCode.RightShift
    local logoId     = config.Logo     or "rbxassetid://125489582002636"

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VioletLibrary"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999

    -- ══ NOTIFICATION ═══════════════════════════════
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Name = "NotificationFrame"
    NotificationFrame.Parent = ScreenGui
    NotificationFrame.BackgroundColor3 = Colors.Secondary
    NotificationFrame.BorderColor3 = Colors.Violet
    NotificationFrame.BorderSizePixel = 2
    NotificationFrame.Position = UDim2.new(0.7, 0, 0.1, 0)
    NotificationFrame.Size = UDim2.new(0, 250, 0, 80)
    NotificationFrame.Visible = false
    NotificationFrame.ZIndex = 10

    local NotificationTitle = Instance.new("TextLabel")
    NotificationTitle.Parent = NotificationFrame
    NotificationTitle.BackgroundColor3 = Colors.Element
    NotificationTitle.BorderColor3 = Colors.Violet
    NotificationTitle.BorderSizePixel = 1
    NotificationTitle.Size = UDim2.new(1, 0, 0, 25)
    NotificationTitle.Text = "Notification"
    NotificationTitle.TextColor3 = Colors.Text
    NotificationTitle.TextSize = 14
    NotificationTitle.Font = Enum.Font.SourceSansBold
    NotificationTitle.ZIndex = 11

    local NotificationText = Instance.new("TextLabel")
    NotificationText.Parent = NotificationFrame
    NotificationText.BackgroundColor3 = Colors.Secondary
    NotificationText.BorderSizePixel = 0
    NotificationText.Position = UDim2.new(0, 0, 0, 25)
    NotificationText.Size = UDim2.new(1, 0, 1, -25)
    NotificationText.Text = ""
    NotificationText.TextColor3 = Colors.Text
    NotificationText.TextSize = 13
    NotificationText.Font = Enum.Font.SourceSans
    NotificationText.TextWrapped = true
    NotificationText.ZIndex = 11

    -- ══ FENÊTRE PRINCIPALE ═════════════════════════
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderColor3 = Colors.Border
    MainFrame.BorderSizePixel = 2
    MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
    MainFrame.Size = UDim2.new(0, 800, 0, 550)
    MainFrame.Active = true
    MainFrame.Draggable = true

    -- Logo (exactement lib originale)
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Parent = MainFrame
    Logo.BackgroundTransparency = 1
    Logo.BorderSizePixel = 0
    Logo.Size = UDim2.new(0, 200, 0, 113)
    Logo.Position = UDim2.new(0, 0, 0, 0)
    Logo.Image = logoId

    -- Boutons contrôle
    local ControlFrame = Instance.new("Frame")
    ControlFrame.Parent = MainFrame
    ControlFrame.BackgroundTransparency = 1
    ControlFrame.BorderSizePixel = 0
    ControlFrame.Size = UDim2.new(0, 55, 0, 20)
    ControlFrame.Position = UDim2.new(1, -65, 0, 10)

    local MinusButton = Instance.new("TextButton")
    MinusButton.Parent = ControlFrame
    MinusButton.BackgroundColor3 = Colors.Element
    MinusButton.BorderColor3 = Colors.Violet
    MinusButton.BorderSizePixel = 1
    MinusButton.Size = UDim2.new(0, 25, 0, 25)
    MinusButton.Position = UDim2.new(0, 0, 0, 0)
    MinusButton.Text = "-"
    MinusButton.TextColor3 = Colors.Text
    MinusButton.TextSize = 20
    MinusButton.Font = Enum.Font.SourceSans

    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = ControlFrame
    CloseButton.BackgroundColor3 = Colors.Element
    CloseButton.BorderColor3 = Colors.Violet
    CloseButton.BorderSizePixel = 1
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(0, 30, 0, 0)
    CloseButton.Text = "x"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.SourceSans

    -- Resize handle
    local ResizeHandle = Instance.new("TextButton")
    ResizeHandle.Parent = MainFrame
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.BorderSizePixel = 0
    ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
    ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
    ResizeHandle.Text = "//"
    ResizeHandle.TextColor3 = Colors.Violet
    ResizeHandle.TextSize = 14
    ResizeHandle.Font = Enum.Font.SourceSans
    ResizeHandle.ZIndex = 10

    local isResizing = false
    ResizeHandle.MouseButton1Down:Connect(function()
        isResizing = true
        local sp = UserInputService:GetMouseLocation()
        local ss = MainFrame.Size
        local mv = UserInputService.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement and isResizing then
                local mp = UserInputService:GetMouseLocation()
                MainFrame.Size = UDim2.new(0, math.max(500, ss.X.Offset + mp.X - sp.X), 0, math.max(350, ss.Y.Offset + mp.Y - sp.Y))
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                isResizing = false; mv:Disconnect()
            end
        end)
    end)

    -- ══ TABS FRAME (sidebar, exactement lib originale) ══
    local TabsFrame = Instance.new("Frame")
    TabsFrame.Name = "TabsFrame"
    TabsFrame.Parent = MainFrame
    TabsFrame.BackgroundColor3 = Colors.Secondary
    TabsFrame.BorderColor3 = Colors.Border
    TabsFrame.BorderSizePixel = 2
    TabsFrame.Position = UDim2.new(0.02, 0, 0.21, 0)
    TabsFrame.Size = UDim2.new(0, 170, 0, 400)

    -- Scroll tabs
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Parent = TabsFrame
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel = 0
    TabScroll.Size = UDim2.new(1, 0, 1, -60)
    TabScroll.Position = UDim2.new(0, 0, 0, 4)
    TabScroll.ScrollBarThickness = 2
    TabScroll.ScrollBarImageColor3 = Colors.Violet
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.ZIndex = 2
    local tsl = Instance.new("UIListLayout")
    tsl.FillDirection = Enum.FillDirection.Vertical
    tsl.Padding = UDim.new(0, 3)
    tsl.SortOrder = Enum.SortOrder.LayoutOrder
    tsl.Parent = TabScroll
    local tsp = Instance.new("UIPadding")
    tsp.PaddingTop = UDim.new(0, 5)
    tsp.PaddingLeft = UDim.new(0, 7)
    tsp.PaddingRight = UDim.new(0, 7)
    tsp.Parent = TabScroll
    tsl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabScroll.CanvasSize = UDim2.new(0, 0, 0, tsl.AbsoluteContentSize.Y + 10)
    end)

    -- Search bar dans la sidebar
    local SearchBox = Instance.new("TextBox")
    SearchBox.Parent = TabsFrame
    SearchBox.BackgroundColor3 = Colors.Element
    SearchBox.BorderColor3 = Colors.Border
    SearchBox.BorderSizePixel = 1
    SearchBox.Size = UDim2.new(1, -10, 0, 22)
    SearchBox.Position = UDim2.new(0, 5, 1, -28)
    SearchBox.PlaceholderText = "Rechercher..."
    SearchBox.Text = ""
    SearchBox.TextColor3 = Colors.Text
    SearchBox.PlaceholderColor3 = Color3.fromRGB(100,100,100)
    SearchBox.TextSize = 13
    SearchBox.Font = Enum.Font.SourceSans
    SearchBox.ClearTextOnFocus = false
    SearchBox.ZIndex = 3

    -- Logo bas sidebar
    local SideLogo = Instance.new("ImageLabel")
    SideLogo.Parent = TabsFrame
    SideLogo.BackgroundTransparency = 1
    SideLogo.BorderSizePixel = 0
    SideLogo.Size = UDim2.new(0, 32, 0, 32)
    SideLogo.Position = UDim2.new(0.5, -16, 1, -56)
    SideLogo.Image = logoId
    SideLogo.ZIndex = 3

    -- ══ CONTENT FRAME ══════════════════════════════
    -- Sub-tab bar horizontale
    local SubTabBar = Instance.new("Frame")
    SubTabBar.Name = "SubTabBar"
    SubTabBar.Parent = MainFrame
    SubTabBar.BackgroundColor3 = Colors.Background
    SubTabBar.BorderColor3 = Colors.Border
    SubTabBar.BorderSizePixel = 1
    SubTabBar.Position = UDim2.new(0.245, 0, 0.21, 0)
    SubTabBar.Size = UDim2.new(0.73, 0, 0, 28)
    SubTabBar.ZIndex = 3
    local stbl = Instance.new("UIListLayout")
    stbl.FillDirection = Enum.FillDirection.Horizontal
    stbl.SortOrder = Enum.SortOrder.LayoutOrder
    stbl.Parent = SubTabBar
    local stbp = Instance.new("UIPadding")
    stbp.PaddingLeft = UDim.new(0, 4)
    stbp.PaddingTop = UDim.new(0, 3)
    stbp.Parent = SubTabBar

    -- Zone colonnes scrollable
    local ColScroll = Instance.new("ScrollingFrame")
    ColScroll.Name = "ColScroll"
    ColScroll.Parent = MainFrame
    ColScroll.BackgroundTransparency = 1
    ColScroll.BorderSizePixel = 0
    ColScroll.Position = UDim2.new(0.245, 0, 0.21+0.055, 0)
    ColScroll.Size = UDim2.new(0.73, 0, 1, -(0.265*550))
    ColScroll.ScrollBarThickness = 3
    ColScroll.ScrollBarImageColor3 = Colors.Violet
    ColScroll.CanvasSize = UDim2.new(0,0,0,0)
    ColScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ColScroll.ZIndex = 3

    local ColsHolder = Instance.new("Frame")
    ColsHolder.Parent = ColScroll
    ColsHolder.BackgroundTransparency = 1
    ColsHolder.BorderSizePixel = 0
    ColsHolder.Size = UDim2.new(1, 0, 0, 0)
    ColsHolder.AutomaticSize = Enum.AutomaticSize.Y
    ColsHolder.ZIndex = 4
    local chl = Instance.new("UIListLayout")
    chl.FillDirection = Enum.FillDirection.Horizontal
    chl.Padding = UDim.new(0, 0)
    chl.VerticalAlignment = Enum.VerticalAlignment.Top
    chl.SortOrder = Enum.SortOrder.LayoutOrder
    chl.Parent = ColsHolder
    local chp = Instance.new("UIPadding")
    chp.PaddingTop = UDim.new(0, 6)
    chp.PaddingLeft = UDim.new(0, 6)
    chp.PaddingRight = UDim.new(0, 6)
    chp.PaddingBottom = UDim.new(0, 6)
    chp.Parent = ColsHolder

    -- ══════════════════════════════════════════
    local tabs = {}
    local curTab = nil

    local Window = {}

    function Window:Notify(title, message, ntype, duration)
        NotificationTitle.Text = title
        NotificationText.Text = message
        NotificationFrame.Visible = true
        if duration then
            task.delay(duration, function()
                NotificationFrame.Visible = false
            end)
        end
    end

    -- ══════════════════════════════════════════
    --  CREATE TAB
    -- ══════════════════════════════════════════
    function Window:CreateTab(name, icon)
        local td = {name=name, subTabs={}, curSub=nil}

        local TB = Instance.new("TextButton")
        TB.Name = name.."Tab"
        TB.Parent = TabScroll
        TB.BackgroundColor3 = Colors.Element
        TB.BorderColor3 = Colors.Border
        TB.BorderSizePixel = 1
        TB.Size = UDim2.new(1, 0, 0, 27)
        TB.Text = (icon and icon.." " or "") .. name
        TB.TextColor3 = Colors.Text
        TB.TextSize = 14
        TB.Font = Enum.Font.SourceSans
        TB.ZIndex = 3

        local SubCont = Instance.new("Frame")
        SubCont.BackgroundTransparency = 1
        SubCont.BorderSizePixel = 0
        SubCont.Size = UDim2.new(1, 0, 1, 0)
        SubCont.Visible = false
        SubCont.ZIndex = 4
        SubCont.Parent = SubTabBar
        local scl = Instance.new("UIListLayout")
        scl.FillDirection = Enum.FillDirection.Horizontal
        scl.SortOrder = Enum.SortOrder.LayoutOrder
        scl.Parent = SubCont

        local ColCont = Instance.new("Frame")
        ColCont.BackgroundTransparency = 1
        ColCont.BorderSizePixel = 0
        ColCont.Size = UDim2.new(1, 0, 0, 0)
        ColCont.AutomaticSize = Enum.AutomaticSize.Y
        ColCont.Visible = false
        ColCont.ZIndex = 5
        ColCont.Parent = ColsHolder
        local ccl = Instance.new("UIListLayout")
        ccl.FillDirection = Enum.FillDirection.Horizontal
        ccl.Padding = UDim.new(0, 6)
        ccl.VerticalAlignment = Enum.VerticalAlignment.Top
        ccl.SortOrder = Enum.SortOrder.LayoutOrder
        ccl.Parent = ColCont

        td.Button  = TB
        td.SubCont = SubCont
        td.ColCont = ColCont
        table.insert(tabs, td)

        local function Activate()
            for _, t in ipairs(tabs) do
                t.Button.BackgroundColor3 = Colors.Element
                t.SubCont.Visible = false
                t.ColCont.Visible = false
            end
            TB.BackgroundColor3 = Colors.Violet
            SubCont.Visible = true
            ColCont.Visible = true
            curTab = td
            if #td.subTabs > 0 and td.curSub == nil then
                td.subTabs[1].activate()
            elseif td.curSub then
                td.curSub.ScrollF.Visible = true
            end
        end

        TB.MouseButton1Click:Connect(Activate)
        TB.MouseEnter:Connect(function()
            if curTab ~= td then TB.BackgroundColor3 = Color3.fromRGB(30,15,60) end
        end)
        TB.MouseLeave:Connect(function()
            if curTab ~= td then TB.BackgroundColor3 = Colors.Element end
        end)
        if #tabs == 1 then task.defer(Activate) end

        local Tab = {}

        -- ══════════════════════════════════════════
        --  CREATE SUBTAB
        -- ══════════════════════════════════════════
        function Tab:CreateSubTab(sname)
            local sd = {name=sname}

            local SB = Instance.new("TextButton")
            SB.Name = "SB_"..sname
            SB.Parent = SubCont
            SB.BackgroundColor3 = Colors.Background
            SB.BorderColor3 = Colors.Border
            SB.BorderSizePixel = 1
            SB.AutomaticSize = Enum.AutomaticSize.X
            SB.Size = UDim2.new(0, 0, 1, -2)
            SB.Text = sname
            SB.TextColor3 = Color3.fromRGB(180,180,180)
            SB.TextSize = 14
            SB.Font = Enum.Font.SourceSans
            SB.ZIndex = 5
            local sbp = Instance.new("UIPadding")
            sbp.PaddingLeft = UDim.new(0,10); sbp.PaddingRight = UDim.new(0,10); sbp.Parent = SB

            local SBLine = Instance.new("Frame")
            SBLine.Parent = SB
            SBLine.BackgroundColor3 = Colors.Violet
            SBLine.BorderSizePixel = 0
            SBLine.Size = UDim2.new(1,0,0,2)
            SBLine.Position = UDim2.new(0,0,1,-2)
            SBLine.Visible = false
            SBLine.ZIndex = 6

            local SubScroll = Instance.new("ScrollingFrame")
            SubScroll.Parent = ColCont
            SubScroll.BackgroundTransparency = 1
            SubScroll.BorderSizePixel = 0
            SubScroll.Size = UDim2.new(1,0,0,0)
            SubScroll.AutomaticSize = Enum.AutomaticSize.Y
            SubScroll.CanvasSize = UDim2.new(0,0,0,0)
            SubScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            SubScroll.ScrollBarThickness = 0
            SubScroll.Visible = false
            SubScroll.ZIndex = 6

            local SubColFrame = Instance.new("Frame")
            SubColFrame.Parent = SubScroll
            SubColFrame.BackgroundTransparency = 1
            SubColFrame.BorderSizePixel = 0
            SubColFrame.Size = UDim2.new(1,0,0,0)
            SubColFrame.AutomaticSize = Enum.AutomaticSize.Y
            SubColFrame.ZIndex = 7
            local scfl = Instance.new("UIListLayout")
            scfl.FillDirection = Enum.FillDirection.Horizontal
            scfl.Padding = UDim.new(0, 6)
            scfl.VerticalAlignment = Enum.VerticalAlignment.Top
            scfl.SortOrder = Enum.SortOrder.LayoutOrder
            scfl.Parent = SubColFrame

            sd.Button  = SB
            sd.Line    = SBLine
            sd.ScrollF = SubScroll
            sd.ColFrame = SubColFrame

            local function ActivateSub()
                for _, s in ipairs(td.subTabs) do
                    s.Button.TextColor3 = Color3.fromRGB(180,180,180)
                    s.Button.BackgroundColor3 = Colors.Background
                    s.Line.Visible = false
                    s.ScrollF.Visible = false
                end
                SB.TextColor3 = Colors.Text
                SB.BackgroundColor3 = Colors.Secondary
                SBLine.Visible = true
                SubScroll.Visible = true
                td.curSub = sd
            end
            sd.activate = ActivateSub
            SB.MouseButton1Click:Connect(ActivateSub)
            table.insert(td.subTabs, sd)
            if #td.subTabs == 1 and curTab == td then task.defer(ActivateSub) end

            local SubTabObj = {}

            -- ══════════════════════════════════════════
            --  CREATE SECTION (exactement lib originale)
            -- ══════════════════════════════════════════
            function SubTabObj:CreateSection(secname)
                -- Section = colonne fond sombre, bordure violette, exactement lib originale
                local Section = Instance.new("Frame")
                Section.Name = "Section"
                Section.Parent = SubColFrame
                Section.BackgroundColor3 = Colors.Secondary
                Section.BorderColor3 = Colors.Border
                Section.BorderSizePixel = 2
                Section.Size = UDim2.new(0, 252, 0, 0)
                Section.AutomaticSize = Enum.AutomaticSize.Y
                Section.ZIndex = 8

                local SectionTitle = Instance.new("TextLabel")
                SectionTitle.Parent = Section
                SectionTitle.BackgroundColor3 = Colors.Element
                SectionTitle.BorderColor3 = Colors.Border
                SectionTitle.BorderSizePixel = 1
                SectionTitle.Size = UDim2.new(1, 0, 0, 24)
                SectionTitle.Text = secname
                SectionTitle.TextColor3 = Color3.fromRGB(160, 100, 255)
                SectionTitle.TextSize = 14
                SectionTitle.Font = Enum.Font.SourceSansBold
                SectionTitle.ZIndex = 9

                local Items = Instance.new("Frame")
                Items.Name = "Items"
                Items.Parent = Section
                Items.BackgroundTransparency = 1
                Items.BorderSizePixel = 0
                Items.Size = UDim2.new(1, 0, 0, 0)
                Items.AutomaticSize = Enum.AutomaticSize.Y
                Items.Position = UDim2.new(0, 0, 0, 24)
                Items.ZIndex = 9
                local il = Instance.new("UIListLayout")
                il.FillDirection = Enum.FillDirection.Vertical
                il.Padding = UDim.new(0, 2)
                il.SortOrder = Enum.SortOrder.LayoutOrder
                il.Parent = Items
                local ip = Instance.new("UIPadding")
                ip.PaddingLeft = UDim.new(0, 6)
                ip.PaddingRight = UDim.new(0, 6)
                ip.PaddingTop = UDim.new(0, 4)
                ip.PaddingBottom = UDim.new(0, 6)
                ip.Parent = Items

                local S = {}

                -- ══ TOGGLE ══
                function S:AddToggle(lbl, default, hint, cb)
                    if type(hint) == "function" then cb=hint; hint=nil end
                    if type(default) == "function" then cb=default; default=false end
                    local val = default == true

                    local Row = Instance.new("Frame")
                    Row.Parent = Items
                    Row.BackgroundColor3 = Colors.Element
                    Row.BorderSizePixel = 0
                    Row.Size = UDim2.new(1, 0, 0, 24)
                    Row.ZIndex = 10

                    local CheckBox = Instance.new("TextButton")
                    CheckBox.Parent = Row
                    CheckBox.BackgroundColor3 = val and Colors.Violet or Colors.Element
                    CheckBox.BorderColor3 = Colors.Border
                    CheckBox.BorderSizePixel = 2
                    CheckBox.Size = UDim2.new(0, 16, 0, 16)
                    CheckBox.Position = UDim2.new(0, 4, 0.5, -8)
                    CheckBox.Text = val and "v" or ""
                    CheckBox.TextColor3 = Colors.Text
                    CheckBox.TextSize = 12
                    CheckBox.Font = Enum.Font.SourceSansBold
                    CheckBox.ZIndex = 11

                    local Text = Instance.new("TextLabel")
                    Text.Parent = Row
                    Text.BackgroundTransparency = 1
                    Text.BorderSizePixel = 0
                    Text.Position = UDim2.new(0, 26, 0, 0)
                    Text.Size = UDim2.new(1, -46, 1, 0)
                    Text.Text = lbl
                    Text.TextColor3 = Colors.Text
                    Text.TextSize = 14
                    Text.Font = Enum.Font.SourceSans
                    Text.TextXAlignment = Enum.TextXAlignment.Left
                    Text.ZIndex = 11

                    if hint then
                        local HintBtn = Instance.new("TextButton")
                        HintBtn.Parent = Row
                        HintBtn.BackgroundColor3 = Colors.Violet
                        HintBtn.BorderSizePixel = 0
                        HintBtn.Size = UDim2.new(0, 16, 0, 16)
                        HintBtn.Position = UDim2.new(1, -20, 0.5, -8)
                        HintBtn.Text = "?"
                        HintBtn.TextColor3 = Colors.Text
                        HintBtn.TextSize = 11
                        HintBtn.Font = Enum.Font.SourceSansBold
                        HintBtn.ZIndex = 12
                        local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(1,0); hc.Parent = HintBtn
                    end

                    local ClickBtn = Instance.new("TextButton")
                    ClickBtn.Parent = Row
                    ClickBtn.BackgroundTransparency = 1
                    ClickBtn.BorderSizePixel = 0
                    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
                    ClickBtn.Text = ""
                    ClickBtn.ZIndex = 13

                    local obj = {Value = val}
                    local function Set(v, silent)
                        val = v; obj.Value = v
                        CheckBox.BackgroundColor3 = v and Colors.Violet or Colors.Element
                        CheckBox.Text = v and "v" or ""
                        if not silent and cb then cb(v) end
                    end
                    ClickBtn.MouseButton1Click:Connect(function() Set(not val) end)
                    Row.MouseEnter:Connect(function() Row.BackgroundColor3 = Color3.fromRGB(25,18,40) end)
                    Row.MouseLeave:Connect(function() Row.BackgroundColor3 = Colors.Element end)
                    function obj:Set(v) Set(v, true) end
                    return obj
                end

                -- ══ SLIDER ══
                function S:AddSlider(lbl, min, max, default, suffix, cb)
                    if type(suffix) == "function" then cb=suffix; suffix="" end
                    local val = math.clamp(default or min, min, max)
                    suffix = suffix or ""

                    local Container = Instance.new("Frame")
                    Container.Parent = Items
                    Container.BackgroundColor3 = Colors.Element
                    Container.BorderSizePixel = 0
                    Container.Size = UDim2.new(1, 0, 0, 38)
                    Container.ZIndex = 10

                    local LblF = Instance.new("TextLabel")
                    LblF.Parent = Container
                    LblF.BackgroundTransparency = 1
                    LblF.Position = UDim2.new(0, 6, 0, 2)
                    LblF.Size = UDim2.new(0.65, 0, 0, 16)
                    LblF.Text = lbl
                    LblF.TextColor3 = Colors.Text
                    LblF.TextSize = 14
                    LblF.Font = Enum.Font.SourceSans
                    LblF.TextXAlignment = Enum.TextXAlignment.Left
                    LblF.ZIndex = 11

                    local ValF = Instance.new("TextLabel")
                    ValF.Parent = Container
                    ValF.BackgroundTransparency = 1
                    ValF.Position = UDim2.new(0.65, 0, 0, 2)
                    ValF.Size = UDim2.new(0.35, -6, 0, 16)
                    ValF.Text = tostring(math.floor(val))..suffix
                    ValF.TextColor3 = Color3.fromRGB(180,180,180)
                    ValF.TextSize = 13
                    ValF.Font = Enum.Font.SourceSans
                    ValF.TextXAlignment = Enum.TextXAlignment.Right
                    ValF.ZIndex = 11

                    local Track = Instance.new("Frame")
                    Track.Parent = Container
                    Track.BackgroundColor3 = Colors.Background
                    Track.BorderColor3 = Colors.Border
                    Track.BorderSizePixel = 1
                    Track.Position = UDim2.new(0, 6, 0, 22)
                    Track.Size = UDim2.new(1, -12, 0, 8)
                    Track.ZIndex = 11

                    local pct = (val-min)/(max-min)
                    local Fill = Instance.new("Frame")
                    Fill.Parent = Track
                    Fill.BackgroundColor3 = Colors.Violet
                    Fill.BorderSizePixel = 0
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    Fill.ZIndex = 12

                    local Knob = Instance.new("Frame")
                    Knob.Parent = Track
                    Knob.BackgroundColor3 = Colors.Text
                    Knob.BorderColor3 = Colors.Border
                    Knob.BorderSizePixel = 1
                    Knob.Size = UDim2.new(0, 8, 0, 12)
                    Knob.Position = UDim2.new(pct, -4, 0.5, -6)
                    Knob.ZIndex = 13

                    local HitBtn = Instance.new("TextButton")
                    HitBtn.Parent = Container
                    HitBtn.BackgroundTransparency = 1
                    HitBtn.BorderSizePixel = 0
                    HitBtn.Position = UDim2.new(0,0,0,16)
                    HitBtn.Size = UDim2.new(1,0,0,22)
                    HitBtn.Text = ""
                    HitBtn.ZIndex = 14

                    local drag = false
                    local obj = {Value = val}
                    local function Update(mx)
                        local r = math.clamp((mx - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                        val = min + (max-min)*r; obj.Value = val
                        Fill.Size = UDim2.new(r,0,1,0)
                        Knob.Position = UDim2.new(r,-4,0.5,-6)
                        ValF.Text = tostring(math.floor(val*10+0.5)/10)..suffix
                        if cb then cb(val) end
                    end
                    HitBtn.MouseButton1Down:Connect(function() drag=true; Update(UserInputService:GetMouseLocation().X) end)
                    UserInputService.InputEnded:Connect(function(i)
                        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
                    end)
                    UserInputService.InputChanged:Connect(function(i)
                        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
                            Update(UserInputService:GetMouseLocation().X)
                        end
                    end)
                    Container.MouseEnter:Connect(function() Container.BackgroundColor3=Color3.fromRGB(22,15,35) end)
                    Container.MouseLeave:Connect(function() Container.BackgroundColor3=Colors.Element end)
                    function obj:Set(v)
                        val=math.clamp(v,min,max); obj.Value=val
                        local r=(val-min)/(max-min)
                        Fill.Size=UDim2.new(r,0,1,0); Knob.Position=UDim2.new(r,-4,0.5,-6)
                        ValF.Text=tostring(val)..suffix
                    end
                    return obj
                end

                -- ══ DROPDOWN ══
                function S:AddDropdown(lbl, opts, default, cb)
                    local sel = default or opts[1] or ""
                    local open = false

                    local Container = Instance.new("Frame")
                    Container.Parent = Items
                    Container.BackgroundColor3 = Colors.Element
                    Container.BorderSizePixel = 0
                    Container.Size = UDim2.new(1, 0, 0, 26)
                    Container.ZIndex = 10
                    Container.ClipsDescendants = false

                    local LblD = Instance.new("TextLabel")
                    LblD.Parent = Container
                    LblD.BackgroundTransparency = 1
                    LblD.Position = UDim2.new(0, 6, 0, 0)
                    LblD.Size = UDim2.new(0.4, 0, 1, 0)
                    LblD.Text = lbl
                    LblD.TextColor3 = Color3.fromRGB(180,180,180)
                    LblD.TextSize = 13
                    LblD.Font = Enum.Font.SourceSans
                    LblD.TextXAlignment = Enum.TextXAlignment.Left
                    LblD.ZIndex = 11

                    local DB = Instance.new("TextButton")
                    DB.Parent = Container
                    DB.BackgroundColor3 = Colors.Background
                    DB.BorderColor3 = Colors.Border
                    DB.BorderSizePixel = 1
                    DB.Position = UDim2.new(0.4, 0, 0.5, -10)
                    DB.Size = UDim2.new(0.58, 0, 0, 20)
                    DB.Text = ""
                    DB.ZIndex = 11

                    local SelLbl = Instance.new("TextLabel")
                    SelLbl.Parent = DB
                    SelLbl.BackgroundTransparency = 1
                    SelLbl.Position = UDim2.new(0, 4, 0, 0)
                    SelLbl.Size = UDim2.new(1, -18, 1, 0)
                    SelLbl.Text = sel
                    SelLbl.TextColor3 = Colors.Text
                    SelLbl.TextSize = 13
                    SelLbl.Font = Enum.Font.SourceSans
                    SelLbl.TextXAlignment = Enum.TextXAlignment.Left
                    SelLbl.ZIndex = 12

                    local Arrow = Instance.new("TextLabel")
                    Arrow.Parent = DB
                    Arrow.BackgroundTransparency = 1
                    Arrow.Position = UDim2.new(1,-16,0,0)
                    Arrow.Size = UDim2.new(0,14,1,0)
                    Arrow.Text = "v"
                    Arrow.TextColor3 = Color3.fromRGB(160,100,255)
                    Arrow.TextSize = 12
                    Arrow.Font = Enum.Font.SourceSans
                    Arrow.ZIndex = 12

                    local DL = Instance.new("Frame")
                    DL.Parent = DB
                    DL.BackgroundColor3 = Colors.Secondary
                    DL.BorderColor3 = Colors.Border
                    DL.BorderSizePixel = 2
                    DL.Position = UDim2.new(0, 0, 1, 1)
                    DL.Size = UDim2.new(1, 0, 0, #opts*22)
                    DL.Visible = false
                    DL.ZIndex = 50
                    DL.ClipsDescendants = true
                    local dll = Instance.new("UIListLayout")
                    dll.FillDirection = Enum.FillDirection.Vertical
                    dll.SortOrder = Enum.SortOrder.LayoutOrder
                    dll.Parent = DL

                    for _, opt in ipairs(opts) do
                        local OB = Instance.new("TextButton")
                        OB.Parent = DL
                        OB.BackgroundColor3 = Colors.Element
                        OB.BorderSizePixel = 0
                        OB.Size = UDim2.new(1,0,0,22)
                        OB.Text = opt
                        OB.TextColor3 = opt==sel and Color3.fromRGB(160,100,255) or Colors.Text
                        OB.TextSize = 13
                        OB.Font = Enum.Font.SourceSans
                        OB.ZIndex = 51
                        OB.MouseEnter:Connect(function() OB.BackgroundColor3=Color3.fromRGB(40,20,70) end)
                        OB.MouseLeave:Connect(function() OB.BackgroundColor3=Colors.Element end)
                        OB.MouseButton1Click:Connect(function()
                            sel=opt; SelLbl.Text=opt; open=false; DL.Visible=false
                            if cb then cb(opt) end
                        end)
                    end

                    DB.MouseButton1Click:Connect(function() open=not open; DL.Visible=open end)
                    Container.MouseEnter:Connect(function() Container.BackgroundColor3=Color3.fromRGB(22,15,35) end)
                    Container.MouseLeave:Connect(function() Container.BackgroundColor3=Colors.Element end)
                    local obj={Value=sel}
                    function obj:Set(v) sel=v; SelLbl.Text=v; obj.Value=v end
                    return obj
                end

                -- ══ BUTTON ══
                function S:AddButton(lbl, cb)
                    local B = Instance.new("TextButton")
                    B.Parent = Items
                    B.BackgroundColor3 = Colors.Violet
                    B.BorderColor3 = Color3.fromRGB(110, 60, 200)
                    B.BorderSizePixel = 1
                    B.Size = UDim2.new(1, 0, 0, 24)
                    B.Text = lbl
                    B.TextColor3 = Colors.Text
                    B.TextSize = 14
                    B.Font = Enum.Font.SourceSans
                    B.ZIndex = 10
                    B.MouseEnter:Connect(function() B.BackgroundColor3=Color3.fromRGB(100,55,185) end)
                    B.MouseLeave:Connect(function() B.BackgroundColor3=Colors.Violet end)
                    B.MouseButton1Down:Connect(function() B.BackgroundColor3=Color3.fromRGB(50,20,100) end)
                    B.MouseButton1Up:Connect(function() B.BackgroundColor3=Colors.Violet end)
                    B.MouseButton1Click:Connect(function() if cb then cb() end end)
                    return B
                end

                -- ══ INPUT ══
                function S:AddInput(lbl, placeholder, cb)
                    local Container = Instance.new("Frame")
                    Container.Parent = Items
                    Container.BackgroundColor3 = Colors.Element
                    Container.BorderSizePixel = 0
                    Container.Size = UDim2.new(1, 0, 0, 26)
                    Container.ZIndex = 10

                    local LblI = Instance.new("TextLabel")
                    LblI.Parent = Container
                    LblI.BackgroundTransparency = 1
                    LblI.Position = UDim2.new(0, 6, 0, 0)
                    LblI.Size = UDim2.new(0.38, 0, 1, 0)
                    LblI.Text = lbl
                    LblI.TextColor3 = Color3.fromRGB(180,180,180)
                    LblI.TextSize = 13
                    LblI.Font = Enum.Font.SourceSans
                    LblI.TextXAlignment = Enum.TextXAlignment.Left
                    LblI.ZIndex = 11

                    local TB2 = Instance.new("TextBox")
                    TB2.Parent = Container
                    TB2.BackgroundColor3 = Colors.Background
                    TB2.BorderColor3 = Colors.Border
                    TB2.BorderSizePixel = 1
                    TB2.Position = UDim2.new(0.38, 0, 0.5, -10)
                    TB2.Size = UDim2.new(0.6, 0, 0, 20)
                    TB2.PlaceholderText = placeholder or ""
                    TB2.Text = ""
                    TB2.TextColor3 = Colors.Text
                    TB2.PlaceholderColor3 = Color3.fromRGB(100,100,100)
                    TB2.TextSize = 13
                    TB2.Font = Enum.Font.SourceSans
                    TB2.ClearTextOnFocus = false
                    TB2.ZIndex = 11
                    local ibp = Instance.new("UIPadding")
                    ibp.PaddingLeft=UDim.new(0,4); ibp.PaddingRight=UDim.new(0,4); ibp.Parent=TB2
                    TB2.Focused:Connect(function() TB2.BorderColor3=Color3.fromRGB(110,60,200) end)
                    TB2.FocusLost:Connect(function(enter)
                        TB2.BorderColor3=Colors.Border
                        if cb then cb(TB2.Text, enter) end
                    end)
                    return TB2
                end

                -- ══ KEYBIND ══
                function S:AddKeybind(lbl, defaultKey, cb)
                    local curKey = defaultKey or Enum.KeyCode.Unknown
                    local Container = Instance.new("Frame")
                    Container.Parent = Items
                    Container.BackgroundColor3 = Colors.Element
                    Container.BorderSizePixel = 0
                    Container.Size = UDim2.new(1, 0, 0, 26)
                    Container.ZIndex = 10

                    local LblK = Instance.new("TextLabel")
                    LblK.Parent = Container
                    LblK.BackgroundTransparency = 1
                    LblK.Position = UDim2.new(0, 6, 0, 0)
                    LblK.Size = UDim2.new(0.6, 0, 1, 0)
                    LblK.Text = lbl
                    LblK.TextColor3 = Colors.Text
                    LblK.TextSize = 14
                    LblK.Font = Enum.Font.SourceSans
                    LblK.TextXAlignment = Enum.TextXAlignment.Left
                    LblK.ZIndex = 11

                    local KB = Instance.new("TextButton")
                    KB.Parent = Container
                    KB.BackgroundColor3 = Colors.Background
                    KB.BorderColor3 = Colors.Border
                    KB.BorderSizePixel = 1
                    KB.Position = UDim2.new(0.62, 0, 0.5, -10)
                    KB.Size = UDim2.new(0.36, 0, 0, 20)
                    KB.Text = tostring(curKey):gsub("Enum.KeyCode.", "")
                    KB.TextColor3 = Color3.fromRGB(160,100,255)
                    KB.TextSize = 13
                    KB.Font = Enum.Font.SourceSans
                    KB.ZIndex = 11

                    KB.MouseButton1Click:Connect(function()
                        KB.Text = "..."
                        KB.BackgroundColor3 = Color3.fromRGB(30,10,60)
                        local conn; conn = UserInputService.InputBegan:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.Keyboard then
                                curKey = inp.KeyCode
                                KB.Text = tostring(curKey):gsub("Enum.KeyCode.","")
                                KB.BackgroundColor3 = Colors.Background
                                if cb then cb(curKey) end
                                conn:Disconnect()
                            end
                        end)
                    end)
                    Container.MouseEnter:Connect(function() Container.BackgroundColor3=Color3.fromRGB(22,15,35) end)
                    Container.MouseLeave:Connect(function() Container.BackgroundColor3=Colors.Element end)
                    local obj={Value=curKey}
                    function obj:Set(k) curKey=k; obj.Value=k; KB.Text=tostring(k):gsub("Enum.KeyCode.","") end
                    return obj
                end

                -- ══ COLOR PICKER ══
                function S:AddColorPicker(lbl, default, cb)
                    local col = default or Colors.Violet
                    local Container = Instance.new("Frame")
                    Container.Parent = Items
                    Container.BackgroundColor3 = Colors.Element
                    Container.BorderSizePixel = 0
                    Container.Size = UDim2.new(1, 0, 0, 26)
                    Container.ZIndex = 10

                    local LblC = Instance.new("TextLabel")
                    LblC.Parent = Container
                    LblC.BackgroundTransparency = 1
                    LblC.Position = UDim2.new(0, 6, 0, 0)
                    LblC.Size = UDim2.new(0.62, 0, 1, 0)
                    LblC.Text = lbl
                    LblC.TextColor3 = Colors.Text
                    LblC.TextSize = 14
                    LblC.Font = Enum.Font.SourceSans
                    LblC.TextXAlignment = Enum.TextXAlignment.Left
                    LblC.ZIndex = 11

                    local Prev = Instance.new("TextButton")
                    Prev.Parent = Container
                    Prev.BackgroundColor3 = col
                    Prev.BorderColor3 = Colors.Border
                    Prev.BorderSizePixel = 2
                    Prev.Position = UDim2.new(1,-44,0.5,-9)
                    Prev.Size = UDim2.new(0,38,0,18)
                    Prev.Text = ""
                    Prev.ZIndex = 11

                    local palette = {
                        Color3.fromRGB(72,40,140), Color3.fromRGB(40,80,200),
                        Color3.fromRGB(200,40,80), Color3.fromRGB(40,180,80),
                        Color3.fromRGB(200,150,40), Color3.fromRGB(200,40,40),
                        Color3.fromRGB(200,200,200), Color3.fromRGB(30,30,30),
                    }
                    local Pal = Instance.new("Frame")
                    Pal.Parent = Container
                    Pal.BackgroundColor3 = Colors.Secondary
                    Pal.BorderColor3 = Colors.Border
                    Pal.BorderSizePixel = 2
                    Pal.Position = UDim2.new(0.3,0,1,2)
                    Pal.Size = UDim2.new(0,160,0,50)
                    Pal.Visible = false
                    Pal.ZIndex = 60
                    local pg = Instance.new("UIGridLayout")
                    pg.CellSize=UDim2.new(0,16,0,16); pg.CellPadding=UDim2.new(0,3,0,3); pg.Parent=Pal
                    local palp = Instance.new("UIPadding")
                    palp.PaddingTop=UDim.new(0,5); palp.PaddingLeft=UDim.new(0,5); palp.Parent=Pal

                    for _, pc in ipairs(palette) do
                        local PB = Instance.new("TextButton")
                        PB.Parent=Pal; PB.BackgroundColor3=pc
                        PB.BorderColor3=Colors.Border; PB.BorderSizePixel=1
                        PB.Size=UDim2.new(0,16,0,16); PB.Text=""; PB.ZIndex=61
                        PB.MouseButton1Click:Connect(function()
                            col=pc; Prev.BackgroundColor3=pc; Pal.Visible=false
                            if cb then cb(pc) end
                        end)
                    end
                    local po=false
                    Prev.MouseButton1Click:Connect(function() po=not po; Pal.Visible=po end)
                    local obj={Value=col}
                    function obj:Set(c) col=c; obj.Value=c; Prev.BackgroundColor3=c end
                    return obj
                end

                -- ══ LABEL ══
                function S:AddLabel(txt, col)
                    local L = Instance.new("TextLabel")
                    L.Parent = Items
                    L.BackgroundTransparency = 1
                    L.BorderSizePixel = 0
                    L.Size = UDim2.new(1, 0, 0, 18)
                    L.Text = txt
                    L.TextColor3 = col or Color3.fromRGB(150,140,165)
                    L.TextSize = 13
                    L.Font = Enum.Font.SourceSans
                    L.TextXAlignment = Enum.TextXAlignment.Left
                    L.ZIndex = 10
                    return L
                end

                -- ══ SEPARATOR ══
                function S:AddSeparator()
                    local Sep = Instance.new("Frame")
                    Sep.Parent = Items
                    Sep.BackgroundColor3 = Colors.Violet
                    Sep.BorderSizePixel = 0
                    Sep.Size = UDim2.new(1, 0, 0, 1)
                    Sep.ZIndex = 10
                    return Sep
                end

                return S
            end

            return SubTabObj
        end

        return Tab
    end

    -- Contrôles
    local isMin = false
    MinusButton.MouseButton1Click:Connect(function()
        isMin = not isMin
        if isMin then
            MainFrame.Size = UDim2.new(0, 800, 0, 50)
        else
            MainFrame.Size = UDim2.new(0, 800, 0, 550)
        end
    end)
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    UserInputService.InputBegan:Connect(function(inp, proc)
        if not proc and inp.KeyCode == toggleKey then
            isVisible = not isVisible
            MainFrame.Visible = isVisible
        end
    end)

    return Window
end

-- ══ TAB PARAMETRES ══════════════════════════════════
function Library:AddSettingsTab(Win)
    local ST = Win:CreateTab("Parametres", "o")
    local GenSub = ST:CreateSubTab("General")
    local AppSub = ST:CreateSubTab("Apparence")
    local KeySub = ST:CreateSubTab("Touches")
    local CfgSub = ST:CreateSubTab("Configs")

    local GenSec = GenSub:CreateSection("General")
    GenSec:AddToggle("Notifications", true, "Activer les notifications", function(v)
        Win:Notify("Parametres", "Notifications: "..(v and "ON" or "OFF"), "info", 2)
    end)
    GenSec:AddToggle("Sons UI", false, "Sons lors des clics", function(v) end)
    GenSec:AddToggle("Animations", true, "Activer les tweens", function(v) end)
    GenSec:AddToggle("Tooltips", true, "Afficher les bulles ?", function(v) end)
    GenSec:AddSeparator()
    GenSec:AddDropdown("Langue", {"Francais","English","Espanol","Deutsch"}, "Francais", function(v)
        Win:Notify("Parametres","Langue: "..v, "info", 2)
    end)
    GenSec:AddSlider("Opacite UI", 40, 100, 100, "%", function(v) end)
    GenSec:AddSlider("Delai notif.", 1, 10, 3, "s", function(v) end)

    local PerfSec = GenSub:CreateSection("Performance")
    PerfSec:AddToggle("Mode performance", false, "Reduit les effets", function(v)
        Win:Notify("Parametres","Mode perf: "..(v and "ON" or "OFF"), "info", 2)
    end)
    PerfSec:AddToggle("Limiter FPS UI", false, function(v) end)
    PerfSec:AddSlider("FPS max UI", 15, 60, 60, " fps", function(v) end)
    PerfSec:AddToggle("Reduire effets", false, function(v) end)
    PerfSec:AddButton("Nettoyer la memoire", function()
        Win:Notify("Systeme","Memoire nettoyee !","info",2)
    end)

    local ThemeSec = AppSub:CreateSection("Theme")
    ThemeSec:AddDropdown("Theme", {"Violet (defaut)","Bleu nuit","Rouge sang","Vert neon","Mono"}, "Violet (defaut)", function(v)
        Win:Notify("Apparence","Theme: "..v,"info",2)
    end)
    ThemeSec:AddColorPicker("Couleur accent", Color3.fromRGB(72,40,140), function(c) end)
    ThemeSec:AddColorPicker("Couleur fond", Color3.fromRGB(0,0,0), function(c) end)
    ThemeSec:AddSlider("Taille UI", 70, 130, 100, "%", function(v) end)

    local StyleSec = AppSub:CreateSection("Style")
    StyleSec:AddToggle("Bordures UI", true, function(v) end)
    StyleSec:AddToggle("Effet glow", true, function(v) end)
    StyleSec:AddSlider("Opacite fond", 0, 60, 0, "%", function(v) end)

    local KeySec = KeySub:CreateSection("Raccourcis")
    KeySec:AddKeybind("Toggle UI", Enum.KeyCode.RightShift, function(k)
        Win:Notify("Touches","Toggle -> "..tostring(k):gsub("Enum.KeyCode.",""),"info",2)
    end)
    KeySec:AddKeybind("Panic key", Enum.KeyCode.Delete, function(k) end)
    KeySec:AddKeybind("Screenshot", Enum.KeyCode.F12, function(k) end)
    KeySec:AddSeparator()
    KeySec:AddToggle("Bloquer input jeu", false, "Empeche les touches de passer au jeu", function(v) end)
    KeySec:AddDropdown("Mode activation",{"Appui","Toggle","Maintien"},"Appui",function(v) end)

    local CfgSec = CfgSub:CreateSection("Gestion")
    CfgSec:AddInput("Nom", "MaConfig", function(t,enter)
        if enter and t~="" then Win:Notify("Config","Nom: "..t,"info",2) end
    end)
    CfgSec:AddButton("Sauvegarder", function()
        Win:Notify("Config","Configuration sauvegardee !","info",2)
    end)
    CfgSec:AddButton("Charger", function()
        Win:Notify("Config","Configuration chargee !","info",2)
    end)
    CfgSec:AddButton("Supprimer", function()
        Win:Notify("Config","Supprimee","info",2)
    end)
    CfgSec:AddButton("Rafraichir", function()
        Win:Notify("Config","Liste rafraichie","info",2)
    end)
    CfgSec:AddSeparator()
    CfgSec:AddDropdown("Config active",{"Default","Config 1","Config 2"},"Default",function(v)
        Win:Notify("Config","Selectionne: "..v,"info",2)
    end)

    local Cfg2Sec = CfgSub:CreateSection("Options auto")
    Cfg2Sec:AddToggle("Autosave", false, function(v) end)
    Cfg2Sec:AddSlider("Intervalle", 10, 300, 60, "s", function(v) end)
    Cfg2Sec:AddToggle("Charger au demarrage", true, function(v) end)
    Cfg2Sec:AddButton("Tout reinitialiser", function()
        Win:Notify("Config","Reset effectue","info",2)
    end)

    return ST
end

return Library
