# Gamedev.js Jam 2026 MACHINES

![jam theme](etc/jam26-theme.png)

Entry for Gamedev.js Jam 2026 **Machines**

https://itch.io/jam/gamedevjs-2026

https://gamedevjs.com/competitions/gamedev-js-jam-2026-start-and-theme-announcement/

---

# 🥤 Vending Machine Mayhem

> **A high-octane Bullet Heaven survival game for Gamedev.js**
<center>

![concept](design/concept-gemini-ai-generated-20260414.jpg)
![cover](design/concept-cover-gemini-ai-generated-20260414.jpg)

</center>

---

## 📋 Game Design Document

### 1. Game Vision
**Vending Machine Mayhem** is a dynamic top-down arena shooter (survival) where the player must survive relentless waves of aggressive vending machines. The game focuses on high-octane chaos, quick reflexes, and the humorous concept of fighting back against "unhealthy snacks."

### 2. Core Loop
* **Defense:** Navigate the open arena to dodge food-based projectiles.
* **Elimination:** Destroy vending machines using coins (ranged) or a crowbar (melee).
* **Upgrade:** Collect "Sugar" dropped by destroyed machines to buy upgrades between waves.
* **Progression:** Survive increasingly difficult waves featuring faster and deadlier machine types.

### 3. Gameplay Mechanics

