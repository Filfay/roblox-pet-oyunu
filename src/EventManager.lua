--[[
    EventManager.lua
    Tüm event sistemini yönetir
]]--

local EventManager = {}
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Event konfigürasyonu
EventManager.activeEvents = {}
EventManager.eventHistory = {}

-- ============================================================================
-- TIME-BASED EVENTS (Saat tabanlı)
-- ============================================================================

function EventManager:CreateTimeBasedEvent(hour, minute, elementType, eventName)
    local timeEvent = {
        name = eventName,
        hour = hour,
        minute = minute,
        element = elementType,
        rewardRarity = "Common",
        active = false,
        duration = 60, -- 1 saat
        triggered = false
    }
    
    return timeEvent
end

function EventManager:CheckTimeEvents()
    local currentTime = os.date("*t")
    
    local timeEvents = {
        {hour = 6, minute = 0, element = "Fire", name = "Sabah Güneşi"},
        {hour = 12, minute = 0, element = "Electric", name = "Öğle Fırtınası"},
        {hour = 18, minute = 0, element = "Nature", name = "Akşam Doğası"},
        {hour = 0, minute = 0, element = "Dark", name = "Gece Festivali"},
        {hour = 3, minute = 0, element = "Water", name = "Gece Ortası Su"},
    }
    
    for _, event in ipairs(timeEvents) do
        if currentTime.hour == event.hour and currentTime.min == event.minute then
            self:TriggerTimeEvent(event)
        end
    end
end

function EventManager:TriggerTimeEvent(event)
    print("⏰ TIME EVENT BAŞLADI: " .. event.name .. " (" .. event.element .. ")")
    
    for _, player in ipairs(Players:GetPlayers()) do
        self:GiveReward(player, event.element, "Common", "TIME_EVENT")
    end
    
    table.insert(self.activeEvents, event)
end

-- ============================================================================
-- MINI GAME EVENTS
-- ============================================================================

