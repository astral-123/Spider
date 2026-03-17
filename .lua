-- ╔══════════════════════════════════════════╗
-- ║        VioletUI Library  v2.0            ║
-- ║   Inspiré du style image - thème violet  ║
-- ╚══════════════════════════════════════════╝

local VioletUI = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ══════════════════════════════════════════
--  PALETTE DE COULEURS
-- ══════════════════════════════════════════
local C = {
    BG          = Color3.fromRGB(18, 14, 22),       -- Fond principal très sombre
    BG2         = Color3.fromRGB(24, 19, 30),       -- Fond secondaire
    Panel       = Color3.fromRGB(30, 24, 38),       -- Panneaux
    Element     = Color3.fromRGB(38, 30, 50),       -- Éléments interactifs
    ElementHov  = Color3.fromRGB(50, 38, 68),       -- Hover
    Violet      = Color3.fromRGB(120, 60, 220),     -- Accent violet
    VioletDark  = Color3.fromRGB(80, 40, 150),      -- Violet foncé
    VioletLight = Color3.fromRGB(160, 100, 255),    -- Violet clair
    VioletGlow  = Color3.fromRGB(140, 80, 240),     -- Violet glow
    Text        = Color3.fromRGB(220, 215, 230),    -- Texte principal
    TextDim     = Color3.fromRGB(140, 130, 155),    -- Texte secondaire
    TextBright  = Color3.fromRGB(255, 250, 255),    -- Texte bright
    Border      = Color3.fromRGB(80, 50, 120),      -- Bordure
    BorderBright= Color3.fromRGB(120, 60, 220),     -- Bordure active
    CheckOff    = Color3.fromRGB(35, 28, 45),       -- Checkbox off
    Slider      = Color3.fromRGB(28, 22, 36),       -- Slider track
    Red         = Color3.fromRGB(200, 60, 60),      -- Rouge (fermer)
    Orange      = Color3.fromRGB(200, 130, 30),     -- Orange (minimiser)
    Green       = Color3.fromRGB(60, 180, 80),      -- Vert (succès)
}

-- ══════════════════════════════════════════
--  UTILITAIRES
-- ══════════════════════════════════════════
local function Tween(obj, props, t, style, dir)
    style = style or Enum.EasingStyle.Quart
    dir = dir or Enum.EasingDirection.Out
    TweenService:Create(obj, TweenInfo.new(t or 0.15, style, dir), props):Play()
end

local function MakeBorder(parent, color, size)
    local b = Instance.new("UIStroke")
    b.Color = color or C.Border
    b.Thickness = size or 1
    b.Parent = parent
    return b
end

local function MakeCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 4)
    c.Parent = parent
    return c
end

local function MakePadding(parent, top, right, bottom, left)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top    or 4)
    p.PaddingRight  = UDim.new(0, right  or 4)
    p.PaddingBottom = UDim.new(0, bottom or 4)
    p.PaddingLeft   = UDim.new(0, left   or 4)
    p.Parent = parent
    return p
end

local function MakeListLayout(parent, dir, padding)
    local l = Instance.new("UIListLayout")
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.Padding = UDim.new(0, padding or 5)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Parent = parent
    return l
end

local function NewFrame(props)
    local f = Instance.new("Frame")
    for k,v in pairs(props) do
        f[k] = v
    end
    return f
end

local function NewLabel(props)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamMedium
    for k,v in pairs(props) do
        l[k] = v
    end
    return l
end

local function NewButton(props)
    local b = Instance.new("TextButton")
    b.Font = Enum.Font.GothamMedium
    b.AutoButtonColor = false
    for k,v in pairs(props) do
        b[k] = v
    end
    return b
end

