local VioletUI = {}
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LocalPlayer      = Players.LocalPlayer

-- ══════════════════════════════════════════
--  COULEURS
-- ══════════════════════════════════════════
local C = {
    BG          = Color3.fromRGB(15, 10, 25),
    BG2         = Color3.fromRGB(22, 15, 35),
    Panel       = Color3.fromRGB(28, 20, 42),
    Element     = Color3.fromRGB(35, 25, 55),
    ElementHov  = Color3.fromRGB(50, 35, 75),
    Violet      = Color3.fromRGB(110, 55, 210),
    VioletDark  = Color3.fromRGB(70, 35, 140),
    VioletLight = Color3.fromRGB(155, 95, 255),
    Text        = Color3.fromRGB(210, 205, 225),
    TextDim     = Color3.fromRGB(130, 120, 150),
    TextBright  = Color3.fromRGB(255, 252, 255),
    Border      = Color3.fromRGB(65, 40, 105),
    BorderHi    = Color3.fromRGB(110, 55, 210),
    SliderBG    = Color3.fromRGB(25, 18, 40),
    Orange      = Color3.fromRGB(220, 130, 30),
    Red         = Color3.fromRGB(210, 55, 55),
    Green       = Color3.fromRGB(55, 185, 85),
}

-- ══════════════════════════════════════════
--  HELPERS
-- ══════════════════════════════════════════
local function Tw(obj, props, t, s, d)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.15, s or Enum.EasingStyle.Quart, d or Enum.EasingDirection.Out),
        props):Play()
end

local function Corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 4); c.Parent = p; return c
end

local function Stroke(p, col, th)
    local s = Instance.new("UIStroke"); s.Color = col or C.Border; s.Thickness = th or 1; s.Parent = p; return s
end

local function Pad(p, t, r, b, l)
    local u = Instance.new("UIPadding")
    u.PaddingTop    = UDim.new(0, t or 4)
    u.PaddingRight  = UDim.new(0, r or 4)
    u.PaddingBottom = UDim.new(0, b or 4)
    u.PaddingLeft   = UDim.new(0, l or 4)
    u.Parent = p; return u
end

local function ListLayout(p, dir, gap, ha, va)
    local l = Instance.new("UIListLayout")
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.Padding = UDim.new(0, gap or 4)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    if ha then l.HorizontalAlignment = ha end
    if va then l.VerticalAlignment = va end
    l.Parent = p; return l
end

local function Frame(props)
    local f = Instance.new("Frame")
    f.BorderSizePixel = 0
    for k,v in pairs(props) do f[k]=v end
    return f
end

local function Label(props)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.BorderSizePixel = 0
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    for k,v in pairs(props) do l[k]=v end
    return l
end

local function Btn(props)
    local b = Instance.new("TextButton")
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Font = Enum.Font.GothamMedium
    for k,v in pairs(props) do b[k]=v end
    return b
end

-- ══════════════════════════════════════════
--  LOGO ŒEIL (identique à la photo originale)
-- ══════════════════════════════════════════
local function BuildEyeLogo(parent, size, col)
    col = col or C.VioletLight
    local sz = size or 38
    local Container = Frame{
        Parent = parent, BackgroundTransparency = 1,
        Size = UDim2.new(0, sz, 0, sz),
    }

    -- Cercle extérieur
    local OuterRing = Frame{
        Parent = Container, BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,1,0),
    }
    local outerStroke = Instance.new("UIStroke")
    outerStroke.Color = col
    outerStroke.Thickness = 1.5
    outerStroke.Parent = OuterRing
    Corner(OuterRing, sz/2)

    -- Ligne horizontale (œil)
    local EyeH = Frame{
        Parent = Container, BackgroundColor3 = col,
        Size = UDim2.new(0.9,0,0,1.5),
        Position = UDim2.new(0.05,0,0.5,-1),
    }

    -- Ligne verticale
    local EyeV = Frame{
        Parent = Container, BackgroundColor3 = col,
        Size = UDim2.new(0,1.5,0.9,0),
        Position = UDim2.new(0.5,-1,0.05,0),
    }

    -- Pupille extérieure
    local PupilOuter = Frame{
        Parent = Container, BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, sz*0.45, 0, sz*0.45),
        Position = UDim2.new(0.5,-sz*0.225,0.5,-sz*0.225),
    }
    local pupStroke = Instance.new("UIStroke")
    pupStroke.Color = col
    pupStroke.Thickness = 1.2
    pupStroke.Parent = PupilOuter
    Corner(PupilOuter, sz)

    -- Pupille intérieure (remplie)
    local PupilInner = Frame{
        Parent = Container, BackgroundColor3 = col,
        Size = UDim2.new(0, sz*0.22, 0, sz*0.22),
        Position = UDim2.new(0.5,-sz*0.11,0.5,-sz*0.11),
    }
    Corner(PupilInner, sz)

    -- Petits traits décoratifs aux 4 coins (style de la photo)
    local corners = {
        {UDim2.new(0,2,0,2),    UDim2.new(0,8,0,1.5)},
        {UDim2.new(1,-10,0,2),  UDim2.new(0,8,0,1.5)},
        {UDim2.new(0,2,1,-4),   UDim2.new(0,8,0,1.5)},
        {UDim2.new(1,-10,1,-4), UDim2.new(0,8,0,1.5)},
    }
    for _, cd in ipairs(corners) do
        Frame{Parent=Container, BackgroundColor3=col, Position=cd[1], Size=cd[2]}
    end
    local corners2 = {
        {UDim2.new(0,2,0,2),    UDim2.new(0,1.5,0,8)},
        {UDim2.new(1,-4,0,2),   UDim2.new(0,1.5,0,8)},
        {UDim2.new(0,2,1,-10),  UDim2.new(0,1.5,0,8)},
        {UDim2.new(1,-4,1,-10), UDim2.new(0,1.5,0,8)},
    }
    for _, cd in ipairs(corners2) do
        Frame{Parent=Container, BackgroundColor3=col, Position=cd[1], Size=cd[2]}
    end

    return Container
end

