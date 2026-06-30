--[[
    PlayerData.lua
    Oyuncu veri yönetimi ve DataStore entegrasyonu
]]--

local PlayerData = {}
local DataStoreService = game:GetService("DataStoreService")

-- DataStore oluştur
local playerDataStore = DataStoreService:GetDataStore("PlayerData")
local levelDataStore = DataStoreService:GetDataStore("PlayerLevels")

-- ============================================================================
-- OYUNCU VERİ YAPISI
-- ============================================================================

function PlayerData:CreateNewPlayerData(player)
    return {
        userId = player.UserId,
        playerName = player.Name,
        joinedAt = os.time(),
        lastLogin = os.time(),
        
        -- Ekonomi
        coins = 1000,
        gems = 0,
        totalSpent = 0,
        
        -- Pet Yönetimi
        pets = {},
        eggs = {},
        currentPet = nil,
        
        -- İstatistikler
        petsRaised = 0,
        eggsHatched = 0,
        breedingsCompleted = 0,
        totalPlayTime = 0,
        firstRarePetObtained = false,
        
        -- Event Geçmişi
        eventLog = {},
        dailyClaimedEvents = {},
        
        -- Başarılar
        achievements = {},
    }
end

-- ============================================================================
-- OYUNCU VERİSİ KAYDETME
-- ============================================================================

function PlayerData:SavePlayerData(player, data)
    local success, err = pcall(function()
        playerDataStore:SetAsync("player_" .. player.UserId, data)
    end)
    
    if success then
        print("✅ Oyuncu verisi kaydedildi: " .. player.Name)
    else
        print("❌ Hata: " .. err)
    end
end

function PlayerData:LoadPlayerData(player)
    local success, data = pcall(function()
        return playerDataStore:GetAsync("player_" .. player.UserId)
    end)
    
    if success then
        if data then
            print("✅ Oyuncu verisi yüklendi: " .. player.Name)
            return data
        else
            print("ℹ️ Yeni oyuncu: " .. player.Name)
            local newData = self:CreateNewPlayerData(player)
            self:SavePlayerData(player, newData)
            return newData
        end
    else
        print("❌ Hata: " .. data)
        return self:CreateNewPlayerData(player)
    end
end

-- ============================================================================
-- OYUNCU SEVİYESİ YÖNETİMİ
-- ============================================================================

function PlayerData:GetPlayerLevel(player)
    local success, level = pcall(function()
        return levelDataStore:GetAsync("level_" .. player.UserId) or 1
    end)
    
    if success then
        return level
    else
        return 1
    end
end

function PlayerData:SetPlayerLevel(player, level)
    local success, err = pcall(function()
        levelDataStore:SetAsync("level_" .. player.UserId, level)
    end)
    
    if success then
        print("✅ Seviye güncellendi: " .. player.Name .. " - Level " .. level)
    else
        print("❌ Hata: " .. err)
    end
end

-- ============================================================================
-- PARA YÖNETİMİ
-- ============================================================================

function PlayerData:AddCoins(playerData, amount)
    playerData.coins = playerData.coins + amount
    print("💰 +" .. amount .. " coin - Toplam: " .. playerData.coins)
    return playerData.coins
end

function PlayerData:RemoveCoins(playerData, amount)
    if playerData.coins >= amount then
        playerData.coins = playerData.coins - amount
        print("💸 -" .. amount .. " coin - Kalan: " .. playerData.coins)
        return true
    else
        print("❌ Yeterli coin yok!")
        return false
    end
end

function PlayerData:GetCoins(playerData)
    return playerData.coins
end

-- ============================================================================
-- İSTATİSTİK GÜNCELLEME
-- ============================================================================

function PlayerData:IncrementStat(playerData, statName)
    if playerData[statName] then
        playerData[statName] = playerData[statName] + 1
        print("📊 " .. statName .. " artırıldı: " .. playerData[statName])
    end
end

function PlayerData:UpdatePlayTime(playerData, seconds)
    playerData.totalPlayTime = playerData.totalPlayTime + seconds
end

