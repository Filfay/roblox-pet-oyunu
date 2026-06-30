--[[
    Main.lua
    Ana script - Tüm sistemleri birleştir
    ServerScriptService'e kopyala
]]--

-- Servisleri al
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Tüm modülleri yükle
local EventManager = require(script.Parent:WaitForChild("EventManager"))
local PetSystem = require(script.Parent:WaitForChild("PetSystem"))
local EggSystem = require(script.Parent:WaitForChild("EggSystem"))
local PlayerData = require(script.Parent:WaitForChild("PlayerData"))
local MiniGames = require(script.Parent:WaitForChild("MiniGames"))
local GUI = require(script.Parent:WaitForChild("GUI"))

print("="*50)
print("🐕 PET ELEMENTS - ANA SCRIPT BAŞLANDI")
print("="*50)

-- ============================================================================
-- OYUNCU GİRİŞİ
-- ============================================================================

Players.PlayerAdded:Connect(function(player)
    print("\n👤 " .. player.Name .. " oyuna giriş yaptı!")
    
    -- Oyuncu verisi yükle
    local playerData = PlayerData:LoadPlayerData(player)
    print("✅ Oyuncu verisi yüklendi")
    
    -- GUI oluştur
    GUI:CreatePlayerPanel(player)
    GUI:CreatePetPanel(player)
    GUI:CreateStatsPanel(player, {
        pets = #playerData.pets,
        eggs = #playerData.eggs,
        objectives = 0,
        playTime = "0h"
    })
    
    print("✅ GUI oluşturuldu")
    
    -- Demo yumurta oluş (test için)
    if #playerData.eggs == 0 then
        print("\n📌 İlk yumurtalar oluşturuluyor...")
        EggSystem:CreateEgg(player, "Fire", "Common", "STARTER")
        EggSystem:CreateEgg(player, "Water", "Common", "STARTER")
        EggSystem:CreateEgg(player, "Nature", "Rare", "STARTER")
        print("✅ İlk yumurtalar oluşturuldu!")
    end
    
    -- Yumurtaları göster
    print("\n🥚 Oyuncunun Yumurta Envanteri:")
    EggSystem:PrintPlayerEggs(player)
    
    -- Auto-save başlat
    PlayerData:StartAutoSave(player, playerData, 60)
end)

Players.PlayerRemoving:Connect(function(player)
    print("\n👤 " .. player.Name .. " oyundan ayrıldı")
end)

-- ============================================================================
-- EVENT MANAGER BAŞLAT
-- ============================================================================

print("\n🎪 Event Manager başlatılıyor...")
EventManager:Start()
print("✅ Event Manager başlatıldı")

-- ============================================================================
-- EGG HATCHER BAŞLAT
-- ============================================================================

print("\n🥚 Egg Hatcher başlatılıyor...")
EggSystem:StartHatcher()
print("✅ Egg Hatcher başlatıldı")

-- ============================================================================
-- TEST DÖNGÜSÜ (Geliştiriciler için)
-- ============================================================================

local testInterval = 0
local TEST_MODE = true -- True = test aktif, False = test deaktif

if TEST_MODE then
    print("\n⚙️ TEST MODU AKTIF")
    
    RunService.Heartbeat:Connect(function()
        testInterval = testInterval + 1
        
        -- Her 300 Frame'de (5 saniye) test çalıştır
        if testInterval >= 300 then
            testInterval = 0
            
            local players = Players:GetPlayers()
            
            if #players > 0 then
                local player = players[1]
                
                -- Rastgele event tetikle
                if math.random(1, 10) == 1 then
                    print("\n🎲 Rastgele event tetikleniyor...")
                    EventManager:CheckLuckyEvent()
                end
                
                -- Mini game tetikle (opsiyonel)
                if math.random(1, 20) == 1 then
                    print("\n🎮 Mini game tetikleniyor...")
                    local success, gameName, score = MiniGames:StartRandomMiniGame(player)
                    
                    if success then
                        local element = PetSystem:DetermineElement()
                        EggSystem:CreateEgg(player, element, "Rare", "MINI_GAME")
                        print("✅ Mini game başarılı! Yumurta kazandı!")
                        
                        -- Bildirim göster
                        GUI:ShowEventNotification(player, "Mini Game Başarılı!", element .. " Egg (Rare)")
                    end
                end
            end
        end
    end)
end

-- ============================================================================
-- KOMUT SISTEMI (TEST İÇİN)
-- ============================================================================

-- Oyuncuya pet ver
local function GivePetCommand(player, element, rarity)
    local pet = PetSystem:CreatePet(element, rarity)
    EggSystem:AddPetToInventory(player, pet)
    print("\n✨ Pet verildi: " .. pet.name .. " (" .. rarity .. ")")
    PetSystem:PrintPetInfo(pet)
    EggSystem:PrintPlayerPets(player)
end

-- Oyuncuya yumurta ver
local function GiveEggCommand(player, element, rarity)
    EggSystem:CreateEgg(player, element, rarity, "COMMAND")
    print("\n🥚 Yumurta verildi: " .. element .. " (" .. rarity .. ")")
    EggSystem:PrintPlayerEggs(player)
end

-- Para ver
local function GiveMoneyCommand(player, amount)
    local playerData = PlayerData:LoadPlayerData(player)
    PlayerData:AddCoins(playerData, amount)
    print("\n💰 Para verildi: " .. amount)
end

-- Test komutları
print("\n" .. string.rep("=", 50))
print("🛠️ TEST KOMUTLARI:")
print("="*50)
print("GivePetCommand(player, 'Fire', 'Rare')")
print("GiveEggCommand(player, 'Water', 'Epic')")
print("GiveMoneyCommand(player, 500)")
print(string.rep("=", 50) .. "\n")

-- Global olarak erişilebilir yap (test için)
_G.GivePet = GivePetCommand
_G.GiveEgg = GiveEggCommand
_G.GiveMoney = GiveMoneyCommand

-- ============================================================================
-- BAŞLANGIÇ ÖZETI
-- ============================================================================

print("\n" .. string.rep("=", 50))
print("✅ PET ELEMENTS OYUNU HAZIR!")
print("="*50)
print("\n📊 Aktif Sistemler:")
print("  ✓ Event Manager (7 event türü)")
print("  ✓ Pet System (5 element)")
print("  ✓ Egg System (Yumurta hatching)")
print("  ✓ Player Data (DataStore)")
print("  ✓ Mini Games (5 oyun)")
print("  ✓ GUI System (UI)")
print("\n🎮 Oyun başladı! Oyuncuları bekleniyor...\n")
print(string.rep("=", 50) .. "\n")