-- ══════════════════════════════════════════
--  NOTIFICATIONS
-- ══════════════════════════════════════════
local function CreateNotifSystem(gui)
    local Holder = Frame{
        Name="NotifHolder", Parent=gui,
        BackgroundTransparency=1,
        Size=UDim2.new(0,270,1,0),
        Position=UDim2.new(1,-280,0,0),
        ZIndex=200,
    }
    ListLayout(Holder, Enum.FillDirection.Vertical, 6)
    Pad(Holder, 16, 0, 0, 0)

    return function(title, msg, ntype, dur)
        local accent = ({info=C.Violet, success=C.Green, warning=C.Orange, error=C.Red})[ntype or "info"] or C.Violet
        local NF = Frame{
            Parent=Holder, BackgroundColor3=C.Panel,
            Size=UDim2.new(1,0,0,64), ZIndex=201,
        }
        Corner(NF, 5)
        Stroke(NF, accent, 1)

        Frame{Parent=NF, BackgroundColor3=accent, Size=UDim2.new(0,3,1,0), ZIndex=202}
        Corner(Frame{Parent=NF, BackgroundColor3=accent, Size=UDim2.new(0,3,1,0), ZIndex=202}, 2)

        Label{Parent=NF, Text=title, TextColor3=C.TextBright, TextSize=13,
            Font=Enum.Font.GothamBold, Size=UDim2.new(1,-14,0,22),
            Position=UDim2.new(0,10,0,5), ZIndex=202}
        Label{Parent=NF, Text=msg, TextColor3=C.TextDim, TextSize=11,
            Size=UDim2.new(1,-14,0,28), Position=UDim2.new(0,10,0,28),
            TextWrapped=true, ZIndex=202}

        local PBG = Frame{Parent=NF, BackgroundColor3=C.Element,
            Size=UDim2.new(1,0,0,2), Position=UDim2.new(0,0,1,-2), ZIndex=203}
        local PF  = Frame{Parent=PBG, BackgroundColor3=accent,
            Size=UDim2.new(1,0,1,0), ZIndex=204}

        NF.Position = UDim2.new(1,10,0,0)
        Tw(NF, {Position=UDim2.new(0,0,0,0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local d = dur or 3
        Tw(PF, {Size=UDim2.new(0,0,1,0)}, d, Enum.EasingStyle.Linear)
        task.delay(d, function()
            Tw(NF, {Position=UDim2.new(1,10,0,0)}, 0.22)
            task.wait(0.25); NF:Destroy()
        end)
    end
end

-- ══════════════════════════════════════════
--  CRÉATION FENÊTRE
-- ══════════════════════════════════════════
function VioletUI:CreateWindow(cfg)
    cfg = cfg or {}
    local winName   = cfg.Name      or "VioletUI"
    local toggleKey = cfg.ToggleKey or Enum.KeyCode.RightShift
    local W         = cfg.Width     or 690
    local H         = cfg.Height    or 430

    -- ScreenGui
    local GUI = Instance.new("ScreenGui")
    GUI.Name = "VioletUI"
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
    GUI.ResetOnSpawn = false
    GUI.DisplayOrder = 999
    GUI.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Notify = CreateNotifSystem(GUI)

    -- Fenêtre principale
    local Main = Frame{
        Name="Main", Parent=GUI,
        BackgroundColor3=C.BG,
        Size=UDim2.new(0,W,0,H),
        Position=UDim2.new(0.5,-W/2,0.5,-H/2),
        Active=true, Draggable=true,
        ZIndex=1,
    }
    Corner(Main, 7)
    Stroke(Main, C.BorderHi, 1.5)

    -- Gradient fond
    local bg = Instance.new("UIGradient")
    bg.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20,13,33)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12,8,20)),
    }
    bg.Rotation = 120
    bg.Parent = Main

    -- ── TOPBAR ──────────────────────────────
    local TopBar = Frame{
        Name="TopBar", Parent=Main,
        BackgroundColor3=C.BG2,
        Size=UDim2.new(1,0,0,44),
        ZIndex=2,
    }
    Corner(TopBar, 7)
    -- couvrir les coins bas
    Frame{Parent=TopBar, BackgroundColor3=C.BG2,
        Size=UDim2.new(1,0,0.5,0), Position=UDim2.new(0,0,0.5,0), ZIndex=2}
    Stroke(TopBar, C.Border, 1)

    -- Logo (œil) à gauche
    local LogoBG = Frame{
        Parent=TopBar, BackgroundColor3=C.VioletDark,
        Size=UDim2.new(0,34,0,34),
        Position=UDim2.new(0,7,0.5,-17),
        ZIndex=3,
    }
    Corner(LogoBG, 6)
    Stroke(LogoBG, C.BorderHi, 1)
    local logoEye = BuildEyeLogo(LogoBG, 26, C.VioletLight)
    logoEye.Position = UDim2.new(0.5,-13,0.5,-13)
    logoEye.Parent = LogoBG

    -- Titre
    Label{
        Parent=TopBar, Text=winName,
        TextColor3=C.TextBright, TextSize=15,
        Font=Enum.Font.GothamBold,
        Size=UDim2.new(0,220,1,0),
        Position=UDim2.new(0,48,0,0),
        ZIndex=3,
    }

    -- Boutons contrôle (style dots orange/rouge comme la photo)
    local function CtrlDot(col, xOff)
        local d = Btn{
            Parent=TopBar, BackgroundColor3=col,
            Size=UDim2.new(0,14,0,14),
            Position=UDim2.new(1,xOff,0.5,-7),
            Text="", ZIndex=3,
        }
        Corner(d, 7)
        return d
    end
    local MinBtn   = CtrlDot(C.Orange, -36)
    local CloseBtn = CtrlDot(C.Red,    -18)

    -- ── SIDEBAR ─────────────────────────────
    local Sidebar = Frame{
        Name="Sidebar", Parent=Main,
        BackgroundColor3=C.BG2,
        Size=UDim2.new(0,148,1,-44),
        Position=UDim2.new(0,0,0,44),
        ZIndex=2,
    }
    -- bordure droite uniquement
    local sideStroke = Instance.new("UIStroke")
    sideStroke.Color = C.Border
    sideStroke.Thickness = 1
    sideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    sideStroke.Parent = Sidebar

    -- ScrollFrame pour les tabs
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Parent = Sidebar
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel = 0
    TabScroll.Size = UDim2.new(1,0,1,-70)
    TabScroll.Position = UDim2.new(0,0,0,6)
    TabScroll.ScrollBarThickness = 2
    TabScroll.ScrollBarImageColor3 = C.Violet
    TabScroll.CanvasSize = UDim2.new(0,0,0,0)
    TabScroll.ZIndex = 3
    local TabScrollLayout = ListLayout(TabScroll, Enum.FillDirection.Vertical, 1)
    Pad(TabScroll, 2, 6, 2, 6)

    -- Search bar en bas sidebar
    local SearchBox = Instance.new("TextBox")
    SearchBox.Parent = Sidebar
    SearchBox.BackgroundColor3 = C.Element
    SearchBox.Size = UDim2.new(1,-12,0,26)
    SearchBox.Position = UDim2.new(0,6,1,-62)
    SearchBox.PlaceholderText = "🔍  Rechercher..."
    SearchBox.Text = ""
    SearchBox.TextColor3 = C.Text
    SearchBox.PlaceholderColor3 = C.TextDim
    SearchBox.TextSize = 12
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.ClearTextOnFocus = false
    SearchBox.ZIndex = 3
    Corner(SearchBox, 5)
    Stroke(SearchBox, C.Border, 1)
    Pad(SearchBox, 0,6,0,8)

    -- Logo "V" en bas
    local SideLogo = Btn{
        Parent=Sidebar,
        BackgroundColor3=C.VioletDark,
        Size=UDim2.new(0,36,0,36),
        Position=UDim2.new(0.5,-18,1,-42),
        Text="", ZIndex=3,
    }
    Corner(SideLogo, 6)
    Stroke(SideLogo, C.Violet, 1)
    local sideEye = BuildEyeLogo(SideLogo, 28, C.VioletLight)
    sideEye.Position = UDim2.new(0.5,-14,0.5,-14)
    sideEye.Parent = SideLogo

    -- ── ZONE CONTENU ────────────────────────
    local ContentZone = Frame{
        Name="ContentZone", Parent=Main,
        BackgroundTransparency=1,
        Size=UDim2.new(1,-148,1,-44),
        Position=UDim2.new(0,148,0,44),
        ZIndex=2,
    }

    -- Barre sous-tabs horizontale (comme la photo : Général | Apparence | Touches | Configs)
    local SubTabBar = Frame{
        Name="SubTabBar", Parent=ContentZone,
        BackgroundColor3=C.BG2,
        Size=UDim2.new(1,0,0,32),
        ZIndex=3,
    }
    Stroke(SubTabBar, C.Border, 1)
    ListLayout(SubTabBar, Enum.FillDirection.Horizontal, 0)
    Pad(SubTabBar, 0,4,0,6)

    -- Zone de contenu scrollable
    local ContentScroll = Instance.new("ScrollingFrame")
    ContentScroll.Parent = ContentZone
    ContentScroll.BackgroundTransparency = 1
    ContentScroll.BorderSizePixel = 0
    ContentScroll.Size = UDim2.new(1,0,1,-32)
    ContentScroll.Position = UDim2.new(0,0,0,32)
    ContentScroll.ScrollBarThickness = 3
    ContentScroll.ScrollBarImageColor3 = C.Violet
    ContentScroll.CanvasSize = UDim2.new(0,0,0,0)
    ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentScroll.ZIndex = 3

    -- Frame colonnes à l'intérieur du scroll
    local ColsFrame = Frame{
        Name="Cols", Parent=ContentScroll,
        BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,0),
        AutomaticSize=Enum.AutomaticSize.Y,
        ZIndex=4,
    }
    local ColsLayout = Instance.new("UIListLayout")
    ColsLayout.FillDirection = Enum.FillDirection.Horizontal
    ColsLayout.Padding = UDim.new(0,6)
    ColsLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    ColsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ColsLayout.Parent = ColsFrame
    Pad(ColsFrame, 8,8,8,8)

    -- ══════════════════════════════════════
    --  ÉTAT
    -- ══════════════════════════════════════
    local mainTabs   = {}
    local curMainTab = nil
    local isVisible  = true
    local isMin      = false

    -- ══════════════════════════════════════
    --  WINDOW OBJECT
    -- ══════════════════════════════════════
    local Win = {}

    function Win:Notify(t, m, tp, d) Notify(t, m, tp, d) end

    -- ── CRÉER UN TAB PRINCIPAL ──────────────
    function Win:CreateTab(name, icon)
        local td = {name=name, subTabs={}, curSub=nil}

        -- Bouton sidebar
        local TB = Btn{
            Name="TB_"..name, Parent=TabScroll,
            BackgroundColor3=C.Element, BackgroundTransparency=0.5,
            Size=UDim2.new(1,0,0,30), Text="", ZIndex=4,
        }
        Corner(TB, 5)

        -- Barre active gauche
        local ActBar = Frame{
            Parent=TB, BackgroundColor3=C.Violet,
            Size=UDim2.new(0,3,0.65,0),
            Position=UDim2.new(0,0,0.175,0),
            Visible=false, ZIndex=5,
        }
        Corner(ActBar, 2)

        -- Icône optionnelle
        local TBIcon = Label{
            Parent=TB, Text=icon or "",
            TextColor3=C.TextDim, TextSize=13,
            Size=UDim2.new(0,20,1,0),
            Position=UDim2.new(0,8,0,0), ZIndex=5,
        }
        local TBLabel = Label{
            Parent=TB, Text=name,
            TextColor3=C.TextDim, TextSize=12,
            Font=Enum.Font.GothamMedium,
            Size=UDim2.new(1,-30,1,0),
            Position=UDim2.new(0, icon and 24 or 10, 0,0),
            ZIndex=5,
        }

        -- Container sous-tabs pour ce tab
        local SubContainer = Frame{
            Name="Sub_"..name, Parent=SubTabBar,
            BackgroundTransparency=1,
            Size=UDim2.new(1,0,1,0), Visible=false, ZIndex=4,
        }
        ListLayout(SubContainer, Enum.FillDirection.Horizontal, 0)

        -- Container colonnes pour ce tab
        local ColContainer = Frame{
            Name="Col_"..name, Parent=ColsFrame,
            BackgroundTransparency=1,
            Size=UDim2.new(1,0,0,0),
            AutomaticSize=Enum.AutomaticSize.Y,
            Visible=false, ZIndex=5,
        }
        local ColContainerLayout = Instance.new("UIListLayout")
        ColContainerLayout.FillDirection = Enum.FillDirection.Horizontal
        ColContainerLayout.Padding = UDim.new(0,6)
        ColContainerLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        ColContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ColContainerLayout.Parent = ColContainer

        td.Button       = TB
        td.ActBar       = ActBar
        td.Label        = TBLabel
        td.SubContainer = SubContainer
        td.ColContainer = ColContainer

        table.insert(mainTabs, td)

        local function Activate()
            for _, t in ipairs(mainTabs) do
                t.Button.BackgroundTransparency = 0.5
                t.Button.BackgroundColor3 = C.Element
                t.ActBar.Visible = false
                t.Label.TextColor3 = C.TextDim
                t.SubContainer.Visible = false
                t.ColContainer.Visible = false
            end
            TB.BackgroundTransparency = 0
            TB.BackgroundColor3 = C.VioletDark
            ActBar.Visible = true
            TBLabel.TextColor3 = C.TextBright
            SubContainer.Visible = true
            ColContainer.Visible = true
            curMainTab = td
            -- activer premier sous-tab
            if td.curSub then
                td.curSub.ColFrame.Visible = true
            elseif #td.subTabs > 0 then
                td.subTabs[1].activate()
            end
        end

        TB.MouseButton1Click:Connect(Activate)
        TB.MouseEnter:Connect(function()
            if curMainTab ~= td then
                Tw(TB,{BackgroundColor3=C.ElementHov, BackgroundTransparency=0.2},0.1)
                Tw(TBLabel,{TextColor3=C.Text},0.1)
            end
        end)
        TB.MouseLeave:Connect(function()
            if curMainTab ~= td then
                Tw(TB,{BackgroundColor3=C.Element, BackgroundTransparency=0.5},0.1)
                Tw(TBLabel,{TextColor3=C.TextDim},0.1)
            end
        end)

        if #mainTabs == 1 then task.defer(Activate) end

        -- ── SOUS-TABS ──────────────────────────
        local Tab = {}

        function Tab:CreateSubTab(sname)
            local sd = {name=sname}

            -- Bouton sous-tab (style de la photo : texte avec underline)
            local SB = Btn{
                Name="SB_"..sname, Parent=SubContainer,
                BackgroundTransparency=1,
                Size=UDim2.new(0,0,1,0),
                AutomaticSize=Enum.AutomaticSize.X,
                Text="", ZIndex=5,
            }
            Pad(SB, 0,12,0,12)

            local SBLabel = Label{
                Parent=SB, Text=sname,
                TextColor3=C.TextDim, TextSize=12,
                Font=Enum.Font.GothamMedium,
                Size=UDim2.new(1,0,1,0),
                TextXAlignment=Enum.TextXAlignment.Center,
                ZIndex=6,
            }
            -- Underline actif
            local SBLine = Frame{
                Parent=SB, BackgroundColor3=C.Violet,
                Size=UDim2.new(1,-8,0,2),
                Position=UDim2.new(0,4,1,-2),
                Visible=false, ZIndex=7,
            }
            Corner(SBLine, 1)

            -- Scroll pour le contenu de ce sous-tab
            local SubScroll = Instance.new("ScrollingFrame")
            SubScroll.Parent = ColContainer
            SubScroll.BackgroundTransparency = 1
            SubScroll.BorderSizePixel = 0
            SubScroll.Size = UDim2.new(1,0,0,0)
            SubScroll.AutomaticSize = Enum.AutomaticSize.Y
            SubScroll.CanvasSize = UDim2.new(0,0,0,0)
            SubScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            SubScroll.ScrollBarThickness = 0
            SubScroll.Visible = false
            SubScroll.ZIndex = 6

            -- Layout horizontal des colonnes (sections côte à côte)
            local SubColFrame = Frame{
                Name="SubCols_"..sname, Parent=SubScroll,
                BackgroundTransparency=1,
                Size=UDim2.new(1,0,0,0),
                AutomaticSize=Enum.AutomaticSize.Y,
                ZIndex=7,
            }
            local SubColLayout = Instance.new("UIListLayout")
            SubColLayout.FillDirection = Enum.FillDirection.Horizontal
            SubColLayout.Padding = UDim.new(0,6)
            SubColLayout.VerticalAlignment = Enum.VerticalAlignment.Top
            SubColLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SubColLayout.Parent = SubColFrame

            sd.Button   = SB
            sd.Label    = SBLabel
            sd.Line     = SBLine
            sd.ColFrame = SubColFrame
            sd.ScrollF  = SubScroll

            local function ActivateSub()
                for _, s in ipairs(td.subTabs) do
                    s.Label.TextColor3 = C.TextDim
                    s.Line.Visible = false
                    s.ScrollF.Visible = false
                end
                SBLabel.TextColor3 = C.TextBright
                SBLine.Visible = true
                SubScroll.Visible = true
                td.curSub = sd
            end
            sd.activate = ActivateSub

            SB.MouseButton1Click:Connect(ActivateSub)
            SB.MouseEnter:Connect(function()
                if not SBLine.Visible then Tw(SBLabel,{TextColor3=C.Text},0.1) end
            end)
            SB.MouseLeave:Connect(function()
                if not SBLine.Visible then Tw(SBLabel,{TextColor3=C.TextDim},0.1) end
            end)

            table.insert(td.subTabs, sd)
            if #td.subTabs == 1 and curMainTab == td then
                task.defer(ActivateSub)
            end

            -- ── SECTIONS ───────────────────────────
            local SubTabObj = {}

            function SubTabObj:CreateSection(secname)
                local Sec = Frame{
                    Name="Sec_"..secname, Parent=SubColFrame,
                    BackgroundColor3=C.Panel,
                    Size=UDim2.new(0,248,0,0),
                    AutomaticSize=Enum.AutomaticSize.Y,
                    ZIndex=8,
                }
                Corner(Sec, 5)
                Stroke(Sec, C.Border, 1)

                -- Header section
                local SecHead = Frame{
                    Parent=Sec, BackgroundColor3=C.BG2,
                    Size=UDim2.new(1,0,0,26), ZIndex=9,
                }
                Corner(SecHead, 5)
                Frame{Parent=SecHead, BackgroundColor3=C.BG2,
                    Size=UDim2.new(1,0,0.5,0), Position=UDim2.new(0,0,0.5,0), ZIndex=9}
                Stroke(SecHead, C.Border, 1)

                Label{
                    Parent=SecHead, Text=secname,
                    TextColor3=C.VioletLight, TextSize=12,
                    Font=Enum.Font.GothamBold,
                    Size=UDim2.new(1,-10,1,0),
                    Position=UDim2.new(0,10,0,0), ZIndex=10,
                }

                -- Ligne dégradée sous titre
                local SecLine = Frame{
                    Parent=SecHead, BackgroundColor3=C.Violet,
                    Size=UDim2.new(0.6,0,0,1),
                    Position=UDim2.new(0,0,1,-1), ZIndex=10,
                }
                local slg = Instance.new("UIGradient")
                slg.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, C.VioletLight),
                    ColorSequenceKeypoint.new(1, Color3.new(0,0,0)),
                }
                slg.Parent = SecLine

                -- Items list
                local Items = Frame{
                    Name="Items", Parent=Sec,
                    BackgroundTransparency=1,
                    Size=UDim2.new(1,0,0,0),
                    AutomaticSize=Enum.AutomaticSize.Y,
                    Position=UDim2.new(0,0,0,26),
                    ZIndex=9,
                }
                ListLayout(Items, Enum.FillDirection.Vertical, 2)
                Pad(Items, 5,7,7,7)

                local S = {}

                -- ─────────────────────────────────────
                --  TOGGLE
                -- ─────────────────────────────────────
                function S:AddToggle(lbl, hint, default, cb)
                    -- Support lbl, default, cb (sans hint)
                    if type(hint) == "boolean" then
                        cb = default; default = hint; hint = nil
                    end
                    local val = default or false

                    local Row = Frame{
                        Parent=Items, BackgroundColor3=C.Element,
                        BackgroundTransparency=0.6,
                        Size=UDim2.new(1,0,0,28), ZIndex=10,
                    }
                    Corner(Row, 4)

                    -- Checkbox carré (style de la photo originale)
                    local Box = Frame{
                        Parent=Row, BackgroundColor3=val and C.Violet or C.SliderBG,
                        Size=UDim2.new(0,14,0,14),
                        Position=UDim2.new(0,8,0.5,-7), ZIndex=11,
                    }
                    Corner(Box, 3)
                    Stroke(Box, val and C.VioletLight or C.Border, 1)

                    -- Coche ✓
                    local Check = Label{
                        Parent=Box, Text="✓",
                        TextColor3=C.TextBright, TextSize=10,
                        Font=Enum.Font.GothamBold,
                        Size=UDim2.new(1,0,1,0),
                        TextXAlignment=Enum.TextXAlignment.Center,
                        TextTransparency=val and 0 or 1, ZIndex=12,
                    }

                    Label{
                        Parent=Row, Text=lbl,
                        TextColor3=C.Text, TextSize=12,
                        Size=UDim2.new(1,-60,1,0),
                        Position=UDim2.new(0,28,0,0), ZIndex=11,
                    }

                    -- Hint "?"
                    if hint then
                        local HB = Btn{
                            Parent=Row, BackgroundColor3=C.VioletDark,
                            Size=UDim2.new(0,15,0,15),
                            Position=UDim2.new(1,-22,0.5,-7.5),
                            Text="?", TextColor3=C.VioletLight,
                            TextSize=10, Font=Enum.Font.GothamBold,
                            ZIndex=12,
                        }
                        Corner(HB, 7)
                    end

                    local ClickBtn = Btn{
                        Parent=Row, BackgroundTransparency=1,
                        Size=UDim2.new(1,0,1,0), Text="", ZIndex=13,
                    }

                    local obj = {Value=val}
                    local function Set(v, silent)
                        val = v; obj.Value = v
                        Tw(Box, {BackgroundColor3=v and C.Violet or C.SliderBG}, 0.12)
                        Tw(Check, {TextTransparency=v and 0 or 1}, 0.1)
                        if not silent and cb then cb(v) end
                    end

                    ClickBtn.MouseButton1Click:Connect(function() Set(not val) end)
                    Row.MouseEnter:Connect(function() Tw(Row,{BackgroundTransparency=0.3},0.1) end)
                    Row.MouseLeave:Connect(function() Tw(Row,{BackgroundTransparency=0.6},0.1) end)

                    function obj:Set(v) Set(v, true) end
                    return obj
                end

                -- ─────────────────────────────────────
                --  SLIDER (style photo : valeur à droite + %)
                -- ─────────────────────────────────────
                function S:AddSlider(lbl, min, max, default, suffix, cb)
                    if type(suffix) == "function" then cb=suffix; suffix="" end
                    local val = math.clamp(default or min, min, max)
                    suffix = suffix or ""

                    local Container = Frame{
                        Parent=Items, BackgroundColor3=C.Element,
                        BackgroundTransparency=0.6,
                        Size=UDim2.new(1,0,0,42), ZIndex=10,
                    }
                    Corner(Container, 4)

                    -- Row titre + valeur (style "Smoothness    0%")
                    Label{
                        Parent=Container, Text=lbl,
                        TextColor3=C.Text, TextSize=12,
                        Size=UDim2.new(0.65,0,0,20),
                        Position=UDim2.new(0,8,0,3), ZIndex=11,
                    }
                    local ValLbl = Label{
                        Parent=Container,
                        Text=tostring(math.floor(val))..suffix,
                        TextColor3=C.TextDim, TextSize=11,
                        Font=Enum.Font.Gotham,
                        Size=UDim2.new(0.35,-8,0,20),
                        Position=UDim2.new(0.65,0,0,3),
                        TextXAlignment=Enum.TextXAlignment.Right,
                        ZIndex=11,
                    }

                    -- Track
                    local Track = Frame{
                        Parent=Container, BackgroundColor3=C.SliderBG,
                        Size=UDim2.new(1,-16,0,4),
                        Position=UDim2.new(0,8,0,28), ZIndex=11,
                    }
                    Corner(Track, 2)
                    Stroke(Track, C.Border, 1)

                    local pct = (val-min)/(max-min)
                    local Fill = Frame{
                        Parent=Track, BackgroundColor3=C.Violet,
                        Size=UDim2.new(pct,0,1,0), ZIndex=12,
                    }
                    Corner(Fill, 2)

                    local Knob = Frame{
                        Parent=Track, BackgroundColor3=Color3.new(1,1,1),
                        Size=UDim2.new(0,9,0,9),
                        Position=UDim2.new(pct,-4.5,0.5,-4.5), ZIndex=13,
                    }
                    Corner(Knob, 5)
                    Stroke(Knob, C.VioletLight, 1)

                    local HitBtn = Btn{
                        Parent=Container, BackgroundTransparency=1,
                        Size=UDim2.new(1,0,0,22),
                        Position=UDim2.new(0,0,0,18), Text="", ZIndex=14,
                    }

                    local drag = false
                    local obj = {Value=val}
                    local function Update(mx)
                        local tp = Track.AbsolutePosition.X
                        local ts = Track.AbsoluteSize.X
                        local r = math.clamp((mx-tp)/ts, 0, 1)
                        val = min + (max-min)*r
                        obj.Value = val
                        Fill.Size = UDim2.new(r,0,1,0)
                        Knob.Position = UDim2.new(r,-4.5,0.5,-4.5)
                        ValLbl.Text = tostring(math.floor(val*10+0.5)/10)..suffix
                        if cb then cb(val) end
                    end

                    HitBtn.MouseButton1Down:Connect(function()
                        drag=true; Update(UserInputService:GetMouseLocation().X)
                    end)
                    UserInputService.InputEnded:Connect(function(i)
                        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
                    end)
                    UserInputService.InputChanged:Connect(function(i)
                        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
                            Update(UserInputService:GetMouseLocation().X)
                        end
                    end)
                    Container.MouseEnter:Connect(function() Tw(Container,{BackgroundTransparency=0.3},0.1) end)
                    Container.MouseLeave:Connect(function() Tw(Container,{BackgroundTransparency=0.6},0.1) end)

                    function obj:Set(v)
                        val = math.clamp(v,min,max)
                        obj.Value = val
                        local r = (val-min)/(max-min)
                        Fill.Size = UDim2.new(r,0,1,0)
                        Knob.Position = UDim2.new(r,-4.5,0.5,-4.5)
                        ValLbl.Text = tostring(val)..suffix
                    end
                    return obj
                end

                -- ─────────────────────────────────────
                --  DROPDOWN (style photo : texte + flèche + valeur)
                -- ─────────────────────────────────────
                function S:AddDropdown(lbl, opts, default, cb)
                    local sel = default or opts[1] or ""
                    local open = false

                    local Container = Frame{
                        Parent=Items, BackgroundColor3=C.Element,
                        BackgroundTransparency=0.6,
                        Size=UDim2.new(1,0,0,28), ZIndex=10,
                        ClipsDescendants=false,
                    }
                    Corner(Container, 4)

                    Label{
                        Parent=Container, Text=lbl,
                        TextColor3=C.TextDim, TextSize=11,
                        Size=UDim2.new(0.42,0,1,0),
                        Position=UDim2.new(0,8,0,0), ZIndex=11,
                    }

                    local DropBtn = Btn{
                        Parent=Container, BackgroundColor3=C.BG2,
                        Size=UDim2.new(0.55,0,0,20),
                        Position=UDim2.new(0.43,0,0.5,-10),
                        Text="", ZIndex=11,
                    }
                    Corner(DropBtn, 4)
                    Stroke(DropBtn, C.Border, 1)

                    local SelLbl = Label{
                        Parent=DropBtn, Text=sel,
                        TextColor3=C.Text, TextSize=11,
                        Font=Enum.Font.Gotham,
                        Size=UDim2.new(1,-20,1,0),
                        Position=UDim2.new(0,6,0,0), ZIndex=12,
                    }
                    Label{
                        Parent=DropBtn, Text="▾",
                        TextColor3=C.VioletLight, TextSize=12,
                        Size=UDim2.new(0,16,1,0),
                        Position=UDim2.new(1,-18,0,0),
                        TextXAlignment=Enum.TextXAlignment.Center,
                        ZIndex=12,
                    }

                    -- Liste déroulante
                    local DL = Frame{
                        Parent=DropBtn, BackgroundColor3=C.Panel,
                        Size=UDim2.new(1,0,0,#opts*22),
                        Position=UDim2.new(0,0,1,2),
                        Visible=false, ZIndex=50,
                    }
                    Corner(DL, 4)
                    Stroke(DL, C.BorderHi, 1)
                    ListLayout(DL, Enum.FillDirection.Vertical, 0)

                    for _, opt in ipairs(opts) do
                        local OB = Btn{
                            Parent=DL, BackgroundColor3=C.Element,
                            BackgroundTransparency=0.5,
                            Size=UDim2.new(1,0,0,22),
                            Text=opt, TextColor3=opt==sel and C.VioletLight or C.Text,
                            TextSize=11, Font=Enum.Font.Gotham,
                            ZIndex=51,
                        }
                        OB.MouseEnter:Connect(function()
                            Tw(OB,{BackgroundColor3=C.VioletDark,BackgroundTransparency=0},0.1)
                        end)
                        OB.MouseLeave:Connect(function()
                            Tw(OB,{BackgroundColor3=C.Element,BackgroundTransparency=0.5},0.1)
                        end)
                        OB.MouseButton1Click:Connect(function()
                            sel=opt; SelLbl.Text=opt
                            open=false; DL.Visible=false
                            if cb then cb(opt) end
                        end)
                    end

                    DropBtn.MouseButton1Click:Connect(function()
                        open=not open; DL.Visible=open
                    end)
                    Container.MouseEnter:Connect(function() Tw(Container,{BackgroundTransparency=0.3},0.1) end)
                    Container.MouseLeave:Connect(function() Tw(Container,{BackgroundTransparency=0.6},0.1) end)

                    local obj = {Value=sel}
                    function obj:Set(v) sel=v; SelLbl.Text=v; obj.Value=v end
                    return obj
                end

                -- ─────────────────────────────────────
                --  BUTTON
                -- ─────────────────────────────────────
                function S:AddButton(lbl, cb)
                    local B = Btn{
                        Parent=Items, BackgroundColor3=C.VioletDark,
                        Size=UDim2.new(1,0,0,26), Text="",ZIndex=10,
                    }
                    Corner(B, 4)
                    Stroke(B, C.Violet, 1)

                    local BG = Instance.new("UIGradient")
                    BG.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(95,45,170)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(55,28,105)),
                    }
                    BG.Rotation = 90; BG.Parent = B

                    Label{
                        Parent=B, Text=lbl,
                        TextColor3=C.TextBright, TextSize=12,
                        Font=Enum.Font.GothamMedium,
                        Size=UDim2.new(1,0,1,0),
                        TextXAlignment=Enum.TextXAlignment.Center,
                        ZIndex=11,
                    }

                    B.MouseEnter:Connect(function() Tw(B,{BackgroundColor3=C.Violet},0.12) end)
                    B.MouseLeave:Connect(function() Tw(B,{BackgroundColor3=C.VioletDark},0.12) end)
                    B.MouseButton1Down:Connect(function() Tw(B,{BackgroundColor3=C.VioletLight},0.07) end)
                    B.MouseButton1Up:Connect(function() Tw(B,{BackgroundColor3=C.Violet},0.1) end)
                    B.MouseButton1Click:Connect(function() if cb then cb() end end)
                    return B
                end

                -- ─────────────────────────────────────
                --  INPUT
                -- ─────────────────────────────────────
                function S:AddInput(lbl, placeholder, cb)
                    local Container = Frame{
                        Parent=Items, BackgroundColor3=C.Element,
                        BackgroundTransparency=0.6,
                        Size=UDim2.new(1,0,0,28), ZIndex=10,
                    }
                    Corner(Container, 4)

                    Label{
                        Parent=Container, Text=lbl,
                        TextColor3=C.TextDim, TextSize=11,
                        Size=UDim2.new(0.38,0,1,0),
                        Position=UDim2.new(0,8,0,0), ZIndex=11,
                    }

                    local TB2 = Instance.new("TextBox")
                    TB2.Parent=Container; TB2.BackgroundColor3=C.BG2
                    TB2.Size=UDim2.new(0.58,0,0,20)
                    TB2.Position=UDim2.new(0.4,0,0.5,-10)
                    TB2.PlaceholderText=placeholder or ""
                    TB2.Text=""; TB2.TextColor3=C.Text
                    TB2.PlaceholderColor3=C.TextDim
                    TB2.TextSize=11; TB2.Font=Enum.Font.Gotham
                    TB2.ClearTextOnFocus=false; TB2.ZIndex=11
                    Corner(TB2,3); Stroke(TB2,C.Border,1); Pad(TB2,0,5,0,5)

                    TB2.Focused:Connect(function() Tw(TB2,{BackgroundColor3=C.Element},0.1) end)
                    TB2.FocusLost:Connect(function(enter)
                        Tw(TB2,{BackgroundColor3=C.BG2},0.1)
                        if cb then cb(TB2.Text, enter) end
                    end)
                    Container.MouseEnter:Connect(function() Tw(Container,{BackgroundTransparency=0.3},0.1) end)
                    Container.MouseLeave:Connect(function() Tw(Container,{BackgroundTransparency=0.6},0.1) end)
                    return TB2
                end

                -- ─────────────────────────────────────
                --  KEYBIND
                -- ─────────────────────────────────────
                function S:AddKeybind(lbl, defaultKey, cb)
                    local curKey = defaultKey or Enum.KeyCode.Unknown
                    local listening = false

                    local Container = Frame{
                        Parent=Items, BackgroundColor3=C.Element,
                        BackgroundTransparency=0.6,
                        Size=UDim2.new(1,0,0,28), ZIndex=10,
                    }
                    Corner(Container, 4)

                    Label{
                        Parent=Container, Text=lbl,
                        TextColor3=C.Text, TextSize=12,
                        Size=UDim2.new(0.6,0,1,0),
                        Position=UDim2.new(0,8,0,0), ZIndex=11,
                    }

                    local KB = Btn{
                        Parent=Container, BackgroundColor3=C.BG2,
                        Size=UDim2.new(0.37,0,0,20),
                        Position=UDim2.new(0.61,0,0.5,-10),
                        Text=tostring(curKey):gsub("Enum.KeyCode.",""),
                        TextColor3=C.VioletLight, TextSize=11,
                        Font=Enum.Font.GothamMedium, ZIndex=11,
                    }
                    Corner(KB,3); Stroke(KB,C.Border,1)

                    KB.MouseButton1Click:Connect(function()
                        listening=true; KB.Text="..."; Tw(KB,{BackgroundColor3=C.VioletDark},0.1)
                        local conn; conn=UserInputService.InputBegan:Connect(function(inp)
                            if inp.UserInputType==Enum.UserInputType.Keyboard then
                                listening=false; curKey=inp.KeyCode
                                KB.Text=tostring(curKey):gsub("Enum.KeyCode.","")
                                Tw(KB,{BackgroundColor3=C.BG2},0.1)
                                if cb then cb(curKey) end
                                conn:Disconnect()
                            end
                        end)
                    end)
                    Container.MouseEnter:Connect(function() Tw(Container,{BackgroundTransparency=0.3},0.1) end)
                    Container.MouseLeave:Connect(function() Tw(Container,{BackgroundTransparency=0.6},0.1) end)

                    local obj={Value=curKey}
                    function obj:Set(k) curKey=k; obj.Value=k; KB.Text=tostring(k):gsub("Enum.KeyCode.","") end
                    return obj
                end

                -- ─────────────────────────────────────
                --  COLOR PICKER
                -- ─────────────────────────────────────
                function S:AddColorPicker(lbl, default, cb)
                    local col = default or C.Violet
                    local Container = Frame{
                        Parent=Items, BackgroundColor3=C.Element,
                        BackgroundTransparency=0.6,
                        Size=UDim2.new(1,0,0,28), ZIndex=10,
                    }
                    Corner(Container, 4)

                    Label{
                        Parent=Container, Text=lbl,
                        TextColor3=C.Text, TextSize=12,
                        Size=UDim2.new(0.6,0,1,0),
                        Position=UDim2.new(0,8,0,0), ZIndex=11,
                    }

                    local Prev = Btn{
                        Parent=Container, BackgroundColor3=col,
                        Size=UDim2.new(0,36,0,18),
                        Position=UDim2.new(1,-44,0.5,-9),
                        Text="", ZIndex=11,
                    }
                    Corner(Prev,3); Stroke(Prev,C.Border,1)

                    local palette = {
                        Color3.fromRGB(110,55,210), Color3.fromRGB(55,110,210),
                        Color3.fromRGB(210,55,110), Color3.fromRGB(55,210,110),
                        Color3.fromRGB(210,160,55), Color3.fromRGB(210,55,55),
                        Color3.fromRGB(200,200,200), Color3.fromRGB(50,50,50),
                    }
                    local Pal = Frame{
                        Parent=Container, BackgroundColor3=C.Panel,
                        Size=UDim2.new(0,158,0,52),
                        Position=UDim2.new(0.35,0,1,4),
                        Visible=false, ZIndex=60,
                    }
                    Corner(Pal,4); Stroke(Pal,C.BorderHi,1)
                    local PGrid = Instance.new("UIGridLayout")
                    PGrid.CellSize=UDim2.new(0,15,0,15); PGrid.CellPadding=UDim2.new(0,4,0,4)
                    PGrid.Parent=Pal; Pad(Pal,5,5,5,5)

                    for _,pc in ipairs(palette) do
                        local PB=Btn{Parent=Pal, BackgroundColor3=pc, Size=UDim2.new(0,15,0,15), Text="", ZIndex=61}
                        Corner(PB,3)
                        PB.MouseButton1Click:Connect(function()
                            col=pc; Prev.BackgroundColor3=pc; Pal.Visible=false
                            if cb then cb(pc) end
                        end)
                    end

                    local palOpen=false
                    Prev.MouseButton1Click:Connect(function()
                        palOpen=not palOpen; Pal.Visible=palOpen
                    end)
                    Container.MouseEnter:Connect(function() Tw(Container,{BackgroundTransparency=0.3},0.1) end)
                    Container.MouseLeave:Connect(function() Tw(Container,{BackgroundTransparency=0.6},0.1) end)

                    local obj={Value=col}
                    function obj:Set(c) col=c; obj.Value=c; Prev.BackgroundColor3=c end
                    return obj
                end

                -- ─────────────────────────────────────
                --  LABEL
                -- ─────────────────────────────────────
                function S:AddLabel(txt, col)
                    local L = Label{
                        Parent=Items, Text=txt,
                        TextColor3=col or C.TextDim, TextSize=11,
                        Size=UDim2.new(1,0,0,18),
                        Position=UDim2.new(0,8,0,0),
                        TextWrapped=true, ZIndex=10,
                    }
                    return L
                end

                -- ─────────────────────────────────────
                --  SEPARATOR
                -- ─────────────────────────────────────
                function S:AddSeparator()
                    local Sep = Frame{
                        Parent=Items, BackgroundColor3=C.Border,
                        Size=UDim2.new(1,0,0,1), ZIndex=10,
                    }
                    local sg = Instance.new("UIGradient")
                    sg.Color=ColorSequence.new{
                        ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),
                        ColorSequenceKeypoint.new(0.3,C.Violet),
                        ColorSequenceKeypoint.new(0.7,C.Violet),
                        ColorSequenceKeypoint.new(1,Color3.new(0,0,0)),
                    }
                    sg.Parent=Sep; return Sep
                end

                -- ─────────────────────────────────────
                --  MULTI-SELECT (checkboxes dans une liste)
                -- ─────────────────────────────────────
                function S:AddMultiSelect(lbl, opts, defaults, cb)
                    defaults = defaults or {}
                    local selected = {}
                    for _,v in ipairs(defaults) do selected[v]=true end

                    local Container = Frame{
                        Parent=Items, BackgroundColor3=C.Element,
                        BackgroundTransparency=0.6,
                        Size=UDim2.new(1,0,0,0),
                        AutomaticSize=Enum.AutomaticSize.Y, ZIndex=10,
                    }
                    Corner(Container, 4)
                    Label{
                        Parent=Container, Text=lbl,
                        TextColor3=C.TextDim, TextSize=11,
                        Font=Enum.Font.GothamBold,
                        Size=UDim2.new(1,0,0,22),
                        Position=UDim2.new(0,8,0,0), ZIndex=11,
                    }
                    local List = Frame{
                        Parent=Container, BackgroundTransparency=1,
                        Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
                        Position=UDim2.new(0,0,0,22), ZIndex=11,
                    }
                    ListLayout(List, Enum.FillDirection.Vertical, 0)
                    Pad(List, 0,6,4,6)

                    for _,opt in ipairs(opts) do
                        local isOn = selected[opt] or false
                        local Row2 = Frame{
                            Parent=List, BackgroundTransparency=1,
                            Size=UDim2.new(1,0,0,22), ZIndex=12,
                        }
                        local B2 = Frame{
                            Parent=Row2, BackgroundColor3=isOn and C.Violet or C.SliderBG,
                            Size=UDim2.new(0,12,0,12),
                            Position=UDim2.new(0,4,0.5,-6), ZIndex=13,
                        }
                        Corner(B2,3); Stroke(B2, isOn and C.VioletLight or C.Border, 1)
                        local Chk2 = Label{
                            Parent=B2, Text="✓", TextColor3=C.TextBright,
                            TextSize=9, Font=Enum.Font.GothamBold,
                            Size=UDim2.new(1,0,1,0),
                            TextXAlignment=Enum.TextXAlignment.Center,
                            TextTransparency=isOn and 0 or 1, ZIndex=14,
                        }
                        Label{
                            Parent=Row2, Text=opt, TextColor3=C.Text, TextSize=11,
                            Size=UDim2.new(1,-22,1,0),
                            Position=UDim2.new(0,22,0,0), ZIndex=13,
                        }
                        local CB2 = Btn{
                            Parent=Row2, BackgroundTransparency=1,
                            Size=UDim2.new(1,0,1,0), Text="", ZIndex=15,
                        }
                        CB2.MouseButton1Click:Connect(function()
                            isOn=not isOn; selected[opt]=isOn
                            Tw(B2,{BackgroundColor3=isOn and C.Violet or C.SliderBG},0.12)
                            Tw(Chk2,{TextTransparency=isOn and 0 or 1},0.1)
                            if cb then cb(selected) end
                        end)
                    end
                    return Container
                end

                return S
            end -- CreateSection

            return SubTabObj
        end -- CreateSubTab

        return Tab
    end -- CreateTab

    -- ── CONTRÔLES FENÊTRE ───────────────────
    MinBtn.MouseButton1Click:Connect(function()
        isMin = not isMin
        Tw(Main, {Size=UDim2.new(0,W,0,isMin and 44 or H)}, 0.25, Enum.EasingStyle.Quart)
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        Tw(Main, {BackgroundTransparency=1, Size=UDim2.new(0,W,0,0)}, 0.2)
        task.wait(0.25); GUI:Destroy()
    end)
    UserInputService.InputBegan:Connect(function(inp, proc)
        if not proc and inp.KeyCode == toggleKey then
            isVisible = not isVisible
            Main.Visible = isVisible
        end
    end)

    -- Auto canvas sidebar
    TabScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabScroll.CanvasSize = UDim2.new(0,0,0,TabScrollLayout.AbsoluteContentSize.Y+8)
    end)

    return Win