function PlayerData:GetPlayerStats(playerData)
    return {
        petsRaised = playerData.petsRaised,
        eggsHatched = playerData.eggsHatched,
        breedingsCompleted = playerData.breedingsCompleted,
        totalPlayTime = playerData.totalPlayTime,
        coins = playerData.coins,
        gems = playerData.gems,
    }
end

-- ============================================================================
-- BAŞARI (ACHIEVEMENT) SİSTEMİ
-- ============================================================================

function PlayerData:UnlockAchievement(playerData, achievementId)
    if not playerData.achievements then
        playerData.achievements = {}
    end
    
    if not playerData.achievements[achievementId] then
        playerData.achievements[achievementId] = {
            unlocked = true,
            unlockedAt = os.time(),
        }
        print("🏆 Başarı açıldı: " .. achievementId)
        return true
    end
    
    return false
end

function PlayerData:CheckAchievements(playerData)
    -- Çeşitli başarıları kontrol et
    
    -- 10 pet yetiştirdiyse
    if playerData.petsRaised >= 10 then
        self:UnlockAchievement(playerData, "PET_COLLECTOR")
    end
    
    -- 5 breeding yaptıysa
    if playerData.breedingsCompleted >= 5 then
        self:UnlockAchievement(playerData, "BREEDER")
    end
    
    -- İlk Nadir Pet aldıysa
    if playerData.firstRarePetObtained then
        self:UnlockAchievement(playerData, "LUCKY_ONE")
    end
    
    -- 50 saat oynadıysa
    if playerData.totalPlayTime >= 50 * 3600 then
        self:UnlockAchievement(playerData, "DEDICATED")
    end
    
    -- 10000 coin biriktirdiyse
    if playerData.coins >= 10000 then
        self:UnlockAchievement(playerData, "RICH")
    end
end

-- ============================================================================
-- EVENT GEÇMİŞİ
-- ============================================================================

function PlayerData:LogEvent(playerData, eventType, eventData)
    if not playerData.eventLog then
        playerData.eventLog = {}
    end
    
    table.insert(playerData.eventLog, {
        type = eventType,
        data = eventData,
        timestamp = os.time(),
    })
end

function PlayerData:GetEventHistory(playerData, limit)
    limit = limit or 10
    
    local history = {}
    for i = math.max(1, #playerData.eventLog - limit + 1), #playerData.eventLog do
        table.insert(history, playerData.eventLog[i])
    end
    
    return history
end

-- ============================================================================
-- GÜNLÜK KONTROL
-- ============================================================================

function PlayerData:ClaimDailyReward(playerData)
    local today = os.date("%Y-%m-%d", os.time())
    
    if not playerData.dailyClaimedEvents then
        playerData.dailyClaimedEvents = {}
    end
    
    if playerData.dailyClaimedEvents[today] then
        print("⚠️ Günlük ödülü zaten aldın!")
        return false
    else
        print("✅ Günlük ödülü aldın!")
        playerData.dailyClaimedEvents[today] = true
        
        -- Ödül ver
        self:AddCoins(playerData, 100)
        
        return true
    end
end

-- ============================================================================
-- OYUNCU BİLGİ GÖSTERİMİ
-- ============================================================================

function PlayerData:PrintPlayerInfo(playerData)
    print("\n" .. playerData.playerName .. " - Oyuncu Bilgisi")
    print("================================")
    print("Coins: " .. playerData.coins)
    print("Gems: " .. playerData.gems)
    print("Pets: " .. #playerData.pets)
    print("Eggs: " .. #playerData.eggs)
    print("Pets Raised: " .. playerData.petsRaised)
    print("Eggs Hatched: " .. playerData.eggsHatched)
    print("Breedings: " .. playerData.breedingsCompleted)
    print("Total Play Time: " .. math.floor(playerData.totalPlayTime / 3600) .. " hours")
    print("================================\n")
end

-- ============================================================================
-- AUTO-SAVE
-- ============================================================================

function PlayerData:StartAutoSave(player, playerData, interval)
    interval = interval or 60 -- Her 60 saniye
    
    local RunService = game:GetService("RunService")
    
    RunService.Heartbeat:Connect(function()
        wait(interval)
        self:SavePlayerData(player, playerData)
    end)
end

return PlayerData