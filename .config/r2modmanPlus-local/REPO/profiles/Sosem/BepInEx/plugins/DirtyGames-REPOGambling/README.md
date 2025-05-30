## 📥 Installation & Configuration (Manual)
***

### 🛠 Installation:
1. The recommended way to install REPOGambling on the game.
2. Download and install Thunderstore Mod Manager
3. Click Install with Mod Manager button on the top of the page
4. Run the game via the Mod Manager.
### ⚙️ Configuration:
1. Go into the configuration file at ``BepInEx\config\DirtyGames.REPOGambling.cfg``
2. Edit any of the settings, save and exit.
3. Reload REPO.
## 📝 Description
***
Ever wanted to turn your shop into a high-stakes casino?  
With **REPOGambling**, you can!

- 🎡 Spin the wheel of fortune with outcomes ranging from jackpots to instant death.
- 🎰 Try your luck with configurable slot machines—bet high, win big (or lose it all)!
- 🧩 Fully customizable spawn chances, reward types, and betting mechanics.

Your casino room could be huge and glorious... or just a dingy restroom. Luck decides.

---

## 🙏 Special Thanks
***
- Huge thanks to **@BudKnight** for crafting the awesome wheel model!
- Special Thanks to @Echanz for taking time to debug with me!
- Thanks to **you** for downloading and trying it out!

---

## 🐛 Known Issues
***
Multiplayer is *mostly* working. If you're reading this, I'm already fixing the next round of bugs. Thanks for your patience!

---

## 📷 Screenshots
***
### 🏆 Slot & Wheel Room
[![Slot & Wheel Room](https://i.imgur.com/hkvKapu.png)](https://i.imgur.com/hkvKapu.png)

### 🎰 Slot Room
[![Slot Room](https://i.imgur.com/Oxxi2wm.png)](https://i.imgur.com/Oxxi2wm.png)

### 🔘 Wheel Room
[![Wheel Room](https://i.imgur.com/VhFZnfW.png)](https://i.imgur.com/VhFZnfW.png)

### 😈 Cheater Detection
[![Cheater Detection](https://i.imgur.com/U8INQE9.png)](https://i.imgur.com/U8INQE9.png)

---

## ☕ Support Me
Want to support development?  
[Buy me a coffee](https://buymeacoffee.com/dirtygames) – every bit helps!

---

## 🖥 Changelog
### 1.5.7
- Adjusted previous `isLocal` comparison preventing money prizes from applying.
### 1.5.6
- Removed previous local actor comparison check possibly preventing prizes applying to the correct player.
### 1.5.5
- READ.MD Update
### 1.5.4
- Moved wheel spin state handling into the RPC to prevent desync and state overwrite issues.
- Added a local spin cooldown to reduce input spam and race conditions.
- Adjusted prize reward logic to apply to the player who spun the wheel, rather than the local client.
### 1.5.3
- Fixed bug preventing wheel from being spun more than once.
### 1.5.2
- **New Slot Configs:**
    - `SlotForceLossChance` – chance to force a loss.
    - `SlotForceWinType` – type of forced win (`Default: Any`).
    - `SlotForceWinChance` – chance to force a win (`Default: 10%`).
- **Slot Machine Tweaks:**
    - Minimum bet increased from 1k → 2k.
    - Multiplier for Spade/Cherry/Berry reduced from 3x → 2x.
    - Removed "Double 7" and "Any 2" rewards (temporarily).
- **Multiplayer Enhancements:**
    - Networked audio for wheel & slots.
    - Synced bet text across players.
- **Other:**
    - Lowered wheel & slot music volume from 100% → 70%.

### 1.5.1
- Fixed slot machine always forcing a win.
- Probability checks now reset properly at/above 100%.
- Fixed multiplayer bug where slot outcome was calculated twice.