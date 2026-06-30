--[[
    MiniGames.lua
    Mini oyun sistemi - Tap Tap, Memory Match, Parkour Rush, vb.
]]--

local MiniGames = {}

-- ============================================================================
-- TAP TAP MINI OYUNU
-- ============================================================================

function MiniGames:TapTapGame(player, duration)
    duration = duration or 30
    local score = 0
    local targetScore = 100
    
    print("🎮 TAP TAP BAŞLADI!")
    print(player.Name .. " - 30 saniyede " .. targetScore .. " puan kazan!")
    
    -- Simülasyon (gerçek oyunda input handler olur)
    local startTime = os.time()
    
    while os.time() - startTime < duration do
        -- Her 0.5 saniyede 1 puan kazanma şansı
        if math.random(1, 2) == 1 then
            score = score + math.random(1, 10)
        end
        wait(0.5)
    end
    
    print("✅ TAP TAP BİTTİ! Skor: " .. score)
    
    if score >= targetScore then
        return true, score
    else
        return false, score
    end
end

-- ============================================================================
-- MEMORY MATCH MINI OYUNU
-- ============================================================================

function MiniGames:MemoryMatchGame(player)
    print("🎮 MEMORY MATCH BAŞLADI!")
    print(player.Name .. " - Kartları eşleştir!")
    
    local cards = {1, 1, 2, 2, 3, 3, 4, 4, 5, 5}
    local flipped = {}
    local matched = 0
    local moves = 0
    local maxMoves = 20
    
    -- Kartları karıştır
    for i = 1, #cards do
        local j = math.random(1, #cards)
        cards[i], cards[j] = cards[j], cards[i]
    end
    
    -- Simülasyon
    while matched < 5 and moves < maxMoves do
        local card1 = math.random(1, #cards)
        local card2 = math.random(1, #cards)
        
        if card1 ~= card2 and cards[card1] == cards[card2] then
            matched = matched + 1
            print("✅ Eşleşti! (" .. matched .. "/5)")
        end
        
        moves = moves + 1
    end
    
    print("✅ MEMORY MATCH BİTTİ! Hamle: " .. moves .. "/20")
    
    if matched == 5 then
        return true, matched
    else
        return false, matched
    end
end

-- ============================================================================
-- PARKOUR RUSH MINI OYUNU
-- ============================================================================

function MiniGames:ParkourRushGame(player)
    print("🎮 PARKOUR RUSH BAŞLADI!")
    print(player.Name .. " - Engelleri aş!")
    
    local distance = 0
    local targetDistance = 150
    local crashed = false
    
    -- Simülasyon - 10 saniye boyunca
    for i = 1, 100 do
        distance = distance + math.random(1, 2)
        
        -- %5 şans çarpma
        if math.random(1, 20) == 1 then
            crashed = true
            print("💥 Çarptın!")
            break
        end
        
        wait(0.1)
    end
    
    print("✅ PARKOUR RUSH BİTTİ! Mesafe: " .. distance)
    
    if distance >= targetDistance then
        return true, distance
    else
        return false, distance
    end
end

-- ============================================================================
-- SPIN WHEEL MINI OYUNU
-- ============================================================================

function MiniGames:SpinWheelGame(player)
    print("🎮 SPIN WHEEL BAŞLADI!")
    print(player.Name .. " - Döndürü!")
    
    local rewards = {
        {name = "Coin", amount = 50},
        {name = "XP", amount = 10},
        {name = "Egg", amount = 1},
        {name = "Gem", amount = 5},
        {name = "Nothing", amount = 0},
    }
    
    -- Oyuncunun spin etmesi için bekleme (simülasyon)
    wait(1)
    
    -- Rastgele ödül seç
    local selectedReward = rewards[math.random(1, #rewards)]
    
    print("✅ SPIN WHEEL BİTTİ!")
    print("🎁 Ödül: " .. selectedReward.name .. " x" .. selectedReward.amount)
    
    return true, selectedReward
end

-- ============================================================================
-- CATCH FALLING MINI OYUNU
-- ============================================================================

function MiniGames:CatchFallingGame(player)
    print("🎮 CATCH FALLING BAŞLADI!")
    print(player.Name .. " - Düşenleri yakala!")
    
    local caught = 0
    local targetCaught = 120
    local missed = 0
    
    -- Simülasyon - 30 saniye
    for i = 1, 300 do
        -- Her 0.1 saniyede bir nesne düşer
        if math.random(1, 3) == 1 then
            if math.random(1, 2) == 1 then
                caught = caught + 1
            else
                missed = missed + 1
            end
        end
        
        wait(0.1)
    end
    
    print("✅ CATCH FALLING BİTTİ!")
    print("Yakalanan: " .. caught .. " - Kaçırılan: " .. missed)
    
    if caught >= targetCaught then
        return true, caught
    else
        return false, caught
    end
end

-- ============================================================================
-- MINI OYUN BAŞLATICI
-- ============================================================================

function MiniGames:StartRandomMiniGame(player)
    local games = {
        {name = "Tap Tap", func = self.TapTapGame, minScore = 100},
        {name = "Memory Match", func = self.MemoryMatchGame, minScore = 80},
        {name = "Parkour Rush", func = self.ParkourRushGame, minScore = 150},
        {name = "Spin Wheel", func = self.SpinWheelGame, minScore = 50},
        {name = "Catch Falling", func = self.CatchFallingGame, minScore = 120},
    }
    
    local selectedGame = games[math.random(1, #games)]
    
    print("\n" .. string.rep("=", 50))
    print("🎮 MINI OYUN: " .. selectedGame.name)
    print(string.rep("=", 50) .. "\n")
    
    local success, score = selectedGame.func(self, player)
    
    print("\n" .. string.rep("=", 50))
    if success then
        print("✅ BAŞARILI! Skor: " .. score)
    else
        print("❌ BAŞARISIZ! Skor: " .. score)
    end
    print(string.rep("=", 50) .. "\n")
    
    return success, selectedGame.name, score
end

return MiniGames