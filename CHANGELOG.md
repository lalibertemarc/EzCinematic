# EzCinematic

## v1.2.0

- Cinematic mode now pushes the graphics past the menu's limits: denser ground clutter drawn much farther out (raid graphics too), 16x texture filtering, best screenshot quality and a farther camera zoom. Only settings below these values are raised, and your own values come back when you turn it off.

## v1.1.0

- Esc in cinematic mode clears your target instead of bringing the interface back. With no target, Esc turns cinematic mode off and restores everything, instead of showing the interface with names, nameplates and sound still changed.

## v1.0.0

- First release for WoW Forever.
- `/cine` (or a key binding under Key Bindings → EzCinematic) toggles cinematic mode for screenshots: hides the UI, nameplates, NPC names and other players' names (yours stays), and switches sound to Music focus: EzSoundMixer's preset if it's installed, otherwise the same volumes built in.
- Pressing it again puts back exactly what you had before, including your volumes. If you leave in combat, it waits until combat ends.
- A /reload or disconnect during cinematic mode restores your settings on the next login.
