--[[
    GUI.lua
    Oyun arayüzü sistemi - ScreenGui, TextButtons, vb.
]]--

local GUI = {}

-- ============================================================================
-- OYUNCU PANEL GUI'SI
-- ============================================================================

function GUI:CreatePlayerPanel(player)
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PetElementsGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- ============ HEADER PANEL ============
    local headerPanel = Instance.new("Frame")
    headerPanel.Name = "HeaderPanel"
    headerPanel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    headerPanel.BorderSizePixel = 0
    headerPanel.Size = UDim2.new(1, 0, 0.08, 0)
    headerPanel.Parent = screenGui
    
    -- Başlık metni
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = "🐕 PET ELEMENTS 🐕"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextSize = 24
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    titleLabel.Parent = headerPanel
    
    -- Coin Display
    local coinLabel = Instance.new("TextLabel")
    coinLabel.Name = "CoinLabel"
    coinLabel.Text = "💰 Coins: 1000"
    coinLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    coinLabel.BackgroundTransparency = 1
    coinLabel.TextSize = 18
    coinLabel.Font = Enum.Font.Gotham
    coinLabel.Size = UDim2.new(0.5, 0, 1, 0)
    coinLabel.Position = UDim2.new(0.5, 0, 0, 0)
    coinLabel.Parent = headerPanel
    
    -- ============ MAIN CONTENT PANEL ============
    local contentPanel = Instance.new("Frame")
    contentPanel.Name = "ContentPanel"
    contentPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    contentPanel.BorderSizePixel = 0
    contentPanel.Size = UDim2.new(1, 0, 0.92, 0)
    contentPanel.Position = UDim2.new(0, 0, 0.08, 0)
    contentPanel.Parent = screenGui
    
    -- ============ TABS SISTEMI ============
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = "TabFrame"
    tabFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabFrame.BorderSizePixel = 0
    tabFrame.Size = UDim2.new(0.3, 0, 1, 0)
    tabFrame.Parent = contentPanel
    
    local tabs = {"Yumurtalar", "Petler", "Mağaza", "İstatistikler", "Görevler"}
    
    for i, tabName in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tabButton.BorderSizePixel = 0
        tabButton.TextSize = 16
        tabButton.Font = Enum.Font.Gotham
        tabButton.Size = UDim2.new(1, 0, 0.2, 0)
        tabButton.Position = UDim2.new(0, 0, (i-1) * 0.2, 0)
        tabButton.Parent = tabFrame
        
        -- Hover efekti
        tabButton.MouseEnter:Connect(function()
            tabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end)
        
        tabButton.MouseLeave:Connect(function()
            tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)
    end
    
    -- ============ TAB CONTENT ============
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    contentFrame.BorderSizePixel = 0
    contentFrame.Size = UDim2.new(0.7, 0, 1, 0)
    contentFrame.Position = UDim2.new(0.3, 0, 0, 0)
    contentFrame.Parent = contentPanel
    
    -- ============ YUMURTALAR TAB ============
    local eggsTab = self:CreateEggsTab(contentFrame)
    
    return screenGui
end

-- ============================================================================
-- YUMURTALAR SEKME
-- ============================================================================

