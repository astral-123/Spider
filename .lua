-- ╔══════════════════════════════════════════╗
-- ║         VioletUI Library v4.0            ║
-- ║  Style EXACT de la lib originale jaune   ║
-- ║  Remplacé : jaune → violet               ║
-- ║  Fond noir, bords carrés, logo original  ║
-- ╚══════════════════════════════════════════╝

local VioletUI = {}
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LocalPlayer      = Players.LocalPlayer

-- ══════════════════════════════════════════
--  COULEURS (identiques à la lib originale
--  mais VIOLET remplace JAUNE partout)
-- ══════════════════════════════════════════
local Colors = {
    Background = Color3.fromRGB(0, 0, 0),        -- fond noir pur
    Secondary  = Color3.fromRGB(11, 11, 11),     -- fond secondaire
    Element    = Color3.fromRGB(17, 17, 17),     -- fond éléments
    Violet     = Color3.fromRGB(110, 50, 210),   -- violet (remplace jaune)
    Text       = Color3.fromRGB(255, 255, 255),  -- texte blanc
    Border     = Color3.fromRGB(110, 50, 210),   -- bordure violette
    Checked    = Color3.fromRGB(110, 50, 210),   -- checkbox cochée
    SliderFill = Color3.fromRGB(110, 50, 210),   -- fill slider
    TabActive  = Color3.fromRGB(110, 50, 210),   -- tab actif
    TabInact   = Color3.fromRGB(17, 17, 17),     -- tab inactif
    Red        = Color3.fromRGB(200, 50, 50),    -- bouton fermer
    Orange     = Color3.fromRGB(200, 130, 30),   -- bouton minimiser
}

local isVisible = true
local toggleKey = Enum.KeyCode.RightShift

-- ══════════════════════════════════════════
--  HELPERS (même style que lib originale)
-- ══════════════════════════════════════════
local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

-- ══════════════════════════════════════════
--  NOTIFICATIONS
-- ══════════════════════════════════════════
local function MakeNotifSystem(gui)
    local Holder = Instance.new("Frame")
    Holder.Name = "NotifHolder"
    Holder.Parent = gui
    Holder.BackgroundTransparency = 1
    Holder.Size = UDim2.new(0, 260, 1, 0)
    Holder.Position = UDim2.new(1, -270, 0, 0)
    Holder.ZIndex = 200
    local ll = Instance.new("UIListLayout")
    ll.FillDirection = Enum.FillDirection.Vertical
    ll.Padding = UDim.new(0, 5)
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.Parent = Holder
    local pp = Instance.new("UIPadding")
    pp.PaddingTop = UDim.new(0, 15)
    pp.Parent = Holder

    return function(title, msg, ntype, dur)
        local accent = ({
            info    = Colors.Violet,
            success = Color3.fromRGB(50, 180, 80),
            warning = Color3.fromRGB(200, 130, 30),
            error   = Color3.fromRGB(200, 50, 50),
        })[ntype or "info"] or Colors.Violet

        local NF = Instance.new("Frame")
        NF.Parent = Holder
        NF.BackgroundColor3 = Colors.Secondary
        NF.BorderColor3 = accent
        NF.BorderSizePixel = 2
        NF.Size = UDim2.new(1, 0, 0, 68)
        NF.ZIndex = 201

        local AccentBar = Instance.new("Frame")
        AccentBar.Parent = NF
        AccentBar.BackgroundColor3 = accent
        AccentBar.BorderSizePixel = 0
        AccentBar.Size = UDim2.new(0, 3, 1, 0)
        AccentBar.ZIndex = 202

        local NT = Instance.new("TextLabel")
        NT.Parent = NF
        NT.BackgroundColor3 = Colors.Element
        NT.BorderColor3 = accent
        NT.BorderSizePixel = 1
        NT.Size = UDim2.new(1, 0, 0, 24)
        NT.Text = title
        NT.TextColor3 = Colors.Text
        NT.TextSize = 14
        NT.Font = Enum.Font.GothamBold
        NT.ZIndex = 202

        local NM = Instance.new("TextLabel")
        NM.Parent = NF
        NM.BackgroundColor3 = Colors.Secondary
        NM.BorderSizePixel = 0
        NM.Position = UDim2.new(0, 5, 0, 26)
        NM.Size = UDim2.new(1, -8, 0, 36)
        NM.Text = msg
        NM.TextColor3 = Color3.fromRGB(200, 200, 200)
        NM.TextSize = 12
        NM.Font = Enum.Font.Gotham
        NM.TextWrapped = true
        NM.TextXAlignment = Enum.TextXAlignment.Left
        NM.ZIndex = 202

        local PBG = Instance.new("Frame")
        PBG.Parent = NF
        PBG.BackgroundColor3 = Colors.Element
        PBG.BorderSizePixel = 0
        PBG.Size = UDim2.new(1, 0, 0, 2)
        PBG.Position = UDim2.new(0, 0, 1, -2)
        PBG.ZIndex = 203

        local PF = Instance.new("Frame")
        PF.Parent = PBG
        PF.BackgroundColor3 = accent
        PF.BorderSizePixel = 0
        PF.Size = UDim2.new(1, 0, 1, 0)
        PF.ZIndex = 204

        NF.Position = UDim2.new(1, 10, 0, 0)
        Tween(NF, {Position = UDim2.new(0, 0, 0, 0)}, 0.25)
        local d = dur or 3
        Tween(PF, {Size = UDim2.new(0, 0, 1, 0)}, d)
        task.delay(d, function()
            Tween(NF, {Position = UDim2.new(1, 10, 0, 0)}, 0.2)
            task.wait(0.25)
            NF:Destroy()
        end)
    end
end

