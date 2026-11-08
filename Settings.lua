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

    -- fmt formats the value shown beside the slider, e.g. "%d yd".
    local function Slider(key, name, tooltip, fmt)
        local range = ns.SLIDERS[key]
        local options = Settings.CreateSliderOptions(range[1], range[2], range[3])
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value)
            return string.format(fmt, value)
        end)
        return Settings.CreateSlider(category, Register(key, Settings.VarType.Number, name), options, tooltip)
    end

    local RAISE_ONLY = " Only raises: if your own graphics setting is already higher, yours is kept."
    local VRAM = " Higher values use more video memory; too high can crash the game in busy areas like cities."

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Names"))
    Check("hidePlayerNames", "Hide player names",
        "Hide other players' names while cinematic mode is on. Turn this off to keep them, for group shots or role-play scenes. Your own name stays as you have it set either way.")

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Sound"))
    Slider("fadeTime", "Volume fade",
        "How long the volumes take to glide into the Music focus mix when cinematic mode turns on, and back to yours when it turns off. 0 switches them at once.",
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
