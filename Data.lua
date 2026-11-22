-- EzCinematic: static data.
local _, ns = ...

-- Set to "0" while cinematic mode is on. Your own name (UnitNameOwn) is left alone.
ns.HIDE_CVARS = {
    "nameplateShowEnemies",
    "nameplateShowFriends",
    -- Forever's own switches (Era lacks them; missing CVars are skipped): friendly NPC
    -- nameplates show their names in grey (Night Watch Guard), and friendly players' plates.
    "nameplateShowFriendlyNpcs",
    "nameplateShowFriendlyPlayers",
    "UnitNameNPC",
    "UnitNameFriendlySpecialNPCName",
    "UnitNameHostleNPC", -- Blizzard's spelling
    "UnitNameInteractiveNPC",
    -- Pets, minions, guardians and totems (yours too) and critters.
    "UnitNameFriendlyPetName",
    "UnitNameFriendlyGuardianName",
    "UnitNameFriendlyTotemName",
    "UnitNameFriendlyMinionName",
    "UnitNameEnemyPetName",
    "UnitNameEnemyGuardianName",
    "UnitNameEnemyTotemName",
    "UnitNameEnemyMinionName",
    "UnitNameNonCombatCreatureName",
}
-- Other players' names: hidden too unless "Hide player names" is off on the options page.
ns.PLAYER_NAME_CVARS = {
    "UnitNameFriendlyPlayerName",
    "UnitNameEnemyPlayerName",
}

-- Sound channels, in EzSoundMixer's order (its presets list volumes in this order). Saved
-- before the sound preset is applied and put back on exit, so your exact volumes return.
-- Volumes fade between the two over the options page's fade time.
-- `key` is the options page slider giving the channel's cinematic volume (percent, 0 = off).
ns.SOUND_CHANNELS = {
    { vol = "Sound_MasterVolume",   on = "Sound_EnableAllSound", key = "volMaster",   label = "Master volume" },
    { vol = "Sound_MusicVolume",    on = "Sound_EnableMusic",    key = "volMusic",    label = "Music volume" },
    { vol = "Sound_SFXVolume",      on = "Sound_EnableSFX",      key = "volSFX",      label = "Effects volume" },
    { vol = "Sound_AmbienceVolume", on = "Sound_EnableAmbience", key = "volAmbience", label = "Ambience volume" },
    { vol = "Sound_DialogVolume",   on = "Sound_EnableDialog",   key = "volDialog",   label = "Dialog volume" },
}
ns.SOUND_CVARS = {}
for _, ch in ipairs(ns.SOUND_CHANNELS) do
    table.insert(ns.SOUND_CVARS, ch.vol)
    table.insert(ns.SOUND_CVARS, ch.on)
end

-- Fade steps: volumes are set this often (seconds) while fading.
ns.FADE_STEP = 0.03

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
    hidePlayerNames = true,
    fadeTime = 2,
    epicBattle = false, -- stay in cinematic mode through combat
    changeSound = true, -- switch to the cinematic mix below (or EzSoundMixer's Music focus)
    useMixer = true,    -- EzSoundMixer's saved Music focus instead of the sliders, when it's loaded
    muteMusic = false,  -- music off in cinematic mode, whatever the mix says
    -- The cinematic mix, in percent: a copy of EzSoundMixer's default Music focus.
    volMaster = 100,
    volMusic = 100,
    volSFX = 30,
    volAmbience = 40,
    volDialog = 60,
}

-- Slider ranges (min, max, step). Maxima are values the client is known to accept.
ns.SLIDERS = {
    clutterDensity = { 16, 256, 16 },
    clutterDistance = { 100, 500, 25 },
    terrainDistance = { 200, 1000, 50 },
    fadeTime = { 0, 6, 0.5 },
}
for _, ch in ipairs(ns.SOUND_CHANNELS) do ns.SLIDERS[ch.key] = { 0, 100, 5 } end

-- EzSoundMixer preset used on entry when it's loaded and "Use EzSoundMixer's Music focus" is on:
-- your saved copy of it (EzSoundMixerDB.presets). Otherwise the options page's volume sliders.
ns.SOUND_PRESET = "Music focus"
-- EzSoundMixer only saves a preset once you change it; until then it uses its built-in default,
-- kept in its code (ns.DEFAULT_PRESETS). A copy of that Music focus, in its preset format: volumes
-- in percent in SOUND_CHANNELS order, `on` = bitmask of enabled channels (31 = all on).
ns.MIXER_DEFAULT = { 100, 100, 30, 40, 60, on = 31 }

ns.BINDINGS = {
    { action = "EZCINEMATIC_TOGGLE", label = "Toggle cinematic mode" },
}
