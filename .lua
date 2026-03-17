-- Violet UI Library - Version GitHub
-- Fichier: violetui.lua

local Library = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Couleurs
local Colors = {
    Background = Color3.fromRGB(0, 0, 0),
    Secondary = Color3.fromRGB(11, 11, 11),
    Element = Color3.fromRGB(17, 17, 17),
    Violet = Color3.fromRGB(72, 40, 140),
    Text = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(72, 40, 140)
}

-- Variables globales
local isVisible = true
local toggleKey = Enum.KeyCode.F

-- Fonction pour créer la fenêtre
function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Violet Hub"
    toggleKey = config.ToggleKey or Enum.KeyCode.F
    local resizable = config.Resizable or true
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VioletLibrary"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame
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
    
    -- Logo
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Parent = MainFrame
    Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Logo.BackgroundTransparency = 1.000
    Logo.Size = UDim2.new(0, 200, 0, 60)
    Logo.Position = UDim2.new(0.02, 0, 0.02, 0)
    Logo.Image = "rbxassetid://125489582002636"
    
    -- Control Buttons
    local ControlFrame = Instance.new("Frame")
    ControlFrame.Name = "ControlFrame"
    ControlFrame.Parent = MainFrame
    ControlFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ControlFrame.BackgroundTransparency = 1
    ControlFrame.Size = UDim2.new(0, 80, 0, 25)
    ControlFrame.Position = UDim2.new(1, -90, 0, 10)
    
    local MinusButton = Instance.new("TextButton")
    MinusButton.Name = "MinusButton"
    MinusButton.Parent = ControlFrame
    MinusButton.BackgroundColor3 = Colors.Element
    MinusButton.BorderColor3 = Colors.Violet
    MinusButton.Size = UDim2.new(0, 25, 0, 25)
    MinusButton.Position = UDim2.new(0, 0, 0, 0)
    MinusButton.Text = "-"
    MinusButton.TextColor3 = Colors.Text
    MinusButton.TextSize = 20
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = ControlFrame
    CloseButton.BackgroundColor3 = Colors.Element
    CloseButton.BorderColor3 = Colors.Violet
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(0, 30, 0, 0)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.TextSize = 20
    
    -- Resize Handle
    if resizable then
        local ResizeHandle = Instance.new("ImageButton")
        ResizeHandle.Name = "ResizeHandle"
        ResizeHandle.Parent = MainFrame
        ResizeHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ResizeHandle.BackgroundTransparency = 1
        ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
        ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
        ResizeHandle.Image = "rbxassetid://3926305904"
        ResizeHandle.ImageColor3 = Colors.Violet
        
        -- Resize functionality
        local isResizing = false
        ResizeHandle.MouseButton1Down:Connect(function()
            isResizing = true
            local startPos = UserInputService:GetMouseLocation()
            local startSize = MainFrame.Size
            
            local connection
            connection = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and isResizing then
                    local mousePos = UserInputService:GetMouseLocation()
                    local delta = Vector2.new(mousePos.X - startPos.X, mousePos.Y - startPos.Y)
                    local newSize = UDim2.new(0, math.max(400, startSize.X.Offset + delta.X), 0, math.max(300, startSize.Y.Offset + delta.Y))
                    MainFrame.Size = newSize
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isResizing = false
                    if connection then
                        connection:Disconnect()
                    end
                end
            end)
        end)
    end
    
    -- Tabs Frame
    local TabsFrame = Instance.new("Frame")
    TabsFrame.Name = "TabsFrame"
    TabsFrame.Parent = MainFrame
    TabsFrame.BackgroundColor3 = Colors.Secondary
    TabsFrame.BorderColor3 = Colors.Violet
    TabsFrame.BorderSizePixel = 2
    TabsFrame.Position = UDim2.new(0.02, 0, 0.15, 0)
    TabsFrame.Size = UDim2.new(0, 200, 0, 400)
    
    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = Colors.Secondary
    ContentFrame.BorderColor3 = Colors.Violet
    ContentFrame.BorderSizePixel = 2
    ContentFrame.Position = UDim2.new(0.28, 0, 0.15, 0)
    ContentFrame.Size = UDim2.new(0, 560, 0, 400)
    
    -- Notification Frame
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
    NotificationTitle.Name = "NotificationTitle"
    NotificationTitle.Parent = NotificationFrame
    NotificationTitle.BackgroundColor3 = Colors.Element
    NotificationTitle.BorderColor3 = Colors.Violet
    NotificationTitle.Size = UDim2.new(1, 0, 0, 25)
    NotificationTitle.Text = "Notification"
    NotificationTitle.TextColor3 = Colors.Text
    NotificationTitle.TextSize = 16
    NotificationTitle.ZIndex = 11
    
    local NotificationText = Instance.new("TextLabel")
    NotificationText.Name = "NotificationText"
    NotificationText.Parent = NotificationFrame
    NotificationText.BackgroundColor3 = Colors.Secondary
    NotificationText.BorderColor3 = Colors.Violet
    NotificationText.Position = UDim2.new(0, 0, 0, 25)
    NotificationText.Size = UDim2.new(1, 0, 1, -25)
    NotificationText.Text = ""
    NotificationText.TextColor3 = Colors.Text
    NotificationText.TextSize = 14
    NotificationText.TextWrapped = true
    NotificationText.ZIndex = 11
    
    -- Variables pour les tabs
    local tabs = {}
    local currentTab = nil
    
    -- Fonction pour créer un nouveau tab
    function Library:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name.."Tab"
        TabButton.Parent = TabsFrame
        TabButton.BackgroundColor3 = Colors.Element
        TabButton.BorderColor3 = Colors.Violet
        TabButton.Size = UDim2.new(0, 180, 0, 30)
        TabButton.Position = UDim2.new(0.05, 0, 0.05 + (#tabs * 0.08), 0)
        TabButton.Text = name
        TabButton.TextColor3 = Colors.Text
        TabButton.TextSize = 14
        
        local TabContent = Instance.new("Frame")
        TabContent.Name = name.."Content"
        TabContent.Parent = ContentFrame
        TabContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false
        
        table.insert(tabs, {Button = TabButton, Content = TabContent, Name = name})
        
        if #tabs == 1 then
            currentTab = TabContent
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Colors.Violet
        end
        
        TabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Visible = false
            end
            for _, tab in pairs(tabs) do
                tab.Button.BackgroundColor3 = Colors.Element
            end
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Colors.Violet
            currentTab = TabContent
        end)
        
        return TabContent
    end
    
    -- Fonction pour créer une section
    function Library:CreateSection(parent, name, position)
        local Section = Instance.new("Frame")
        Section.Name = name.."Section"
        Section.Parent = parent
        Section.BackgroundColor3 = Colors.Secondary
        Section.BorderColor3 = Colors.Violet
        Section.BorderSizePixel = 2
        Section.Position = UDim2.new(position or 0.02, 0, 0.02, 0)
        Section.Size = UDim2.new(0, 260, 0, 380)
        
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Name = "SectionTitle"
        SectionTitle.Parent = Section
        SectionTitle.BackgroundColor3 = Colors.Element
        SectionTitle.BorderColor3 = Colors.Violet
        SectionTitle.Size = UDim2.new(1, 0, 0, 25)
        SectionTitle.Text = name
        SectionTitle.TextColor3 = Colors.Text
        SectionTitle.TextSize = 16
        
        return Section
    end
    
    -- Fonction pour créer un checkbox
    function Library:CreateCheckbox(parent, text, callback)
        local yPos = (#parent:GetChildren() - 1) * 0.08
        
        local CheckboxButton = Instance.new("TextButton")
        CheckboxButton.Name = "Checkbox"..text
        CheckboxButton.Parent = parent
        CheckboxButton.BackgroundColor3 = Colors.Element
        CheckboxButton.BorderColor3 = Colors.Violet
        CheckboxButton.Position = UDim2.new(0.05, 0, 0.1 + yPos, 0)
        CheckboxButton.Size = UDim2.new(0, 20, 0, 20)
        CheckboxButton.Text = ""
        
        local CheckboxText = Instance.new("TextLabel")
        CheckboxText.Name = "CheckboxText"
        CheckboxText.Parent = CheckboxButton
        CheckboxText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        CheckboxText.BackgroundTransparency = 1
        CheckboxText.Position = UDim2.new(1.5, 0, 0, 0)
        CheckboxText.Size = UDim2.new(0, 150, 0, 20)
        CheckboxText.Text = text
        CheckboxText.TextColor3 = Colors.Text
        CheckboxText.TextSize = 14
        CheckboxText.TextXAlignment = Enum.TextXAlignment.Left
        
        local isChecked = false
        
        CheckboxButton.MouseButton1Click:Connect(function()
            isChecked = not isChecked
            if isChecked then
                CheckboxButton.BackgroundColor3 = Colors.Violet
            else
                CheckboxButton.BackgroundColor3 = Colors.Element
            end
            if callback then
                callback(isChecked)
            end
        end)
        
        return CheckboxButton
    end
    
    -- Fonction pour créer un button
    function Library:CreateButton(parent, text, callback)
        local yPos = (#parent:GetChildren() - 1) * 0.08
        
        local Button = Instance.new("TextButton")
        Button.Name = "Button"..text
        Button.Parent = parent
        Button.BackgroundColor3 = Colors.Element
        Button.BorderColor3 = Colors.Violet
        Button.Position = UDim2.new(0.05, 0, 0.1 + yPos, 0)
        Button.Size = UDim2.new(0, 100, 0, 25)
        Button.Text = text
        Button.TextColor3 = Colors.Text
        Button.TextSize = 14
        
        Button.MouseButton1Click:Connect(function()
            if callback then
                callback()
            end
        end)
        
        return Button
    end
    
    -- Fonction pour créer un dropdown
    function Library:CreateDropdown(parent, text, options, callback)
        local yPos = (#parent:GetChildren() - 1) * 0.08
        
        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Name = "Dropdown"..text
        DropdownButton.Parent = parent
        DropdownButton.BackgroundColor3 = Colors.Element
        DropdownButton.BorderColor3 = Colors.Violet
        DropdownButton.Position = UDim2.new(0.05, 0, 0.1 + yPos, 0)
        DropdownButton.Size = UDim2.new(0, 150, 0, 25)
        DropdownButton.Text = text.." ▼"
        DropdownButton.TextColor3 = Colors.Text
        DropdownButton.TextSize = 14
        
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Name = "DropdownFrame"
        DropdownFrame.Parent = DropdownButton
        DropdownFrame.BackgroundColor3 = Colors.Secondary
        DropdownFrame.BorderColor3 = Colors.Violet
        DropdownFrame.BorderSizePixel = 2
        DropdownFrame.Position = UDim2.new(0, 0, 1, 0)
        DropdownFrame.Size = UDim2.new(1, 0, 0, #options * 25)
        DropdownFrame.Visible = false
        DropdownFrame.ZIndex = 10
        DropdownFrame.ClipsDescendants = true
        
        for i, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Name = "Option"..option
            OptionButton.Parent = DropdownFrame
            OptionButton.BackgroundColor3 = Colors.Element
            OptionButton.BorderColor3 = Colors.Violet
            OptionButton.Size = UDim2.new(1, 0, 0, 25)
            OptionButton.Position = UDim2.new(0, 0, (i-1) * 0.25, 0)
            OptionButton.Text = option
            OptionButton.TextColor3 = Colors.Text
            OptionButton.TextSize = 14
            OptionButton.ZIndex = 11
            
            OptionButton.MouseButton1Click:Connect(function()
                DropdownButton.Text = option.." ▼"
                DropdownFrame.Visible = false
                if callback then
                    callback(option)
                end
            end)
        end
        
        DropdownButton.MouseButton1Click:Connect(function()
            DropdownFrame.Visible = not DropdownFrame.Visible
        end)
        
        return DropdownButton
    end
    
    -- Fonction pour créer un slider
    function Library:CreateSlider(parent, text, min, max, default, callback)
        local yPos = (#parent:GetChildren() - 1) * 0.08
        
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Name = "Slider"..text
        SliderFrame.Parent = parent
        SliderFrame.BackgroundColor3 = Colors.Element
        SliderFrame.BorderColor3 = Colors.Violet
        SliderFrame.Position = UDim2.new(0.05, 0, 0.1 + yPos, 0)
        SliderFrame.Size = UDim2.new(0, 200, 0, 30)
        
        local SliderText = Instance.new("TextLabel")
        SliderText.Name = "SliderText"
        SliderText.Parent = SliderFrame
        SliderText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SliderText.BackgroundTransparency = 1
        SliderText.Size = UDim2.new(1, 0, 0, 15)
        SliderText.Text = text..": "..tostring(default)
        SliderText.TextColor3 = Colors.Text
        SliderText.TextSize = 14
        
        local SliderBar = Instance.new("Frame")
        SliderBar.Name = "SliderBar"
        SliderBar.Parent = SliderFrame
        SliderBar.BackgroundColor3 = Colors.Element
        SliderBar.BorderColor3 = Colors.Violet
        SliderBar.Position = UDim2.new(0, 0, 0.5, 5)
        SliderBar.Size = UDim2.new(1, 0, 0, 5)
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Name = "SliderFill"
        SliderFill.Parent = SliderBar
        SliderFill.BackgroundColor3 = Colors.Violet
        SliderFill.BorderSizePixel = 0
        SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        
        local value = default
        local dragging = false
        
        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = UserInputService:GetMouseLocation()
                local barPos = SliderBar.AbsolutePosition
                local barSize = SliderBar.AbsoluteSize.X
                local relativePos = math.clamp((mousePos.X - barPos.X) / barSize, 0, 1)
                value = min + (max - min) * relativePos
                SliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
                SliderText.Text = text..": "..tostring(math.floor(value * 100) / 100)
                if callback then
                    callback(value)
                end
            end
        end)
        
        return SliderFrame
    end
    
    -- Fonction pour créer un input
    function Library:CreateInput(parent, placeholder, callback)
        local yPos = (#parent:GetChildren() - 1) * 0.08
        
        local InputBox = Instance.new("TextBox")
        InputBox.Name = "Input"..placeholder
        InputBox.Parent = parent
        InputBox.BackgroundColor3 = Colors.Element
        InputBox.BorderColor3 = Colors.Violet
        InputBox.Position = UDim2.new(0.05, 0, 0.1 + yPos, 0)
        InputBox.Size = UDim2.new(0, 150, 0, 25)
        InputBox.PlaceholderText = placeholder
        InputBox.Text = ""
        InputBox.TextColor3 = Colors.Text
        InputBox.TextSize = 14
        
        InputBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                if callback then
                    callback(InputBox.Text)
                end
            end
        end)
        
        return InputBox
    end
    
    -- Fonction pour créer une notification
    function Library:Notify(title, message, duration)
        NotificationTitle.Text = title
        NotificationText.Text = message
        NotificationFrame.Visible = true
        
        if duration then
            task.wait(duration)
            NotificationFrame.Visible = false
        end
    end
    
    -- Fonction pour créer un keybind
    function Library:CreateKeybind(parent, text, defaultKey, callback)
        local yPos = (#parent:GetChildren() - 1) * 0.08
        
        local KeybindButton = Instance.new("TextButton")
        KeybindButton.Name = "Keybind"..text
        KeybindButton.Parent = parent
        KeybindButton.BackgroundColor3 = Colors.Element
        KeybindButton.BorderColor3 = Colors.Violet
        KeybindButton.Position = UDim2.new(0.05, 0, 0.1 + yPos, 0)
        KeybindButton.Size = UDim2.new(0, 150, 0, 25)
        KeybindButton.Text = text..": "..tostring(defaultKey):gsub("Enum.KeyCode.", "")
        KeybindButton.TextColor3 = Colors.Text
        KeybindButton.TextSize = 14
        
        local currentKey = defaultKey
        
        KeybindButton.MouseButton1Click:Connect(function()
            local KeybindPopup = Instance.new("Frame")
            KeybindPopup.Name = "KeybindPopup"
            KeybindPopup.Parent = ScreenGui
            KeybindPopup.BackgroundColor3 = Colors.Secondary
            KeybindPopup.BorderColor3 = Colors.Violet
            KeybindPopup.BorderSizePixel = 2
            KeybindPopup.Position = UDim2.new(0.4, 0, 0.4, 0)
            KeybindPopup.Size = UDim2.new(0, 300, 0, 150)
            KeybindPopup.ZIndex = 20
            
            local PopupTitle = Instance.new("TextLabel")
            PopupTitle.Name = "PopupTitle"
            PopupTitle.Parent = KeybindPopup
            PopupTitle.BackgroundColor3 = Colors.Element
            PopupTitle.BorderColor3 = Colors.Violet
            PopupTitle.Size = UDim2.new(1, 0, 0, 30)
            PopupTitle.Text = "Appuyez sur une touche"
            PopupTitle.TextColor3 = Colors.Text
            PopupTitle.TextSize = 16
            PopupTitle.ZIndex = 21
            
            local PopupText = Instance.new("TextLabel")
            PopupText.Name = "PopupText"
            PopupText.Parent = KeybindPopup
            PopupText.BackgroundColor3 = Colors.Element
            PopupText.BorderColor3 = Colors.Violet
            PopupText.Position = UDim2.new(0.2, 0, 0.4, 0)
            PopupText.Size = UDim2.new(0, 180, 0, 40)
            PopupText.Text = "..."
            PopupText.TextColor3 = Colors.Text
            PopupText.TextSize = 14
            PopupText.ZIndex = 21
            
            local connection
            connection = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    PopupText.Text = tostring(currentKey):gsub("Enum.KeyCode.", "")
                    task.wait(0.5)
                    KeybindPopup:Destroy()
                    KeybindButton.Text = text..": "..tostring(currentKey):gsub("Enum.KeyCode.", "")
                    if callback then
                        callback(currentKey)
                    end
                    connection:Disconnect()
                end
            end)
        end)
        
        return KeybindButton
    end
    
    -- Tab Paramètres
    local SettingsTab = Library:CreateTab("Paramètres")
    
    local SettingsLeft = Library:CreateSection(SettingsTab, "Personnalisation", 0.02)
    local SettingsRight = Library:CreateSection(SettingsTab, "Configuration", 0.52)
    
    Library:CreateButton(SettingsLeft, "Changer couleur", function()
        Library:Notify("Info", "Fonctionnalité à venir", 2)
    end)
    
    Library:CreateDropdown(SettingsRight, "Configs", {"Default", "Config 1", "Config 2"}, function(option)
        Library:Notify("Configuration", "Config: "..option, 1.5)
    end)
    
    Library:CreateButton(SettingsRight, "Save", function()
        Library:Notify("Configuration", "Config sauvegardée", 1.5)
    end)
    
    Library:CreateButton(SettingsRight, "Load", function()
        Library:Notify("Configuration", "Config chargée", 1.5)
    end)
    
    Library:CreateButton(SettingsRight, "Delete", function()
        Library:Notify("Configuration", "Config supprimée", 1.5)
    end)
    
    Library:CreateButton(SettingsRight, "Refresh", function()
        Library:Notify("Configuration", "Configs rafraîchies", 1.5)
    end)
    
    Library:CreateKeybind(SettingsRight, "Toggle UI", toggleKey, function(key)
        toggleKey = key
        Library:Notify("Keybind", "Touche: "..tostring(key):gsub("Enum.KeyCode.", ""), 1.5)
    end)
    
    -- Minus button
    MinusButton.MouseButton1Click:Connect(function()
        isVisible = false
        MainFrame.Visible = false
    end)
    
    -- Close button
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Global keybind
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == toggleKey then
            isVisible = not isVisible
            MainFrame.Visible = isVisible
        end
    end)
    
    -- Retourne l'objet window avec toutes les méthodes
    local Window = {}
    Window.CreateTab = function(name) return Library:CreateTab(name) end
    Window.CreateSection = function(parent, name, pos) return Library:CreateSection(parent, name, pos) end
    Window.CreateCheckbox = function(parent, text, cb) return Library:CreateCheckbox(parent, text, cb) end
    Window.CreateButton = function(parent, text, cb) return Library:CreateButton(parent, text, cb) end
    Window.CreateDropdown = function(parent, text, opts, cb) return Library:CreateDropdown(parent, text, opts, cb) end
    Window.CreateSlider = function(parent, text, min, max, def, cb) return Library:CreateSlider(parent, text, min, max, def, cb) end
    Window.CreateInput = function(parent, placeholder, cb) return Library:CreateInput(parent, placeholder, cb) end
    Window.CreateKeybind = function(parent, text, key, cb) return Library:CreateKeybind(parent, text, key, cb) end
    Window.Notify = function(title, msg, duration) return Library:Notify(title, msg, duration) end
    
    return Window
end

return Library
