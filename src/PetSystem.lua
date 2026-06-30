--[[
    PetSystem.lua
    Pet sistemi - Pet oluşturma, yetiştirme, breeding
]]--

local PetSystem = {}

-- ============================================================================
-- PET VERILERI
-- ============================================================================

PetSystem.PetBreeds = {
    Fire = {
        {name = "Phoenix", stats = {health = 100, attack = 90, speed = 85}, icon = "🔥"},
        {name = "Dragon", stats = {health = 150, attack = 120, speed = 60}, icon = "🐉"},
        {name = "Fox", stats = {health = 60, attack = 70, speed = 95}, icon = "🦊"},
    },
    Water = {
        {name = "Dolphin", stats = {health = 80, attack = 75, speed = 90}, icon = "🐬"},
        {name = "Turtle", stats = {health = 140, attack = 50, speed = 40}, icon = "🐢"},
        {name = "Leviathan", stats = {health = 180, attack = 110, speed = 50}, icon = "🌊"},
    },
    Nature = {
        {name = "Deer", stats = {health = 70, attack = 60, speed = 100}, icon = "🦌"},
        {name = "Rabbit", stats = {health = 50, attack = 50, speed = 110}, icon = "🐰"},
        {name = "Tree Spirit", stats = {health = 120, attack = 80, speed = 70}, icon = "🌲"},
    },
    Electric = {
        {name = "Spark", stats = {health = 75, attack = 85, speed = 95}, icon = "⚡"},
        {name = "Thunder Bird", stats = {health = 90, attack = 100, speed = 88}, icon = "🦅"},
        {name = "Storm Beast", stats = {health = 130, attack = 115, speed = 85}, icon = "⛈️"},
    },
    Dark = {
        {name = "Shadow Cat", stats = {health = 85, attack = 95, speed = 90}, icon = "🐈‍⬛"},
        {name = "Raven", stats = {health = 65, attack = 75, speed = 100}, icon = "🐦"},
        {name = "Void Dragon", stats = {health = 160, attack = 130, speed = 75}, icon = "🖤"},
    }
}

-- Element kombinasyonları (Hybrid petler)
PetSystem.HybridCombinations = {
    ["Fire_Water"] = {name = "Steam Sprite", element = "Steam", icon = "💨"},
    ["Fire_Nature"] = {name = "Lava Guardian", element = "Lava", icon = "🌋"},
    ["Water_Nature"] = {name = "Moss Guardian", element = "Moss", icon = "🟢"},
    ["Electric_Water"] = {name = "Storm Rider", element = "Storm", icon = "⛈️"},
    ["Dark_Fire"] = {name = "Inferno Beast", element = "Inferno", icon = "🔥🖤"},
    ["Electric_Nature"] = {name = "Nature Storm", element = "NatureStorm", icon = "🌪️"},
}

-- Nadir oranları
PetSystem.RarityRates = {
    Common = 0.60,    -- %60
    Rare = 0.30,      -- %30
    Epic = 0.08,      -- %8
    Legendary = 0.02  -- %2
}

-- ============================================================================
-- PET OLUŞTURMA
-- ============================================================================

