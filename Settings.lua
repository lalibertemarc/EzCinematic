-- Options page: Esc > Options > AddOns > EzCinematic. Changes apply the next time cinematic
-- mode turns on or off (the page can't be open while the UI is hidden anyway).
local _, ns = ...

function ns.BuildSettings(db)
    local category, layout = Settings.RegisterVerticalLayoutCategory("EzCinematic")
    ns.settingsCategory = category

    local function Register(key, varType, name)
        return Settings.RegisterAddOnSetting(category, "EZCINEMATIC_" .. key:upper(), key, db, varType,
            name, ns.DEFAULTS[key])
    end

    local function Check(key, name, tooltip)
        return Settings.CreateCheckbox(category, Register(key, Settings.VarType.Boolean, name), tooltip)
    end

    -- fmt formats the value shown beside the slider, e.g. "%d yd", or is a function of the value.
    local function Slider(key, name, tooltip, fmt)
        local range = ns.SLIDERS[key]
        local options = Settings.CreateSliderOptions(range[1], range[2], range[3])
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value)
            if type(fmt) == "function" then return fmt(value) end
            return string.format(fmt, value)
        end)
        return Settings.CreateSlider(category, Register(key, Settings.VarType.Number, name), options, tooltip)
    end

    local RAISE_ONLY = " Only raises: if your own graphics setting is already higher, yours is kept."
    local VRAM = " Higher values use more video memory; too high can crash the game in busy areas like cities."

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Names"))
    Check("hidePlayerNames", "Hide player names",
        "Hide other players' names while cinematic mode is on. Turn this off to keep them, for group shots or role-play scenes. Your own name stays as you have it set either way.")

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Combat"))
    Check("epicBattle", "Epic battle",
        "Stay in cinematic mode when combat starts, to film or screenshot your fights without the interface. Off by default: combat turns cinematic mode off so you never fight blind. While it's on, turning cinematic mode off during a fight brings names, nameplates and graphics back when combat ends; press Alt+Z to see your interface right away.")

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Sound"))
    -- No SetParentInitializer/AddEvaluateStateCVar here (no greying out): they write fields on
    -- Blizzard's initializers from addon code, and the settings list then draws Blizzard's own
    -- rows tainted (Forever: IsUserOAuthed forbidden on the Social page, 2026-11-15).
    Check("changeSound", "Change volumes",
        "Switch to the cinematic mix below while cinematic mode is on: music up front, the rest softer. Your own volumes come back when it turns off. Turn this off to leave your volumes as they are; the options below then do nothing.")
    -- EzSoundMixer is an optional dependency, so it has loaded by now if it's going to.
    local hasMixer = C_AddOns.IsAddOnLoaded("EzSoundMixer")
    if hasMixer then
        Check("useMixer", "Use EzSoundMixer's Music focus",
            "Use the Music focus preset as you set it in EzSoundMixer instead of the volumes below. If you deleted Music focus there, the volumes below are used. Needs Change volumes.")
    end
    local function Percent(value)
        if value <= 0 then return "Off" end
        return string.format("%d%%", math.floor(value + 0.5))
    end
    local sliderTip = "Volume while cinematic mode is on. Slide to 0 to turn this sound off. Needs Change volumes"
        .. (hasMixer and ", and is used when Use EzSoundMixer's Music focus is off." or ".")
    for _, ch in ipairs(ns.SOUND_CHANNELS) do
        Slider(ch.key, ch.label, sliderTip, Percent)
    end
    Check("muteMusic", "Mute music",
        "No music while cinematic mode is on, whatever the volumes say: for your own music or a quiet scene. Also /cine mute.")
    Slider("fadeTime", "Volume fade",
        "How long the volumes take to glide into the cinematic mix when cinematic mode turns on, and back to yours when it turns off. 0 switches them at once.",
        "%.1f s")

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Graphics boost"))
    Check("boost", "Boost graphics",
        "While cinematic mode is on, push the scenery past the graphics menu's limits. Your settings come back when it turns off.")
    Slider("clutterDensity", "Ground clutter density",
        "How thick grass, flowers and pebbles are." .. RAISE_ONLY .. VRAM, "%d")
    Slider("clutterDistance", "Ground clutter distance",
        "How far out ground clutter is drawn." .. RAISE_ONLY .. VRAM, "%d yd")
    Slider("terrainDistance", "Terrain detail distance",
        "How far out terrain keeps its full detail." .. RAISE_ONLY .. VRAM, "%d yd")
    Check("reflections", "Full water reflections",
        "Water reflects everything: buildings, players and creatures." .. VRAM)

    Settings.RegisterAddOnCategory(category)
end
