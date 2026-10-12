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
    weatherDensity = "3",            RAIDweatherDensity = "3",    -- full rain and snow
    textureFilteringMode = "5",      -- 16x anisotropic: sharp ground textures at a distance
    screenshotQuality = "10",        -- least compression on saved screenshots
    cameraDistanceMaxZoomFactor = "2.6", -- zoom the camera out farther for wide shots
}

-- Raised the same way, to the values set on the options page. Option key -> CVars it sets.
ns.GRAPHICS_OPTIONS = {
    -- Ground clutter (grass, flowers, pebbles): thicker and drawn farther out.
    clutterDensity = { "groundEffectDensity", "RAIDgroundEffectDensity" },
    clutterDistance = { "groundEffectDist", "RAIDgroundEffectDist" },
    terrainDistance = { "terrainLodDist", "RAIDterrainLodDist" }, -- detailed terrain farther out
}
-- Clutter starts fading at this fraction of its draw distance.
ns.CLUTTER_FADE_CVARS = { "groundEffectFade", "RAIDgroundEffectFade" }
ns.CLUTTER_FADE = 0.8
-- With the reflections option: water reflects everything.
ns.REFLECTION_CVARS = { "reflectionMode", "RAIDreflectionMode" }
ns.REFLECTION_FULL = 3

-- Options page defaults. Safe on an 8 GB card: 256 clutter at 500 yd, terrain 1000 and full
-- reflections together ran one out of video memory in a city (D3D12 framebuffer/texture asserts).
ns.DEFAULTS = {
    boost = true,
    clutterDensity = 128,
    clutterDistance = 350,
    terrainDistance = 800,
    reflections = false,
}

-- Slider ranges (min, max, step). Maxima are values the client is known to accept.
ns.SLIDERS = {
    clutterDensity = { 16, 256, 16 },
    clutterDistance = { 100, 500, 25 },
    terrainDistance = { 200, 1000, 50 },
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
