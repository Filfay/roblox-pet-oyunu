--[[
    EggSystem.lua
    Yumurta sistemi - Yumurta oluşturma, açılma, veri yönetimi
]]--

local EggSystem = {}
local PetSystem = require(script.Parent.PetSystem)

-- ============================================================================
-- YUMURTA VERİ YAPISI
-- ============================================================================

EggSystem.eggs = {} -- Tüm yumurtaları tut

function EggSystem:CreateEgg(player, element, rarity, eventType)
    local egg = {
        id = game:GetService("HttpService"):GenerateGUID(false),
        playerId = player.UserId,
        playerName = player.Name,
        element = element or PetSystem:DetermineElement(),
        rarity = rarity or PetSystem:DetermineRarity(),
        eventType = eventType or "UNKNOWN",
        createdAt = os.time(),
        hatchTime = nil,
        isHatched = false,
        hatchedPet = nil,
        
        -- Yumurta görünümü
        stage = 1, -- 1-3 arasında
        progress = 0, -- 0-100
        icon = "🥚",
    }
    
    print("🥚 Yumurta oluşturuldu - " .. player.Name .. " - " .. element .. " (" .. rarity .. ")")
    
    table.insert(self.eggs, egg)
    self:SaveEggToPlayer(player, egg)
    
    return egg
end

-- ============================================================================
-- YUMURTA AÇILMA
-- ============================================================================

function EggSystem:HatchEgg(egg)
    if egg.isHatched then
        print("⚠️ Bu yumurta zaten açıldı!")
        return nil
    end
    
    -- Pet oluştur
    local pet = PetSystem:CreatePet(egg.element, egg.rarity)
    
    egg.isHatched = true
    egg.hatchedPet = pet
    egg.hatchTime = os.time()
    
    print("✨ Yumurta açıldı! Pet: " .. pet.name .. " " .. pet.icon)
    
    return pet
end

function EggSystem:UpdateEggProgress(egg, deltaTime)
    -- Her saniyede ilerleme artar
    -- Toplam 300 saniyede (5 dakika) açılır (test için)
    -- Gerçek oyunda daha uzun olabilir
    
    if egg.isHatched then
        return
    end
    
    egg.progress = egg.progress + (deltaTime / 300) * 100
    
    -- Stage güncellemesi
    if egg.progress > 33 and egg.stage == 1 then
        egg.stage = 2
        egg.icon = "🥚💫"
    elseif egg.progress > 66 and egg.stage == 2 then
        egg.stage = 3
        egg.icon = "🥚✨"
    end
    
    if egg.progress >= 100 then
        self:HatchEgg(egg)
    end
end

-- ============================================================================
-- YUMURTA VERİ YÖNETİMİ
-- ============================================================================

function EggSystem:SaveEggToPlayer(player, egg)
    local playerData = self:GetPlayerData(player)
    
    if not playerData.eggs then
        playerData.eggs = {}
    end
    
    table.insert(playerData.eggs, egg)
    
    print("💾 Yumurta oyuncuya kaydedildi")
end

function EggSystem:GetPlayerData(player)
    -- TODO: DataStore entegrasyonu
    -- Şimdilik memory'de tutalım
    
    if not _G.PlayerData then
        _G.PlayerData = {}
    end
    
    if not _G.PlayerData[player.UserId] then
        _G.PlayerData[player.UserId] = {
            eggs = {},
            pets = {},
            coins = 1000,
        }
    end
    
    return _G.PlayerData[player.UserId]
end

function EggSystem:GetPlayerEggs(player)
    local playerData = self:GetPlayerData(player)
    return playerData.eggs or {}
end

function EggSystem:GetPlayerPets(player)
    local playerData = self:GetPlayerData(player)
    return playerData.pets or {}
end

-- ============================================================================
-- YUMURTA ENVANTERI
-- ============================================================================

function EggSystem:PrintPlayerEggs(player)
    local eggs = self:GetPlayerEggs(player)
    
    print("\n" .. player.Name .. " - Yumurtalar (" .. #eggs .. ")")
    print("================================")
    
    for i, egg in ipairs(eggs) do
        local status = egg.isHatched and "✅ AÇILDI" or "🥚 KAPALI (" .. math.floor(egg.progress) .. "%)" 
        print(i .. ". " .. egg.icon .. " " .. egg.element .. " - " .. egg.rarity .. " - " .. status)
    end
    
    print("================================\n")
end

-- ============================================================================
-- YUMURTA ALIŞVERIŞI
-- ============================================================================

function EggSystem:BuyEgg(player, rarity)
    local prices = {
        Common = 100,
        Rare = 300,
        Epic = 800,
        Legendary = 2000
    }
    
    local playerData = self:GetPlayerData(player)
    local price = prices[rarity]
    
    if playerData.coins >= price then
        playerData.coins = playerData.coins - price
        
        -- Random element seç
        local element = PetSystem:DetermineElement()
        
        self:CreateEgg(player, element, rarity, "PURCHASED")
        
        print("💳 Yumurta satın alındı - " .. player.Name .. " (" .. rarity .. ")")
        return true
    else
        print("❌ Yeterli coin yok! Gereken: " .. price .. ", Var: " .. playerData.coins)
        return false
    end
end

-- ============================================================================
-- PET'İ ENVANTERYE EKLEMEVERİLERİ
-- ============================================================================

function EggSystem:AddPetToInventory(player, pet)
    local playerData = self:GetPlayerData(player)
    
    if not playerData.pets then
        playerData.pets = {}
    end
    
    table.insert(playerData.pets, pet)
    
    print("📦 Pet envanterye eklendi: " .. player.Name .. " - " .. pet.name)
end

function EggSystem:PrintPlayerPets(player)
    local pets = self:GetPlayerPets(player)
    
    print("\n" .. player.Name .. " - Petler (" .. #pets .. ")")
    print("================================")
    
    for i, pet in ipairs(pets) do
        print(i .. ". " .. pet.icon .. " " .. pet.name .. " (Level " .. pet.level .. ") - " .. pet.rarity)
    end
    
    print("================================\n")
end

-- ============================================================================
-- YUMURTA HATCHER (Ana Döngü)
-- ============================================================================

function EggSystem:StartHatcher()
    print("🥚 Egg Hatcher başlatıldı!")
    
    local RunService = game:GetService("RunService")
    
    RunService.Heartbeat:Connect(function(deltaTime)
        for _, egg in ipairs(self.eggs) do
            if not egg.isHatched then
                self:UpdateEggProgress(egg, deltaTime)
            end
        end
    end)
end

-- ============================================================================
-- YUMURTA İSTATİSTİKLERİ
-- ============================================================================

function EggSystem:GetEggInfo(egg)
    return {
        id = egg.id,
        element = egg.element,
        rarity = egg.rarity,
        eventType = egg.eventType,
        isHatched = egg.isHatched,
        progress = math.floor(egg.progress),
        stage = egg.stage,
        createdAt = egg.createdAt,
    }
end

return EggSystem