# EzCinematic

## v1.6.1

- Listed under **Audio & Video** in the game's AddOns list.

## v1.6.0

- New **Epic battle** option (off by default): cinematic mode stays on when combat starts, so you can film your fights or grab battle screenshots without the interface. Find it on the options page or type `/cine epic on`. If you turn cinematic mode off during a fight, your names, nameplates and graphics come back when combat ends (the game locks them during a fight); press Alt+Z to see your interface right away.

## v1.5.0

- The volume change now fades smoothly instead of switching at once: the music swells in when cinematic mode turns on and settles back to your own volumes when it turns off. Set how long it takes (0 to 6 seconds, 2 by default, 0 for the old instant switch) under **Volume fade** on the options page.
- New **Hide player names** option: turn it off to keep other players' names on screen in cinematic mode, for group shots or role-play scenes. NPC, pet and creature names are still hidden.

## v1.4.3

- Cinematic mode now also hides the names of pets, minions, guardians, totems and critters (yours included). They come back with everything else when you turn it off.

## v1.4.2

- Cinematic mode now clears your target when it starts: the game always shows your target's name, so it used to stay floating over a trainer or anyone else you had selected. This works from the key binding and from a macro with `/click EzCinematicButton` (the new recommended macro). Plain `/cine` can't clear a target, so it tells you to press Esc instead.

## v1.4.1

- Cinematic mode now turns itself off when you enter combat, bringing back the interface, nameplates, names, graphics and sound right away. Before, getting pulled by a mob left you stuck with no UI until the fight ended.

## v1.4.0

- New options page (Esc → Options → AddOns → EzCinematic, or `/cine config`) to tune the graphics boost for your graphics card: ground clutter density and distance, terrain detail distance, and full water reflections. You can also turn the boost off. The defaults stay the safe v1.3.1 values.

## v1.3.1

- Fixed a game crash in busy areas like cities: cinematic mode's graphics boost could run the graphics card out of video memory. Ground clutter and terrain detail are toned down, and water reflections are no longer forced to full.

## v1.3.0

- More graphics in cinematic mode: detailed terrain reaches farther, full water reflections and full weather. As before, only settings below these values are raised, and yours come back when you turn it off.

## v1.2.0

- Cinematic mode now pushes the graphics past the menu's limits: denser ground clutter drawn much farther out (raid graphics too), 16x texture filtering, best screenshot quality and a farther camera zoom. Only settings below these values are raised, and your own values come back when you turn it off.

## v1.1.0

- Esc in cinematic mode clears your target instead of bringing the interface back. With no target, Esc turns cinematic mode off and restores everything, instead of showing the interface with names, nameplates and sound still changed.

## v1.0.0

- First release for WoW Forever.
- `/cine` (or a key binding under Key Bindings → EzCinematic) toggles cinematic mode for screenshots: hides the UI, nameplates, NPC names and other players' names (yours stays), and switches sound to Music focus: EzSoundMixer's preset if it's installed, otherwise the same volumes built in.
- Pressing it again puts back exactly what you had before, including your volumes. If you leave in combat, it waits until combat ends.
- A /reload or disconnect during cinematic mode restores your settings on the next login.