function GUI:CreateEggsTab(parent)
    local frame = Instance.new("Frame")
    frame.Name = "EggsTab"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Parent = parent
    
    -- Başlık
    local title = Instance.new("TextLabel")
    title.Text = "🥚 Yumurtalarım"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.Size = UDim2.new(1, 0, 0.1, 0)
    title.Parent = frame
    
    -- Yumurta listesi scroll
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "EggsList"
    scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.Size = UDim2.new(1, -20, 0.7, 0)
    scrollFrame.Position = UDim2.new(0, 10, 0.12, 0)
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = frame
    
    -- İlk yumurta örneği
    local eggItem = Instance.new("TextButton")
    eggItem.Name = "EggItem"
    eggItem.Text = "🥚 Fire Egg (Rare) - 45% İlerleme"
    eggItem.TextColor3 = Color3.fromRGB(255, 255, 255)
    eggItem.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    eggItem.BorderSizePixel = 0
    eggItem.TextSize = 14
    eggItem.Font = Enum.Font.Gotham
    eggItem.Size = UDim2.new(1, -10, 0.15, 0)
    eggItem.Position = UDim2.new(0, 5, 0, 5)
    eggItem.Parent = scrollFrame
    
    -- Progress bar
    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    progressBar.BorderSizePixel = 0
    progressBar.Size = UDim2.new(1, -10, 0.05, 0)
    progressBar.Position = UDim2.new(0, 5, 0.18, 0)
    progressBar.Parent = scrollFrame
    
    local progress = Instance.new("Frame")
    progress.Name = "Progress"
    progress.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    progress.BorderSizePixel = 0
    progress.Size = UDim2.new(0.45, 0, 1, 0)
    progress.Parent = progressBar
    
    -- Buton bölüm
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = "ButtonFrame"
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Size = UDim2.new(1, 0, 0.15, 0)
    buttonFrame.Position = UDim2.new(0, 0, 0.82, 0)
    buttonFrame.Parent = frame
    
    -- Yumurta Satın Al Butonu
    local buyButton = Instance.new("TextButton")
    buyButton.Name = "BuyEggButton"
    buyButton.Text = "🛍️ Yumurta Satın Al"
    buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    buyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 75)
    buyButton.BorderSizePixel = 0
    buyButton.TextSize = 16
    buyButton.Font = Enum.Font.GothamBold
    buyButton.Size = UDim2.new(0.45, 0, 0.8, 0)
    buyButton.Position = UDim2.new(0.05, 0, 0.1, 0)
    buyButton.Parent = buttonFrame
    
    buyButton.MouseEnter:Connect(function()
        buyButton.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
    end)
    
    buyButton.MouseLeave:Connect(function()
        buyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 75)
    end)
    
    -- Refresh Butonu
    local refreshButton = Instance.new("TextButton")
    refreshButton.Name = "RefreshButton"
    refreshButton.Text = "🔄 Yenile"
    refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    refreshButton.BorderSizePixel = 0
    refreshButton.TextSize = 16
    refreshButton.Font = Enum.Font.GothamBold
    refreshButton.Size = UDim2.new(0.45, 0, 0.8, 0)
    refreshButton.Position = UDim2.new(0.5, 0, 0.1, 0)
    refreshButton.Parent = buttonFrame
    
    refreshButton.MouseEnter:Connect(function()
        refreshButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    end)
    
    refreshButton.MouseLeave:Connect(function()
        refreshButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end)
    
    return frame
end

-- ============================================================================
-- PET PANEL
-- ============================================================================

function GUI:CreatePetPanel(player)
    local screenGui = player:WaitForChild("PlayerGui"):FindFirstChild("PetElementsGui")
    
    -- Pet gösterme paneli
    local petPanel = Instance.new("Frame")
    petPanel.Name = "PetPanel"
    petPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    petPanel.BorderSizePixel = 0
    petPanel.Size = UDim2.new(0.3, -10, 0.4, 0)
    petPanel.Position = UDim2.new(0.05, 0, 0.5, 0)
    petPanel.Parent = screenGui
    
    -- Pet ikonu
    local petIcon = Instance.new("TextLabel")
    petIcon.Text = "🐉"
    petIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    petIcon.BackgroundTransparency = 1
    petIcon.TextSize = 60
    petIcon.Font = Enum.Font.GothamBold
    petIcon.Size = UDim2.new(1, 0, 0.4, 0)
    petIcon.Parent = petPanel
    
    -- Pet adı
    local petName = Instance.new("TextLabel")
    petName.Text = "Dragon"
    petName.TextColor3 = Color3.fromRGB(255, 255, 255)
    petName.BackgroundTransparency = 1
    petName.TextSize = 18
    petName.Font = Enum.Font.GothamBold
    petName.Size = UDim2.new(1, 0, 0.2, 0)
    petName.Position = UDim2.new(0, 0, 0.4, 0)
    petName.Parent = petPanel
    
    -- Pet level
    local petLevel = Instance.new("TextLabel")
    petLevel.Text = "Level 5"
    petLevel.TextColor3 = Color3.fromRGB(200, 200, 200)
    petLevel.BackgroundTransparency = 1
    petLevel.TextSize = 14
    petLevel.Font = Enum.Font.Gotham
    petLevel.Size = UDim2.new(1, 0, 0.15, 0)
    petLevel.Position = UDim2.new(0, 0, 0.6, 0)
    petLevel.Parent = petPanel
    
    -- Pet element
    local petElement = Instance.new("TextLabel")
    petElement.Text = "Element: 🔥 Fire"
    petElement.TextColor3 = Color3.fromRGB(255, 165, 0)
    petElement.BackgroundTransparency = 1
    petElement.TextSize = 12
    petElement.Font = Enum.Font.Gotham
    petElement.Size = UDim2.new(1, 0, 0.15, 0)
    petElement.Position = UDim2.new(0, 0, 0.75, 0)
    petElement.Parent = petPanel
    
    return petPanel
