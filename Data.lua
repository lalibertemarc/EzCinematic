-- EzCinematic: static data.
local _, ns = ...

-- Set to "0" while cinematic mode is on. Your own name (UnitNameOwn) is left alone.
ns.HIDE_CVARS = {
    "nameplateShowEnemies",
    "nameplateShowFriends",
    "UnitNameNPC",
    "UnitNameFriendlySpecialNPCName",
    "UnitNameHostleNPC", -- Blizzard's spelling
    "UnitNameInteractiveNPC",
    "UnitNameFriendlyPlayerName",
    "UnitNameEnemyPlayerName",
}

-- Saved before the sound preset is applied and put back on exit, so your exact volumes return.
ns.SOUND_CVARS = {
    "Sound_MasterVolume", "Sound_EnableAllSound",
    "Sound_MusicVolume", "Sound_EnableMusic",
    "Sound_SFXVolume", "Sound_EnableSFX",
    "Sound_AmbienceVolume", "Sound_EnableAmbience",
    "Sound_DialogVolume", "Sound_EnableDialog",
}

-- EzSoundMixer preset applied on entry (skipped if EzSoundMixer isn't loaded).
ns.SOUND_PRESET = "Music focus"

ns.BINDINGS = {
    { action = "EZCINEMATIC_TOGGLE", label = "Toggle cinematic mode" },
}
