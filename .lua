-- VioletUI v5
-- Style exact de la photo : fond noir, sections sombres, violet partout
-- Font : SourceSans uniquement (valide Roblox)

local VioletUI = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local C = {
    BG       = Color3.fromRGB(0, 0, 0),
    Panel    = Color3.fromRGB(11, 11, 11),
    Element  = Color3.fromRGB(17, 17, 17),
    Violet   = Color3.fromRGB(72, 40, 140),
    VioletHi = Color3.fromRGB(110, 60, 200),
    Text     = Color3.fromRGB(255, 255, 255),
    TextDim  = Color3.fromRGB(180, 180, 180),
    Red      = Color3.fromRGB(200, 50, 50),
    Orange   = Color3.fromRGB(200, 130, 30),
    White    = Color3.fromRGB(255, 255, 255),
}

local FONT = Enum.Font.SourceSans
local FONTB = Enum.Font.SourceSansBold

local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

-- ══════════════════════════════════════════
--  NOTIFICATIONS
-- ══════════════════════════════════════════
local function MakeNotif(gui)
    local H = Instance.new("Frame")
    H.BackgroundTransparency = 1
    H.Size = UDim2.new(0, 260, 1, 0)
    H.Position = UDim2.new(1, -270, 0, 0)
    H.ZIndex = 200
    H.Parent = gui
    local l = Instance.new("UIListLayout")
    l.FillDirection = Enum.FillDirection.Vertical
    l.Padding = UDim.new(0, 4)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Parent = H
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, 14)
    p.Parent = H

    return function(title, msg, ntype, dur)
        local accent = ({
            info    = C.Violet,
            success = Color3.fromRGB(50, 180, 80),
            warning = C.Orange,
            error   = C.Red,
        })[ntype or "info"] or C.Violet

        local NF = Instance.new("Frame")
        NF.BackgroundColor3 = C.Panel
        NF.BorderColor3 = accent
        NF.BorderSizePixel = 2
        NF.Size = UDim2.new(1, 0, 0, 62)
        NF.ZIndex = 201
        NF.Parent = H

        local bar = Instance.new("Frame")
        bar.BackgroundColor3 = accent
        bar.BorderSizePixel = 0
        bar.Size = UDim2.new(0, 3, 1, 0)
        bar.ZIndex = 202
        bar.Parent = NF

        local nt = Instance.new("TextLabel")
        nt.BackgroundColor3 = C.Element
        nt.BorderSizePixel = 0
        nt.Size = UDim2.new(1, 0, 0, 22)
        nt.Text = title
        nt.TextColor3 = C.Text
        nt.TextSize = 14
        nt.Font = FONTB
        nt.ZIndex = 202
        nt.Parent = NF

        local nm = Instance.new("TextLabel")
        nm.BackgroundTransparency = 1
        nm.BorderSizePixel = 0
        nm.Position = UDim2.new(0, 6, 0, 24)
        nm.Size = UDim2.new(1, -8, 0, 32)
        nm.Text = msg
        nm.TextColor3 = C.TextDim
        nm.TextSize = 13
        nm.Font = FONT
        nm.TextWrapped = true
        nm.TextXAlignment = Enum.TextXAlignment.Left
        nm.ZIndex = 202
        nm.Parent = NF

        local pbg = Instance.new("Frame")
        pbg.BackgroundColor3 = C.Element
        pbg.BorderSizePixel = 0
        pbg.Size = UDim2.new(1, 0, 0, 2)
        pbg.Position = UDim2.new(0, 0, 1, -2)
        pbg.ZIndex = 203
        pbg.Parent = NF

        local pf = Instance.new("Frame")
        pf.BackgroundColor3 = accent
        pf.BorderSizePixel = 0
        pf.Size = UDim2.new(1, 0, 1, 0)
        pf.ZIndex = 204
        pf.Parent = pbg

        NF.Position = UDim2.new(1, 10, 0, 0)
        Tween(NF, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
        local d = dur or 3
        Tween(pf, {Size = UDim2.new(0, 0, 1, 0)}, d)
        task.delay(d, function()
            Tween(NF, {Position = UDim2.new(1, 10, 0, 0)}, 0.2)
            task.wait(0.25)
            NF:Destroy()
        end)
    end
end

-- ══════════════════════════════════════════
--  CREATE WINDOW
-- ══════════════════════════════════════════
function VioletUI:CreateWindow(cfg)
    cfg = cfg or {}
    local winName   = cfg.Name      or "Violet Hub"
    local toggleKey = cfg.ToggleKey or Enum.KeyCode.RightShift
    local W         = cfg.Width     or 752
    local H         = cfg.Height    or 493
    local logoId    = cfg.Logo      or "rbxassetid://125489582002636"

    local GUI = Instance.new("ScreenGui")
    GUI.Name = "VioletUI"
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GUI.ResetOnSpawn = false
    GUI.DisplayOrder = 999
    GUI.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Notify = MakeNotif(GUI)

    -- Fenêtre principale
    local FrameGui = Instance.new("Frame")
    FrameGui.Name = "FrameGui"
    FrameGui.Parent = GUI
    FrameGui.BackgroundColor3 = C.BG
    FrameGui.BorderColor3 = C.Violet
    FrameGui.BorderSizePixel = 2
    FrameGui.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
    FrameGui.Size = UDim2.new(0, W, 0, H)
    FrameGui.Active = true
    FrameGui.Draggable = true

    -- Logo centré en haut (comme la photo)
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Parent = FrameGui
    Logo.BackgroundTransparency = 1
    Logo.BorderSizePixel = 0
    Logo.Size = UDim2.new(0, 200, 0, 113)
    Logo.Position = UDim2.new(0, 0, 0, 0)
    Logo.Image = logoId

    -- Boutons contrôle (dots)
    local CtrlFrame = Instance.new("Frame")
    CtrlFrame.BackgroundTransparency = 1
    CtrlFrame.BorderSizePixel = 0
    CtrlFrame.Size = UDim2.new(0, 40, 0, 14)
    CtrlFrame.Position = UDim2.new(1, -50, 0, 10)
    CtrlFrame.Parent = FrameGui

    local MinBtn = Instance.new("TextButton")
    MinBtn.BackgroundColor3 = C.Orange
    MinBtn.BorderSizePixel = 0
    MinBtn.Size = UDim2.new(0, 14, 0, 14)
    MinBtn.Position = UDim2.new(0, 0, 0, 0)
    MinBtn.Text = ""
    MinBtn.ZIndex = 2
    MinBtn.Parent = CtrlFrame
    local mc = Instance.new("UICorner"); mc.CornerRadius = UDim.new(1,0); mc.Parent = MinBtn

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.BackgroundColor3 = C.Red
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Size = UDim2.new(0, 14, 0, 14)
    CloseBtn.Position = UDim2.new(0, 20, 0, 0)
    CloseBtn.Text = ""
    CloseBtn.ZIndex = 2
    CloseBtn.Parent = CtrlFrame
    local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(1,0); cc.Parent = CloseBtn

    -- Resize
    local ResizeHandle = Instance.new("TextButton")
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.BorderSizePixel = 0
    ResizeHandle.Size = UDim2.new(0, 16, 0, 16)
    ResizeHandle.Position = UDim2.new(1, -16, 1, -16)
    ResizeHandle.Text = "⤡"
    ResizeHandle.TextColor3 = C.Violet
    ResizeHandle.TextSize = 16
    ResizeHandle.Font = FONT
    ResizeHandle.ZIndex = 10
    ResizeHandle.Parent = FrameGui

    local isResizing = false
    ResizeHandle.MouseButton1Down:Connect(function()
        isResizing = true
        local sp = UserInputService:GetMouseLocation()
        local ss = FrameGui.Size
        local mv = UserInputService.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement and isResizing then
                local mp = UserInputService:GetMouseLocation()
                FrameGui.Size = UDim2.new(0, math.max(500, ss.X.Offset + mp.X - sp.X), 0, math.max(350, ss.Y.Offset + mp.Y - sp.Y))
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                isResizing = false; mv:Disconnect()
            end
        end)
    end)

    -- Sidebar tabs (style exact photo)
    local FrameTab = Instance.new("Frame")
    FrameTab.Name = "FrameTab"
    FrameTab.Parent = FrameGui
    FrameTab.BackgroundColor3 = C.Panel
    FrameTab.BorderSizePixel = 0
    FrameTab.Position = UDim2.new(0, 0, 0, 113)
    FrameTab.Size = UDim2.new(0, 200, 1, -113)

    -- Search bar bas sidebar
    local SearchBox = Instance.new("TextBox")
    SearchBox.BackgroundColor3 = C.Element
    SearchBox.BorderColor3 = C.Violet
    SearchBox.BorderSizePixel = 1
    SearchBox.Size = UDim2.new(1, -12, 0, 24)
    SearchBox.Position = UDim2.new(0, 6, 1, -30)
    SearchBox.PlaceholderText = "Rechercher..."
    SearchBox.Text = ""
    SearchBox.TextColor3 = C.Text
    SearchBox.PlaceholderColor3 = Color3.fromRGB(100,100,100)
    SearchBox.TextSize = 14
    SearchBox.Font = FONT
    SearchBox.ClearTextOnFocus = false
    SearchBox.ZIndex = 3
    SearchBox.Parent = FrameTab

    -- Logo bas sidebar
    local SideLogo = Instance.new("ImageLabel")
    SideLogo.BackgroundTransparency = 1
    SideLogo.BorderSizePixel = 0
    SideLogo.Size = UDim2.new(0, 36, 0, 36)
    SideLogo.Position = UDim2.new(0.5, -18, 1, -70)
    SideLogo.Image = logoId
    SideLogo.ZIndex = 3
    SideLogo.Parent = FrameTab

    -- Scroll pour les tab buttons
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel = 0
    TabScroll.Size = UDim2.new(1, 0, 1, -110)
    TabScroll.Position = UDim2.new(0, 0, 0, 4)
    TabScroll.ScrollBarThickness = 2
    TabScroll.ScrollBarImageColor3 = C.Violet
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.ZIndex = 3
    TabScroll.Parent = FrameTab
    local tsl = Instance.new("UIListLayout")
    tsl.FillDirection = Enum.FillDirection.Vertical
    tsl.Padding = UDim.new(0, 2)
    tsl.SortOrder = Enum.SortOrder.LayoutOrder
    tsl.Parent = TabScroll
    local tsp = Instance.new("UIPadding")
    tsp.PaddingTop = UDim.new(0, 4)
    tsp.PaddingLeft = UDim.new(0, 8)
    tsp.PaddingRight = UDim.new(0, 8)
    tsp.Parent = TabScroll

    tsl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabScroll.CanvasSize = UDim2.new(0, 0, 0, tsl.AbsoluteContentSize.Y + 8)
    end)

    -- Zone contenu (à droite de la sidebar)
    local FrameElement = Instance.new("Frame")
    FrameElement.Name = "FrameElement"
    FrameElement.Parent = FrameGui
    FrameElement.BackgroundTransparency = 1
    FrameElement.BorderSizePixel = 0
    FrameElement.Position = UDim2.new(0, 200, 0, 0)
    FrameElement.Size = UDim2.new(1, -200, 1, 0)

    -- Barre sub-tabs horizontale
    local SubTabBar = Instance.new("Frame")
    SubTabBar.Name = "SubTabBar"
    SubTabBar.Parent = FrameElement
    SubTabBar.BackgroundColor3 = C.BG
    SubTabBar.BorderColor3 = C.Violet
    SubTabBar.BorderSizePixel = 1
    SubTabBar.Size = UDim2.new(1, 0, 0, 30)
    SubTabBar.Position = UDim2.new(0, 0, 0, 0)
    SubTabBar.ZIndex = 3
    local stbl = Instance.new("UIListLayout")
    stbl.FillDirection = Enum.FillDirection.Horizontal
    stbl.SortOrder = Enum.SortOrder.LayoutOrder
    stbl.Parent = SubTabBar
    local stbp = Instance.new("UIPadding")
    stbp.PaddingLeft = UDim.new(0, 4)
    stbp.PaddingTop = UDim.new(0, 4)
    stbp.Parent = SubTabBar

    -- Scroll contenu colonnes
    local ColScroll = Instance.new("ScrollingFrame")
    ColScroll.BackgroundTransparency = 1
    ColScroll.BorderSizePixel = 0
    ColScroll.Size = UDim2.new(1, 0, 1, -30)
    ColScroll.Position = UDim2.new(0, 0, 0, 30)
    ColScroll.ScrollBarThickness = 3
    ColScroll.ScrollBarImageColor3 = C.Violet
    ColScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ColScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ColScroll.ZIndex = 3
    ColScroll.Parent = FrameElement

    local ColsHolder = Instance.new("Frame")
    ColsHolder.BackgroundTransparency = 1
    ColsHolder.BorderSizePixel = 0
    ColsHolder.Size = UDim2.new(1, 0, 0, 0)
    ColsHolder.AutomaticSize = Enum.AutomaticSize.Y
    ColsHolder.ZIndex = 4
    ColsHolder.Parent = ColScroll
    local chl = Instance.new("UIListLayout")
    chl.FillDirection = Enum.FillDirection.Horizontal
    chl.Padding = UDim.new(0, 0)
    chl.VerticalAlignment = Enum.VerticalAlignment.Top
    chl.SortOrder = Enum.SortOrder.LayoutOrder
    chl.Parent = ColsHolder
    local chp = Instance.new("UIPadding")
    chp.PaddingTop = UDim.new(0, 8)
    chp.PaddingLeft = UDim.new(0, 8)
    chp.PaddingRight = UDim.new(0, 8)
    chp.PaddingBottom = UDim.new(0, 8)
    chp.Parent = ColsHolder

    -- ── ÉTAT ──
    local tabs = {}
    local curTab = nil
    local isVisible = true
    local isMin = false

    local Win = {}
    function Win:Notify(t, m, tp, d) Notify(t, m, tp, d) end

    -- ══════════════════════════════════════
    --  CREATE TAB
    -- ══════════════════════════════════════
    function Win:CreateTab(name, icon)
        local td = {name=name, subTabs={}, curSub=nil}

        -- Bouton tab sidebar (style exact photo)
        local TB = Instance.new("TextButton")
        TB.Name = name.."Tab"
        TB.Parent = TabScroll
        TB.BackgroundColor3 = C.Element
        TB.BorderColor3 = C.Violet
        TB.BorderSizePixel = 1
        TB.Size = UDim2.new(1, 0, 0, 27)
        TB.Text = (icon and icon.." " or "") .. name
        TB.TextColor3 = C.Text
        TB.TextSize = 14
        TB.Font = FONT
        TB.ZIndex = 4

        -- Container sub-tabs
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

        -- Container colonnes
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

        td.Button   = TB
        td.SubCont  = SubCont
        td.ColCont  = ColCont
        table.insert(tabs, td)

        local function Activate()
            for _, t in ipairs(tabs) do
                t.Button.BackgroundColor3 = C.Element
                t.Button.TextColor3 = C.Text
                t.SubCont.Visible = false
                t.ColCont.Visible = false
            end
            TB.BackgroundColor3 = C.Violet
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
            if curTab ~= td then TB.BackgroundColor3 = Color3.fromRGB(30, 15, 60) end
        end)
        TB.MouseLeave:Connect(function()
            if curTab ~= td then TB.BackgroundColor3 = C.Element end
        end)
        if #tabs == 1 then task.defer(Activate) end

        local Tab = {}

        -- ══════════════════════════════════
        --  CREATE SUBTAB
        -- ══════════════════════════════════
        function Tab:CreateSubTab(sname)
            local sd = {name=sname}

            local SB = Instance.new("TextButton")
            SB.Name = "SB_"..sname
            SB.Parent = SubCont
            SB.BackgroundColor3 = C.BG
            SB.BorderColor3 = C.Violet
            SB.BorderSizePixel = 1
            SB.AutomaticSize = Enum.AutomaticSize.X
            SB.Size = UDim2.new(0, 0, 1, -4)
            SB.Text = sname
            SB.TextColor3 = C.TextDim
            SB.TextSize = 14
            SB.Font = FONT
            SB.ZIndex = 5
            local sbp = Instance.new("UIPadding")
            sbp.PaddingLeft = UDim.new(0, 10)
            sbp.PaddingRight = UDim.new(0, 10)
            sbp.Parent = SB

            -- underline actif
            local SBLine = Instance.new("Frame")
            SBLine.BackgroundColor3 = C.Violet
            SBLine.BorderSizePixel = 0
            SBLine.Size = UDim2.new(1, 0, 0, 2)
            SBLine.Position = UDim2.new(0, 0, 1, -2)
            SBLine.Visible = false
            SBLine.ZIndex = 6
            SBLine.Parent = SB

            -- Scroll pour ce sous-tab
            local SubScroll = Instance.new("ScrollingFrame")
            SubScroll.BackgroundTransparency = 1
            SubScroll.BorderSizePixel = 0
            SubScroll.Size = UDim2.new(1, 0, 0, 0)
            SubScroll.AutomaticSize = Enum.AutomaticSize.Y
            SubScroll.CanvasSize = UDim2.new(0,0,0,0)
            SubScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            SubScroll.ScrollBarThickness = 0
            SubScroll.Visible = false
            SubScroll.ZIndex = 6
            SubScroll.Parent = ColCont

            local SubColFrame = Instance.new("Frame")
            SubColFrame.BackgroundTransparency = 1
            SubColFrame.BorderSizePixel = 0
            SubColFrame.Size = UDim2.new(1, 0, 0, 0)
            SubColFrame.AutomaticSize = Enum.AutomaticSize.Y
            SubColFrame.ZIndex = 7
            SubColFrame.Parent = SubScroll
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
                    s.Button.TextColor3 = C.TextDim
                    s.Button.BackgroundColor3 = C.BG
                    s.Line.Visible = false
                    s.ScrollF.Visible = false
                end
                SB.TextColor3 = C.Text
                SB.BackgroundColor3 = C.Panel
                SBLine.Visible = true
                SubScroll.Visible = true
                td.curSub = sd
            end
            sd.activate = ActivateSub

            SB.MouseButton1Click:Connect(ActivateSub)
            table.insert(td.subTabs, sd)
            if #td.subTabs == 1 and curTab == td then task.defer(ActivateSub) end

            local SubTabObj = {}

            -- ════════════════════════════════
            --  CREATE SECTION
            -- ════════════════════════════════
            function SubTabObj:CreateSection(secname)
                -- Section = colonne (style photo : fond sombre, pas de bordure arrondie)
                local Sec = Instance.new("Frame")
                Sec.Name = "Section"
                Sec.Parent = SubColFrame
                Sec.BackgroundColor3 = C.Panel
                Sec.BorderSizePixel = 0
                Sec.Size = UDim2.new(0, 252, 0, 0)
                Sec.AutomaticSize = Enum.AutomaticSize.Y
                Sec.ZIndex = 8

                -- Titre section (style photo)
                local SecTitle = Instance.new("TextLabel")
                SecTitle.Parent = Sec
                SecTitle.BackgroundColor3 = C.Panel
                SecTitle.BorderSizePixel = 0
                SecTitle.Size = UDim2.new(1, 0, 0, 22)
                SecTitle.Text = secname
                SecTitle.TextColor3 = Color3.fromRGB(160, 100, 255)
                SecTitle.TextSize = 14
                SecTitle.Font = FONTB
                SecTitle.TextXAlignment = Enum.TextXAlignment.Left
                SecTitle.ZIndex = 9
                local stp = Instance.new("UIPadding")
                stp.PaddingLeft = UDim.new(0, 8)
                stp.Parent = SecTitle

                -- Ligne violet sous titre
                local SecLine = Instance.new("Frame")
                SecLine.Parent = Sec
                SecLine.BackgroundColor3 = C.Violet
                SecLine.BorderSizePixel = 0
                SecLine.Size = UDim2.new(1, 0, 0, 1)
                SecLine.Position = UDim2.new(0, 0, 0, 22)
                SecLine.ZIndex = 9

                -- Sous-titre description
                local SecDesc = Instance.new("TextLabel")
                SecDesc.Parent = Sec
                SecDesc.BackgroundTransparency = 1
                SecDesc.BorderSizePixel = 0
                SecDesc.Position = UDim2.new(0, 0, 0, 23)
                SecDesc.Size = UDim2.new(1, 0, 0, 0)
                SecDesc.Text = ""
                SecDesc.TextColor3 = Color3.fromRGB(130, 120, 150)
                SecDesc.TextSize = 12
                SecDesc.Font = FONT
                SecDesc.TextXAlignment = Enum.TextXAlignment.Left
                SecDesc.ZIndex = 9
                SecDesc.AutomaticSize = Enum.AutomaticSize.Y
                SecDesc.TextWrapped = true
                local sdp = Instance.new("UIPadding")
                sdp.PaddingLeft = UDim.new(0, 8)
                sdp.PaddingRight = UDim.new(0, 4)
                sdp.Parent = SecDesc

                -- Items
                local Items = Instance.new("Frame")
                Items.Name = "Items"
                Items.Parent = Sec
                Items.BackgroundTransparency = 1
                Items.BorderSizePixel = 0
                Items.Size = UDim2.new(1, 0, 0, 0)
                Items.AutomaticSize = Enum.AutomaticSize.Y
                Items.Position = UDim2.new(0, 0, 0, 23)
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
                    SecDesc.Text = txt
                    Items.Position = UDim2.new(0, 0, 0, 23 + SecDesc.TextBounds.Y + 4)
                end

                -- ══════════════════════════
                --  TOGGLE (checkbox carré)
                -- ══════════════════════════
                function S:AddToggle(lbl, default, hint, cb)
                    if type(hint) == "function" then cb=hint; hint=nil end
                    if type(default) == "function" then cb=default; default=false end
                    local val = default == true

                    local Row = Instance.new("Frame")
                    Row.Parent = Items
                    Row.BackgroundColor3 = C.Element
                    Row.BorderSizePixel = 0
                    Row.Size = UDim2.new(1, 0, 0, 24)
                    Row.ZIndex = 10

                    -- Checkbox (style exact photo : carré avec bordure violette)
                    local Box = Instance.new("TextButton")
                    Box.Parent = Row
                    Box.BackgroundColor3 = val and C.Violet or C.Element
                    Box.BorderColor3 = C.Violet
                    Box.BorderSizePixel = 2
                    Box.Size = UDim2.new(0, 16, 0, 16)
                    Box.Position = UDim2.new(0, 4, 0.5, -8)
                    Box.Text = val and "✓" or ""
                    Box.TextColor3 = C.White
                    Box.TextSize = 12
                    Box.Font = FONTB
                    Box.ZIndex = 11

                    local Lbl = Instance.new("TextLabel")
                    Lbl.Parent = Row
                    Lbl.BackgroundTransparency = 1
                    Lbl.BorderSizePixel = 0
                    Lbl.Position = UDim2.new(0, 26, 0, 0)
                    Lbl.Size = UDim2.new(1, -46, 1, 0)
                    Lbl.Text = lbl
                    Lbl.TextColor3 = C.Text
                    Lbl.TextSize = 14
                    Lbl.Font = FONT
                    Lbl.TextXAlignment = Enum.TextXAlignment.Left
                    Lbl.ZIndex = 11

                    -- Hint "?" (style photo)
                    if hint then
                        local HB = Instance.new("TextButton")
                        HB.Parent = Row
                        HB.BackgroundColor3 = C.Violet
                        HB.BorderSizePixel = 0
                        HB.Size = UDim2.new(0, 16, 0, 16)
                        HB.Position = UDim2.new(1, -20, 0.5, -8)
                        HB.Text = "?"
                        HB.TextColor3 = C.White
                        HB.TextSize = 12
                        HB.Font = FONTB
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
                        Box.BackgroundColor3 = v and C.Violet or C.Element
                        Box.Text = v and "✓" or ""
                        if not silent and cb then cb(v) end
                    end
                    ClickBtn.MouseButton1Click:Connect(function() Set(not val) end)
                    Row.MouseEnter:Connect(function() Row.BackgroundColor3 = Color3.fromRGB(25, 18, 40) end)
                    Row.MouseLeave:Connect(function() Row.BackgroundColor3 = C.Element end)
                    function obj:Set(v) Set(v, true) end
                    return obj
                end

                -- ══════════════════════════
                --  SLIDER (style photo)
                -- ══════════════════════════
                function S:AddSlider(lbl, min, max, default, suffix, cb)
                    if type(suffix) == "function" then cb=suffix; suffix="" end
                    local val = math.clamp(default or min, min, max)
                    suffix = suffix or ""

                    local Container = Instance.new("Frame")
                    Container.Parent = Items
                    Container.BackgroundColor3 = C.Element
                    Container.BorderSizePixel = 0
                    Container.Size = UDim2.new(1, 0, 0, 38)
                    Container.ZIndex = 10

                    -- Titre + valeur (style photo : "Smoothness   0%")
                    local LblF = Instance.new("TextLabel")
                    LblF.Parent = Container
                    LblF.BackgroundTransparency = 1
                    LblF.Position = UDim2.new(0, 6, 0, 2)
                    LblF.Size = UDim2.new(0.65, 0, 0, 16)
                    LblF.Text = lbl
                    LblF.TextColor3 = C.Text
                    LblF.TextSize = 14
                    LblF.Font = FONT
                    LblF.TextXAlignment = Enum.TextXAlignment.Left
                    LblF.ZIndex = 11

                    local ValF = Instance.new("TextLabel")
                    ValF.Parent = Container
                    ValF.BackgroundTransparency = 1
                    ValF.Position = UDim2.new(0.65, 0, 0, 2)
                    ValF.Size = UDim2.new(0.35, -6, 0, 16)
                    ValF.Text = tostring(math.floor(val))..suffix
                    ValF.TextColor3 = C.TextDim
                    ValF.TextSize = 13
                    ValF.Font = FONT
                    ValF.TextXAlignment = Enum.TextXAlignment.Right
                    ValF.ZIndex = 11

                    -- Track (style photo : barre violette)
                    local Track = Instance.new("Frame")
                    Track.Parent = Container
                    Track.BackgroundColor3 = C.BG
                    Track.BorderColor3 = C.Violet
                    Track.BorderSizePixel = 1
                    Track.Position = UDim2.new(0, 6, 0, 22)
                    Track.Size = UDim2.new(1, -12, 0, 8)
                    Track.ZIndex = 11

                    local pct = (val - min) / (max - min)
                    local Fill = Instance.new("Frame")
                    Fill.Parent = Track
                    Fill.BackgroundColor3 = C.Violet
                    Fill.BorderSizePixel = 0
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    Fill.ZIndex = 12

                    local Knob = Instance.new("Frame")
                    Knob.Parent = Track
                    Knob.BackgroundColor3 = C.White
                    Knob.BorderColor3 = C.Violet
                    Knob.BorderSizePixel = 1
                    Knob.Size = UDim2.new(0, 8, 0, 12)
                    Knob.Position = UDim2.new(pct, -4, 0.5, -6)
                    Knob.ZIndex = 13

                    local HitBtn = Instance.new("TextButton")
                    HitBtn.Parent = Container
                    HitBtn.BackgroundTransparency = 1
                    HitBtn.BorderSizePixel = 0
                    HitBtn.Position = UDim2.new(0, 0, 0, 16)
                    HitBtn.Size = UDim2.new(1, 0, 0, 22)
                    HitBtn.Text = ""
                    HitBtn.ZIndex = 14

                    local drag = false
                    local obj = {Value = val}
                    local function Update(mx)
                        local r = math.clamp((mx - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                        val = min + (max - min) * r
                        obj.Value = val
                        Fill.Size = UDim2.new(r, 0, 1, 0)
                        Knob.Position = UDim2.new(r, -4, 0.5, -6)
                        ValF.Text = tostring(math.floor(val * 10 + 0.5) / 10) .. suffix
                        if cb then cb(val) end
                    end
                    HitBtn.MouseButton1Down:Connect(function() drag=true; Update(UserInputService:GetMouseLocation().X) end)
                    UserInputService.InputEnded:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag=false end
                    end)
                    UserInputService.InputChanged:Connect(function(i)
                        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
                            Update(UserInputService:GetMouseLocation().X)
                        end
                    end)
                    Container.MouseEnter:Connect(function() Container.BackgroundColor3 = Color3.fromRGB(22, 15, 35) end)
                    Container.MouseLeave:Connect(function() Container.BackgroundColor3 = C.Element end)

                    function obj:Set(v)
                        val = math.clamp(v, min, max); obj.Value = val
                        local r = (val-min)/(max-min)
                        Fill.Size = UDim2.new(r,0,1,0)
                        Knob.Position = UDim2.new(r,-4,0.5,-6)
                        ValF.Text = tostring(val)..suffix
                    end
                    return obj
                end

                -- ══════════════════════════
                --  DROPDOWN (style photo)
                -- ══════════════════════════
                function S:AddDropdown(lbl, opts, default, cb)
                    local sel = default or opts[1] or ""
                    local open = false

                    local Container = Instance.new("Frame")
                    Container.Parent = Items
                    Container.BackgroundColor3 = C.Element
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
                    LblD.TextColor3 = C.TextDim
                    LblD.TextSize = 13
                    LblD.Font = FONT
                    LblD.TextXAlignment = Enum.TextXAlignment.Left
                    LblD.ZIndex = 11

                    -- Bouton dropdown (style photo : fond sombre bordure violette flèche)
                    local DB = Instance.new("TextButton")
                    DB.Parent = Container
                    DB.BackgroundColor3 = C.BG
                    DB.BorderColor3 = C.Violet
                    DB.BorderSizePixel = 1
                    DB.Position = UDim2.new(0.4, 0, 0.5, -10)
                    DB.Size = UDim2.new(0.58, 0, 0, 20)
                    DB.Text = ""
                    DB.ZIndex = 11

                    local SelLbl = Instance.new("TextLabel")
                    SelLbl.Parent = DB
                    SelLbl.BackgroundTransparency = 1
                    SelLbl.Position = UDim2.new(0, 4, 0, 0)
                    SelLbl.Size = UDim2.new(1, -20, 1, 0)
                    SelLbl.Text = sel
                    SelLbl.TextColor3 = C.Text
                    SelLbl.TextSize = 13
                    SelLbl.Font = FONT
                    SelLbl.TextXAlignment = Enum.TextXAlignment.Left
                    SelLbl.ZIndex = 12

                    local Arrow = Instance.new("TextLabel")
                    Arrow.Parent = DB
                    Arrow.BackgroundTransparency = 1
                    Arrow.Position = UDim2.new(1, -18, 0, 0)
                    Arrow.Size = UDim2.new(0, 16, 1, 0)
                    Arrow.Text = "▾"
                    Arrow.TextColor3 = Color3.fromRGB(160, 100, 255)
                    Arrow.TextSize = 14
                    Arrow.Font = FONT
                    Arrow.ZIndex = 12

                    local DL = Instance.new("Frame")
                    DL.Parent = DB
                    DL.BackgroundColor3 = C.Panel
                    DL.BorderColor3 = C.Violet
                    DL.BorderSizePixel = 2
                    DL.Position = UDim2.new(0, 0, 1, 1)
                    DL.Size = UDim2.new(1, 0, 0, #opts * 22)
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
                        OB.BackgroundColor3 = C.Element
                        OB.BorderSizePixel = 0
                        OB.Size = UDim2.new(1, 0, 0, 22)
                        OB.Text = opt
                        OB.TextColor3 = opt==sel and Color3.fromRGB(160,100,255) or C.Text
                        OB.TextSize = 13
                        OB.Font = FONT
                        OB.ZIndex = 51
                        OB.MouseEnter:Connect(function() OB.BackgroundColor3 = Color3.fromRGB(40,20,70) end)
                        OB.MouseLeave:Connect(function() OB.BackgroundColor3 = C.Element end)
                        OB.MouseButton1Click:Connect(function()
                            sel=opt; SelLbl.Text=opt; open=false; DL.Visible=false
                            if cb then cb(opt) end
                        end)
                    end

                    DB.MouseButton1Click:Connect(function() open=not open; DL.Visible=open end)
                    Container.MouseEnter:Connect(function() Container.BackgroundColor3 = Color3.fromRGB(22,15,35) end)
                    Container.MouseLeave:Connect(function() Container.BackgroundColor3 = C.Element end)

                    local obj = {Value = sel}
                    function obj:Set(v) sel=v; SelLbl.Text=v; obj.Value=v end
                    return obj
                end

                -- ══════════════════════════
                --  BUTTON
                -- ══════════════════════════
                function S:AddButton(lbl, cb)
                    local B = Instance.new("TextButton")
                    B.Parent = Items
                    B.BackgroundColor3 = C.Violet
                    B.BorderColor3 = C.VioletHi
                    B.BorderSizePixel = 1
                    B.Size = UDim2.new(1, 0, 0, 24)
                    B.Text = lbl
                    B.TextColor3 = C.White
                    B.TextSize = 14
                    B.Font = FONT
                    B.ZIndex = 10
                    B.MouseEnter:Connect(function() B.BackgroundColor3 = C.VioletHi end)
                    B.MouseLeave:Connect(function() B.BackgroundColor3 = C.Violet end)
                    B.MouseButton1Down:Connect(function() B.BackgroundColor3 = Color3.fromRGB(50, 20, 100) end)
                    B.MouseButton1Up:Connect(function() B.BackgroundColor3 = C.Violet end)
                    B.MouseButton1Click:Connect(function() if cb then cb() end end)
                    return B
                end

                -- ══════════════════════════
                --  INPUT
                -- ══════════════════════════
                function S:AddInput(lbl, placeholder, cb)
                    local Container = Instance.new("Frame")
                    Container.Parent = Items
                    Container.BackgroundColor3 = C.Element
                    Container.BorderSizePixel = 0
                    Container.Size = UDim2.new(1, 0, 0, 26)
                    Container.ZIndex = 10

                    local LblI = Instance.new("TextLabel")
                    LblI.Parent = Container
                    LblI.BackgroundTransparency = 1
                    LblI.Position = UDim2.new(0, 6, 0, 0)
                    LblI.Size = UDim2.new(0.38, 0, 1, 0)
                    LblI.Text = lbl
                    LblI.TextColor3 = C.TextDim
                    LblI.TextSize = 13
                    LblI.Font = FONT
                    LblI.TextXAlignment = Enum.TextXAlignment.Left
                    LblI.ZIndex = 11

                    local TB2 = Instance.new("TextBox")
                    TB2.Parent = Container
                    TB2.BackgroundColor3 = C.BG
                    TB2.BorderColor3 = C.Violet
                    TB2.BorderSizePixel = 1
                    TB2.Position = UDim2.new(0.38, 0, 0.5, -10)
                    TB2.Size = UDim2.new(0.6, 0, 0, 20)
                    TB2.PlaceholderText = placeholder or ""
                    TB2.Text = ""
                    TB2.TextColor3 = C.Text
                    TB2.PlaceholderColor3 = Color3.fromRGB(100,100,100)
                    TB2.TextSize = 13
                    TB2.Font = FONT
                    TB2.ClearTextOnFocus = false
                    TB2.ZIndex = 11
                    local ibp = Instance.new("UIPadding")
                    ibp.PaddingLeft = UDim.new(0,4); ibp.PaddingRight = UDim.new(0,4); ibp.Parent = TB2
                    TB2.Focused:Connect(function() TB2.BorderColor3 = C.VioletHi end)
                    TB2.FocusLost:Connect(function(enter)
                        TB2.BorderColor3 = C.Violet
                        if cb then cb(TB2.Text, enter) end
                    end)
                    return TB2
                end

                -- ══════════════════════════
                --  KEYBIND
                -- ══════════════════════════
                function S:AddKeybind(lbl, defaultKey, cb)
                    local curKey = defaultKey or Enum.KeyCode.Unknown

                    local Container = Instance.new("Frame")
                    Container.Parent = Items
                    Container.BackgroundColor3 = C.Element
                    Container.BorderSizePixel = 0
                    Container.Size = UDim2.new(1, 0, 0, 26)
                    Container.ZIndex = 10

                    local LblK = Instance.new("TextLabel")
                    LblK.Parent = Container
                    LblK.BackgroundTransparency = 1
                    LblK.Position = UDim2.new(0, 6, 0, 0)
                    LblK.Size = UDim2.new(0.6, 0, 1, 0)
                    LblK.Text = lbl
                    LblK.TextColor3 = C.Text
                    LblK.TextSize = 14
                    LblK.Font = FONT
                    LblK.TextXAlignment = Enum.TextXAlignment.Left
                    LblK.ZIndex = 11

                    local KB = Instance.new("TextButton")
                    KB.Parent = Container
                    KB.BackgroundColor3 = C.BG
                    KB.BorderColor3 = C.Violet
                    KB.BorderSizePixel = 1
                    KB.Position = UDim2.new(0.62, 0, 0.5, -10)
                    KB.Size = UDim2.new(0.36, 0, 0, 20)
                    KB.Text = tostring(curKey):gsub("Enum.KeyCode.", "")
                    KB.TextColor3 = Color3.fromRGB(160, 100, 255)
                    KB.TextSize = 13
                    KB.Font = FONT
                    KB.ZIndex = 11

                    KB.MouseButton1Click:Connect(function()
                        KB.Text = "..."
                        KB.BackgroundColor3 = Color3.fromRGB(30, 10, 60)
                        local conn; conn = UserInputService.InputBegan:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.Keyboard then
                                curKey = inp.KeyCode
                                KB.Text = tostring(curKey):gsub("Enum.KeyCode.", "")
                                KB.BackgroundColor3 = C.BG
                                if cb then cb(curKey) end
                                conn:Disconnect()
                            end
                        end)
                    end)
                    Container.MouseEnter:Connect(function() Container.BackgroundColor3 = Color3.fromRGB(22,15,35) end)
                    Container.MouseLeave:Connect(function() Container.BackgroundColor3 = C.Element end)

                    local obj = {Value = curKey}
                    function obj:Set(k) curKey=k; obj.Value=k; KB.Text=tostring(k):gsub("Enum.KeyCode.","") end
                    return obj
                end

                -- ══════════════════════════
                --  COLOR PICKER
                -- ══════════════════════════
                function S:AddColorPicker(lbl, default, cb)
                    local col = default or C.Violet

                    local Container = Instance.new("Frame")
                    Container.Parent = Items
                    Container.BackgroundColor3 = C.Element
                    Container.BorderSizePixel = 0
                    Container.Size = UDim2.new(1, 0, 0, 26)
                    Container.ZIndex = 10

                    local LblC = Instance.new("TextLabel")
                    LblC.Parent = Container
                    LblC.BackgroundTransparency = 1
                    LblC.Position = UDim2.new(0, 6, 0, 0)
                    LblC.Size = UDim2.new(0.62, 0, 1, 0)
                    LblC.Text = lbl
                    LblC.TextColor3 = C.Text
                    LblC.TextSize = 14
                    LblC.Font = FONT
                    LblC.TextXAlignment = Enum.TextXAlignment.Left
                    LblC.ZIndex = 11

                    local Prev = Instance.new("TextButton")
                    Prev.Parent = Container
                    Prev.BackgroundColor3 = col
                    Prev.BorderColor3 = C.Violet
                    Prev.BorderSizePixel = 2
                    Prev.Position = UDim2.new(1, -44, 0.5, -9)
                    Prev.Size = UDim2.new(0, 38, 0, 18)
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
                    Pal.BackgroundColor3 = C.Panel
                    Pal.BorderColor3 = C.Violet
                    Pal.BorderSizePixel = 2
                    Pal.Position = UDim2.new(0.3, 0, 1, 2)
                    Pal.Size = UDim2.new(0, 160, 0, 50)
                    Pal.Visible = false
                    Pal.ZIndex = 60
                    local pg = Instance.new("UIGridLayout")
                    pg.CellSize = UDim2.new(0, 16, 0, 16)
                    pg.CellPadding = UDim2.new(0, 3, 0, 3)
                    pg.Parent = Pal
                    local palp = Instance.new("UIPadding")
                    palp.PaddingTop = UDim.new(0,5); palp.PaddingLeft = UDim.new(0,5); palp.Parent = Pal

                    for _, pc in ipairs(palette) do
                        local PB = Instance.new("TextButton")
                        PB.Parent = Pal
                        PB.BackgroundColor3 = pc
                        PB.BorderColor3 = C.Violet
                        PB.BorderSizePixel = 1
                        PB.Size = UDim2.new(0,16,0,16)
                        PB.Text = ""
                        PB.ZIndex = 61
                        PB.MouseButton1Click:Connect(function()
                            col=pc; Prev.BackgroundColor3=pc; Pal.Visible=false
                            if cb then cb(pc) end
                        end)
                    end

                    local po = false
                    Prev.MouseButton1Click:Connect(function() po=not po; Pal.Visible=po end)

                    local obj = {Value = col}
                    function obj:Set(c) col=c; obj.Value=c; Prev.BackgroundColor3=c end
                    return obj
                end

                -- ══════════════════════════
                --  LABEL
                -- ══════════════════════════
                function S:AddLabel(txt, col)
                    local L = Instance.new("TextLabel")
                    L.Parent = Items
                    L.BackgroundTransparency = 1
                    L.BorderSizePixel = 0
                    L.Size = UDim2.new(1, 0, 0, 18)
                    L.Text = txt
                    L.TextColor3 = col or C.TextDim
                    L.TextSize = 13
                    L.Font = FONT
                    L.TextXAlignment = Enum.TextXAlignment.Left
                    L.ZIndex = 10
                    return L
                end

                -- ══════════════════════════
                --  SEPARATOR
                -- ══════════════════════════
                function S:AddSeparator()
                    local Sep = Instance.new("Frame")
                    Sep.Parent = Items
                    Sep.BackgroundColor3 = C.Violet
                    Sep.BorderSizePixel = 0
                    Sep.Size = UDim2.new(1, 0, 0, 1)
                    Sep.ZIndex = 10
                    return Sep
                end

                return S
            end -- CreateSection

            return SubTabObj
        end -- CreateSubTab

        return Tab
    end -- CreateTab

    -- Contrôles
    MinBtn.MouseButton1Click:Connect(function()
        isMin = not isMin
        Tween(FrameGui, {Size = UDim2.new(0, W, 0, isMin and 40 or H)}, 0.2)
    end)
    CloseBtn.MouseButton1Click:Connect(function() GUI:Destroy() end)
    UserInputService.InputBegan:Connect(function(inp, proc)
        if not proc and inp.KeyCode == toggleKey then
            isVisible = not isVisible
            FrameGui.Visible = isVisible
        end
    end)

    return Win
end

-- ══════════════════════════════════════════
--  TAB PARAMÈTRES COMPLET
-- ══════════════════════════════════════════
function VioletUI:AddSettingsTab(Win)
    local ST = Win:CreateTab("Parametres", "⚙")
    local GenSub = ST:CreateSubTab("General")
    local AppSub = ST:CreateSubTab("Apparence")
    local KeySub = ST:CreateSubTab("Touches")
    local CfgSub = ST:CreateSubTab("Configs")

    -- GENERAL
    local GenSec = GenSub:CreateSection("General")
    GenSec:AddToggle("Notifications", true, "Activer les notifications", function(v)
        Win:Notify("Parametres", "Notifications: "..(v and "ON" or "OFF"), v and "success" or "info", 2)
    end)
    GenSec:AddToggle("Sons UI", false, "Sons lors des clics", function(v) end)
    GenSec:AddToggle("Animations", true, "Activer les tweens", function(v) end)
    GenSec:AddToggle("Tooltips", true, "Afficher les bulles ?", function(v) end)
    GenSec:AddSeparator()
    GenSec:AddDropdown("Langue", {"Francais","English","Espanol","Deutsch"}, "Francais", function(v)
        Win:Notify("Parametres","Langue: "..v,"info",2)
    end)
    GenSec:AddSlider("Opacite UI", 40, 100, 100, "%", function(v) end)
    GenSec:AddSlider("Delai notif.", 1, 10, 3, "s", function(v) end)

    local PerfSec = GenSub:CreateSection("Performance")
    PerfSec:AddToggle("Mode performance", false, "Reduit les effets", function(v)
        Win:Notify("Parametres","Mode perf: "..(v and "ON" or "OFF"),"warning",2)
    end)
    PerfSec:AddToggle("Limiter FPS UI", false, "Limite le framerate UI", function(v) end)
    PerfSec:AddSlider("FPS max UI", 15, 60, 60, " fps", function(v) end)
    PerfSec:AddToggle("Reduire effets", false, function(v) end)
    PerfSec:AddButton("Nettoyer la memoire", function()
        Win:Notify("Systeme","Memoire nettoyee !","success",2)
    end)

    -- APPARENCE
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
    StyleSec:AddToggle("Gradient fond", false, function(v) end)
    StyleSec:AddSlider("Opacite fond", 0, 60, 0, "%", function(v) end)

    -- TOUCHES
    local KeySec = KeySub:CreateSection("Raccourcis")
    KeySec:AddKeybind("Toggle UI", Enum.KeyCode.RightShift, function(k)
        Win:Notify("Touches","Toggle -> "..tostring(k):gsub("Enum.KeyCode.",""),"info",2)
    end)
    KeySec:AddKeybind("Panic key", Enum.KeyCode.Delete, function(k) end)
    KeySec:AddKeybind("Screenshot", Enum.KeyCode.F12, function(k) end)
    KeySec:AddSeparator()
    KeySec:AddToggle("Bloquer input jeu", false, "Empeche les touches de passer au jeu", function(v)
        Win:Notify("Touches","Blocage: "..(v and "ON" or "OFF"),"warning",2)
    end)
    KeySec:AddDropdown("Mode activation",{"Appui","Toggle","Maintien"},"Appui",function(v) end)

    local Key2Sec = KeySub:CreateSection("Options")
    Key2Sec:AddToggle("Touches globales", true, function(v) end)
    Key2Sec:AddSlider("Delai repetition", 0, 500, 0, "ms", function(v) end)

    -- CONFIGS
    local CfgSec = CfgSub:CreateSection("Gestion")
    CfgSec:AddInput("Nom", "MaConfig", function(t,enter)
        if enter and t~="" then Win:Notify("Config","Nom: "..t,"info",2) end
    end)
    CfgSec:AddButton("Sauvegarder", function()
        Win:Notify("Config","Configuration sauvegardee !","success",2.5)
    end)
    CfgSec:AddButton("Charger", function()
        Win:Notify("Config","Configuration chargee !","success",2)
    end)
    CfgSec:AddButton("Supprimer", function()
        Win:Notify("Config","Supprimee","warning",2)
    end)
    CfgSec:AddButton("Rafraichir", function()
        Win:Notify("Config","Liste rafraichie","info",1.5)
    end)
    CfgSec:AddSeparator()
    CfgSec:AddDropdown("Config active",{"Default","Config 1","Config 2"},"Default",function(v)
        Win:Notify("Config","Selectionne: "..v,"info",2)
    end)

    local Cfg2Sec = CfgSub:CreateSection("Options auto")
    Cfg2Sec:AddToggle("Autosave", false, "Sauvegarder automatiquement", function(v)
        Win:Notify("Config","Autosave: "..(v and "ON" or "OFF"),"info",2)
    end)
    Cfg2Sec:AddSlider("Intervalle", 10, 300, 60, "s", function(v) end)
    Cfg2Sec:AddToggle("Charger au demarrage", true, function(v) end)
    Cfg2Sec:AddButton("Tout reinitialiser", function()
        Win:Notify("Config","Reset effectue","warning",2)
    end)

    return ST
end

return VioletUI
