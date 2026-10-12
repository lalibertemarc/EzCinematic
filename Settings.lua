-- Options page: Esc > Options > AddOns > EzCinematic. Changes apply the next time cinematic
-- mode turns on (the page can't be open while the UI is hidden anyway).
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

    local function Slider(key, name, tooltip, unit)
        local range = ns.SLIDERS[key]
        local options = Settings.CreateSliderOptions(range[1], range[2], range[3])
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value)
            return string.format("%d%s", value, unit)
        end)
        return Settings.CreateSlider(category, Register(key, Settings.VarType.Number, name), options, tooltip)
    end

    local RAISE_ONLY = " Only raises: if your own graphics setting is already higher, yours is kept."
    local VRAM = " Higher values use more video memory; too high can crash the game in busy areas like cities."

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Graphics boost"))
    Check("boost", "Boost graphics",
        "While cinematic mode is on, push the scenery past the graphics menu's limits. Your settings come back when it turns off.")
    Slider("clutterDensity", "Ground clutter density",
        "How thick grass, flowers and pebbles are." .. RAISE_ONLY .. VRAM, "")
    Slider("clutterDistance", "Ground clutter distance",
        "How far out ground clutter is drawn." .. RAISE_ONLY .. VRAM, " yd")
    Slider("terrainDistance", "Terrain detail distance",
        "How far out terrain keeps its full detail." .. RAISE_ONLY .. VRAM, " yd")
    Check("reflections", "Full water reflections",
        "Water reflects everything: buildings, players and creatures." .. VRAM)

    Settings.RegisterAddOnCategory(category)
end
