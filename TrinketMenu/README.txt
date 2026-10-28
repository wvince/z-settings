Forever Trinket Menu v1.2.6
===========================
Addon para WoW Forever (Classic+, Interface 16001).

Caracteristicas Principales:
----------------------------
1. Marco Compacto y Dinamico:
   - Muestra los dos abalorios equipados con indicador de tiempo y espiral de reutilizacion.
   - Clic izquierdo en cualquier abalorio para activarlo (/use 13 o /use 14).
   - Funciona 100% durante el combate (incluso estando aturdido o incapacitado).

2. Menu Desplegable en Cuadricula:
   - Pasa el raton o haz clic derecho en una ranura para abrir la lista de abalorios de tus bolsas.
   - La ventana de opciones ofrece 2, 3, 4 o 6 columnas; el comando permite de 1 a 10.

3. Cola de Cambio en Combate (Combat Swap Queue):
   - Si haces clic en un abalorio de tus bolsas durante el combate, se guarda en cola con un borde dorado.
   - En el instante exacto en que sales de combate, se equipa automaticamente.

4. Cola de Rotacion Automatica (Auto-Queue):
   - Haz Alt+Clic en cualquier abalorio del desplegable para asignarle una prioridad (1, 2, 3...).
   - Cuando tu abalorio activo entra en enfriamiento, el addon equipa automaticamente el siguiente abalorio disponible al terminar el combate.
   - Si un abalorio de mayor prioridad termina su reutilizacion en tus bolsas, vuelve a equiparse solo.

5. Atajos de Teclado Nativos de WoW:
   - Configura teclas directas para Usar Abalorio 1 y 2 desde Escape -> Teclado (Keybindings).

6. Boton de Minimapa 360 Grados:
   - Arrastra el icono del minimapa libremente por todo el borde circular.
   - Mayus+Clic para bloquear/desbloquear rapidamente la ventana.

7. Avisos de Abalorio Listo:
   - Destello visual en el boton y sonido sutil cuando un abalorio termina su reutilizacion.
   - Pulso visual del icono en el centro de la pantalla (translucido, sin textos molestos, estilo CooldownPulse).

8. Control de Ranuras Individuales:
   - Puedes ocultar o mostrar Ranura 1 o Ranura 2 de forma independiente (ideal para abalorios pasivos).

9. Borde del Marco Principal Ocultable:
   - Puedes ocultar o mostrar el recuadro exterior y fondo del marco principal de forma independiente desde las opciones o con /trinketmenu border.
   - Bloquear la ventana (/trinketmenu lock) fija su posicion en pantalla pero mantiene el borde visible a menos que actives expresamente la opcion de ocultarlo.
   - Aunque el borde este oculto, puedes seguir moviendo la ventana manteniendo pulsado Mayus y arrastrando directamente desde los iconos de los abalorios.

10. Borde del Menu Desplegable de Bolsas Ocultable:
   - Elimina el borde exterior grueso tipo tooltip de la lista flotante de abalorios, proporcionando una interfaz moderna, limpia y compacta.
   - Configurable directamente en la ventana de opciones (/trinketmenu opt) o mediante /trinketmenu menuborder.

11. Sinergia con Leveling BiS Advisor:
   - Si utilizas el addon Leveling BiS Advisor, los abalorios recomendados para tu clase y nivel se destacan automaticamente con un borde dorado en el menu desplegable.

Comandos de Chat / Chat Commands:
---------------------------------
/trinketmenu                     - Mostrar u ocultar el marco / Show or hide frame
/trinketmenu opt                 - Abrir ventana de opciones y cola / Open options & queue
/trinketmenu test                - Probar el pulso visual del abalorio / Test ready alert pulse
/trinketmenu auto                - Alternar rotacion automatica / Toggle auto-queue
/trinketmenu cols <1-10>         - Columnas del menu (numero entero) / Dropdown columns (whole number)
/trinketmenu scale <0.5-2.0>     - Ajustar escala; opciones: 0.7-1.5 / Set scale; options panel: 0.7-1.5
/trinketmenu lock / unlock       - Bloquear o desbloquear posicion / Lock or unlock frame
/trinketmenu border              - Alternar borde del marco principal / Toggle main frame border
/trinketmenu menuborder          - Alternar borde del menu desplegable / Toggle dropdown menu border
/trinketmenu sound                - Silenciar o activar el sonido de aviso / Mute or unmute the ready sound
/trinketmenu minimap              - Ocultar o mostrar el boton del minimapa / Hide or show the minimap button
/trinketmenu lang auto|en|es     - Cambiar idioma / Change language

