# Forever Trinket Menu - v1.2.5 (WoW Forever / Classic+)

A lightweight, modern trinket manager created specifically for **WoW Forever (Classic+ / Interface 16001)** and **Classic Era**.

### 🛠️ What's New in v1.2.5 (Maintenance Update)
- Removed `/tm`; `/trinketmenu` is now the addon's only slash-command prefix.
- Corrected command limits: scale accepts 0.5-2.0 (the options panel adjusts from 0.7-1.5), and dropdown columns accept whole numbers from 1-10.
- Localized command feedback and usage messages in English and Spanish.

### 🌟 What's New in v1.2.4 (Bug Fix & Stability Update)
- **Fixed mouse hover nil error**: Resolved BugGrabber error `TrinketMenu.lua: attempt to call a nil value` when hovering over equipped trinkets with certain items in bags (e.g. Hearthstone).
- **Blizzard C_Item API Migration**: Modernized item querying to seamlessly support `C_Item.GetItemInfo` and `C_Item.GetItemInfoInstant` with fallbacks for older clients.
- **Asynchronous Preloading**: Added `C_Item.RequestLoadItemDataByID` for smooth background caching of bag items without frame drops.
- **Timer Safety**: Added null-checks for `C_Timer.After` in dropdown auto-hide logic.

---

### 📦 Key Features
1. **Compact & Dynamic Frame**: Shows both equipped trinkets with countdown timers and cooldown spirals. Combat-safe (`/use 13`, `/use 14`).
2. **Flyout Bag Grid**: Hover or right-click to view all trinkets in your bags in a neat grid. The options panel offers 2, 3, 4, or 6 columns; the command accepts 1-10.
3. **Combat Swap Queue**: Click any bag trinket in combat; it queues with a golden border and equips the instant combat drops.
4. **Auto-Queue Priority Rotation**: Alt-click trinkets in the flyout to assign priority ranks. TrinketMenu automatically rotates them off cooldown.
5. **Native WoW Keybindings**: Directly bind "Use Trinket 1" and "Use Trinket 2" in Escape -> Options -> Keybindings.
6. **360° Draggable Minimap Button**: Freely position the minimap button. Shift-click to lock/unlock.
7. **Clean Customization**: Hide frame border or dropdown border independently (/trinketmenu border, /trinketmenu menuborder).
8. **Leveling BiS Advisor Synergy**: Recommended trinkets are automatically highlighted with a golden border.

### 💻 Slash Commands
- `/trinketmenu` - Toggle frame
- `/trinketmenu opt` - Open options & auto-queue panel
- `/trinketmenu auto` - Toggle auto-queue rotation
- `/trinketmenu cols <1-10>` - Set dropdown grid columns (whole number)
- `/trinketmenu scale <0.5-2.0>` - Adjust scale (options panel: 0.7-1.5)
- `/trinketmenu lock` / `/trinketmenu unlock` - Lock or unlock window
- `/trinketmenu border` - Toggle main frame border
- `/trinketmenu menuborder` - Toggle dropdown border
- `/trinketmenu lang auto|en|es` - Change language