end

-- ============================================================================
-- EVENT NOTIFIER
-- ============================================================================

function GUI:ShowEventNotification(player, eventName, reward)
    local screenGui = player:WaitForChild("PlayerGui"):FindFirstChild("PetElementsGui")
    
    if not screenGui then
        return
    end
    
    -- Notification Frame
    local notification = Instance.new("Frame")
    notification.Name = "EventNotification"
    notification.BackgroundColor3 = Color3.fromRGB(0, 150, 75)
    notification.BorderSizePixel = 0
    notification.Size = UDim2.new(0.4, 0, 0.1, 0)
    notification.Position = UDim2.new(0.3, 0, 0.05, 0)
    notification.Parent = screenGui
    
    -- Notification Text
    local text = Instance.new("TextLabel")
    text.Text = "🎉 " .. eventName .. " - " .. reward
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.BackgroundTransparency = 1
    text.TextSize = 16
    text.Font = Enum.Font.GothamBold
    text.Size = UDim2.new(1, 0, 1, 0)
    text.Parent = notification
    
    -- 3 saniye sonra disappear
    game:GetService("Debris"):AddItem(notification, 3)
end

-- ============================================================================
-- STATS PANEL
-- ============================================================================

function GUI:CreateStatsPanel(player, stats)
    local screenGui = player:WaitForChild("PlayerGui"):FindFirstChild("PetElementsGui")
    
    if not screenGui then
        return
    end
    
    -- Stats Frame
    local statsFrame = Instance.new("Frame")
    statsFrame.Name = "StatsFrame"
    statsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    statsFrame.BorderSizePixel = 0
    statsFrame.Size = UDim2.new(0.3, -10, 0.35, 0)
    statsFrame.Position = UDim2.new(0.65, 0, 0.5, 0)
    statsFrame.Parent = screenGui
    
    -- Stats Title
    local title = Instance.new("TextLabel")
    title.Text = "📊 İstatistikler"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Size = UDim2.new(1, 0, 0.15, 0)
    title.Parent = statsFrame
    
    -- Stats Items
    local statItems = {
        "🐕 Petler: " .. (stats.pets or 0),
        "🥚 Yumurtalar: " .. (stats.eggs or 0),
        "🎯 Görevler: " .. (stats.objectives or 0),
        "⏱️ Oyun Süresi: " .. (stats.playTime or "0h"),
    }
    
    for i, stat in ipairs(statItems) do
        local statLabel = Instance.new("TextLabel")
        statLabel.Text = stat
        statLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        statLabel.BackgroundTransparency = 1
        statLabel.TextSize = 12
        statLabel.Font = Enum.Font.Gotham
        statLabel.Size = UDim2.new(1, -10, 0.18, 0)
        statLabel.Position = UDim2.new(0, 5, 0.15 + (i-1) * 0.2, 0)
        statLabel.Parent = statsFrame
    end
    
    return statsFrame
end

return GUI