function EventManager:TriggerMiniGameEvent()
    local miniGames = {
        {name = "Tap Tap", minScore = 100, rarity = "Rare"},
        {name = "Memory Match", minScore = 80, rarity = "Rare"},
        {name = "Parkour Rush", minScore = 150, rarity = "Epic"},
        {name = "Spin Wheel", minScore = 50, rarity = "Common"},
        {name = "Catch Falling", minScore = 120, rarity = "Rare"},
    }
    
    local selectedGame = miniGames[math.random(1, #miniGames)]
    
    print("🎮 MINI GAME EVENT: " .. selectedGame.name)
    
    -- Tüm oyunculara mini oyun gönder
    for _, player in ipairs(Players:GetPlayers()) do
        self:StartMiniGame(player, selectedGame)
    end
end

function EventManager:StartMiniGame(player, gameData)
    -- Mini oyun başlat
    local success = false -- Oyuncu başarılı oldu mu?
    
    -- TODO: Mini oyun mantığı buraya gelecek
    
    if success then
        self:GiveReward(player, "Random", gameData.rarity, "MINI_GAME")
    end
end

-- ============================================================================
-- OBJECTIVE EVENTS (Görev etkinlikleri)
-- ============================================================================

function EventManager:CheckObjectiveEvents(player, playerData)
    local objectives = {
        {
            name = "5 Pet Yetiştir",
            condition = function() return playerData.petsRaised >= 5 end,
            reward = "Common"
        },
        {
            name = "1000 Coin Kazan",
            condition = function() return playerData.coins >= 1000 end,
            reward = "Common"
        },
        {
            name = "3 Pet Birleştir",
            condition = function() return playerData.breedingsCompleted >= 3 end,
            reward = "Rare"
        },
        {
            name = "10 Yumurta Aç",
            condition = function() return playerData.eggsHatched >= 10 end,
            reward = "Common"
        },
        {
            name = "İlk Nadir Pet",
            condition = function() return playerData.firstRarePetObtained end,
            reward = "Rare"
        },
    }
    
    for _, objective in ipairs(objectives) do
        if objective.condition() then
            print("🎯 OBJECTIVE TAMAMLANDI: " .. objective.name)
            self:GiveReward(player, "Random", objective.reward, "OBJECTIVE")
        end
    end
end

-- ============================================================================
-- SEASONAL EVENTS (Mevsimsel)
-- ============================================================================

function EventManager:GetCurrentSeason()
    local month = os.date("*t").month
    
    if month >= 3 and month <= 5 then
        return "Spring", "Nature"
    elseif month >= 6 and month <= 8 then
        return "Summer", "Fire"
    elseif month >= 9 and month <= 11 then
        return "Autumn", "Electric"
    else
        return "Winter", "Water"
    end
end

function EventManager:CheckSeasonalEvent()
    local season, element = self:GetCurrentSeason()
    
    print("🌍 SEASONAL EVENT: " .. season .. " (" .. element .. ")")
    
    for _, player in ipairs(Players:GetPlayers()) do
        self:GiveReward(player, element, "Rare", "SEASONAL")
    end
end

-- ============================================================================
-- WEATHER EVENTS (Hava durumuna göre)
-- ============================================================================

function EventManager:CheckWeatherEvent()
    -- TODO: Roblox hava API'sini kullan veya rastgele hava oluştur
    
    local weatherTypes = {
        {weather = "Sunny", element = "Fire"},
        {weather = "Rainy", element = "Water"},
        {weather = "Cloudy", element = "Electric"},
        {weather = "Snowy", element = "Water"},
        {weather = "Stormy", element = "Electric"},
    }
    
    local currentWeather = weatherTypes[math.random(1, #weatherTypes)]
    
    print("🌦️ WEATHER EVENT: " .. currentWeather.weather .. " (" .. currentWeather.element .. ")")
    
    for _, player in ipairs(Players:GetPlayers()) do
        self:GiveReward(player, currentWeather.element, "Common", "WEATHER")
    end
end

-- ============================================================================
-- LUCKY RANDOM EVENTS (Şans etkinlikleri)
-- ============================================================================

function EventManager:CheckLuckyEvent()
    local chance = math.random(1, 100)
    
    if chance <= 5 then -- %5 şans
        print("🎲 LUCKY EVENT: Golden Hour - 2x Yumurta!")
        
        for _, player in ipairs(Players:GetPlayers()) do
            self:GiveReward(player, "Random", "Rare", "LUCKY_GOLDEN")
            self:GiveReward(player, "Random", "Rare", "LUCKY_GOLDEN")
        end
        
    elseif chance <= 10 then -- %5 şans
        print("🎲 LUCKY EVENT: Lucky Strike - Garantili Nadir!")
        
        for _, player in ipairs(Players:GetPlayers()) do
            self:GiveReward(player, "Random", "Rare", "LUCKY_STRIKE")
        end
        
    elseif chance <= 12 then -- %2 şans
        print("🎲 LUCKY EVENT: JACKPOT - 5 Yumurta!")
        
        for _, player in ipairs(Players:GetPlayers()) do
            for i = 1, 5 do
                self:GiveReward(player, "Random", "Common", "LUCKY_JACKPOT")
            end
        end
        
    elseif chance <= 15 then -- %3 şans
        print("🎲 LUCKY EVENT: Mystery Box!")
        
        for _, player in ipairs(Players:GetPlayers()) do
            self:GiveReward(player, "Random", "Epic", "LUCKY_MYSTERY")
        end
    end
end

-- ============================================================================
-- MULTIPLAYER EVENTS (Çok oyunculu)
-- ============================================================================

function EventManager:CheckMultiplayerEvent()
    local playerCount = #Players:GetPlayers()
    
    if playerCount >= 50 then
        print("👥 MULTIPLAYER EVENT: Legendary Event (50+ oyuncu)!")
        self:TriggerMultiplayerEvent("Legendary", playerCount)
        
    elseif playerCount >= 25 then
        print("👥 MULTIPLAYER EVENT: Grand Event (25+ oyuncu)!")
        self:TriggerMultiplayerEvent("Grand", playerCount)
        
    elseif playerCount >= 10 then
        print("👥 MULTIPLAYER EVENT: Festival (10+ oyuncu)!")
        self:TriggerMultiplayerEvent("Festival", playerCount)
        
    elseif playerCount >= 5 then
        print("👥 MULTIPLAYER EVENT: Group Event (5+ oyuncu)!")
        self:TriggerMultiplayerEvent("Group", playerCount)
    end
end

function EventManager:TriggerMultiplayerEvent(eventType, playerCount)
    local rewardMap = {
        ["Group"] = "Common",
        ["Festival"] = "Rare",
        ["Grand"] = "Epic",
        ["Legendary"] = "Epic"
    }
    
    for _, player in ipairs(Players:GetPlayers()) do
        self:GiveReward(player, "Random", rewardMap[eventType], "MULTIPLAYER_" .. eventType)
    end
end

-- ============================================================================
-- REWARD SISTEMI
-- ============================================================================

function EventManager:GiveReward(player, element, rarity, eventType)
    print("✅ Reward veriliyor - Element: " .. element .. ", Rarity: " .. rarity .. ", Event: " .. eventType)
    
    -- TODO: Yumurta sistemiyle entegre et
    -- EggSystem:CreateEgg(player, element, rarity)
    
    -- Event geçmişine ekle
    table.insert(self.eventHistory, {
        player = player.Name,
        element = element,
        rarity = rarity,
        eventType = eventType,
        timestamp = os.time()
    })
end

-- ============================================================================
-- MAIN EVENT LOOP (Ana döngü)
-- ============================================================================

function EventManager:Start()
    print("🎪 Event Manager başlatıldı!")
    
    local lastTimeCheck = os.time()
    local lastMiniGameCheck = os.time()
    local lastLuckyCheck = os.time()
    local lastWeatherCheck = os.time()
    local lastMultiplayerCheck = os.time()
    
    -- Her saniye çalış
    RunService.Heartbeat:Connect(function()
        local currentTime = os.time()
        
        -- Saatlik kontrol (60 saniyede bir)
        if currentTime - lastTimeCheck >= 60 then
            self:CheckTimeEvents()
            lastTimeCheck = currentTime
        end
        
        -- Mini game kontrol (10 dakikada bir = 600 saniye)
        if currentTime - lastMiniGameCheck >= 600 then
            self:TriggerMiniGameEvent()
            lastMiniGameCheck = currentTime
        end
        
        -- Şans kontrol (15-30 dakikada bir)
        if currentTime - lastLuckyCheck >= math.random(900, 1800) then
            self:CheckLuckyEvent()
            lastLuckyCheck = currentTime
        end
        
        -- Hava durumu kontrol (30 dakikada bir)
        if currentTime - lastWeatherCheck >= 1800 then
            self:CheckWeatherEvent()
            lastWeatherCheck = currentTime
        end
        
        -- Mevsimsel kontrol (24 saatte bir)
        if currentTime - lastWeatherCheck >= 86400 then
            self:CheckSeasonalEvent()
        end
        
        -- Çok oyunculu kontrol (5 dakikada bir)
        if currentTime - lastMultiplayerCheck >= 300 then
            self:CheckMultiplayerEvent()
            lastMultiplayerCheck = currentTime
        end
    end)
end

return EventManager