-- Violet UI Library
-- Version: 1.0

local Library = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Couleurs principales
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
local isDragging = false
local dragStart = nil
local startPos = nil
local currentConfig = "Default"

-- Création de l'interface principale
function Library:CreateWindow(title)
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
    
    -- Resize Handle (bas droite)
    local ResizeHandle = Instance.new("ImageButton")
    ResizeHandle.Name = "ResizeHandle"
    ResizeHandle.Parent = MainFrame
    ResizeHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
    ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
    ResizeHandle.Image = "rbxassetid://3926305904"
    ResizeHandle.ImageColor3 = Colors.Violet
    ResizeHandle.ImageRectOffset = Vector2.new(4, 4)
    ResizeHandle.ImageRectSize = Vector2.new(360, 360)
    
    -- Logo
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Parent = MainFrame
    Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Logo.BackgroundTransparency = 1.000
    Logo.Size = UDim2.new(0, 200, 0, 60)
    Logo.Position = UDim2.new(0.02, 0, 0.02, 0)
    Logo.Image = "rbxassetid://125489582002636"
    
    -- Control Buttons (haut droite)
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
    
    -- Tabs Frame (gauche)
    local TabsFrame = Instance.new("Frame")
    TabsFrame.Name = "TabsFrame"
    TabsFrame.Parent = MainFrame
    TabsFrame.BackgroundColor3 = Colors.Secondary
    TabsFrame.BorderColor3 = Colors.Violet
    TabsFrame.BorderSizePixel = 2
    TabsFrame.Position = UDim2.new(0.02, 0, 0.15, 0)
    TabsFrame.Size = UDim2.new(0, 200, 0, 400)
    
    -- Content Frame (droite)
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = Colors.Secondary
    ContentFrame.BorderColor3 = Colors.Violet
    ContentFrame.BorderSizePixel = 2
    ContentFrame.Position = UDim2.new(0.28, 0, 0.15, 0)
    ContentFrame.Size = UDim2.new(0, 560, 0, 400)
    
    -- Notification Frame (caché par défaut)
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Name = "NotificationFrame"
    NotificationFrame.Parent = ScreenGui
    NotificationFrame.BackgroundColor3 = Colors.Secondary
    NotificationFrame.BorderColor3 = Colors.Violet
    NotificationFrame.BorderSizePixel = 2
    NotificationFrame.Position = UDim2.new(0.7, 0, 0.1, 0)
    NotificationFrame.Size = UDim2.new(0, 250, 0, 80)
    NotificationFrame.Visible = false
    
    local NotificationTitle = Instance.new("TextLabel")
    NotificationTitle.Name = "NotificationTitle"
    NotificationTitle.Parent = NotificationFrame
    NotificationTitle.BackgroundColor3 = Colors.Element
    NotificationTitle.BorderColor3 = Colors.Violet
    NotificationTitle.Size = UDim2.new(1, 0, 0, 25)
    NotificationTitle.Text = "Notification"
    NotificationTitle.TextColor3 = Colors.Text
    NotificationTitle.TextSize = 16
    
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
    
    -- Keybind Frame
    local KeybindFrame = Instance.new("Frame")
    KeybindFrame.Name = "KeybindFrame"
    KeybindFrame.Parent = ScreenGui
    KeybindFrame.BackgroundColor3 = Colors.Secondary
    KeybindFrame.BorderColor3 = Colors.Violet
    KeybindFrame.BorderSizePixel = 2
    KeybindFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
    KeybindFrame.Size = UDim2.new(0, 300, 0, 150)
    KeybindFrame.Visible = false
    
    local KeybindTitle = Instance.new("TextLabel")
    KeybindTitle.Name = "KeybindTitle"
    KeybindTitle.Parent = KeybindFrame
    KeybindTitle.BackgroundColor3 = Colors.Element
    KeybindTitle.BorderColor3 = Colors.Violet
    KeybindTitle.Size = UDim2.new(1, 0, 0, 30)
    KeybindTitle.Text = "Appuyez sur une touche"
    KeybindTitle.TextColor3 = Colors.Text
    KeybindTitle.TextSize = 16
    
    local KeybindTextBox = Instance.new("TextBox")
    KeybindTextBox.Name = "KeybindTextBox"
    KeybindTextBox.Parent = KeybindFrame
    KeybindTextBox.BackgroundColor3 = Colors.Element
    KeybindTextBox.BorderColor3 = Colors.Violet
    KeybindTextBox.Position = UDim2.new(0.2, 0, 0.4, 0)
    KeybindTextBox.Size = UDim2.new(0, 180, 0, 40)
    KeybindTextBox.Text = ""
    KeybindTextBox.TextColor3 = Colors.Text
    KeybindTextBox.TextSize = 14
    KeybindTextBox.PlaceholderText = "Cliquez ici"
    
    local KeybindButton = Instance.new("TextButton")
    KeybindButton.Name = "KeybindButton"
    KeybindButton.Parent = KeybindFrame
    KeybindButton.BackgroundColor3 = Colors.Element
    KeybindButton.BorderColor3 = Colors.Violet
    KeybindButton.Position = UDim2.new(0.35, 0, 0.7, 0)
    KeybindButton.Size = UDim2.new(0, 100, 0, 30)
    KeybindButton.Text = "Confirmer"
    KeybindButton.TextColor3 = Colors.Text
    KeybindButton.TextSize = 14
    
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
        TabButton.Position = UDim2.new(0.05, 0, 0.05 + (#tabs * 0.1), 0)
        TabButton.Text = name
        TabButton.TextColor3 = Colors.Text
        TabButton.TextSize = 14
        
        -- Content pour ce tab
        local TabContent = Instance.new("Frame")
        TabContent.Name = name.."Content"
        TabContent.Parent = ContentFrame
        TabContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false
        
        table.insert(tabs, {Button = TabButton, Content = TabContent, Name = name})
        
        -- Si c'est le premier tab, l'activer
        if #tabs == 1 then
            currentTab = TabContent
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Colors.Violet
        end
        
        -- Gestionnaire de clic
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
    
    -- Fonction pour créer une section dans un tab
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
        local yPos = #parent:GetChildren() * 0.08
        
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
        local yPos = #parent:GetChildren() * 0.08
        
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
        local yPos = #parent:GetChildren() * 0.08
        
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
        local yPos = #parent:GetChildren() * 0.08
        
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
        
        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local connection
                connection = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        connection:Disconnect()
                    end
                end)
                
                local moveConnection
                moveConnection = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
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
                
                moveConnection:Connect(function(input)
                    if input.UserInputState == Enum.UserInputState.End then
                        moveConnection:Disconnect()
                    end
                end)
            end
        end)
        
        return SliderFrame
    end
    
    -- Fonction pour créer un input
    function Library:CreateInput(parent, placeholder, callback)
        local yPos = #parent:GetChildren() * 0.08
        
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
        local yPos = #parent:GetChildren() * 0.08
        
        local KeybindButton = Instance.new("TextButton")
        KeybindButton.Name = "Keybind"..text
        KeybindButton.Parent = parent
        KeybindButton.BackgroundColor3 = Colors.Element
        KeybindButton.BorderColor3 = Colors.Violet
        KeybindButton.Position = UDim2.new(0.05, 0, 0.1 + yPos, 0)
        KeybindButton.Size = UDim2.new(0, 120, 0, 25)
        KeybindButton.Text = text..": "..tostring(defaultKey)
        KeybindButton.TextColor3 = Colors.Text
        KeybindButton.TextSize = 14
        
        local currentKey = defaultKey
        local isBinding = false
        
        KeybindButton.MouseButton1Click:Connect(function()
            isBinding = true
            KeybindButton.Text = "Appuyez sur une touche..."
            
            local connection
            connection = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    KeybindButton.Text = text..": "..tostring(currentKey)
                    isBinding = false
                    connection:Disconnect()
                    if callback then
                        callback(currentKey)
                    end
                end
            end)
        end)
        
        return KeybindButton
    end
    
    -- Tab Paramètres (toujours présente)
    local SettingsTab = Library:CreateTab("Paramètres")
    
    -- Section gauche - Personnalisation
    local SettingsLeft = Library:CreateSection(SettingsTab, "Personnalisation", 0.02)
    
    Library:CreateButton(SettingsLeft, "Changer couleur violet", function()
        -- Logique pour changer la couleur
        Library:Notify("Info", "Fonctionnalité à venir", 3)
    end)
    
    Library:CreateButton(SettingsLeft, "Changer texte", function()
        Library:Notify("Info", "Fonctionnalité à venir", 3)
    end)
    
    Library:CreateButton(SettingsLeft, "Changer fond", function()
        Library:Notify("Info", "Fonctionnalité à venir", 3)
    end)
    
    -- Section droite - Configuration
    local SettingsRight = Library:CreateSection(SettingsTab, "Configuration", 0.52)
    
    local configDropdown = Library:CreateDropdown(SettingsRight, "Configs", {"Default", "Config 1", "Config 2", "Config 3"}, function(option)
        currentConfig = option
        Library:Notify("Configuration", "Config sélectionnée: "..option, 2)
    end)
    
    Library:CreateButton(SettingsRight, "Save", function()
        Library:Notify("Configuration", "Config sauvegardée: "..currentConfig, 2)
    end)
    
    Library:CreateButton(SettingsRight, "Refresh", function()
        Library:Notify("Configuration", "Configs rafraîchies", 2)
    end)
    
    Library:CreateButton(SettingsRight, "Delete", function()
        Library:Notify("Configuration", "Config supprimée: "..currentConfig, 2)
    end)
    
    Library:CreateButton(SettingsRight, "Load", function()
        Library:Notify("Configuration", "Config chargée: "..currentConfig, 2)
    end)
    
    Library:CreateKeybind(SettingsRight, "Toggle UI", toggleKey, function(key)
        toggleKey = key
        Library:Notify("Keybind", "Nouvelle touche: "..tostring(key), 2)
    end)
    
    -- Gestionnaires d'événements
    
    -- Drag pour le resize
    local resizeConnection
    ResizeHandle.MouseButton1Down:Connect(function()
        isResizing = true
        local startPos = UserInputService:GetMouseLocation()
        local startSize = MainFrame.Size
        
        resizeConnection = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and isResizing then
                local mousePos = UserInputService:GetMouseLocation()
                local delta = Vector2.new(mousePos.X - startPos.X, mousePos.Y - startPos.Y)
                local newSize = UDim2.new(0, startSize.X.Offset + delta.X, 0, startSize.Y.Offset + delta.Y)
                
                -- Limites minimales
                if newSize.X.Offset > 400 and newSize.Y.Offset > 300 then
                    MainFrame.Size = newSize
                end
            end
        end)
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and isResizing then
            isResizing = false
            if resizeConnection then
                resizeConnection:Disconnect()
            end
        end
    end)
    
    -- Bouton moins (minimiser)
    MinusButton.MouseButton1Click:Connect(function()
        isVisible = false
        MainFrame.Visible = false
    end)
    
    -- Bouton fermer
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Keybind global pour toggle UI
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == toggleKey then
            isVisible = not isVisible
            MainFrame.Visible = isVisible
        end
    end)
    
    return Library