-- ══════════════════════════════════════════
--  CRÉATION DE LA FENÊTRE
-- ══════════════════════════════════════════
function VioletUI:CreateWindow(config)
    config = config or {}
    local winTitle   = config.Name       or "VioletUI"
    local toggleKey  = config.ToggleKey  or Enum.KeyCode.RightShift
    local winW       = config.Width      or 820
    local winH       = config.Height     or 560
    local logoId     = config.Logo       or ""

    -- ScreenGui
    local GUI = Instance.new("ScreenGui")
    GUI.Name = "VioletUI_"..math.random(1000,9999)
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
    GUI.ResetOnSpawn = false
    GUI.DisplayOrder = 999
    GUI.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Overlay sombre pour les popups
    local Overlay = NewFrame{
        Name = "Overlay",
        Parent = GUI,
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0.4,
        Size = UDim2.new(1,0,1,0),
        Position = UDim2.new(0,0,0,0),
        Visible = false,
        ZIndex = 50,
    }

    -- Fenêtre principale
    local Main = NewFrame{
        Name = "Main",
        Parent = GUI,
        BackgroundColor3 = C.BG,
        Size = UDim2.new(0, winW, 0, winH),
        Position = UDim2.new(0.5, -winW/2, 0.5, -winH/2),
        Active = true,
        Draggable = true,
        ZIndex = 1,
    }
    MakeCorner(Main, 8)
    MakeBorder(Main, C.BorderBright, 1.5)

    -- Effet de fond subtil (gradient)
    local BgGrad = Instance.new("UIGradient")
    BgGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 16, 32)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 10, 22)),
    }
    BgGrad.Rotation = 135
    BgGrad.Parent = Main

    -- ── HEADER ──────────────────────────────
    local Header = NewFrame{
        Name = "Header",
        Parent = Main,
        BackgroundColor3 = C.BG2,
        Size = UDim2.new(1,0,0,50),
        ZIndex = 2,
    }
    MakeCorner(Header, 8) -- coins arrondis en haut seulement visuellement

    -- Logo / Icône
    local LogoFrame = NewFrame{
        Name = "LogoFrame",
        Parent = Header,
        BackgroundColor3 = C.VioletDark,
        Size = UDim2.new(0,40,0,40),
        Position = UDim2.new(0,8,0.5,-20),
        ZIndex = 3,
    }
    MakeCorner(LogoFrame, 8)
    MakeBorder(LogoFrame, C.VioletGlow, 1)

    -- Icône œil (SVG-like avec des frames)
    local EyeOuter = NewFrame{
        Parent = LogoFrame,
        BackgroundColor3 = C.VioletLight,
        Size = UDim2.new(0,20,0,12),
        Position = UDim2.new(0.5,-10,0.5,-6),
        ZIndex = 4,
    }
    MakeCorner(EyeOuter, 6)
    local EyeInner = NewFrame{
        Parent = LogoFrame,
        BackgroundColor3 = C.BG,
        Size = UDim2.new(0,8,0,8),
        Position = UDim2.new(0.5,-4,0.5,-4),
        ZIndex = 5,
    }
    MakeCorner(EyeInner, 4)
    local EyePupil = NewFrame{
        Parent = LogoFrame,
        BackgroundColor3 = C.VioletLight,
        Size = UDim2.new(0,4,0,4),
        Position = UDim2.new(0.5,-2,0.5,-2),
        ZIndex = 6,
    }
    MakeCorner(EyePupil, 2)

    -- Titre
    local TitleLabel = NewLabel{
        Parent = Header,
        Text = winTitle,
        TextColor3 = C.TextBright,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(0,200,1,0),
        Position = UDim2.new(0,56,0,0),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
    }

    -- Ligne décorative sous le titre
    local TitleLine = NewFrame{
        Parent = Header,
        BackgroundColor3 = C.Violet,
        Size = UDim2.new(0,120,0,1),
        Position = UDim2.new(0,56,1,-8),
        ZIndex = 3,
    }
    local TitleLineGrad = Instance.new("UIGradient")
    TitleLineGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, C.VioletLight),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0)),
    }
    TitleLineGrad.Parent = TitleLine

    -- Boutons de contrôle (style dots)
    local CtrlFrame = NewFrame{
        Name = "Controls",
        Parent = Header,
        BackgroundTransparency = 1,
        Size = UDim2.new(0,80,0,30),
        Position = UDim2.new(1,-90,0.5,-15),
        ZIndex = 3,
    }
    MakeListLayout(CtrlFrame, Enum.FillDirection.Horizontal, 8)
    MakePadding(CtrlFrame, 6, 0, 0, 0)

    local function MakeCtrlBtn(color, symbol, zidx)
        local b = NewButton{
            Parent = CtrlFrame,
            BackgroundColor3 = color,
            Size = UDim2.new(0,16,0,16),
            Text = "",
            ZIndex = zidx or 4,
        }
        MakeCorner(b, 8)
        local lbl = NewLabel{
            Parent = b,
            Text = symbol,
            TextColor3 = Color3.fromRGB(0,0,0),
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            ZIndex = (zidx or 4)+1,
            TextTransparency = 0.5,
        }
        b.MouseEnter:Connect(function() lbl.TextTransparency = 0 end)
        b.MouseLeave:Connect(function() lbl.TextTransparency = 0.5 end)
        return b
    end

    local MinBtn   = MakeCtrlBtn(C.Orange, "−")
    local CloseBtn = MakeCtrlBtn(C.Red, "×")

    -- ── SIDEBAR (liste des tabs) ─────────────
    local Sidebar = NewFrame{
        Name = "Sidebar",
        Parent = Main,
        BackgroundColor3 = C.BG2,
        Size = UDim2.new(0,140,1,-60),
        Position = UDim2.new(0,0,0,50),
        ZIndex = 2,
    }
    local SidebarBorder = Instance.new("UIStroke")
    SidebarBorder.Color = C.Border
    SidebarBorder.Thickness = 1
    SidebarBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SidebarBorder.Parent = Sidebar

    -- Logo bas de sidebar
    local SideLogoFrame = NewFrame{
        Parent = Sidebar,
        BackgroundColor3 = C.VioletDark,
        Size = UDim2.new(0,40,0,40),
        Position = UDim2.new(0.5,-20,1,-50),
        ZIndex = 3,
    }
    MakeCorner(SideLogoFrame, 8)
    MakeBorder(SideLogoFrame, C.Violet, 1)
    local SideLogoText = NewLabel{
        Parent = SideLogoFrame,
        Text = "V",
        TextColor3 = C.VioletLight,
        TextSize = 22,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1,0,1,0),
        ZIndex = 4,
    }

    -- Search bar bas sidebar
    local SearchBox = Instance.new("TextBox")
    SearchBox.Name = "SearchBox"
    SearchBox.Parent = Sidebar
    SearchBox.BackgroundColor3 = C.Element
    SearchBox.Size = UDim2.new(1,-16,0,26)
    SearchBox.Position = UDim2.new(0,8,1,-90)
    SearchBox.PlaceholderText = "🔍  Rechercher..."
    SearchBox.Text = ""
    SearchBox.TextColor3 = C.Text
    SearchBox.PlaceholderColor3 = C.TextDim
    SearchBox.TextSize = 12
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.ClearTextOnFocus = false
    SearchBox.ZIndex = 3
    MakeCorner(SearchBox, 4)
    MakeBorder(SearchBox, C.Border, 1)
    MakePadding(SearchBox, 0, 6, 0, 8)

    -- Liste tabs dans sidebar
    local TabList = NewFrame{
        Name = "TabList",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,1,-100),
        Position = UDim2.new(0,0,0,8),
        ZIndex = 3,
    }
    local TabListLayout = MakeListLayout(TabList, Enum.FillDirection.Vertical, 2)
    MakePadding(TabList, 4, 6, 4, 6)

    -- Scrolling pour tabs
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name = "TabScroll"
    TabScroll.Parent = Sidebar
    TabScroll.BackgroundTransparency = 1
    TabScroll.Size = UDim2.new(1,0,1,-100)
    TabScroll.Position = UDim2.new(0,0,0,8)
    TabScroll.ScrollBarThickness = 2
    TabScroll.ScrollBarImageColor3 = C.Violet
    TabScroll.CanvasSize = UDim2.new(0,0,0,0)
    TabScroll.ZIndex = 3
    TabScroll.BorderSizePixel = 0
    local TabScrollLayout = MakeListLayout(TabScroll, Enum.FillDirection.Vertical, 2)
    MakePadding(TabScroll, 4, 6, 4, 6)

    -- ── ZONE DE CONTENU ──────────────────────
    local ContentArea = NewFrame{
        Name = "ContentArea",
        Parent = Main,
        BackgroundColor3 = C.BG,
        Size = UDim2.new(1,-140,1,-60),
        Position = UDim2.new(0,140,0,50),
        ZIndex = 2,
    }

    -- Sub-tabs (onglets horizontaux en haut du contenu)
    local SubTabBar = NewFrame{
        Name = "SubTabBar",
        Parent = ContentArea,
        BackgroundColor3 = C.BG2,
        Size = UDim2.new(1,0,0,36),
        Position = UDim2.new(0,0,0,0),
        ZIndex = 3,
    }
    local SubTabBarLayout = MakeListLayout(SubTabBar, Enum.FillDirection.Horizontal, 0)
    MakePadding(SubTabBar, 6, 6, 4, 6)

    -- Contenu des sous-tabs
    local SubContent = NewFrame{
        Name = "SubContent",
        Parent = ContentArea,
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,1,-36),
        Position = UDim2.new(0,0,0,36),
        ZIndex = 3,
    }

    -- ══════════════════════════════════════
    --  ÉTAT INTERNE
    -- ══════════════════════════════════════
    local tabs = {}
    local currentMainTab = nil
    local isMinimized = false
    local guiVisible = true

    -- ══════════════════════════════════════
    --  OBJECT WINDOW
    -- ══════════════════════════════════════
    local Window = {}

    -- ── NOTIFICATION ────────────────────────
    local notifQueue = {}
    local notifActive = false

    local NotifHolder = NewFrame{
        Name = "NotifHolder",
        Parent = GUI,
        BackgroundTransparency = 1,
        Size = UDim2.new(0,280,1,0),
        Position = UDim2.new(1,-295,0,0),
        ZIndex = 100,
    }
    MakeListLayout(NotifHolder, Enum.FillDirection.Vertical, 8)
    -- padding top pour laisser de l'espace
    local notifPad = Instance.new("UIPadding")
    notifPad.PaddingTop = UDim.new(0, 20)
    notifPad.PaddingRight = UDim.new(0, 8)
    notifPad.Parent = NotifHolder

    local function ShowNotif(title, message, ntype, duration)
        local typeColors = {
            info    = C.Violet,
            success = C.Green,
            warning = C.Orange,
            error   = C.Red,
        }
        local accent = typeColors[ntype or "info"] or C.Violet

        local NF = NewFrame{
            Parent = NotifHolder,
            BackgroundColor3 = C.Panel,
            Size = UDim2.new(1,0,0,70),
            ZIndex = 101,
            ClipsDescendants = true,
        }
        MakeCorner(NF, 6)
        MakeBorder(NF, accent, 1)

        -- Barre colorée gauche
        local Accent = NewFrame{
            Parent = NF,
            BackgroundColor3 = accent,
            Size = UDim2.new(0,3,1,0),
            ZIndex = 102,
        }
        MakeCorner(Accent, 2)

        local NTitle = NewLabel{
            Parent = NF,
            Text = title,
            TextColor3 = C.TextBright,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            Size = UDim2.new(1,-16,0,22),
            Position = UDim2.new(0,12,0,6),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 102,
        }
        local NMsg = NewLabel{
            Parent = NF,
            Text = message,
            TextColor3 = C.TextDim,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            Size = UDim2.new(1,-16,0,34),
            Position = UDim2.new(0,12,0,28),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            ZIndex = 102,
        }

        -- Barre de progression
        local ProgBG = NewFrame{
            Parent = NF,
            BackgroundColor3 = C.Element,
            Size = UDim2.new(1,0,0,2),
            Position = UDim2.new(0,0,1,-2),
            ZIndex = 103,
        }
        local Prog = NewFrame{
            Parent = ProgBG,
            BackgroundColor3 = accent,
            Size = UDim2.new(1,0,1,0),
            ZIndex = 104,
        }

        -- Animation entrée
        NF.Position = UDim2.new(1,10,0,0)
        Tween(NF, {Position = UDim2.new(0,0,0,0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        -- Animation progress bar
        local dur = duration or 3
        Tween(Prog, {Size = UDim2.new(0,0,1,0)}, dur, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

        task.delay(dur, function()
            Tween(NF, {Position = UDim2.new(1,10,0,0)}, 0.25)
            task.wait(0.3)
            NF:Destroy()
        end)
    end

    function Window:Notify(title, message, ntype, duration)
        ShowNotif(title, message, ntype, duration)
    end

    -- ── TABS PRINCIPAUX ──────────────────────
    function Window:CreateTab(name, icon)
        local tabData = {Name = name, SubTabs = {}, Content = nil}

        -- Bouton dans la sidebar
        local TabBtn = NewButton{
            Name = "Tab_"..name,
            Parent = TabScroll,
            BackgroundColor3 = C.Element,
            BackgroundTransparency = 0.4,
            Size = UDim2.new(1,0,0,32),
            Text = "",
            ZIndex = 4,
        }
        MakeCorner(TabBtn, 5)

        -- Indicateur actif (barre gauche)
        local ActiveBar = NewFrame{
            Parent = TabBtn,
            BackgroundColor3 = C.Violet,
            Size = UDim2.new(0,3,0.7,0),
            Position = UDim2.new(0,0,0.15,0),
            Visible = false,
            ZIndex = 5,
        }
        MakeCorner(ActiveBar, 2)

        -- Icône (optionnelle) + texte
        local TabIcon = NewLabel{
            Parent = TabBtn,
            Text = icon or "",
            TextColor3 = C.TextDim,
            TextSize = 14,
            Size = UDim2.new(0,24,1,0),
            Position = UDim2.new(0,10,0,0),
            ZIndex = 5,
        }
        local TabLabel = NewLabel{
            Parent = TabBtn,
            Text = name,
            TextColor3 = C.TextDim,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            Size = UDim2.new(1,-40,1,0),
            Position = UDim2.new(0, icon and 28 or 12, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 5,
        }

        -- Container contenu pour ce tab
        local TabContentFrame = NewFrame{
            Name = "TabContent_"..name,
            Parent = GUI,  -- attaché au GUI, géré manuellement
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,1,0),
            Visible = false,
            ZIndex = 2,
        }
        -- On le met comme enfant de SubContent
        TabContentFrame.Parent = SubContent

        -- Sub-tab bar container pour ce tab
        local SubTabContainer = NewFrame{
            Name = "SubTabs_"..name,
            Parent = SubTabBar,
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,1,0),
            Visible = false,
            ZIndex = 4,
        }
        local SubTabContainerLayout = MakeListLayout(SubTabContainer, Enum.FillDirection.Horizontal, 0)
        MakePadding(SubTabContainer, 0, 0, 0, 0)

        tabData.Button = TabBtn
        tabData.ActiveBar = ActiveBar
        tabData.TabLabel = TabLabel
        tabData.ContentFrame = TabContentFrame
        tabData.SubTabsContainer = SubTabContainer

        table.insert(tabs, tabData)

        -- Gestion du clic
        local function ActivateTab()
            -- Désactiver tous les tabs
            for _, t in ipairs(tabs) do
                t.Button.BackgroundTransparency = 0.4
                t.Button.BackgroundColor3 = C.Element
                t.ActiveBar.Visible = false
                t.TabLabel.TextColor3 = C.TextDim
                t.ContentFrame.Visible = false
                t.SubTabsContainer.Visible = false
            end
            -- Activer ce tab
            TabBtn.BackgroundTransparency = 0
            TabBtn.BackgroundColor3 = C.VioletDark
            ActiveBar.Visible = true
            TabLabel.TextColor3 = C.TextBright
            TabContentFrame.Visible = true
            SubTabContainer.Visible = true
            currentMainTab = tabData
        end

        TabBtn.MouseButton1Click:Connect(ActivateTab)

        -- Hover
        TabBtn.MouseEnter:Connect(function()
            if currentMainTab ~= tabData then
                Tween(TabBtn, {BackgroundColor3 = C.ElementHov, BackgroundTransparency = 0.2}, 0.12)
                Tween(TabLabel, {TextColor3 = C.Text}, 0.12)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if currentMainTab ~= tabData then
                Tween(TabBtn, {BackgroundColor3 = C.Element, BackgroundTransparency = 0.4}, 0.12)
                Tween(TabLabel, {TextColor3 = C.TextDim}, 0.12)
            end
        end)

        -- Activer le premier tab automatiquement
        if #tabs == 1 then
            task.defer(ActivateTab)
        end

        -- ── SOUS-TABS ──────────────────────────
        local Tab = {}

        function Tab:CreateSubTab(subname)
            local subData = {Name = subname}

            local SubBtn = NewButton{
                Name = "SubTab_"..subname,
                Parent = SubTabContainer,
                BackgroundColor3 = C.BG2,
                BackgroundTransparency = 1,
                Size = UDim2.new(0,0,1,0),  -- auto
                AutomaticSize = Enum.AutomaticSize.X,
                Text = "",
                ZIndex = 5,
            }
            MakePadding(SubBtn, 0, 14, 0, 14)

            local SubBtnLabel = NewLabel{
                Parent = SubBtn,
                Text = subname,
                TextColor3 = C.TextDim,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                Size = UDim2.new(1,0,1,0),
                ZIndex = 6,
            }
            -- Soulignement actif
            local SubLine = NewFrame{
                Parent = SubBtn,
                BackgroundColor3 = C.Violet,
                Size = UDim2.new(1,-8,0,2),
                Position = UDim2.new(0,4,1,-2),
                Visible = false,
                ZIndex = 7,
            }
            MakeCorner(SubLine, 1)

            -- Contenu scrollable pour ce sous-tab
            local SubScrollFrame = Instance.new("ScrollingFrame")
            SubScrollFrame.Name = "SubScroll_"..subname
            SubScrollFrame.Parent = TabContentFrame
            SubScrollFrame.BackgroundTransparency = 1
            SubScrollFrame.Size = UDim2.new(1,0,1,0)
            SubScrollFrame.CanvasSize = UDim2.new(0,0,0,0)
            SubScrollFrame.ScrollBarThickness = 3
            SubScrollFrame.ScrollBarImageColor3 = C.Violet
            SubScrollFrame.BorderSizePixel = 0
            SubScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
            SubScrollFrame.Visible = false
            SubScrollFrame.ZIndex = 4

            -- Layout pour les colonnes
            local ColFrame = NewFrame{
                Name = "ColFrame",
                Parent = SubScrollFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1,0,1,0),
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 5,
            }
            local ColLayout = Instance.new("UIListLayout")
            ColLayout.FillDirection = Enum.FillDirection.Horizontal
            ColLayout.Padding = UDim.new(0, 8)
            ColLayout.VerticalAlignment = Enum.VerticalAlignment.Top
            ColLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ColLayout.Parent = ColFrame
            MakePadding(ColFrame, 10, 10, 10, 10)

            subData.Button = SubBtn
            subData.Label = SubBtnLabel
            subData.Line = SubLine
            subData.ScrollFrame = SubScrollFrame
            subData.ColFrame = ColFrame

            table.insert(tabData.SubTabs, subData)

            local function ActivateSubTab()
                for _, s in ipairs(tabData.SubTabs) do
                    s.Button.BackgroundTransparency = 1
                    s.Label.TextColor3 = C.TextDim
                    s.Line.Visible = false
                    s.ScrollFrame.Visible = false
                end
                SubBtn.BackgroundTransparency = 0.7
                SubBtnLabel.TextColor3 = C.TextBright
                SubLine.Visible = true
                SubScrollFrame.Visible = true
            end

            SubBtn.MouseButton1Click:Connect(ActivateSubTab)

            SubBtn.MouseEnter:Connect(function()
                if not SubLine.Visible then
                    Tween(SubBtnLabel, {TextColor3 = C.Text}, 0.1)
                end
            end)
            SubBtn.MouseLeave:Connect(function()
                if not SubLine.Visible then
                    Tween(SubBtnLabel, {TextColor3 = C.TextDim}, 0.1)
                end
            end)

            -- Activer premier sous-tab
            if #tabData.SubTabs == 1 then
                task.defer(ActivateSubTab)
            end

            -- ── SECTIONS (colonnes) ────────────────
            local SubTabObj = {}

            function SubTabObj:CreateSection(secname)
                local SectionCol = NewFrame{
                    Name = "Section_"..secname,
                    Parent = ColFrame,
                    BackgroundColor3 = C.Panel,
                    Size = UDim2.new(0,280,0,0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    ZIndex = 6,
                }
                MakeCorner(SectionCol, 6)
                MakeBorder(SectionCol, C.Border, 1)

                local SecHeader = NewFrame{
                    Parent = SectionCol,
                    BackgroundColor3 = C.BG2,
                    Size = UDim2.new(1,0,0,28),
                    ZIndex = 7,
                }
                MakeCorner(SecHeader, 6)
                MakeBorder(SecHeader, C.Border, 1)

                local SecTitle = NewLabel{
                    Parent = SecHeader,
                    Text = secname,
                    TextColor3 = C.VioletLight,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    Size = UDim2.new(1,-12,1,0),
                    Position = UDim2.new(0,10,0,0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 8,
                }

                -- Ligne accent sous le titre
                local SecLine = NewFrame{
                    Parent = SecHeader,
                    BackgroundColor3 = C.Violet,
                    Size = UDim2.new(0.4,0,0,1),
                    Position = UDim2.new(0,0,1,-1),
                    ZIndex = 8,
                }
                local SecLineGrad = Instance.new("UIGradient")
                SecLineGrad.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, C.VioletLight),
                    ColorSequenceKeypoint.new(1, Color3.new(0,0,0)),
                }
                SecLineGrad.Parent = SecLine

                local ItemList = NewFrame{
                    Name = "Items",
                    Parent = SectionCol,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1,0,0,0),
                    Position = UDim2.new(0,0,0,28),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    ZIndex = 7,
                }
                MakeListLayout(ItemList, Enum.FillDirection.Vertical, 2)
                MakePadding(ItemList, 6, 8, 8, 8)

                local Section = {}

                -- ╔══════════════════════════════╗
                -- ║  ÉLÉMENTS UI                 ║
                -- ╚══════════════════════════════╝

                -- ── TOGGLE (Checkbox amélioré) ──
                function Section:AddToggle(label, default, hint, callback)
                    local val = default or false

                    local Row = NewFrame{
                        Parent = ItemList,
                        BackgroundColor3 = C.Element,
                        BackgroundTransparency = 0.5,
                        Size = UDim2.new(1,0,0,30),
                        ZIndex = 8,
                    }
                    MakeCorner(Row, 4)

                    local Lbl = NewLabel{
                        Parent = Row,
                        Text = label,
                        TextColor3 = C.Text,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        Size = UDim2.new(1,-60,1,0),
                        Position = UDim2.new(0,10,0,0),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 9,
                    }

                    -- Hint "?"
                    if hint then
                        local HintBtn = NewButton{
                            Parent = Row,
                            BackgroundColor3 = C.VioletDark,
                            Size = UDim2.new(0,16,0,16),
                            Position = UDim2.new(0, string.len(label)*7+14, 0.5, -8),
                            Text = "?",
                            TextColor3 = C.VioletLight,
                            TextSize = 10,
                            Font = Enum.Font.GothamBold,
                            ZIndex = 9,
                        }
                        MakeCorner(HintBtn, 8)
                    end

                    -- Toggle switch
                    local ToggleBG = NewFrame{
                        Parent = Row,
                        BackgroundColor3 = val and C.Violet or C.Slider,
                        Size = UDim2.new(0,32,0,16),
                        Position = UDim2.new(1,-42,0.5,-8),
                        ZIndex = 9,
                    }
                    MakeCorner(ToggleBG, 8)
                    MakeBorder(ToggleBG, val and C.VioletLight or C.Border, 1)

                    local ToggleKnob = NewFrame{
                        Parent = ToggleBG,
                        BackgroundColor3 = C.TextBright,
                        Size = UDim2.new(0,12,0,12),
                        Position = UDim2.new(0, val and 18 or 2, 0.5, -6),
                        ZIndex = 10,
                    }
                    MakeCorner(ToggleKnob, 6)

                    local ToggleBtn = NewButton{
                        Parent = Row,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1,0,1,0),
                        Text = "",
                        ZIndex = 10,
                    }

                    local obj = {Value = val}

                    local function SetToggle(newVal, silent)
                        val = newVal
                        obj.Value = val
                        if val then
                            Tween(ToggleBG, {BackgroundColor3 = C.Violet}, 0.15)
                            Tween(ToggleKnob, {Position = UDim2.new(0,18,0.5,-6)}, 0.15, Enum.EasingStyle.Back)
                        else
                            Tween(ToggleBG, {BackgroundColor3 = C.Slider}, 0.15)
                            Tween(ToggleKnob, {Position = UDim2.new(0,2,0.5,-6)}, 0.15, Enum.EasingStyle.Back)
                        end
                        if not silent and callback then callback(val) end
                    end

                    ToggleBtn.MouseButton1Click:Connect(function()
                        SetToggle(not val)
                    end)

                    Row.MouseEnter:Connect(function()
                        Tween(Row, {BackgroundTransparency = 0.2}, 0.1)
                    end)
                    Row.MouseLeave:Connect(function()
                        Tween(Row, {BackgroundTransparency = 0.5}, 0.1)
                    end)

                    function obj:Set(v) SetToggle(v, true) end
                    return obj
                end

                -- ── SLIDER ──────────────────────
                function Section:AddSlider(label, min, max, default, suffix, callback)
                    local val = default or min
                    suffix = suffix or ""

                    local Container = NewFrame{
                        Parent = ItemList,
                        BackgroundColor3 = C.Element,
                        BackgroundTransparency = 0.5,
                        Size = UDim2.new(1,0,0,46),
                        ZIndex = 8,
                    }
                    MakeCorner(Container, 4)

                    local TopRow = NewFrame{
                        Parent = Container,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1,0,0,20),
                        ZIndex = 9,
                    }

                    local SliderLbl = NewLabel{
                        Parent = TopRow,
                        Text = label,
                        TextColor3 = C.Text,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        Size = UDim2.new(0.6,0,1,0),
                        Position = UDim2.new(0,10,0,0),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 9,
                    }

                    local ValLbl = NewLabel{
                        Parent = TopRow,
                        Text = tostring(val)..suffix,
                        TextColor3 = C.VioletLight,
                        TextSize = 12,
                        Font = Enum.Font.GothamMedium,
                        Size = UDim2.new(0.4,-10,1,0),
                        Position = UDim2.new(0.6,0,0,0),
                        TextXAlignment = Enum.TextXAlignment.Right,
                        ZIndex = 9,
                    }

                    local Track = NewFrame{
                        Parent = Container,
                        BackgroundColor3 = C.Slider,
                        Size = UDim2.new(1,-20,0,4),
                        Position = UDim2.new(0,10,0,30),
                        ZIndex = 9,
                    }
                    MakeCorner(Track, 2)
                    MakeBorder(Track, C.Border, 1)

                    local pct = (val - min) / (max - min)
                    local Fill = NewFrame{
                        Parent = Track,
                        BackgroundColor3 = C.Violet,
                        Size = UDim2.new(pct,0,1,0),
                        ZIndex = 10,
                    }
                    MakeCorner(Fill, 2)
                    local FillGrad = Instance.new("UIGradient")
                    FillGrad.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, C.VioletDark),
                        ColorSequenceKeypoint.new(1, C.VioletLight),
                    }
                    FillGrad.Parent = Fill

                    -- Knob du slider
                    local Knob = NewFrame{
                        Parent = Track,
                        BackgroundColor3 = C.TextBright,
                        Size = UDim2.new(0,10,0,10),
                        Position = UDim2.new(pct,-5,0.5,-5),
                        ZIndex = 11,
                    }
                    MakeCorner(Knob, 5)
                    MakeBorder(Knob, C.Violet, 1)

                    local TrackBtn = NewButton{
                        Parent = Container,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1,0,0,24),
                        Position = UDim2.new(0,0,0,20),
                        Text = "",
                        ZIndex = 12,
                    }

                    local dragging = false
                    local obj = {Value = val}

                    local function UpdateSlider(mx)
                        local tp = Track.AbsolutePosition
                        local ts = Track.AbsoluteSize
                        local rel = math.clamp((mx - tp.X) / ts.X, 0, 1)
                        local newVal = min + (max - min) * rel
                        -- Arrondi
                        newVal = math.floor(newVal * 100 + 0.5) / 100
                        val = newVal
                        obj.Value = val
                        Fill.Size = UDim2.new(rel, 0, 1, 0)
                        Knob.Position = UDim2.new(rel, -5, 0.5, -5)
                        ValLbl.Text = tostring(math.floor(val * 10 + 0.5) / 10)..suffix
                        if callback then callback(val) end
                    end

                    TrackBtn.MouseButton1Down:Connect(function()
                        dragging = true
                        local mx = UserInputService:GetMouseLocation().X
                        UpdateSlider(mx)
                    end)
                    UserInputService.InputEnded:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                        end
                    end)
                    UserInputService.InputChanged:Connect(function(i)
                        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                            UpdateSlider(UserInputService:GetMouseLocation().X)
                        end
                    end)

                    Container.MouseEnter:Connect(function()
                        Tween(Container, {BackgroundTransparency = 0.2}, 0.1)
                    end)
                    Container.MouseLeave:Connect(function()
                        Tween(Container, {BackgroundTransparency = 0.5}, 0.1)
                    end)

                    function obj:Set(v)
                        val = math.clamp(v, min, max)
                        obj.Value = val
                        local rel = (val-min)/(max-min)
                        Fill.Size = UDim2.new(rel,0,1,0)
                        Knob.Position = UDim2.new(rel,-5,0.5,-5)
                        ValLbl.Text = tostring(val)..suffix
                    end
                    return obj
                end

                -- ── DROPDOWN ────────────────────
                function Section:AddDropdown(label, options, default, callback)
                    local selected = default or (options[1] or "")
                    local isOpen = false

                    local Container = NewFrame{
                        Parent = ItemList,
                        BackgroundColor3 = C.Element,
                        BackgroundTransparency = 0.5,
                        Size = UDim2.new(1,0,0,30),
                        ZIndex = 8,
                        ClipsDescendants = false,
                    }
                    MakeCorner(Container, 4)

                    local Lbl = NewLabel{
                        Parent = Container,
                        Text = label,
                        TextColor3 = C.TextDim,
                        TextSize = 11,
                        Font = Enum.Font.Gotham,
                        Size = UDim2.new(0.45,0,1,0),
                        Position = UDim2.new(0,8,0,0),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 9,
                    }

                    local DropBtn = NewButton{
                        Parent = Container,
                        BackgroundColor3 = C.BG2,
                        Size = UDim2.new(0.5,-4,0,22),
                        Position = UDim2.new(0.5,0,0.5,-11),
                        Text = "",
                        ZIndex = 9,
                    }
                    MakeCorner(DropBtn, 4)
                    MakeBorder(DropBtn, C.Border, 1)

                    local DropVal = NewLabel{
                        Parent = DropBtn,
                        Text = selected,
                        TextColor3 = C.Text,
                        TextSize = 11,
                        Font = Enum.Font.GothamMedium,
                        Size = UDim2.new(1,-22,1,0),
                        Position = UDim2.new(0,6,0,0),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 10,
                    }
                    local Arrow = NewLabel{
                        Parent = DropBtn,
                        Text = "▾",
                        TextColor3 = C.VioletLight,
                        TextSize = 12,
                        Size = UDim2.new(0,18,1,0),
                        Position = UDim2.new(1,-18,0,0),
                        ZIndex = 10,
                    }

                    -- Liste déroulante
                    local DropList = NewFrame{
                        Name = "DropList",
                        Parent = Container,
                        BackgroundColor3 = C.Panel,
                        Size = UDim2.new(0.5,-4,0,0),
                        Position = UDim2.new(0.5,0,1,2),
                        ZIndex = 30,
                        Visible = false,
                        ClipsDescendants = true,
                    }
                    MakeCorner(DropList, 4)
                    MakeBorder(DropList, C.BorderBright, 1)
                    MakeListLayout(DropList, Enum.FillDirection.Vertical, 0)

                    for _, opt in ipairs(options) do
                        local OptBtn = NewButton{
                            Parent = DropList,
                            BackgroundColor3 = C.Element,
                            BackgroundTransparency = 0.5,
                            Size = UDim2.new(1,0,0,24),
                            Text = opt,
                            TextColor3 = opt == selected and C.VioletLight or C.Text,
                            TextSize = 11,
                            Font = Enum.Font.Gotham,
                            ZIndex = 31,
                        }
                        OptBtn.MouseEnter:Connect(function()
                            Tween(OptBtn, {BackgroundColor3 = C.VioletDark, BackgroundTransparency = 0}, 0.1)
                            Tween(OptBtn, {TextColor3 = C.TextBright}, 0.1)
                        end)
                        OptBtn.MouseLeave:Connect(function()
                            Tween(OptBtn, {BackgroundColor3 = C.Element, BackgroundTransparency = 0.5}, 0.1)
                            Tween(OptBtn, {TextColor3 = opt == selected and C.VioletLight or C.Text}, 0.1)
                        end)
                        OptBtn.MouseButton1Click:Connect(function()
                            selected = opt
                            DropVal.Text = opt
                            isOpen = false
                            DropList.Visible = false
                            Tween(Arrow, {Rotation = 0}, 0.15)
                            if callback then callback(opt) end
                        end)
                    end

                    -- Hauteur auto de la liste
                    DropList.Size = UDim2.new(0.5,-4, 0, #options * 24)

                    DropBtn.MouseButton1Click:Connect(function()
                        isOpen = not isOpen
                        DropList.Visible = isOpen
                        Tween(Arrow, {Rotation = isOpen and 180 or 0}, 0.15)
                    end)

                    Container.MouseEnter:Connect(function()
                        Tween(Container, {BackgroundTransparency = 0.2}, 0.1)
                    end)
                    Container.MouseLeave:Connect(function()
                        Tween(Container, {BackgroundTransparency = 0.5}, 0.1)
                    end)

                    local obj = {Value = selected}
                    function obj:Set(v)
                        selected = v
                        DropVal.Text = v
                        obj.Value = v
                    end
                    return obj
                end

                -- ── BUTTON ──────────────────────
                function Section:AddButton(label, hint, callback)
                    if type(hint) == "function" then
                        callback = hint
                        hint = nil
                    end

                    local Btn = NewButton{
                        Parent = ItemList,
                        BackgroundColor3 = C.VioletDark,
                        Size = UDim2.new(1,0,0,28),
                        Text = "",
                        ZIndex = 8,
                    }
                    MakeCorner(Btn, 4)
                    MakeBorder(Btn, C.Violet, 1)

                    local BtnGrad = Instance.new("UIGradient")
                    BtnGrad.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 50, 180)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 30, 120)),
                    }
                    BtnGrad.Rotation = 90
                    BtnGrad.Parent = Btn

                    local BtnLbl = NewLabel{
                        Parent = Btn,
                        Text = label,
                        TextColor3 = C.TextBright,
                        TextSize = 12,
                        Font = Enum.Font.GothamMedium,
                        Size = UDim2.new(1,0,1,0),
                        ZIndex = 9,
                    }

                    Btn.MouseEnter:Connect(function()
                        Tween(Btn, {BackgroundColor3 = C.Violet}, 0.12)
                        Tween(BtnLbl, {TextColor3 = Color3.fromRGB(255,255,255)}, 0.12)
                    end)
                    Btn.MouseLeave:Connect(function()
                        Tween(Btn, {BackgroundColor3 = C.VioletDark}, 0.12)
                    end)
                    Btn.MouseButton1Down:Connect(function()
                        Tween(Btn, {BackgroundColor3 = C.VioletGlow}, 0.08)
                    end)
                    Btn.MouseButton1Up:Connect(function()
                        Tween(Btn, {BackgroundColor3 = C.VioletDark}, 0.1)
                    end)
                    Btn.MouseButton1Click:Connect(function()
                        if callback then callback() end
                    end)

                    return Btn
                end

                -- ── INPUT (TextBox) ──────────────
                function Section:AddInput(label, placeholder, callback)
                    local Container = NewFrame{
                        Parent = ItemList,
                        BackgroundColor3 = C.Element,
                        BackgroundTransparency = 0.5,
                        Size = UDim2.new(1,0,0,30),
                        ZIndex = 8,
                    }
                    MakeCorner(Container, 4)

                    local Lbl = NewLabel{
                        Parent = Container,
                        Text = label,
                        TextColor3 = C.TextDim,
                        TextSize = 11,
                        Size = UDim2.new(0.4,0,1,0),
                        Position = UDim2.new(0,8,0,0),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 9,
                    }

                    local Box = Instance.new("TextBox")
                    Box.Parent = Container
                    Box.BackgroundColor3 = C.BG2
                    Box.Size = UDim2.new(0.55,0,0,22)
                    Box.Position = UDim2.new(0.43,0,0.5,-11)
                    Box.PlaceholderText = placeholder or ""
                    Box.Text = ""
                    Box.TextColor3 = C.Text
                    Box.PlaceholderColor3 = C.TextDim
                    Box.TextSize = 11
                    Box.Font = Enum.Font.Gotham
                    Box.ClearTextOnFocus = false
                    Box.ZIndex = 9
                    MakeCorner(Box, 4)
                    MakeBorder(Box, C.Border, 1)
                    MakePadding(Box, 0, 6, 0, 6)

                    Box.Focused:Connect(function()
                        Tween(Box, {BackgroundColor3 = C.Element}, 0.1)
                        -- changer bordure
                    end)
                    Box.FocusLost:Connect(function(enter)
                        Tween(Box, {BackgroundColor3 = C.BG2}, 0.1)
                        if callback then callback(Box.Text, enter) end
                    end)

                    return Box
                end

                -- ── KEYBIND ─────────────────────
                function Section:AddKeybind(label, defaultKey, callback)
                    local currentKey = defaultKey or Enum.KeyCode.Unknown
                    local listening = false

                    local Container = NewFrame{
                        Parent = ItemList,
                        BackgroundColor3 = C.Element,
                        BackgroundTransparency = 0.5,
                        Size = UDim2.new(1,0,0,30),
                        ZIndex = 8,
                    }
                    MakeCorner(Container, 4)

                    local Lbl = NewLabel{
                        Parent = Container,
                        Text = label,
                        TextColor3 = C.Text,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        Size = UDim2.new(0.6,0,1,0),
                        Position = UDim2.new(0,8,0,0),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 9,
                    }

                    local KeyBtn = NewButton{
                        Parent = Container,
                        BackgroundColor3 = C.BG2,
                        Size = UDim2.new(0.35,0,0,22),
                        Position = UDim2.new(0.63,0,0.5,-11),
                        Text = tostring(currentKey):gsub("Enum.KeyCode.",""),
                        TextColor3 = C.VioletLight,
                        TextSize = 11,
                        Font = Enum.Font.GothamMedium,
                        ZIndex = 9,
                    }
                    MakeCorner(KeyBtn, 4)
                    MakeBorder(KeyBtn, C.Border, 1)

                    KeyBtn.MouseButton1Click:Connect(function()
                        listening = true
                        KeyBtn.Text = "..."
                        Tween(KeyBtn, {BackgroundColor3 = C.VioletDark}, 0.1)

                        local conn
                        conn = UserInputService.InputBegan:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.Keyboard then
                                listening = false
                                currentKey = inp.KeyCode
                                local kname = tostring(currentKey):gsub("Enum.KeyCode.","")
                                KeyBtn.Text = kname
                                Tween(KeyBtn, {BackgroundColor3 = C.BG2}, 0.1)
                                if callback then callback(currentKey) end
                                conn:Disconnect()
                            end
                        end)
                    end)

                    Container.MouseEnter:Connect(function()
                        Tween(Container, {BackgroundTransparency = 0.2}, 0.1)
                    end)
                    Container.MouseLeave:Connect(function()
                        Tween(Container, {BackgroundTransparency = 0.5}, 0.1)
                    end)

                    local obj = {Value = currentKey}
                    function obj:Set(k)
                        currentKey = k
                        obj.Value = k
                        KeyBtn.Text = tostring(k):gsub("Enum.KeyCode.","")
                    end
                    return obj
                end

                -- ── COLOR PICKER (simple) ────────
                function Section:AddColorPicker(label, default, callback)
                    local col = default or Color3.fromRGB(120,60,220)

                    local Container = NewFrame{
                        Parent = ItemList,
                        BackgroundColor3 = C.Element,
                        BackgroundTransparency = 0.5,
                        Size = UDim2.new(1,0,0,30),
                        ZIndex = 8,
                    }
                    MakeCorner(Container, 4)

                    local Lbl = NewLabel{
                        Parent = Container,
                        Text = label,
                        TextColor3 = C.Text,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        Size = UDim2.new(0.6,0,1,0),
                        Position = UDim2.new(0,8,0,0),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 9,
                    }

                    local ColorPreview = NewButton{
                        Parent = Container,
                        BackgroundColor3 = col,
                        Size = UDim2.new(0,40,0,20),
                        Position = UDim2.new(1,-50,0.5,-10),
                        Text = "",
                        ZIndex = 9,
                    }
                    MakeCorner(ColorPreview, 4)
                    MakeBorder(ColorPreview, C.Border, 1)

                    -- Palette simplifiée
                    local palette = {
                        Color3.fromRGB(120,60,220),
                        Color3.fromRGB(60,120,220),
                        Color3.fromRGB(220,60,120),
                        Color3.fromRGB(60,220,120),
                        Color3.fromRGB(220,160,60),
                        Color3.fromRGB(220,60,60),
                        Color3.fromRGB(200,200,200),
                        Color3.fromRGB(60,60,60),
                    }

                    local PaletteFrame = NewFrame{
                        Parent = Container,
                        BackgroundColor3 = C.Panel,
                        Size = UDim2.new(0,180,0,60),
                        Position = UDim2.new(0.3,0,1,4),
                        ZIndex = 20,
                        Visible = false,
                    }
                    MakeCorner(PaletteFrame, 4)
                    MakeBorder(PaletteFrame, C.BorderBright, 1)
                    local PalLayout = Instance.new("UIGridLayout")
                    PalLayout.CellSize = UDim2.new(0,18,0,18)
                    PalLayout.CellPadding = UDim2.new(0,4,0,4)
                    PalLayout.Parent = PaletteFrame
                    MakePadding(PaletteFrame, 6, 6, 6, 6)

                    for _, pc in ipairs(palette) do
                        local PBtn = NewButton{
                            Parent = PaletteFrame,
                            BackgroundColor3 = pc,
                            Size = UDim2.new(0,18,0,18),
                            Text = "",
                            ZIndex = 21,
                        }
                        MakeCorner(PBtn, 3)
                        PBtn.MouseButton1Click:Connect(function()
                            col = pc
                            ColorPreview.BackgroundColor3 = pc
                            PaletteFrame.Visible = false
                            if callback then callback(pc) end
                        end)
                    end

                    local paletteOpen = false
                    ColorPreview.MouseButton1Click:Connect(function()
                        paletteOpen = not paletteOpen
                        PaletteFrame.Visible = paletteOpen
                    end)

                    local obj = {Value = col}
                    function obj:Set(c)
                        col = c
                        obj.Value = c
                        ColorPreview.BackgroundColor3 = c
                    end
                    return obj
                end

                -- ── LABEL (texte info) ───────────
                function Section:AddLabel(text, color)
                    local Lbl = NewLabel{
                        Parent = ItemList,
                        Text = text,
                        TextColor3 = color or C.TextDim,
                        TextSize = 11,
                        Font = Enum.Font.Gotham,
                        Size = UDim2.new(1,0,0,20),
                        Position = UDim2.new(0,8,0,0),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        ZIndex = 8,
                        TextWrapped = true,
                    }
                    return Lbl
                end

                -- ── SEPARATOR ───────────────────
                function Section:AddSeparator()
                    local Sep = NewFrame{
                        Parent = ItemList,
                        BackgroundColor3 = C.Border,
                        Size = UDim2.new(1,0,0,1),
                        ZIndex = 8,
                    }
                    local SepGrad = Instance.new("UIGradient")
                    SepGrad.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.new(0,0,0)),
                        ColorSequenceKeypoint.new(0.3, C.Violet),
                        ColorSequenceKeypoint.new(0.7, C.Violet),
                        ColorSequenceKeypoint.new(1, Color3.new(0,0,0)),
                    }
                    SepGrad.Parent = Sep
                    return Sep
                end

                return Section
            end -- CreateSection

            return SubTabObj
        end -- CreateSubTab

        return Tab
    end -- CreateTab

    -- ══════════════════════════════════════
    --  CONTRÔLES FENÊTRE
    -- ══════════════════════════════════════
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetH = isMinimized and 50 or winH
        Tween(Main, {Size = UDim2.new(0, winW, 0, targetH)}, 0.3, Enum.EasingStyle.Quart)
        if isMinimized then
            ShowNotif("VioletUI", "Interface réduite (appui "..tostring(toggleKey):gsub("Enum.KeyCode.","").." pour afficher)", "info", 2)
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, {BackgroundTransparency = 1}, 0.2)
        task.wait(0.2)
        GUI:Destroy()
    end)

    -- Toggle key
    UserInputService.InputBegan:Connect(function(inp, processed)
        if not processed and inp.KeyCode == toggleKey then
            guiVisible = not guiVisible
            Main.Visible = guiVisible
        end
    end)

    -- Scroll canvas size auto
    TabScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabScroll.CanvasSize = UDim2.new(0,0,0,TabScrollLayout.AbsoluteContentSize.Y + 8)
    end)

    return Window
