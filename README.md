# 🐕 Pet Elements - Roblox Pet Tycoon

**Event sistemli, oyuncuları oyunda tutacak bir Pet Tycoon oyunu!**

---

## 🎮 Oyun Özellikleri

### 📅 **7 Türde Event Sistemi**
- ⏰ **Time-based Events** - Her saat başında farklı elementli yumurta
- 🎮 **Mini Game Events** - Mini oyunlar oynayarak yumurta kazan
- 🎯 **Objective Events** - Görevleri tamamlayarak yumurta kazan
- 🌍 **Seasonal Events** - Mevsimsel özel yumurtalar
- 🌦️ **Weather Events** - Hava durumuna göre event
- 🎲 **Lucky Random Events** - Rastgele şans olayları
- 👥 **Multiplayer Events** - Oyuncu sayısına göre mega eventler

### 🔥 **5 Element Sistemi**
- 🔥 **Fire** (Ateş) - Phoenix, Dragon, Fox
- 💧 **Water** (Su) - Dolphin, Turtle, Leviathan
- 🌿 **Nature** (Doğa) - Deer, Rabbit, Tree Spirit
- ⚡ **Electric** (Elektrik) - Spark, Thunder Bird, Storm Beast
- 🌙 **Dark** (Karanlık) - Shadow Cat, Raven, Void Dragon

### 🐕 **Pet Sistemi**
- Nadir ırk sistemi (Common, Rare, Epic, Legendary)
- Pet yetiştirme ve levelling
- Breeding (iki peti birleştir, hybrid pet oluştur)
- Pet satış sistemi
- Element kombinasyonu ile hybrid petler

### 🎮 **5 Mini Oyun**
- 🎮 **Tap Tap** - Hızlı tıklama
- 🧠 **Memory Match** - Hafıza oyunu
- 🏃 **Parkour Rush** - Engel aşma
- 🎡 **Spin Wheel** - Döndür, kazan
- 🎯 **Catch Falling** - Düşenleri yakala

### 💰 **Ekonomi Sistemi**
- Para kazanma (pet satışı, görevler, eventler)
- Yumurta satın alma
- Pet levelı geliştirme
- DataStore ile veri kayıt

### 🎨 **GUI Sistemi**
- Modern arayüz tasarımı
- Sekme sistemi (Yumurtalar, Petler, Mağaza, İstatistikler, Görevler)
- Event bildirimleri
- Pet gösterimi paneli
- İstatistik paneli

---

## 📁 **Proje Yapısı**

```
roblox-pet-oyunu/
├── src/
│   ├── Main.lua              ← Ana script (bunu Roblox'a kopyala)
│   ├── EventManager.lua      ← Event sistemi
│   ├── PetSystem.lua         ← Pet yönetimi
│   ├── EggSystem.lua         ← Yumurta sistemi
│   ├── MiniGames.lua         ← Mini oyunlar
│   ├── PlayerData.lua        ← Oyuncu verisi
│   └── GUI.lua               ← Arayüz
└── README.md
```

---

## 🚀 **Kurulum**

### 1️⃣ **Roblox Studio'da Yeni Oyun Oluştur**
- Roblox Studio aç
- Blank Game seç
- Yeni oyun oluştur

### 2️⃣ **Script Dosyalarını Kopyala**
1. **ServerScriptService** > Yeni Script > "Main" olarak adlandır
2. Main.lua'daki tüm kodu kopyala ve yapıştır
3. Script başarısız derlenirse, Cmd+Shift+B (Syntax Check) yap

### 3️⃣ **Modülleri Ekle**
1. ServerScriptService'de 6 adet **ModuleScript** oluştur:
   - EventManager
   - PetSystem
   - EggSystem
   - PlayerData
   - MiniGames
   - GUI

2. Her ModuleScript'e ilgili Lua kodunu kopyala

### 4️⃣ **Oyunu Başlat**
- Play tuşuna bas
- Konsolu aç (View > Output)
- Oyun başlamış olmalı!

---

## 🎮 **Nasıl Oynanır**

### Oyuncuların Hedefi:
1. 🥚 **Yumurta topla** - Eventlere katılarak, mini oyunlar oynayarak
2. 🐕 **Pet yetiştir** - Yumurtaları aç, petleri level atla
3. 🔀 **Breeding yap** - İki peti birleştir, hybrid pet oluştur
4. 💰 **Para kazan** - Petleri sat, görevleri tamamla
5. 🏆 **Başarı aç** - Başarıları kilidini aç, ödüller al

### Event Döngüsü:
```
Her Saat → Time-based Event (Yumurta)
Her 10 dakika → Mini Game Event
Her 15-30 dakika → Lucky Random Event
Her 30 dakika → Weather Event
Mevsimde 1x → Seasonal Event
5+ oyuncu → Multiplayer Event
```

---

## 🛠️ **Test Komutları**

Roblox Output konsolunda şunları yazabilirsin:

```lua
-- Pet ver
_G.GivePet(game.Players:GetPlayers()[1], "Fire", "Rare")

-- Yumurta ver
_G.GiveEgg(game.Players:GetPlayers()[1], "Water", "Epic")

-- Para ver
_G.GiveMoney(game.Players:GetPlayers()[1], 1000)
```

---

## 📊 **Sistem Mimarisi**

### EventManager
```
⏰ Saatlik Check
├─ Time Events
├─ Mini Games
├─ Objectives
├─ Seasonal
├─ Weather
├─ Lucky Events
└─ Multiplayer Events
```

### PetSystem
```
🐕 Pet Oluştur
├─ Element Seç (5 türde)
├─ Rarity Belirle (4 seviye)
├─ Stats Hesapla
└─ Hybrid Pet (2 elementten)
```

### EggSystem
```
🥚 Yumurta Yönet
├─ Oluştur (Event'ten)
├─ Progress Güncelle (300 saniye)
├─ Hatch Et (Pet Doğur)
└─ İnvanter Yönet
```

### PlayerData
```
👤 Oyuncu Verisi
├─ Ekonomi (Para, Gems)
├─ İstatistikler
├─ Başarılar
├─ Event Geçmişi
└─ DataStore (Kaydet/Yükle)
```

---

## 🎨 **GUI Özellikleri**

- 📱 Responsive tasarım
- 🎨 Modern dark theme
- 🔄 Sekme sistemi (5 tab)
- 📊 İstatistik gösterimi
- 🔔 Event bildirimleri
- ⚡ Smooth hover efektleri

---

## 🐛 **Bilinen Sorunlar**

- Mini oyunlar şu an simülasyon (gerçek input handler ekle)
- Weather sistemi API kullanmıyor (rastgele)
- Hybrid pet kombinasyonu 6'ya sınırlı (daha ekle)

---

## 🔄 **Gelecek Güncellemeler**

- [ ] PvP battal sistemi
- [ ] Pet Trading Pazar
- [ ] Clans/Guilds
- [ ] Leaderboards
- [ ] Achievements UI
- [ ] Pet Skins
- [ ] More Mini Games
- [ ] Mobile Uyumluluğu

---

## 📞 **Destek**

Sorun yaşarsan:
1. Output'u kontrol et (Syntax hataları)
2. Tüm ModuleScriptlerin adlarını kontrol et
3. ServerScriptService'da Main script olduğunu doğrula
4. Roblox Studio'yu restart et

---

## 📜 **Lisans**

Bu proje açık kaynak olup özgürce kullanılabilir.

---

**Oyunı Geliştir! 🚀**

Filfay tarafından geliştirilmiştir.