function PetSystem:CreatePet(element, rarity)
    local breeds = self.PetBreeds[element]
    local selectedBreed = breeds[math.random(1, #breeds)]
    
    local pet = {
        id = game:GetService("HttpService"):GenerateGUID(false),
        name = selectedBreed.name,
        element = element,
        rarity = rarity,
        level = 1,
        experience = 0,
        stats = {
            health = selectedBreed.stats.health,
            attack = selectedBreed.stats.attack,
            speed = selectedBreed.stats.speed,
        },
        icon = selectedBreed.icon,
        createdAt = os.time(),
        value = self:CalculatePetValue(rarity, selectedBreed.stats),
    }
    
    return pet
end

function PetSystem:CalculatePetValue(rarity, stats)
    local baseValue = 100
    local rarityMultiplier = {
        Common = 1,
        Rare = 3,
        Epic = 8,
        Legendary = 20
    }
    
    local totalStats = stats.health + stats.attack + stats.speed
    local statsBonus = totalStats / 300 -- Normalize et
    
    return math.floor(baseValue * rarityMultiplier[rarity] * (1 + statsBonus))
end

-- ============================================================================
-- RARITY BELIRLEME (Event'ten gelen)
-- ============================================================================

function PetSystem:DetermineRarity()
    local random = math.random()
    
    if random <= self.RarityRates.Common then
        return "Common"
    elseif random <= (self.RarityRates.Common + self.RarityRates.Rare) then
        return "Rare"
    elseif random <= (self.RarityRates.Common + self.RarityRates.Rare + self.RarityRates.Epic) then
        return "Epic"
    else
        return "Legendary"
    end
end

function PetSystem:DetermineElement()
    local elements = {"Fire", "Water", "Nature", "Electric", "Dark"}
    return elements[math.random(1, #elements)]
end

-- ============================================================================
-- PET YETİŞTİRME
-- ============================================================================

function PetSystem:FeedPet(pet, foodAmount)
    -- Yemek ver, experience ver
    pet.experience = pet.experience + foodAmount
    
    local expNeeded = 100 * pet.level
    
    if pet.experience >= expNeeded then
        self:LevelUpPet(pet)
    end
    
    return pet
end

function PetSystem:LevelUpPet(pet)
    pet.level = pet.level + 1
    pet.experience = 0
    
    -- Stat'ları geliştir
    local statIncrease = {
        health = math.floor(pet.stats.health * 0.1),
        attack = math.floor(pet.stats.attack * 0.1),
        speed = math.floor(pet.stats.speed * 0.1),
    }
    
    pet.stats.health = pet.stats.health + statIncrease.health
    pet.stats.attack = pet.stats.attack + statIncrease.attack
    pet.stats.speed = pet.stats.speed + statIncrease.speed
    
    print("✨ " .. pet.name .. " Level " .. pet.level .. " oldu!")
    
    return pet
end

-- ============================================================================
-- BREEDING (Çoğaltma)
-- ============================================================================

function PetSystem:BreedPets(pet1, pet2)
    -- Ebeveynlerin genetiğini birleştir
    local childElement = pet1.element
    
    -- %30 şans çocuğun farklı element olması
    if math.random(1, 100) <= 30 then
        if pet1.element ~= pet2.element then
            childElement = pet2.element
        end
    end
    
    local childRarity = self:DetermineChildRarity(pet1.rarity, pet2.rarity)
    local childPet = self:CreatePet(childElement, childRarity)
    
    -- İlk level 5 olsun (breeding bonusu)
    childPet.level = 5
    
    print("🐣 Yeni pet doğdu: " .. childPet.name .. " (" .. childRarity .. ")")
    
    return childPet
end

function PetSystem:DetermineChildRarity(parent1Rarity, parent2Rarity)
    local rarityValues = {
        Common = 1,
        Rare = 2,
        Epic = 3,
        Legendary = 4
    }
    
    local parent1Val = rarityValues[parent1Rarity]
    local parent2Val = rarityValues[parent2Rarity]
    
    -- Ortalaması al, biraz rastgelelik ekle
    local avgRarity = math.floor((parent1Val + parent2Val) / 2 + math.random(-1, 1))
    
    local rarityMap = {
        [1] = "Common",
        [2] = "Rare",
        [3] = "Epic",
        [4] = "Legendary"
    }
    
    return rarityMap[math.max(1, math.min(4, avgRarity))]
end

-- ============================================================================
-- HYBRID PET OLUŞTURMA
-- ============================================================================

function PetSystem:CreateHybridPet(pet1, pet2)
    local combinationKey = pet1.element .. "_" .. pet2.element
    
    -- Ters sırada da kontrol et
    if not self.HybridCombinations[combinationKey] then
        combinationKey = pet2.element .. "_" .. pet1.element
    end
    
    local hybridData = self.HybridCombinations[combinationKey]
    
    if not hybridData then
        print("❌ Bu kombinasyon imkansız!")
        return nil
    end
    
    -- Hybrid pet oluştur
    local hybridPet = {
        id = game:GetService("HttpService"):GenerateGUID(false),
        name = hybridData.name,
        element = hybridData.element,
        rarity = "Rare", -- Hybrid'ler daima Rare
        level = math.max(pet1.level, pet2.level),
        experience = 0,
        stats = {
            health = math.floor((pet1.stats.health + pet2.stats.health) / 2 * 1.2),
            attack = math.floor((pet1.stats.attack + pet2.stats.attack) / 2 * 1.2),
            speed = math.floor((pet1.stats.speed + pet2.stats.speed) / 2 * 1.2),
        },
        icon = hybridData.icon,
        createdAt = os.time(),
        isHybrid = true,
        parentElements = {pet1.element, pet2.element},
    }
    
    hybridPet.value = self:CalculatePetValue(hybridPet.rarity, hybridPet.stats)
    
    print("✨ Hybrid pet oluşturuldu: " .. hybridPet.name)
    
    return hybridPet
end

-- ============================================================================
-- PET İSTATİSTİKLERİ
-- ============================================================================

function PetSystem:GetPetInfo(pet)
    return {
        name = pet.name,
        element = pet.element,
        rarity = pet.rarity,
        level = pet.level,
        experience = pet.experience,
        health = pet.stats.health,
        attack = pet.stats.attack,
        speed = pet.stats.speed,
        value = pet.value,
        icon = pet.icon,
        isHybrid = pet.isHybrid or false,
    }
end

function PetSystem:PrintPetInfo(pet)
    print("\n" .. pet.icon .. " ===== " .. pet.name .. " =====")
    print("Element: " .. pet.element)
    print("Rarity: " .. pet.rarity)
    print("Level: " .. pet.level)
    print("Health: " .. pet.stats.health)
    print("Attack: " .. pet.stats.attack)
    print("Speed: " .. pet.stats.speed)
    print("Value: " .. pet.value .. " coins")
    if pet.isHybrid then
        print("Hybrid: YES")
    end
    print("========================\n")
end

return PetSystem