==================================================
English Summary (CurseForge / GitHub Description):
==================================================
Forever Trinket Menu is a lightweight, modern trinket manager for WoW Forever (Classic+ Interface 16001):
- Compact frame showing equipped trinkets with cooldown spirals and remaining timers.
- One-click use in and out of combat (/use 13 and /use 14).
- Flyout menu displaying trinkets from your bags; the options panel offers 2, 3, 4, or 6 columns, while the command accepts 1-10.
- Combat Swap Queue: Queue any bag trinket during combat to equip it automatically upon leaving combat.
- Priority Auto-Queue: Alt-click trinkets in the flyout menu to build an auto-equip rotation when your active trinket goes on cooldown.
- Full border customization: Hide frame borders and dropdown borders independently without affecting position lock.
- 360-degree draggable minimap button (Shift-click to lock/unlock).
- Ready cooldown alerts with subtle sound and center pulse animation.
- Leveling BiS Advisor integration: A golden border highlights recommended trinkets.

==================================================
Changelog:
==================================================
v1.2.6:
- Added the MIT license (LICENSE file) and the X-License field in the TOC.
- Fixed /trinketmenu lock, unlock, border and menuborder being ignored when the command had extra spaces.
- Auto-queue no longer scans every bag slot on each update tick: it is skipped when no trinkets are queued and limited to twice per second (it still runs immediately when combat ends).
- Removed the star glyph from the Leveling BiS Advisor tooltip line (the default font may not draw it) and corrected the docs: recommended trinkets get a golden border.
- Added /trinketmenu sound to mute or unmute the trinket-ready sound (on by default, as before).
- Added /trinketmenu minimap to hide or show the minimap button.
- Added an entry in Blizzard's AddOn compartment menu.

v1.2.5:
- Removed `/tm`; `/trinketmenu` is now the addon's only slash-command prefix.
- Corrected the documented command limits: scale accepts 0.5-2.0, while the options panel adjusts from 0.7-1.5; the columns command accepts whole numbers from 1-10.
- Localized command feedback and usage messages in English and Spanish.

v1.2.4:
- Fixed Lua error (attempt to call a nil value) on mouse hover over equipped trinkets caused by Blizzard's migration of GetItemInfo to C_Item.GetItemInfo in modern WoW 1.60 Classic Beta / Anniversary.
- Added safe wrappers and fallback support for C_Item.GetItemInfo and C_Item.GetItemInfoInstant.
- Integrated C_Item.RequestLoadItemDataByID to safely preload uncached bag items without throwing errors.
- Guarded C_Timer.After in flyout menu auto-hide logic for guaranteed stability across all client environments.

v1.2.3:
- Fixed Lua error when hovering over an unequipped/empty slot when fewer than 2 trinkets are equipped (resolved invalid order comparator in GetAvailableTrinkets).
- Fixed keybinding functionality for equipped trinket slots using Blizzard native CLICK bindings (CLICK ForeverTrinketMenuSlot1:LeftButton), ensuring combat-safe execution and proper Key Bindings menu display.
- Added automatic keybinding migration on login for existing bindings from prior versions.
- Updated Leveling BiS Advisor synergy to inspect active currentBiS trinket rankings.

v1.2.2:
- Added independent option to hide the main frame border (/trinketmenu border or Options menu).
- Decoupled window locking from border visibility: locking the window now only locks its position without forcing borders to disappear.
- Added option to remove outer border on the flyout bag trinket menu (/trinketmenu menuborder or Options menu) with clean, compact spacing.
- Fixed bidirectional border toggling for both main frame and dropdown menu: backdrop pieces and corner slices properly show/hide on demand.
- Aligned flyout bag trinket menu directly beneath/beside the active hovered slot button.
- Enabled Shift+Drag window repositioning directly from the trinket icons at all times.
- Documented Leveling BiS Advisor synergy (golden border for recommended trinkets).
- Refined Options panel dimensions and control layout.
- Full English and Spanish localization updates.

License / Licencia:
-------------------
MIT License. Copyright (c) 2026 sk0lu. See the LICENSE file / Ver el archivo LICENSE.