-- ══════════════════════════════════════════
--  CRÉER LA FENÊTRE
-- ══════════════════════════════════════════
function VioletUI:CreateWindow(config)
    config = config or {}
    local windowName = config.Name       or "Violet Hub"
    toggleKey        = config.ToggleKey  or Enum.KeyCode.RightShift
    local W          = config.Width      or 800
    local H          = config.Height     or 550
    local logoId     = config.Logo       or "rbxassetid://125489582002636"

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VioletUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999

    local Notify = MakeNotifSystem(ScreenGui)

    -- ── FENÊTRE PRINCIPALE ──
    -- Exactement comme la lib originale : fond noir, bord violet, BorderSizePixel=2
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderColor3 = Colors.Border
    MainFrame.BorderSizePixel = 2
    MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
    MainFrame.Size = UDim2.new(0, W, 0, H)
    MainFrame.Active = true
    MainFrame.Draggable = true

    -- ── LOGO (exactement comme lib originale) ──
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Parent = MainFrame
    Logo.BackgroundTransparency = 1
    Logo.Size = UDim2.new(0, 200, 0, 60)
    Logo.Position = UDim2.new(0.02, 0, 0.02, 0)
    Logo.Image = logoId

    -- ── BOUTONS CONTRÔLE (dots style lib originale) ──
    local ControlFrame = Instance.new("Frame")
    ControlFrame.Name = "ControlFrame"
    ControlFrame.Parent = MainFrame
    ControlFrame.BackgroundTransparency = 1
    ControlFrame.Size = UDim2.new(0, 55, 0, 20)
    ControlFrame.Position = UDim2.new(1, -65, 0, 12)

    -- Bouton minimiser (orange dot)
    local MinBtn = Instance.new("TextButton")
    MinBtn.Name = "MinBtn"
    MinBtn.Parent = ControlFrame
    MinBtn.BackgroundColor3 = Colors.Orange
    MinBtn.BorderSizePixel = 0
    MinBtn.Size = UDim2.new(0, 14, 0, 14)
    MinBtn.Position = UDim2.new(0, 0, 0.5, -7)
    MinBtn.Text = ""
    MinBtn.ZIndex = 2
    local mc = Instance.new("UICorner"); mc.CornerRadius = UDim.new(1,0); mc.Parent = MinBtn

    -- Bouton fermer (rouge dot)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Parent = ControlFrame
    CloseBtn.BackgroundColor3 = Colors.Red
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Size = UDim2.new(0, 14, 0, 14)
    CloseBtn.Position = UDim2.new(0, 22, 0.5, -7)
    CloseBtn.Text = ""
    CloseBtn.ZIndex = 2
    local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(1,0); cc.Parent = CloseBtn

    -- ── RESIZE HANDLE ──
    local ResizeHandle = Instance.new("ImageButton")
    ResizeHandle.Name = "ResizeHandle"
    ResizeHandle.Parent = MainFrame
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
    ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
    ResizeHandle.Image = "rbxassetid://3926305904"
    ResizeHandle.ImageColor3 = Colors.Violet
    ResizeHandle.ZIndex = 10

    local isResizing = false
    ResizeHandle.MouseButton1Down:Connect(function()
        isResizing = true
        local startPos = UserInputService:GetMouseLocation()
        local startSize = MainFrame.Size

        local mv = UserInputService.InputChanged:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement and isResizing then
                local mp = UserInputService:GetMouseLocation()
                local dx = mp.X - startPos.X
                local dy = mp.Y - startPos.Y
                MainFrame.Size = UDim2.new(0, math.max(500, startSize.X.Offset+dx), 0, math.max(350, startSize.Y.Offset+dy))
            end
        end)
        UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                isResizing = false
                mv:Disconnect()
            end
        end)
    end)

    -- ── TABS FRAME (sidebar gauche, exactement lib originale) ──
    local TabsFrame = Instance.new("Frame")
    TabsFrame.Name = "TabsFrame"
    TabsFrame.Parent = MainFrame
    TabsFrame.BackgroundColor3 = Colors.Secondary
    TabsFrame.BorderColor3 = Colors.Border
    TabsFrame.BorderSizePixel = 2
    TabsFrame.Position = UDim2.new(0.02, 0, 0.15, 0)
    TabsFrame.Size = UDim2.new(0, 165, 0, 390)

    -- Search bar dans la sidebar
    local SearchBox = Instance.new("TextBox")
    SearchBox.Parent = TabsFrame
    SearchBox.BackgroundColor3 = Colors.Element
    SearchBox.BorderColor3 = Colors.Border
    SearchBox.BorderSizePixel = 1
    SearchBox.Size = UDim2.new(1, -10, 0, 24)
    SearchBox.Position = UDim2.new(0, 5, 1, -32)
    SearchBox.PlaceholderText = "🔍 Rechercher..."
    SearchBox.Text = ""
    SearchBox.TextColor3 = Colors.Text
    SearchBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    SearchBox.TextSize = 12
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.ClearTextOnFocus = false
    SearchBox.ZIndex = 3

    -- ── CONTENT FRAME ──
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = Colors.Secondary
    ContentFrame.BorderColor3 = Colors.Border
    ContentFrame.BorderSizePixel = 2
    ContentFrame.Position = UDim2.new(0.235, 0, 0.15, 0)
    ContentFrame.Size = UDim2.new(0, 600, 0, 390)

    -- Barre sous-tabs horizontale (Général | Apparence | Touches | Configs)
    local SubTabBar = Instance.new("Frame")
    SubTabBar.Name = "SubTabBar"
    SubTabBar.Parent = ContentFrame
    SubTabBar.BackgroundColor3 = Colors.Secondary
    SubTabBar.BorderColor3 = Colors.Border
    SubTabBar.BorderSizePixel = 1
    SubTabBar.Size = UDim2.new(1, 0, 0, 28)
    SubTabBar.ZIndex = 3
    local stbl = Instance.new("UIListLayout")
    stbl.FillDirection = Enum.FillDirection.Horizontal
    stbl.SortOrder = Enum.SortOrder.LayoutOrder
    stbl.Parent = SubTabBar
    local stbp = Instance.new("UIPadding")
    stbp.PaddingLeft = UDim.new(0, 6)
    stbp.PaddingTop = UDim.new(0, 4)
    stbp.Parent = SubTabBar

    -- Zone colonnes (scrollable)
    local ColScroll = Instance.new("ScrollingFrame")
    ColScroll.Name = "ColScroll"
    ColScroll.Parent = ContentFrame
    ColScroll.BackgroundTransparency = 1
    ColScroll.BorderSizePixel = 0
    ColScroll.Size = UDim2.new(1, 0, 1, -28)
    ColScroll.Position = UDim2.new(0, 0, 0, 28)
    ColScroll.ScrollBarThickness = 3
    ColScroll.ScrollBarImageColor3 = Colors.Violet
    ColScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ColScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ColScroll.ZIndex = 3

    local ColsHolder = Instance.new("Frame")
    ColsHolder.Name = "ColsHolder"
    ColsHolder.Parent = ColScroll
    ColsHolder.BackgroundTransparency = 1
    ColsHolder.Size = UDim2.new(1, 0, 0, 0)
    ColsHolder.AutomaticSize = Enum.AutomaticSize.Y
    ColsHolder.ZIndex = 4
    local chl = Instance.new("UIListLayout")
    chl.FillDirection = Enum.FillDirection.Horizontal
    chl.Padding = UDim.new(0, 4)
    chl.VerticalAlignment = Enum.VerticalAlignment.Top
    chl.SortOrder = Enum.SortOrder.LayoutOrder
    chl.Parent = ColsHolder
    local chp = Instance.new("UIPadding")
    chp.PaddingTop = UDim.new(0, 6)
    chp.PaddingLeft = UDim.new(0, 6)
    chp.PaddingRight = UDim.new(0, 6)
    chp.PaddingBottom = UDim.new(0, 6)
    chp.Parent = ColsHolder

    -- ── ÉTAT ──
    local tabs = {}
    local curTab = nil
    local isMin = false

    -- ══════════════════════════════════════
    --  OBJET WINDOW
    -- ══════════════════════════════════════
    local Win = {}

    function Win:Notify(t, m, tp, d) Notify(t, m, tp, d) end

    -- ── CRÉER UN TAB PRINCIPAL ──────────────
    function Win:CreateTab(name, icon)
        local td = {name=name, subTabs={}, curSub=nil}

        -- Bouton tab dans la sidebar (exactement comme lib originale)
        local TB = Instance.new("TextButton")
        TB.Name = name.."Tab"
        TB.Parent = TabsFrame
        TB.BackgroundColor3 = Colors.Element
        TB.BorderColor3 = Colors.Border
        TB.BorderSizePixel = 1
        TB.Size = UDim2.new(0, 150, 0, 28)
        TB.Position = UDim2.new(0, 7, 0, 8 + (#tabs * 32))
        TB.Text = (icon and icon.." " or "") .. name
        TB.TextColor3 = Colors.Text
        TB.TextSize = 13
        TB.Font = Enum.Font.GothamMedium
        TB.ZIndex = 2

        -- Container sous-tabs
        local SubContainer = Instance.new("Frame")
        SubContainer.Name = "SubCont_"..name
        SubContainer.Parent = SubTabBar
        SubContainer.BackgroundTransparency = 1
        SubContainer.Size = UDim2.new(1, 0, 1, 0)
        SubContainer.Visible = false
        SubContainer.ZIndex = 4
        local scl = Instance.new("UIListLayout")
        scl.FillDirection = Enum.FillDirection.Horizontal
        scl.SortOrder = Enum.SortOrder.LayoutOrder
        scl.Parent = SubContainer

        -- Container colonnes
        local ColContainer = Instance.new("Frame")
        ColContainer.Name = "ColCont_"..name
        ColContainer.Parent = ColsHolder
        ColContainer.BackgroundTransparency = 1
        ColContainer.Size = UDim2.new(1, 0, 0, 0)
        ColContainer.AutomaticSize = Enum.AutomaticSize.Y
        ColContainer.Visible = false
        ColContainer.ZIndex = 5
        local ccl = Instance.new("UIListLayout")
        ccl.FillDirection = Enum.FillDirection.Horizontal
        ccl.Padding = UDim.new(0, 4)
        ccl.VerticalAlignment = Enum.VerticalAlignment.Top
        ccl.SortOrder = Enum.SortOrder.LayoutOrder
        ccl.Parent = ColContainer

        td.Button       = TB
        td.SubContainer = SubContainer
        td.ColContainer = ColContainer
        table.insert(tabs, td)

        local function Activate()
            for _, t in ipairs(tabs) do
                t.Button.BackgroundColor3 = Colors.Element
                t.Button.TextColor3 = Colors.Text
                t.SubContainer.Visible = false
                t.ColContainer.Visible = false
            end
            TB.BackgroundColor3 = Colors.Violet
            TB.TextColor3 = Colors.Text
            SubContainer.Visible = true
            ColContainer.Visible = true
            curTab = td
            if #td.subTabs > 0 and td.curSub == nil then
                td.subTabs[1].activate()
            elseif td.curSub then
                td.curSub.ColFrame.Visible = true
            end
        end

        TB.MouseButton1Click:Connect(Activate)
        TB.MouseEnter:Connect(function()
            if curTab ~= td then TB.BackgroundColor3 = Color3.fromRGB(30, 20, 50) end
        end)
        TB.MouseLeave:Connect(function()
            if curTab ~= td then TB.BackgroundColor3 = Colors.Element end
        end)

        if #tabs == 1 then task.defer(Activate) end

        local Tab = {}

        -- ── SOUS-TABS ──
        function Tab:CreateSubTab(sname)
            local sd = {name=sname}

            local SB = Instance.new("TextButton")
            SB.Name = "SB_"..sname
            SB.Parent = SubContainer
            SB.BackgroundColor3 = Colors.Element
            SB.BorderSizePixel = 0
            SB.AutomaticSize = Enum.AutomaticSize.X
            SB.Size = UDim2.new(0, 0, 1, -6)
            SB.Text = sname
            SB.TextColor3 = Color3.fromRGB(180, 180, 180)
            SB.TextSize = 12
            SB.Font = Enum.Font.GothamMedium
            SB.ZIndex = 5
            local sbp = Instance.new("UIPadding")
            sbp.PaddingLeft = UDim.new(0, 10)
            sbp.PaddingRight = UDim.new(0, 10)
            sbp.Parent = SB

            -- underline actif
            local SBLine = Instance.new("Frame")
            SBLine.Parent = SB
            SBLine.BackgroundColor3 = Colors.Violet
            SBLine.BorderSizePixel = 0
            SBLine.Size = UDim2.new(1, 0, 0, 2)
            SBLine.Position = UDim2.new(0, 0, 1, -2)
            SBLine.Visible = false
            SBLine.ZIndex = 6

            -- Scroll colonnes pour ce sous-tab
            local SubScroll = Instance.new("ScrollingFrame")
            SubScroll.Parent = ColContainer
            SubScroll.BackgroundTransparency = 1
            SubScroll.BorderSizePixel = 0
            SubScroll.Size = UDim2.new(1, 0, 0, 0)
            SubScroll.AutomaticSize = Enum.AutomaticSize.Y
            SubScroll.CanvasSize = UDim2.new(0,0,0,0)
            SubScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            SubScroll.ScrollBarThickness = 0
            SubScroll.Visible = false
            SubScroll.ZIndex = 6

            local SubColFrame = Instance.new("Frame")
            SubColFrame.Name = "SubCols_"..sname
            SubColFrame.Parent = SubScroll
            SubColFrame.BackgroundTransparency = 1
            SubColFrame.Size = UDim2.new(1, 0, 0, 0)
            SubColFrame.AutomaticSize = Enum.AutomaticSize.Y
            SubColFrame.ZIndex = 7
            local scfl = Instance.new("UIListLayout")
            scfl.FillDirection = Enum.FillDirection.Horizontal
            scfl.Padding = UDim.new(0, 4)
            scfl.VerticalAlignment = Enum.VerticalAlignment.Top
            scfl.SortOrder = Enum.SortOrder.LayoutOrder
            scfl.Parent = SubColFrame

            sd.Button   = SB
            sd.Line     = SBLine
            sd.ScrollF  = SubScroll
            sd.ColFrame = SubColFrame

            local function ActivateSub()
                for _, s in ipairs(td.subTabs) do
                    s.Button.TextColor3 = Color3.fromRGB(180,180,180)
                    s.Button.BackgroundColor3 = Colors.Element
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
            if #td.subTabs == 1 and curTab == td then
                task.defer(ActivateSub)
            end

            -- ════════════════════════════════
            --  OBJET SOUS-TAB
            -- ════════════════════════════════
            local SubTabObj = {}

            -- ── CRÉER SECTION (colonne) ──
            function SubTabObj:CreateSection(secname)

                -- Colonne section (exactement comme lib originale)
                local Sec = Instance.new("Frame")
                Sec.Name = "Sec_"..secname
                Sec.Parent = SubColFrame
                Sec.BackgroundColor3 = Colors.Secondary
                Sec.BorderColor3 = Colors.Border
                Sec.BorderSizePixel = 2
                Sec.Size = UDim2.new(0, 280, 0, 0)
                Sec.AutomaticSize = Enum.AutomaticSize.Y
                Sec.ZIndex = 8

                -- Header section (titre violet)
                local SecTitle = Instance.new("TextLabel")
                SecTitle.Parent = Sec
                SecTitle.BackgroundColor3 = Colors.Element
                SecTitle.BorderColor3 = Colors.Border
                SecTitle.BorderSizePixel = 1
                SecTitle.Size = UDim2.new(1, 0, 0, 24)
                SecTitle.Text = secname
                SecTitle.TextColor3 = Color3.fromRGB(160, 100, 255)
                SecTitle.TextSize = 13
                SecTitle.Font = Enum.Font.GothamBold
                SecTitle.ZIndex = 9

                -- Sous-titre italique (description optionnelle)
                local SecSubTitle = Instance.new("TextLabel")
                SecSubTitle.Parent = Sec
                SecSubTitle.BackgroundTransparency = 1
                SecSubTitle.BorderSizePixel = 0
                SecSubTitle.Position = UDim2.new(0, 6, 0, 26)
                SecSubTitle.Size = UDim2.new(1, -8, 0, 16)
                SecSubTitle.Text = ""
                SecSubTitle.TextColor3 = Color3.fromRGB(130, 120, 150)
                SecSubTitle.TextSize = 11
                SecSubTitle.Font = Enum.Font.GothamItalic
                SecSubTitle.TextXAlignment = Enum.TextXAlignment.Left
                SecSubTitle.ZIndex = 9

                -- Liste items
                local Items = Instance.new("Frame")
                Items.Name = "Items"
                Items.Parent = Sec
                Items.BackgroundTransparency = 1
                Items.BorderSizePixel = 0
                Items.Size = UDim2.new(1, 0, 0, 0)
                Items.AutomaticSize = Enum.AutomaticSize.Y
                Items.Position = UDim2.new(0, 0, 0, 24)
                Items.ZIndex = 9
                local il = Instance.new("UIListLayout")
                il.FillDirection = Enum.FillDirection.Vertical
                il.Padding = UDim.new(0, 1)
                il.SortOrder = Enum.SortOrder.LayoutOrder
                il.Parent = Items
                local ip = Instance.new("UIPadding")
                ip.PaddingLeft = UDim.new(0, 6)
                ip.PaddingRight = UDim.new(0, 6)
                ip.PaddingTop = UDim.new(0, 4)
                ip.PaddingBottom = UDim.new(0, 6)
                ip.Parent = Items

                local S = {}

                function S:SetDescription(txt)
                    SecSubTitle.Text = txt
                    Items.Position = UDim2.new(0,0,0,42)
                end

                -- ════════════════════════════
                --  TOGGLE (checkbox carré, style lib originale)
                -- ════════════════════════════
                function S:AddToggle(lbl, default, hint, cb)
                    -- Gestion surcharge : (lbl, default, cb) sans hint
                    if type(hint) == "function" then cb=hint; hint=nil end
                    if type(default) == "function" then cb=default; default=false end
                    local val = default == true

                    local Row = Instance.new("Frame")
                    Row.Parent = Items
                    Row.BackgroundColor3 = Colors.Element
                    Row.BorderSizePixel = 0
                    Row.Size = UDim2.new(1, 0, 0, 26)
                    Row.ZIndex = 10

                    -- Checkbox (carré avec bordure violette)
                    local Box = Instance.new("Frame")
                    Box.Parent = Row
                    Box.BackgroundColor3 = val and Colors.Violet or Colors.Background
                    Box.BorderColor3 = Colors.Border
                    Box.BorderSizePixel = 2
                    Box.Size = UDim2.new(0, 14, 0, 14)
                    Box.Position = UDim2.new(0, 4, 0.5, -7)
                    Box.ZIndex = 11

                    local Check = Instance.new("TextLabel")
                    Check.Parent = Box
                    Check.BackgroundTransparency = 1
                    Check.Size = UDim2.new(1, 0, 1, 0)
                    Check.Text = "✓"
                    Check.TextColor3 = Colors.Text
                    Check.TextSize = 10
                    Check.Font = Enum.Font.GothamBold
                    Check.TextTransparency = val and 0 or 1
                    Check.ZIndex = 12

                    local Lbl = Instance.new("TextLabel")
                    Lbl.Parent = Row
                    Lbl.BackgroundTransparency = 1
                    Lbl.Position = UDim2.new(0, 24, 0, 0)
                    Lbl.Size = UDim2.new(1, -44, 1, 0)
                    Lbl.Text = lbl
                    Lbl.TextColor3 = Colors.Text
                    Lbl.TextSize = 12
                    Lbl.Font = Enum.Font.Gotham
                    Lbl.TextXAlignment = Enum.TextXAlignment.Left
                    Lbl.ZIndex = 11

                    -- Hint "?"
                    if hint then
                        local HB = Instance.new("TextButton")
                        HB.Parent = Row
                        HB.BackgroundColor3 = Colors.Violet
                        HB.BorderSizePixel = 0
                        HB.Size = UDim2.new(0, 14, 0, 14)
                        HB.Position = UDim2.new(1, -18, 0.5, -7)
                        HB.Text = "?"
                        HB.TextColor3 = Colors.Text
                        HB.TextSize = 10
                        HB.Font = Enum.Font.GothamBold
                        HB.ZIndex = 12
                        local hc = Instance.new("UICorner"); hc.CornerRadius=UDim.new(1,0); hc.Parent=HB
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
                        Box.BackgroundColor3 = v and Colors.Violet or Colors.Background
                        Check.TextTransparency = v and 0 or 1
                        if not silent and cb then cb(v) end
                    end
                    ClickBtn.MouseButton1Click:Connect(function() Set(not val) end)
                    Row.MouseEnter:Connect(function() Row.BackgroundColor3 = Color3.fromRGB(25, 18, 40) end)
                    Row.MouseLeave:Connect(function() Row.BackgroundColor3 = Colors.Element end)
                    function obj:Set(v) Set(v, true) end
                    return obj
                end

                -- ════════════════════════════
                --  SLIDER (style lib originale)
                -- ════════════════════════════
                function S:AddSlider(lbl, min, max, default, suffix, cb)
                    if type(suffix)=="function" then cb=suffix; suffix="" end
                    local val = math.clamp(default or min, min, max)
                    suffix = suffix or ""

                    local Container = Instance.new("Frame")
                    Container.Parent = Items
                    Container.BackgroundColor3 = Colors.Element
                    Container.BorderSizePixel = 0
                    Container.Size = UDim2.new(1, 0, 0, 40)
                    Container.ZIndex = 10

                    -- Titre + valeur
                    local LblF = Instance.new("TextLabel")
                    LblF.Parent = Container
                    LblF.BackgroundTransparency = 1
                    LblF.Position = UDim2.new(0, 4, 0, 2)
                    LblF.Size = UDim2.new(0.65, 0, 0, 16)
                    LblF.Text = lbl
                    LblF.TextColor3 = Colors.Text
                    LblF.TextSize = 11
                    LblF.Font = Enum.Font.Gotham
                    LblF.TextXAlignment = Enum.TextXAlignment.Left
                    LblF.ZIndex = 11

                    local ValF = Instance.new("TextLabel")
                    ValF.Parent = Container
                    ValF.BackgroundTransparency = 1
                    ValF.Position = UDim2.new(0.65, 0, 0, 2)
                    ValF.Size = UDim2.new(0.35, -4, 0, 16)
                    ValF.Text = tostring(math.floor(val))..suffix
                    ValF.TextColor3 = Color3.fromRGB(160, 120, 255)
                    ValF.TextSize = 11
                    ValF.Font = Enum.Font.GothamMedium
                    ValF.TextXAlignment = Enum.TextXAlignment.Right
                    ValF.ZIndex = 11

                    -- Track
                    local Track = Instance.new("Frame")
                    Track.Parent = Container
                    Track.BackgroundColor3 = Colors.Background
                    Track.BorderColor3 = Colors.Border
                    Track.BorderSizePixel = 1
                    Track.Position = UDim2.new(0, 4, 0, 22)
                    Track.Size = UDim2.new(1, -8, 0, 8)
                    Track.ZIndex = 11

                    local pct = (val-min)/(max-min)
                    local Fill = Instance.new("Frame")
                    Fill.Parent = Track
                    Fill.BackgroundColor3 = Colors.Violet
                    Fill.BorderSizePixel = 0
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    Fill.ZIndex = 12

                    -- Knob
                    local Knob = Instance.new("Frame")
                    Knob.Parent = Track
                    Knob.BackgroundColor3 = Color3.fromRGB(220, 200, 255)
                    Knob.BorderColor3 = Colors.Violet
                    Knob.BorderSizePixel = 1
                    Knob.Size = UDim2.new(0, 8, 0, 12)
                    Knob.Position = UDim2.new(pct, -4, 0.5, -6)
                    Knob.ZIndex = 13

                    local HitBtn = Instance.new("TextButton")
                    HitBtn.Parent = Container
                    HitBtn.BackgroundTransparency = 1
                    HitBtn.BorderSizePixel = 0
                    HitBtn.Position = UDim2.new(0, 0, 0, 18)
                    HitBtn.Size = UDim2.new(1, 0, 0, 22)
                    HitBtn.Text = ""
                    HitBtn.ZIndex = 14

                    local drag = false
                    local obj = {Value = val}
                    local function Update(mx)
                        local tp = Track.AbsolutePosition.X
                        local ts = Track.AbsoluteSize.X
                        local r = math.clamp((mx-tp)/ts, 0, 1)
                        val = min+(max-min)*r
                        obj.Value = val
                        Fill.Size = UDim2.new(r, 0, 1, 0)
                        Knob.Position = UDim2.new(r, -4, 0.5, -6)
                        ValF.Text = tostring(math.floor(val*10+0.5)/10)..suffix
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
                    Container.MouseEnter:Connect(function() Container.BackgroundColor3 = Color3.fromRGB(22, 15, 35) end)
                    Container.MouseLeave:Connect(function() Container.BackgroundColor3 = Colors.Element end)

                    function obj:Set(v)
                        val=math.clamp(v,min,max); obj.Value=val
                        local r=(val-min)/(max-min)
                        Fill.Size=UDim2.new(r,0,1,0)
                        Knob.Position=UDim2.new(r,-4,0.5,-6)
                        ValF.Text=tostring(val)..suffix
                    end
                    return obj
                end

                -- ════════════════════════════
                --  DROPDOWN (style lib originale)
                -- ════════════════════════════
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
                    LblD.Position = UDim2.new(0, 4, 0, 0)
                    LblD.Size = UDim2.new(0.4, 0, 1, 0)
                    LblD.Text = lbl
                    LblD.TextColor3 = Color3.fromRGB(150, 140, 165)
                    LblD.TextSize = 11
                    LblD.Font = Enum.Font.Gotham
                    LblD.TextXAlignment = Enum.TextXAlignment.Left
                    LblD.ZIndex = 11

                    local DropBtn = Instance.new("TextButton")
                    DropBtn.Parent = Container
                    DropBtn.BackgroundColor3 = Colors.Background
                    DropBtn.BorderColor3 = Colors.Border
                    DropBtn.BorderSizePixel = 1
                    DropBtn.Position = UDim2.new(0.4, 0, 0.5, -10)
                    DropBtn.Size = UDim2.new(0.58, 0, 0, 20)
                    DropBtn.Text = ""
                    DropBtn.ZIndex = 11

                    local SelLbl = Instance.new("TextLabel")
                    SelLbl.Parent = DropBtn
                    SelLbl.BackgroundTransparency = 1
                    SelLbl.Position = UDim2.new(0, 4, 0, 0)
                    SelLbl.Size = UDim2.new(1, -18, 1, 0)
                    SelLbl.Text = sel
                    SelLbl.TextColor3 = Colors.Text
                    SelLbl.TextSize = 11
                    SelLbl.Font = Enum.Font.Gotham
                    SelLbl.TextXAlignment = Enum.TextXAlignment.Left
                    SelLbl.ZIndex = 12

                    local Arrow = Instance.new("TextLabel")
                    Arrow.Parent = DropBtn
                    Arrow.BackgroundTransparency = 1
                    Arrow.Position = UDim2.new(1, -16, 0, 0)
                    Arrow.Size = UDim2.new(0, 14, 1, 0)
                    Arrow.Text = "▾"
                    Arrow.TextColor3 = Color3.fromRGB(160, 100, 255)
                    Arrow.TextSize = 12
                    Arrow.ZIndex = 12

                    -- Liste déroulante
                    local DL = Instance.new("Frame")
                    DL.Parent = DropBtn
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
                        OB.Size = UDim2.new(1, 0, 0, 22)
                        OB.Text = opt
                        OB.TextColor3 = opt==sel and Color3.fromRGB(160,100,255) or Colors.Text
                        OB.TextSize = 11
                        OB.Font = Enum.Font.Gotham
                        OB.ZIndex = 51
                        OB.MouseEnter:Connect(function() OB.BackgroundColor3 = Color3.fromRGB(50, 30, 80) end)
                        OB.MouseLeave:Connect(function() OB.BackgroundColor3 = Colors.Element end)
                        OB.MouseButton1Click:Connect(function()
                            sel=opt; SelLbl.Text=opt; open=false; DL.Visible=false
                            if cb then cb(opt) end
                        end)
                    end

                    DropBtn.MouseButton1Click:Connect(function()
                        open=not open; DL.Visible=open
                    end)
                    Container.MouseEnter:Connect(function() Container.BackgroundColor3=Color3.fromRGB(22,15,35) end)
                    Container.MouseLeave:Connect(function() Container.BackgroundColor3=Colors.Element end)

                    local obj={Value=sel}
                    function obj:Set(v) sel=v; SelLbl.Text=v; obj.Value=v end
                    return obj
                end

                -- ════════════════════════════
                --  BUTTON
                -- ════════════════════════════
                function S:AddButton(lbl, cb)
                    local B = Instance.new("TextButton")
                    B.Parent = Items
                    B.BackgroundColor3 = Colors.Violet
                    B.BorderColor3 = Color3.fromRGB(140, 70, 255)
                    B.BorderSizePixel = 1
                    B.Size = UDim2.new(1, 0, 0, 26)
                    B.Text = lbl
                    B.TextColor3 = Colors.Text
                    B.TextSize = 12
                    B.Font = Enum.Font.GothamMedium
                    B.ZIndex = 10

                    B.MouseEnter:Connect(function() B.BackgroundColor3 = Color3.fromRGB(130, 65, 240) end)
                    B.MouseLeave:Connect(function() B.BackgroundColor3 = Colors.Violet end)
                    B.MouseButton1Down:Connect(function() B.BackgroundColor3 = Color3.fromRGB(85, 40, 165) end)
                    B.MouseButton1Up:Connect(function() B.BackgroundColor3 = Colors.Violet end)
                    B.MouseButton1Click:Connect(function() if cb then cb() end end)
                    return B
                end

                -- ════════════════════════════
                --  INPUT
                -- ════════════════════════════
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
                    LblI.Position = UDim2.new(0, 4, 0, 0)
                    LblI.Size = UDim2.new(0.38, 0, 1, 0)
                    LblI.Text = lbl
                    LblI.TextColor3 = Color3.fromRGB(150,140,165)
                    LblI.TextSize = 11
                    LblI.Font = Enum.Font.Gotham
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
                    TB2.TextSize = 11
                    TB2.Font = Enum.Font.Gotham
                    TB2.ClearTextOnFocus = false
                    TB2.ZIndex = 11
                    local ip = Instance.new("UIPadding")
                    ip.PaddingLeft = UDim.new(0,4); ip.PaddingRight=UDim.new(0,4); ip.Parent=TB2

                    TB2.Focused:Connect(function() TB2.BorderColor3 = Colors.Violet end)
                    TB2.FocusLost:Connect(function(enter)
                        TB2.BorderColor3 = Colors.Border
                        if cb then cb(TB2.Text, enter) end
                    end)
                    return TB2
                end

                -- ════════════════════════════
                --  KEYBIND
                -- ════════════════════════════
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
                    LblK.Position = UDim2.new(0, 4, 0, 0)
                    LblK.Size = UDim2.new(0.6, 0, 1, 0)
                    LblK.Text = lbl
                    LblK.TextColor3 = Colors.Text
                    LblK.TextSize = 12
                    LblK.Font = Enum.Font.Gotham
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
                    KB.TextColor3 = Color3.fromRGB(160, 100, 255)
                    KB.TextSize = 11
                    KB.Font = Enum.Font.GothamMedium
                    KB.ZIndex = 11

                    KB.MouseButton1Click:Connect(function()
                        KB.Text = "..."
                        KB.BackgroundColor3 = Color3.fromRGB(30, 15, 60)
                        local conn; conn = UserInputService.InputBegan:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.Keyboard then
                                curKey = inp.KeyCode
                                KB.Text = tostring(curKey):gsub("Enum.KeyCode.", "")
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

                -- ════════════════════════════
                --  COLOR PICKER
                -- ════════════════════════════
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
                    LblC.Position = UDim2.new(0, 4, 0, 0)
                    LblC.Size = UDim2.new(0.6, 0, 1, 0)
                    LblC.Text = lbl
                    LblC.TextColor3 = Colors.Text
                    LblC.TextSize = 12
                    LblC.Font = Enum.Font.Gotham
                    LblC.TextXAlignment = Enum.TextXAlignment.Left
                    LblC.ZIndex = 11

                    local Prev = Instance.new("TextButton")
                    Prev.Parent = Container
                    Prev.BackgroundColor3 = col
                    Prev.BorderColor3 = Colors.Border
                    Prev.BorderSizePixel = 2
                    Prev.Position = UDim2.new(1, -44, 0.5, -9)
                    Prev.Size = UDim2.new(0, 38, 0, 18)
                    Prev.Text = ""
                    Prev.ZIndex = 11

                    local palette = {
                        Color3.fromRGB(110,50,210), Color3.fromRGB(50,110,210),
                        Color3.fromRGB(210,50,110), Color3.fromRGB(50,210,110),
                        Color3.fromRGB(210,160,50), Color3.fromRGB(210,50,50),
                        Color3.fromRGB(210,210,210), Color3.fromRGB(40,40,40),
                    }
                    local Pal = Instance.new("Frame")
                    Pal.Parent = Container
                    Pal.BackgroundColor3 = Colors.Secondary
                    Pal.BorderColor3 = Colors.Border
                    Pal.BorderSizePixel = 2
                    Pal.Position = UDim2.new(0.35, 0, 1, 2)
                    Pal.Size = UDim2.new(0, 160, 0, 50)
                    Pal.Visible = false
                    Pal.ZIndex = 60
                    local pg = Instance.new("UIGridLayout")
                    pg.CellSize=UDim2.new(0,16,0,16); pg.CellPadding=UDim2.new(0,3,0,3)
                    pg.Parent=Pal
                    local palp = Instance.new("UIPadding")
                    palp.PaddingTop=UDim.new(0,5); palp.PaddingLeft=UDim.new(0,5); palp.Parent=Pal

                    for _, pc in ipairs(palette) do
                        local PB = Instance.new("TextButton")
                        PB.Parent=Pal; PB.BackgroundColor3=pc
                        PB.BorderSizePixel=1; PB.BorderColor3=Colors.Border
                        PB.Size=UDim2.new(0,16,0,16); PB.Text=""; PB.ZIndex=61
                        PB.MouseButton1Click:Connect(function()
                            col=pc; Prev.BackgroundColor3=pc; Pal.Visible=false
                            if cb then cb(pc) end
                        end)
                    end

                    local po=false
                    Prev.MouseButton1Click:Connect(function() po=not po; Pal.Visible=po end)
                    Container.MouseEnter:Connect(function() Container.BackgroundColor3=Color3.fromRGB(22,15,35) end)
                    Container.MouseLeave:Connect(function() Container.BackgroundColor3=Colors.Element end)

                    local obj={Value=col}
                    function obj:Set(c) col=c; obj.Value=c; Prev.BackgroundColor3=c end
                    return obj
                end

                -- ════════════════════════════
                --  LABEL
                -- ════════════════════════════
                function S:AddLabel(txt, col)
                    local L = Instance.new("TextLabel")
                    L.Parent = Items
                    L.BackgroundTransparency = 1
                    L.BorderSizePixel = 0
                    L.Size = UDim2.new(1, 0, 0, 16)
                    L.Text = txt
                    L.TextColor3 = col or Color3.fromRGB(130, 120, 150)
                    L.TextSize = 11
                    L.Font = Enum.Font.GothamItalic
                    L.TextXAlignment = Enum.TextXAlignment.Left
                    L.ZIndex = 10
                    return L
                end

                -- ════════════════════════════
                --  SEPARATOR
                -- ════════════════════════════
                function S:AddSeparator()
                    local Sep = Instance.new("Frame")
                    Sep.Parent = Items
                    Sep.BackgroundColor3 = Colors.Border
                    Sep.BorderSizePixel = 0
                    Sep.Size = UDim2.new(1, 0, 0, 1)
                    Sep.ZIndex = 10
                    return Sep
                end

                -- ════════════════════════════
                --  MULTI-SELECT
                -- ════════════════════════════
                function S:AddMultiSelect(lbl, opts, defaults, cb)
                    defaults = defaults or {}
                    local selected = {}
                    for _,v in ipairs(defaults) do selected[v]=true end

                    local Container = Instance.new("Frame")
                    Container.Parent = Items
                    Container.BackgroundColor3 = Colors.Element
                    Container.BorderSizePixel = 0
                    Container.Size = UDim2.new(1, 0, 0, 0)
                    Container.AutomaticSize = Enum.AutomaticSize.Y
                    Container.ZIndex = 10

                    local LblM = Instance.new("TextLabel")
                    LblM.Parent = Container
                    LblM.BackgroundTransparency = 1
                    LblM.Position = UDim2.new(0, 4, 0, 0)
                    LblM.Size = UDim2.new(1, 0, 0, 20)
                    LblM.Text = lbl
                    LblM.TextColor3 = Color3.fromRGB(150,140,165)
                    LblM.TextSize = 11
                    LblM.Font = Enum.Font.GothamMedium
                    LblM.TextXAlignment = Enum.TextXAlignment.Left
                    LblM.ZIndex = 11

                    local List = Instance.new("Frame")
                    List.Parent = Container
                    List.BackgroundTransparency = 1
                    List.Position = UDim2.new(0, 0, 0, 20)
                    List.Size = UDim2.new(1, 0, 0, 0)
                    List.AutomaticSize = Enum.AutomaticSize.Y
                    List.ZIndex = 11
                    local ll2 = Instance.new("UIListLayout")
                    ll2.FillDirection = Enum.FillDirection.Vertical
                    ll2.Padding = UDim.new(0, 0)
                    ll2.SortOrder = Enum.SortOrder.LayoutOrder
                    ll2.Parent = List
                    local lp = Instance.new("UIPadding")
                    lp.PaddingLeft=UDim.new(0,6); lp.PaddingRight=UDim.new(0,4); lp.Parent=List

                    for _, opt in ipairs(opts) do
                        local isOn = selected[opt] or false
                        local Row2 = Instance.new("Frame")
                        Row2.Parent = List
                        Row2.BackgroundTransparency = 1
                        Row2.Size = UDim2.new(1, 0, 0, 22)
                        Row2.ZIndex = 12

                        local B2 = Instance.new("Frame")
                        B2.Parent = Row2
                        B2.BackgroundColor3 = isOn and Colors.Violet or Colors.Background
                        B2.BorderColor3 = Colors.Border
                        B2.BorderSizePixel = 2
                        B2.Size = UDim2.new(0, 12, 0, 12)
                        B2.Position = UDim2.new(0, 0, 0.5, -6)
                        B2.ZIndex = 13

                        local Chk2 = Instance.new("TextLabel")
                        Chk2.Parent = B2
                        Chk2.BackgroundTransparency = 1
                        Chk2.Size = UDim2.new(1, 0, 1, 0)
                        Chk2.Text = "✓"
                        Chk2.TextColor3 = Colors.Text
                        Chk2.TextSize = 9
                        Chk2.Font = Enum.Font.GothamBold
                        Chk2.TextTransparency = isOn and 0 or 1
                        Chk2.ZIndex = 14

                        local OLbl = Instance.new("TextLabel")
                        OLbl.Parent = Row2
                        OLbl.BackgroundTransparency = 1
                        OLbl.Position = UDim2.new(0, 18, 0, 0)
                        OLbl.Size = UDim2.new(1, -18, 1, 0)
                        OLbl.Text = opt
                        OLbl.TextColor3 = Colors.Text
                        OLbl.TextSize = 11
                        OLbl.Font = Enum.Font.Gotham
                        OLbl.TextXAlignment = Enum.TextXAlignment.Left
                        OLbl.ZIndex = 13

                        local CB2 = Instance.new("TextButton")
                        CB2.Parent = Row2
                        CB2.BackgroundTransparency = 1
                        CB2.BorderSizePixel = 0
                        CB2.Size = UDim2.new(1, 0, 1, 0)
                        CB2.Text = ""
                        CB2.ZIndex = 15
                        CB2.MouseButton1Click:Connect(function()
                            isOn=not isOn; selected[opt]=isOn
                            B2.BackgroundColor3 = isOn and Colors.Violet or Colors.Background
                            Chk2.TextTransparency = isOn and 0 or 1
                            if cb then cb(selected) end
                        end)
                        Row2.MouseEnter:Connect(function() Row2.BackgroundColor3=Color3.fromRGB(22,15,35); Row2.BackgroundTransparency=0 end)
                        Row2.MouseLeave:Connect(function() Row2.BackgroundTransparency=1 end)
                    end
                    return Container
                end

                return S
            end -- CreateSection

            return SubTabObj
        end -- CreateSubTab

        return Tab
    end -- CreateTab

    -- ── CONTRÔLES ───────────────────────────
    local isMin = false
    MinBtn.MouseButton1Click:Connect(function()
        isMin = not isMin
        Tween(MainFrame, {Size = UDim2.new(0, W, 0, isMin and 44 or H)}, 0.25)
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    UserInputService.InputBegan:Connect(function(inp, proc)
        if not proc and inp.KeyCode == toggleKey then
            isVisible = not isVisible
            MainFrame.Visible = isVisible
        end
    end)

    return Win
end

-- ══════════════════════════════════════════
--  TAB PARAMÈTRES COMPLET
-- ══════════════════════════════════════════
function VioletUI:AddSettingsTab(Win)
    local ST = Win:CreateTab("Paramètres", "⚙")

    local GenSub  = ST:CreateSubTab("Général")
    local AppSub  = ST:CreateSubTab("Apparence")
    local KeySub  = ST:CreateSubTab("Touches")
    local CfgSub  = ST:CreateSubTab("Configs")

    -- GÉNÉRAL
    local GenSec = GenSub:CreateSection("Général")
    GenSec:SetDescription("Paramètres généraux de l'interface")
    GenSec:AddToggle("Notifications", true, "Activer les notifications popup", function(v)
        Win:Notify("Paramètres", "Notifications: "..(v and "ON" or "OFF"), v and "success" or "info", 2)
    end)
    GenSec:AddToggle("Sons UI", false, "Sons lors des interactions", function(v) end)
    GenSec:AddToggle("Animations", true, "Activer les tweens", function(v) end)
    GenSec:AddToggle("Tooltips", true, "Afficher les bulles (?)", function(v) end)
    GenSec:AddSeparator()
    GenSec:AddLabel("Langue")
    GenSec:AddDropdown("Langue", {"Français","English","Español","Deutsch","Русский"}, "Français", function(v)
        Win:Notify("Paramètres","Langue: "..v,"info",2)
    end)
    GenSec:AddSlider("Opacité UI", 40, 100, 100, "%", function(v) end)
    GenSec:AddSlider("Délai notif.", 1, 10, 3, "s", function(v) end)

    local PerfSec = GenSub:CreateSection("Performance")
    PerfSec:SetDescription("Optimisation de l'interface")
    PerfSec:AddToggle("Mode performance", false, "Réduit les effets", function(v)
        Win:Notify("Paramètres","Mode perf: "..(v and "ON" or "OFF"),"warning",2)
    end)
    PerfSec:AddToggle("Limiter FPS UI", false, "Limite le framerate UI", function(v) end)
    PerfSec:AddSlider("FPS max UI", 15, 60, 60, " fps", function(v) end)
    PerfSec:AddToggle("Réduire effets", false, function(v) end)
    PerfSec:AddButton("Nettoyer la mémoire", function()
        Win:Notify("Système","Mémoire nettoyée !","success",2)
    end)

    -- APPARENCE
    local ThemeSec = AppSub:CreateSection("Thème")
    ThemeSec:SetDescription("Personnalisation des couleurs")
    ThemeSec:AddDropdown("Thème", {"Violet (défaut)","Bleu nuit","Rouge sang","Vert néon","Or royal","Mono"}, "Violet (défaut)", function(v)
        Win:Notify("Apparence","Thème: "..v,"info",2)
    end)
    ThemeSec:AddColorPicker("Couleur accent", Color3.fromRGB(110,50,210), function(c) end)
    ThemeSec:AddColorPicker("Couleur fond", Color3.fromRGB(0,0,0), function(c) end)
    ThemeSec:AddColorPicker("Couleur texte", Color3.fromRGB(255,255,255), function(c) end)
    ThemeSec:AddSeparator()
    ThemeSec:AddSlider("Taille UI", 70, 130, 100, "%", function(v) end)
    ThemeSec:AddDropdown("Police", {"Gotham","GothamBold","Arial","Code"}, "Gotham", function(v) end)

    local StyleSec = AppSub:CreateSection("Style")
    StyleSec:SetDescription("Options visuelles")
    StyleSec:AddToggle("Bordures UI", true, function(v) end)
    StyleSec:AddToggle("Effet glow", true, function(v) end)
    StyleSec:AddToggle("Gradient fond", false, function(v) end)
    StyleSec:AddToggle("Ombre portée", false, function(v) end)
    StyleSec:AddSlider("Épaisseur bordure", 1, 4, 2, "px", function(v) end)
    StyleSec:AddSlider("Opacité fond", 0, 60, 0, "%", function(v) end)

    -- TOUCHES
    local KeySec = KeySub:CreateSection("Raccourcis")
    KeySec:SetDescription("Configurez vos touches clavier")
    KeySec:AddKeybind("Toggle UI", Enum.KeyCode.RightShift, function(k)
        Win:Notify("Touches","Toggle → "..tostring(k):gsub("Enum.KeyCode.",""),"info",2)
    end)
    KeySec:AddKeybind("Panic key", Enum.KeyCode.Delete, function(k)
        Win:Notify("Touches","Panic → "..tostring(k):gsub("Enum.KeyCode.",""),"warning",2)
    end)
    KeySec:AddKeybind("Screenshot", Enum.KeyCode.F12, function(k) end)
    KeySec:AddKeybind("Configs rapides", Enum.KeyCode.F5, function(k) end)
    KeySec:AddSeparator()
    KeySec:AddToggle("Bloquer input jeu", false, "Empêche les touches de passer au jeu", function(v)
        Win:Notify("Touches","Blocage: "..(v and "ON" or "OFF"),"warning",2)
    end)
    KeySec:AddDropdown("Mode activation",{"Appui","Toggle","Maintien"},"Appui",function(v) end)

    -- CONFIGS
    local CfgSec = CfgSub:CreateSection("Gestion")
    CfgSec:SetDescription("Sauvegarde et chargement")
    CfgSec:AddInput("Nom", "MaConfig", function(t,enter)
        if enter and t~="" then Win:Notify("Config","Nom: "..t,"info",2) end
    end)
    CfgSec:AddButton("💾  Sauvegarder", function()
        Win:Notify("Config","Configuration sauvegardée !","success",2.5)
    end)
    CfgSec:AddButton("📂  Charger", function()
        Win:Notify("Config","Configuration chargée !","success",2)
    end)
    CfgSec:AddButton("🗑️  Supprimer", function()
        Win:Notify("Config","Supprimée","warning",2)
    end)
    CfgSec:AddButton("🔄  Rafraîchir", function()
        Win:Notify("Config","Liste rafraîchie","info",1.5)
    end)
    CfgSec:AddSeparator()
    CfgSec:AddDropdown("Config active",{"Default","Config 1","Config 2","Config 3"},"Default",function(v)
        Win:Notify("Config","Sélectionné: "..v,"info",2)
    end)

    local Cfg2Sec = CfgSub:CreateSection("Options auto")
    Cfg2Sec:SetDescription("Gestion automatique")
    Cfg2Sec:AddToggle("Autosave", false, "Sauvegarder automatiquement", function(v)
        Win:Notify("Config","Autosave: "..(v and "ON" or "OFF"),"info",2)
    end)
    Cfg2Sec:AddSlider("Intervalle", 10, 300, 60, "s", function(v) end)
    Cfg2Sec:AddToggle("Charger au démarrage", true, function(v) end)
    Cfg2Sec:AddToggle("Backup auto", false, function(v) end)
    Cfg2Sec:AddButton("↩️  Tout réinitialiser", function()
        Win:Notify("Config","Reset effectué","warning",2)
    end)

    return ST
end

return VioletUI
