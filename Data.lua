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

-- Raised while cinematic mode is on, past what the graphics menu offers. Only raised: a
-- setting already at or above the value is left alone. The RAID copies are what the game
-- uses in raids and battlegrounds when the separate raid graphics settings are on.
ns.GRAPHICS_CVARS = {
    -- Ground clutter (grass, flowers, pebbles): thicker, drawn farther out, fading later.
    groundEffectDensity = "256",     RAIDgroundEffectDensity = "256",
    groundEffectDist = "500",        RAIDgroundEffectDist = "500",
    groundEffectFade = "370",        RAIDgroundEffectFade = "370",
    terrainLodDist = "1000",         RAIDterrainLodDist = "1000", -- detailed terrain farther out
    reflectionMode = "3",            RAIDreflectionMode = "3",    -- water reflects everything
    weatherDensity = "3",            RAIDweatherDensity = "3",    -- full rain and snow
    textureFilteringMode = "5",      -- 16x anisotropic: sharp ground textures at a distance
    screenshotQuality = "10",        -- least compression on saved screenshots
    cameraDistanceMaxZoomFactor = "2.6", -- zoom the camera out farther for wide shots
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