end

-- ══════════════════════════════════════════
--  CRÉATION AUTO DU TAB PARAMÈTRES COMPLET
-- ══════════════════════════════════════════
function VioletUI:AddSettingsTab(window, options)
    options = options or {}
    local SettingsTab = window:CreateTab("Paramètres", "⚙")
    local ParamSub    = SettingsTab:CreateSubTab("Général")
    local VisuSub     = SettingsTab:CreateSubTab("Apparence")
    local KeysSub     = SettingsTab:CreateSubTab("Touches")
    local ConfigSub   = SettingsTab:CreateSubTab("Configs")

    -- ── GÉNÉRAL ──────────────────────────
    local GeneralSec = ParamSub:CreateSection("Général")
    GeneralSec:AddLabel("Paramètres généraux de l'interface", C.TextDim)
    GeneralSec:AddSeparator()

    local notifToggle = GeneralSec:AddToggle("Notifications", true, "Activer/désactiver les notifications", function(v)
        window:Notify("Paramètres", "Notifications: "..(v and "ON" or "OFF"), v and "success" or "info", 2)
    end)

    local soundToggle = GeneralSec:AddToggle("Sons UI", false, "Sons lors des clics", function(v)
        window:Notify("Paramètres", "Sons UI: "..(v and "ON" or "OFF"), "info", 2)
    end)

    local animToggle = GeneralSec:AddToggle("Animations", true, "Activer les animations", function(v)
        window:Notify("Paramètres", "Animations: "..(v and "ON" or "OFF"), "info", 2)
    end)

    GeneralSec:AddSeparator()
    GeneralSec:AddLabel("Langue", C.VioletLight)
    local langDrop = GeneralSec:AddDropdown("Langue", {"Français", "English", "Español", "Deutsch", "Русский"}, "Français", function(v)
        window:Notify("Paramètres", "Langue changée: "..v, "info", 2)
    end)

    local opacitySlider = GeneralSec:AddSlider("Opacité UI", 50, 100, 100, "%", function(v)
        window:Notify("Paramètres", "Opacité: "..math.floor(v).."%", "info", 1)
    end)

    -- ── APPARENCE ────────────────────────
    local ThemeSec = VisuSub:CreateSection("Thème")
    ThemeSec:AddLabel("Personnalisation visuelle", C.TextDim)
    ThemeSec:AddSeparator()

    local accentColor = ThemeSec:AddColorPicker("Couleur accent", Color3.fromRGB(120,60,220), function(c)
        window:Notify("Apparence", "Couleur accent changée", "success", 2)
    end)

    local bgColor = ThemeSec:AddColorPicker("Couleur fond", Color3.fromRGB(18,14,22), function(c)
        window:Notify("Apparence", "Couleur fond changée", "info", 2)
    end)

    ThemeSec:AddSeparator()
    local themeDrop = ThemeSec:AddDropdown("Thème prédéfini", {
        "Violet (défaut)", "Bleu Nuit", "Rouge Sang", "Vert Néon", "Or Royal", "Monochrome"
    }, "Violet (défaut)", function(v)
        window:Notify("Apparence", "Thème: "..v, "info", 2)
    end)

    ThemeSec:AddSeparator()
    local uiScaleSlider = ThemeSec:AddSlider("Taille UI", 70, 130, 100, "%", function(v)
        window:Notify("Apparence", "Taille: "..math.floor(v).."%", "info", 1)
    end)
    local fontDrop = ThemeSec:AddDropdown("Police", {"Gotham", "Arial", "Code", "Cartoon"}, "Gotham", function(v)
        window:Notify("Apparence", "Police: "..v, "info", 2)
    end)

    local FontSec = VisuSub:CreateSection("Éléments")
    FontSec:AddLabel("Visibilité des éléments", C.TextDim)
    FontSec:AddSeparator()
    FontSec:AddToggle("Afficher bordures", true, nil, function(v) end)
    FontSec:AddToggle("Ombre portée", true, nil, function(v) end)
    FontSec:AddToggle("Coins arrondis", true, nil, function(v) end)
    FontSec:AddToggle("Effet glow violet", true, nil, function(v) end)
    FontSec:AddSlider("Transparence fond", 0, 60, 0, "%", function(v) end)
    FontSec:AddSlider("Épaisseur bordure", 1, 4, 1, "px", function(v) end)

    -- ── TOUCHES ─────────────────────────
    local KeysSec = KeysSub:CreateSection("Raccourcis")
    KeysSec:AddLabel("Configurez vos touches", C.TextDim)
    KeysSec:AddSeparator()

    KeysSec:AddKeybind("Toggle UI", Enum.KeyCode.RightShift, function(k)
        window:Notify("Touche", "Toggle UI → "..tostring(k):gsub("Enum.KeyCode.",""), "info", 2)
    end)
    KeysSec:AddKeybind("Panic Key (fermer)", Enum.KeyCode.Delete, function(k)
        window:Notify("Touche", "Panic Key → "..tostring(k):gsub("Enum.KeyCode.",""), "warning", 2)
    end)
    KeysSec:AddKeybind("Screenshot", Enum.KeyCode.F12, function(k)
        window:Notify("Touche", "Screenshot → "..tostring(k):gsub("Enum.KeyCode.",""), "info", 2)
    end)
    KeysSec:AddKeybind("Ouvrir Configs", Enum.KeyCode.F5, function(k)
        window:Notify("Touche", "Ouvrir Configs → "..tostring(k):gsub("Enum.KeyCode.",""), "info", 2)
    end)

    local KeysSec2 = KeysSub:CreateSection("Options touches")
    KeysSec2:AddLabel("Options avancées des touches", C.TextDim)
    KeysSec2:AddSeparator()
    KeysSec2:AddToggle("Bloquer input jeu", false, "Empêche les touches de passer au jeu", function(v)
        window:Notify("Touches", "Blocage input: "..(v and "ON" or "OFF"), "warning", 2)
    end)
    KeysSec2:AddToggle("Touches globales", true, nil, function(v) end)
    KeysSec2:AddDropdown("Mode touche", {"Appui", "Toggle", "Maintien"}, "Appui", function(v) end)

    -- ── CONFIGS ─────────────────────────
    local ConfigSec = ConfigSub:CreateSection("Gestion")
    ConfigSec:AddLabel("Sauvegardez et chargez vos configs", C.TextDim)
    ConfigSec:AddSeparator()

    ConfigSec:AddInput("Nom config", "MaConfig", function(text, enter)
        if enter and text ~= "" then
            window:Notify("Config", "Nom: "..text, "info", 2)
        end
    end)

    ConfigSec:AddButton("💾  Sauvegarder", function()
        window:Notify("Config", "Configuration sauvegardée !", "success", 2.5)
    end)
    ConfigSec:AddButton("📂  Charger", function()
        window:Notify("Config", "Configuration chargée !", "success", 2)
    end)
    ConfigSec:AddButton("🗑️  Supprimer", function()
        window:Notify("Config", "Configuration supprimée", "warning", 2)
    end)
    ConfigSec:AddButton("🔄  Rafraîchir liste", function()
        window:Notify("Config", "Liste rafraîchie", "info", 1.5)
    end)
    ConfigSec:AddSeparator()

    local ConfigSec2 = ConfigSub:CreateSection("Configs cloud")
    ConfigSec2:AddLabel("Partage de configurations", C.TextDim)
    ConfigSec2:AddSeparator()
    ConfigSec2:AddInput("Code config", "Entrer un code...", function(text, enter)
        if enter and text ~= "" then
            window:Notify("Cloud", "Import config: "..text, "info", 2)
        end
    end)
    ConfigSec2:AddButton("⬆️  Uploader config", function()
        window:Notify("Cloud", "Config uploadée !", "success", 2)
    end)
    ConfigSec2:AddButton("⬇️  Télécharger config", function()
        window:Notify("Cloud", "Config téléchargée !", "success", 2)
    end)
    ConfigSec2:AddToggle("Autosave", false, "Sauvegarder automatiquement", function(v)
        window:Notify("Config", "Autosave: "..(v and "ON" or "OFF"), "info", 2)
    end)
    ConfigSec2:AddSlider("Intervalle autosave", 10, 300, 60, "s", function(v) end)

    return SettingsTab
