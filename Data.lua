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

-- EzSoundMixer preset applied on entry.
ns.SOUND_PRESET = "Music focus"

-- Used instead when EzSoundMixer isn't loaded: a copy of its default Music focus preset.
ns.FALLBACK_SOUND = {
    Sound_MasterVolume = "1.00",   Sound_EnableAllSound = "1",
    Sound_MusicVolume = "1.00",    Sound_EnableMusic = "1",
    Sound_SFXVolume = "0.30",      Sound_EnableSFX = "1",
    Sound_AmbienceVolume = "0.40", Sound_EnableAmbience = "1",
    Sound_DialogVolume = "0.60",   Sound_EnableDialog = "1",
}

ns.BINDINGS = {
    { action = "EZCINEMATIC_TOGGLE", label = "Toggle cinematic mode" },
}