end

-- ══════════════════════════════════════════
--  TAB PARAMÈTRES AUTOMATIQUE (très fourni)
-- ══════════════════════════════════════════
function VioletUI:AddSettingsTab(Win)
    local ST = Win:CreateTab("Paramètres", "⚙")

    -- ── GÉNÉRAL ──────────────────────────
    local GenSub = ST:CreateSubTab("Général")

    local GenSec = GenSub:CreateSection("Général")
    GenSec:AddLabel("Paramètres généraux de l'interface")
    GenSec:AddSeparator()
    local notifT = GenSec:AddToggle("Notifications", "Activer les notifications popup", true, function(v)
        Win:Notify("Paramètres", "Notifications: "..(v and "ON" or "OFF"), v and "success" or "info", 2)
    end)
    local soundT = GenSec:AddToggle("Sons UI", "Sons lors des interactions", false, function(v)
        Win:Notify("Paramètres", "Sons: "..(v and "ON" or "OFF"), "info", 2)
    end)
    local animT = GenSec:AddToggle("Animations", "Activer les tweens", true, function(v) end)
    local tooltipT = GenSec:AddToggle("Tooltips", "Afficher les infobulles (?)", true, function(v) end)
    GenSec:AddSeparator()
    GenSec:AddLabel("Langue")
    GenSec:AddDropdown("Langue", {"Français","English","Español","Deutsch","Русский","中文"}, "Français", function(v)
        Win:Notify("Paramètres", "Langue: "..v, "info", 2)
    end)
    GenSec:AddSlider("Opacité UI", 40, 100, 100, "%", function(v) end)
    GenSec:AddSlider("Délai notif.", 1, 10, 3, "s", function(v) end)

    local Gen2Sec = GenSub:CreateSection("Performance")
    Gen2Sec:AddLabel("Optimisation de l'interface")
    Gen2Sec:AddSeparator()
    Gen2Sec:AddToggle("Mode performance", false, function(v)
        Win:Notify("Paramètres", "Mode perf: "..(v and "ON" or "OFF"), "warning", 2)
    end)
    Gen2Sec:AddToggle("Limiter FPS UI", false, function(v) end)
    Gen2Sec:AddSlider("FPS max UI", 15, 60, 60, " fps", function(v) end)
    Gen2Sec:AddToggle("Réduire effets", false, function(v) end)
    Gen2Sec:AddButton("Nettoyer la mémoire", function()
        Win:Notify("Système", "Mémoire nettoyée !", "success", 2)
    end)

    -- ── APPARENCE ────────────────────────
    local AppSub = ST:CreateSubTab("Apparence")

    local ThemeSec = AppSub:CreateSection("Thème")
    ThemeSec:AddLabel("Personnalisation des couleurs")
    ThemeSec:AddSeparator()
    ThemeSec:AddDropdown("Thème", {
        "Violet (défaut)","Bleu nuit","Rouge sang","Vert néon","Or royal","Monochrome","Rose","Cyan"
    }, "Violet (défaut)", function(v)
        Win:Notify("Apparence", "Thème: "..v, "info", 2)
    end)
    ThemeSec:AddColorPicker("Couleur accent", Color3.fromRGB(110,55,210), function(c)
        Win:Notify("Apparence", "Couleur accent changée", "success", 2)
    end)
    ThemeSec:AddColorPicker("Couleur fond", Color3.fromRGB(15,10,25), function(c) end)
    ThemeSec:AddColorPicker("Couleur texte", Color3.fromRGB(210,205,225), function(c) end)
    ThemeSec:AddSeparator()
    ThemeSec:AddSlider("Taille UI", 70, 130, 100, "%", function(v) end)
    ThemeSec:AddDropdown("Police", {"Gotham","GothamBold","Arial","Code","Cartoon"}, "Gotham", function(v) end)

    local StyleSec = AppSub:CreateSection("Style")
    StyleSec:AddLabel("Options visuelles")
    StyleSec:AddSeparator()
    StyleSec:AddToggle("Bordures UI", true, function(v) end)
    StyleSec:AddToggle("Coins arrondis", true, function(v) end)
    StyleSec:AddToggle("Effet glow", true, function(v) end)
    StyleSec:AddToggle("Gradient fond", true, function(v) end)
    StyleSec:AddToggle("Ombre portée", false, function(v) end)
    StyleSec:AddSlider("Épaisseur bordure", 1, 4, 1, "px", function(v) end)
    StyleSec:AddSlider("Opacité fond", 0, 60, 0, "%", function(v) end)
    StyleSec:AddSlider("Radius coins", 0, 12, 6, "px", function(v) end)

    -- ── TOUCHES ─────────────────────────
    local KeySub = ST:CreateSubTab("Touches")

    local KeySec = KeySub:CreateSection("Raccourcis")
    KeySec:AddLabel("Configurez vos touches clavier")
    KeySec:AddSeparator()
    KeySec:AddKeybind("Toggle UI", Enum.KeyCode.RightShift, function(k)
        Win:Notify("Touches", "Toggle → "..tostring(k):gsub("Enum.KeyCode.",""), "info", 2)
    end)
    KeySec:AddKeybind("Panic key", Enum.KeyCode.Delete, function(k)
        Win:Notify("Touches", "Panic → "..tostring(k):gsub("Enum.KeyCode.",""), "warning", 2)
    end)
    KeySec:AddKeybind("Screenshot", Enum.KeyCode.F12, function(k) end)
    KeySec:AddKeybind("Configs rapides", Enum.KeyCode.F5, function(k) end)
    KeySec:AddKeybind("Tab suivant", Enum.KeyCode.PageUp, function(k) end)
    KeySec:AddKeybind("Tab précédent", Enum.KeyCode.PageDown, function(k) end)

    local Key2Sec = KeySub:CreateSection("Options touches")
    Key2Sec:AddLabel("Comportement des touches")
    Key2Sec:AddSeparator()
    Key2Sec:AddToggle("Bloquer input jeu", false, "Empêche les touches de passer au jeu", function(v)
        Win:Notify("Touches", "Blocage: "..(v and "ON" or "OFF"), "warning", 2)
    end)
    Key2Sec:AddToggle("Touches globales", true, function(v) end)
    Key2Sec:AddToggle("Activer joystick", false, function(v) end)
    Key2Sec:AddDropdown("Mode activation", {"Appui","Toggle","Maintien"}, "Appui", function(v) end)
    Key2Sec:AddSlider("Délai répétition", 0, 500, 0, "ms", function(v) end)

    -- ── CONFIGS ─────────────────────────
    local CfgSub = ST:CreateSubTab("Configs")

    local CfgSec = CfgSub:CreateSection("Gestion")
    CfgSec:AddLabel("Sauvegarde et chargement")
    CfgSec:AddSeparator()
    CfgSec:AddInput("Nom de config", "MaConfig", function(t, enter)
        if enter and t~="" then Win:Notify("Config", "Nom: "..t, "info", 2) end
    end)
    CfgSec:AddButton("💾  Sauvegarder", function()
        Win:Notify("Config", "Configuration sauvegardée !", "success", 2.5)
    end)
    CfgSec:AddButton("📂  Charger", function()
        Win:Notify("Config", "Configuration chargée !", "success", 2)
    end)
    CfgSec:AddButton("🗑️  Supprimer", function()
        Win:Notify("Config", "Supprimée", "warning", 2)
    end)
    CfgSec:AddButton("🔄  Rafraîchir", function()
        Win:Notify("Config", "Liste rafraîchie", "info", 1.5)
    end)
    CfgSec:AddSeparator()
    CfgSec:AddDropdown("Configs sauvées", {"Default","Config 1","Config 2","Config 3"}, "Default", function(v)
        Win:Notify("Config", "Sélectionné: "..v, "info", 2)
    end)

    local Cfg2Sec = CfgSub:CreateSection("Options auto")
    Cfg2Sec:AddLabel("Gestion automatique")
    Cfg2Sec:AddSeparator()
    Cfg2Sec:AddToggle("Autosave", false, "Sauvegarder automatiquement", function(v)
        Win:Notify("Config", "Autosave: "..(v and "ON" or "OFF"), "info", 2)
    end)
    Cfg2Sec:AddSlider("Intervalle", 10, 300, 60, "s", function(v) end)
    Cfg2Sec:AddToggle("Charger au démarrage", true, function(v) end)
    Cfg2Sec:AddToggle("Backup auto", false, function(v) end)
    Cfg2Sec:AddButton("↩️  Tout réinitialiser", function()
        Win:Notify("Config", "Reset effectué", "warning", 2)
    end)

    return ST
end

return VioletUI