end

return VioletUI

--[[
══════════════════════════════════════════════════════
  EXEMPLE D'UTILISATION COMPLÈTE
══════════════════════════════════════════════════════

local VioletUI = loadstring(game:HttpGet("URL_ICI"))()

local Win = VioletUI:CreateWindow({
    Name = "Mon Hub",
    ToggleKey = Enum.KeyCode.RightShift,
})

-- Ajouter le tab paramètres automatiquement
VioletUI:AddSettingsTab(Win)

-- Créer un tab personnalisé
local CombatTab = Win:CreateTab("Combat", "⚔")
local AimbotSub = CombatTab:CreateSubTab("Aimbot")
local StrafeSub = CombatTab:CreateSubTab("Strafe")

-- Section Aimbot
local AimbotSec = AimbotSub:CreateSection("Aimbot")
local enabled = AimbotSec:AddToggle("Activé", false, "Active l'aimbot", function(val)
    print("Aimbot:", val)
end)
local smooth = AimbotSec:AddSlider("Smoothness", 0, 100, 50, "%", function(val)
    print("Smooth:", val)
end)
local bodyPart = AimbotSec:AddDropdown("Partie du corps", {"Tête", "Torse", "Jambes"}, "Tête", function(v)
    print("Body:", v)
end)

-- Notification
Win:Notify("Bienvenue", "VioletUI chargé avec succès !", "success", 3)

══════════════════════════════════════════════════════
]]