#### **Movement & Combat**
* **Dash:** A short, burst of speed used to dodge incoming cans or avoid being cornered.
* **Coin Attack:** The player fires coins. Each shot "costs" money (the game's currency acts as ammunition), forcing a balance between offense and saving for upgrades.
* **Knockback:** Getting hit by food pushes the player back, potentially shoving them into a dangerous cluster of enemies.

#### **Enemy Types (Vending Machines)**
| Type | Attack | Behavior |
| :--- | :--- | :--- |
| **Soda Machine** | Fires soda cans in a straight line. | Stationary while firing, then rolls closer to player. |
| **Snack Machine** | Sprays bags of chips (shotgun spread). | Slow movement but very high durability. |
| **Coffee Bot** | Leaves burning puddles of hot coffee. | Circles the player, creating hazardous zones. |
| **Toy Capsule** | Launches small, explosive capsules. | Fast-moving; attempts to ram the player. |

---

### 4. Progression System (Upgrades)
At the end of each wave, the player chooses one of three random power-up cards:

* **Sugar Rush:** +15% Movement Speed
* **Extra Carbonation:** +20% Projectile Velocity
* **Quick Change:** -15% Fire Cooldown
* **Magnet:** Wider Collection Range

![upgrades](design/Gemini_Generated_Image_xeo0txeo0txeo0tx.png)

---

### 5. World Design (The Map)
* **The Arena:** A minimalist gray space (e.g., an empty parking lot or a dark warehouse).
* **Clean Layout:** No static obstacles, allowing the player to focus entirely on bullet-dodging patterns.
* **Dynamic Borders:** Boundaries (like "Caution" tape) shrink as the wave progresses, forcing the player into closer quarters with the machines.

---

### 6. Visuals & Sound
* **Style:** Low-poly 3D or clean 2D Cartoon.
* **VFX:** Destroyed machines erupt in a "fountain" of food items and coins.
* **Audio:** * Mechanical "clunks" and "whirs" for movement.
    * Satisfying "psshhh" (hissing gas) when soda cans are fired.
    * High-energy, retro Synthwave soundtrack.

---

### 7. Win/Loss Conditions
* **Defeat:** The "Health" bar (or "Blood Sugar Level") reaches zero after taking too many hits.
* **Victory:** Survive 10 waves and defeat the Final Boss: **The Industrial Walk-in Freezer**.


## 🎮 Asset Development Tracker

| Category | Asset Name | Description | Status | File Link |
| :--- | :--- | :--- | :---: | :--- |
 **Characters** | Player Sprite Sheet (Boy) | Idle, Walk, Shoot (4 directions) | ✅ Done | [link](assets/spritesheet-boy-4x3-100x150.png) |
| **Characters** | Player Sprite Sheet (Girl) | Idle, Walk, Shoot (4 directions) | ✅ Done | [link](assets/spritesheet-girl-4x3-100x150.png) |
| **Enemies** | Soda Machine | Enemy RED: shoots soda cans | ✅ Done | [link](assets/spritesheet-machine-red-4x2-250x350.png) |
| **Enemies** | Snack Machine | Enemy YELLOW: shotgun-style chip spray | ✅ Done | [link](assets/spritesheet-machine-yellow-4x2-250x350.png) |
| **Enemies** | Coffee Bot | Enemy BLUE: leaves hot coffee puddles | ✅ Done | [link](assets/spritesheet-machine-blue-4x2-250x350.png) |
| **Enemies** | Industrial Fridge | Final Boss | ❌ Todo | [link](#) |
| **Collectibles**| Coin | Ammo currency | ✅ Done | [link](assets/spritesheet-coin-2x4-120x120.png) |
| **Collectibles**| Sugar | Upgrades currency | ✅ Done | [link](assets/spritesheet-sugar-2x4-120x120.png) |
| **Projectiles**| Soda Can / Chips | Enemy projectiles | ✅ Done | [link](assets/spritesheet-food-3x3-130x130.png) |
| **Projectiles**| Trails | Food trails | ✅ Done | [link](assets/spritesheet-trail-3x9-250x250.png) |
| **Projectiles**| Bullet | Player's projectile (ammo) | ✅ Done | [link](assets/spritesheet-bullet-2x4-120x120.png) |
| **Projectiles**| Cap | Thrown out on enemy hit | ✅ Done | [link](assets/spritesheet-cap-2x4-120x120.png) |
| **Environment**| Floor Texture | Tileable warehouse/parking texture | ❌ Todo | [link](#) |
| **VFX** | Explosion / Sparkles | Destroyed machine & coin fountain | ❌ Todo | [link](#) |
| **UI/HUD** | Health & Sugar Bar | Main player stats bars | ❌ Todo | [link](#) |
| **UI/HUD** | Upgrade Cards | Icons for: Double Shot, Magnet, etc. | ❌ Todo | [link](#) |
| **UI/HUD** | Title Screen | NES-style retro main menu | ❌ Todo | [link](#) |
| **Audio** | Main Theme | Fast-paced Synthwave track | ❌ Todo | [link](#) |
| **Audio** | SFX Pack | Coin shoot, Can hiss, Explosion | ❌ Todo | [link](#) |

* ✅ Done
* ⏳ In Progress
* ❌ Todo

## Spritesheets

### Boy
![boy](assets/spritesheet-boy-4x3-100x150.png)

### Girl
![girl](assets/spritesheet-girl-4x3-100x150.png)

### Food
![food](assets/spritesheet-food-3x3-130x130.png)

### Trail

![trail](assets/spritesheet-trail-3x9-250x250.png)

### Coin
![coin](assets/spritesheet-coin-2x4-120x120.png)

### Sugar
![sugar](assets/spritesheet-sugar-2x4-120x120.png)

### Bullet
![bullet](assets/spritesheet-bullet-2x4-120x120.png)

### Cap
![cap](assets/spritesheet-cap-2x4-120x120.png)

### Machines
![machine red](assets/spritesheet-machine-red-4x2-250x350.png)

![machine blue](assets/spritesheet-machine-blue-4x2-250x350.png)

![machine yellow](assets/spritesheet-machine-yellow-4x2-250x350.png)

## Audio

https://alkakrab.itch.io/free-shooter-synthwave-music-pack

* [(Soft Loop For Dialogues, Pause or Other Things) 9](assets/short-loop.mp3)

https://pixabay.com/sound-effects

## 🛠️ Tech Stack

### Assets & Tools
* **[Gemini](https://gemini.google.com/)** - Concepts, ideas, design document, assets
* **[Picsart](https://picsart.com/background-remover/)** - Background remover
* **[Gimp](https://www.gimp.org/)** - Image editing, final assets
* **[TinyPNG](https://tinypng.com/)** - Assets file size optimization

### Core Engine & Rendering
* **[Kontra.js](https://github.com/straker/kontra)** - A lightweight JavaScript gaming micro-library, optimized for js13kGames.

