std = "lua51"
max_line_length = false
self = false

globals = {
    "EzCinematicDB",
    "EzCinematic_Toggle",
    "BINDING_HEADER_EZCINEMATIC",
    "SLASH_EZCINEMATIC1",
    "SLASH_EZCINEMATIC2",
    "SlashCmdList",
}

read_globals = {
    -- Frames & UI
    "CreateFrame", "UIParent", "DEFAULT_CHAT_FRAME",
    -- Namespaced APIs
    "C_CVar", "C_AddOns",
    -- Settings panel
    "Settings", "CreateSettingsListSectionHeaderInitializer", "MinimalSliderWithSteppersMixin",
    -- Global APIs
    "strtrim", "InCombatLockdown", "SetUIVisibility", "UnitExists",
    "GetBindingKey", "SetOverrideBindingClick", "ClearOverrideBindings",
}