end

-- Exemple d'utilisation
local MyLibrary = Library:CreateWindow("Violet UI")

-- Créer des tabs
local MainTab = MyLibrary:CreateTab("Principal")
local MiscTab = MyLibrary:CreateTab("Divers")

-- Sections dans MainTab
local LeftSection = MyLibrary:CreateSection(MainTab, "Général", 0.02)
local RightSection = MyLibrary:CreateSection(MainTab, "Options", 0.52)

-- Ajouter des éléments
MyLibrary:CreateCheckbox(LeftSection, "Activer option 1", function(state)
    print("Option 1:", state)
end)

MyLibrary:CreateButton(LeftSection, "Clique moi", function()
    MyLibrary:Notify("Action", "Bouton cliqué!", 2)
end)

MyLibrary:CreateDropdown(RightSection, "Choix", {"Option A", "Option B", "Option C"}, function(selected)
    print("Sélectionné:", selected)
end)

MyLibrary:CreateSlider(RightSection, "Volume", 0, 100, 50, function(value)
    print("Volume:", value)
end)

MyLibrary:CreateInput(RightSection, "Entrez texte", function(text)
    print("Texte:", text)
end)

MyLibrary:CreateKeybind(MiscTab, "Test Key", Enum.KeyCode.G, function(key)
    print("Nouvelle touche:", key)
end)

MyLibrary:Notify("Bienvenue", "Library chargée avec succès!", 3)
