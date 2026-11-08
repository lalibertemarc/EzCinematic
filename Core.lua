-- EzCinematic: one key for clean screenshots.
local addonName, ns = ...

local GetCVar, SetCVar, GetCVarBool = C_CVar.GetCVar, C_CVar.SetCVar, C_CVar.GetCVarBool

local db           -- EzCinematicDB, set on ADDON_LOADED
local pendingExit  -- exit was asked for in combat; runs on PLAYER_REGEN_ENABLED
local events = CreateFrame("Frame")

local function Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99EzCinematic|r: " .. msg)
end

-- Same call the game's Alt+Z binding makes; plain Show/Hide as a fallback.
local function SetUIShown(shown)
    if SetUIVisibility then
        SetUIVisibility(shown)
    else
        UIParent:SetShown(shown)
    end
end

-- Remembers current values in db.saved. CVars this client doesn't have are skipped.
local function Snapshot(list)
    for _, name in ipairs(list) do
        local value = GetCVar(name)
        if value ~= nil then db.saved[name] = value end
    end
end

-- Remembers the names' settings, then hides them.
local function HideNames(list)
    Snapshot(list)
    for _, name in ipairs(list) do
        if db.saved[name] then SetCVar(name, "0") end
    end
end

local IS_SOUND = {}
for _, name in ipairs(ns.SOUND_CVARS) do IS_SOUND[name] = true end

-- Cinematic graphics values from Data.lua and the options page: CVar name -> number.
local function GraphicsTargets()
    local targets = {}
    for name, value in pairs(ns.GRAPHICS_CVARS) do targets[name] = tonumber(value) end
    for key, names in pairs(ns.GRAPHICS_OPTIONS) do
        for _, name in ipairs(names) do targets[name] = db[key] end
    end
    for _, name in ipairs(ns.CLUTTER_FADE_CVARS) do
        targets[name] = math.floor(db.clutterDistance * ns.CLUTTER_FADE)
    end
    if db.reflections then
        for _, name in ipairs(ns.REFLECTION_CVARS) do targets[name] = ns.REFLECTION_FULL end
    end
    return targets
end

-- Raises each graphics CVar to its cinematic value, remembering only the ones it changes.
local function BoostGraphics()
    if not db.boost then return end
    for name, value in pairs(GraphicsTargets()) do
        local current = GetCVar(name)
        if current ~= nil and (tonumber(current) or 0) < value then
            db.saved[name] = current
            SetCVar(name, tostring(value))
        end
    end
end

---------------------------------------------------------------------------
-- Sound fade
---------------------------------------------------------------------------
-- Volumes glide to the cinematic mix and back instead of jumping. A channel switched off at
-- either end fades from or to silence: it is switched on before a fade-in and off after a
-- fade-out. The end values wait in db.fadeTo while a fade runs, so a /reload halfway through
-- still lands on them at the next login.
local fader = CreateFrame("Frame")
local fade -- { steps = { { cvar, from, to } }, final = { cvar = value }, elapsed, duration }

local function Volume(name) return tonumber(GetCVar(name)) or 0 end

-- Stops a running fade where it is and returns the values it was heading for.
local function StopFade()
    fader:SetScript("OnUpdate", nil)
    local final = fade and fade.final
    fade = nil
    db.fadeTo = nil
    return final
end

-- Switches go first: off ones then silence the volume being set; on ones are on already.
local function SetFinal(final)
    for _, ch in ipairs(ns.SOUND_CHANNELS) do
        if final[ch.on] then SetCVar(ch.on, final[ch.on]) end
    end
    for _, ch in ipairs(ns.SOUND_CHANNELS) do
        if final[ch.vol] then SetCVar(ch.vol, final[ch.vol]) end
    end
end

local function FinishFade()
    local final = StopFade()
    if final then SetFinal(final) end
end

-- Smoothstep: starts and ends gently, so neither end of the fade has an audible corner.
local function Ease(x) return x * x * (3 - 2 * x) end

local function OnFadeUpdate(_, elapsed)
    fade.elapsed = fade.elapsed + elapsed
    fade.wait = fade.wait - elapsed
    if fade.elapsed >= fade.duration then return FinishFade() end
    if fade.wait > 0 then return end
    fade.wait = ns.FADE_STEP
    local k = Ease(fade.elapsed / fade.duration)
    for _, step in ipairs(fade.steps) do
        SetCVar(step[1], string.format("%.3f", step[2] + (step[3] - step[2]) * k))
    end
end

-- Moves the sound CVars to `targets` (CVar -> value; missing ones are left alone) over
-- db.fadeTime seconds, starting from wherever they are now, even halfway through another fade.
local function FadeSound(targets)
    StopFade()
    local final, steps = {}, {}
    for _, ch in ipairs(ns.SOUND_CHANNELS) do
        if GetCVar(ch.vol) ~= nil and GetCVar(ch.on) ~= nil then
            local isOn = GetCVar(ch.on) == "1"
            local toVol = targets[ch.vol] or GetCVar(ch.vol)
            local toOn = (targets[ch.on] or GetCVar(ch.on)) == "1"
            final[ch.vol], final[ch.on] = toVol, toOn and "1" or "0"
            local from = isOn and Volume(ch.vol) or 0
            local to = toOn and (tonumber(toVol) or 0) or 0
            if from ~= to then
                if not isOn then
                    SetCVar(ch.vol, "0")
                    SetCVar(ch.on, "1")
                end
                steps[#steps + 1] = { ch.vol, from, to }
            end
        end
    end
    if (db.fadeTime or 0) <= 0 or #steps == 0 then return SetFinal(final) end
    fade = { steps = steps, final = final, elapsed = 0, wait = 0, duration = db.fadeTime }
    db.fadeTo = final
    fader:SetScript("OnUpdate", OnFadeUpdate)
end

-- The Music focus mix: EzSoundMixer's saved copy when you have one (volumes in percent in
-- SOUND_CHANNELS order, `on` = bitmask of enabled channels), else the built-in copy of its default.
local function SoundTargets()
    local preset = C_AddOns.IsAddOnLoaded("EzSoundMixer") and type(EzSoundMixerDB) == "table"
        and type(EzSoundMixerDB.presets) == "table" and EzSoundMixerDB.presets[ns.SOUND_PRESET]
    if type(preset) ~= "table" or type(preset.on) ~= "number" then return ns.FALLBACK_SOUND end
    local targets = {}
    for i, ch in ipairs(ns.SOUND_CHANNELS) do
        if type(preset[i]) == "number" then
            targets[ch.vol] = string.format("%.2f", preset[i] / 100)
            targets[ch.on] = math.floor(preset.on / 2 ^ (i - 1)) % 2 == 1 and "1" or "0"
        end
    end
    return targets
end

---------------------------------------------------------------------------
-- Esc while hidden
---------------------------------------------------------------------------
-- The game's Esc shows a hidden UI before it gets to clearing the target, and ClearTarget is
-- protected, so a plain Lua handler can't step in. While cinematic mode is on, the game-menu
-- keys click this secure button instead: Esc drops the target first, then exits cinematic mode.
local escButton = CreateFrame("Button", "EzCinematicEscButton", nil, "SecureActionButtonTemplate")
escButton:RegisterForClicks(GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp")
escButton:SetAttribute("type", "macro")
escButton:SetAttribute("macrotext", "/cleartarget")
escButton:SetScript("PreClick", function()
    if not UnitExists("target") then EzCinematic_Toggle() end
end)

-- Out of combat only, like everything else Enter/Restore do.
local function SetEscOverride(on)
    ClearOverrideBindings(escButton)
    if not on then return end
    for _, key in ipairs({ GetBindingKey("TOGGLEGAMEMENU") }) do
        SetOverrideBindingClick(escButton, true, key, escButton:GetName())
    end
end

---------------------------------------------------------------------------
-- Toggle button
---------------------------------------------------------------------------
-- The game always shows your target's name, whatever the name CVars say, so entering cinematic
-- mode drops the target. ClearTarget is protected: the key binding and `/click EzCinematicButton`
-- go through this secure button, whose "target" action with unit "none" clears it (a plain
-- action, so it also works from a user macro, where macrotext wouldn't). While cinematic mode is
-- on the action is off, so leaving keeps whatever you targeted meanwhile. Fires on release like a
-- mouse click; PostClick ignores the press.
local toggleButton = CreateFrame("Button", "EzCinematicButton", nil, "SecureActionButtonTemplate")
toggleButton:RegisterForClicks("AnyUp", "AnyDown")
toggleButton:SetAttribute("useOnKeyDown", false)
toggleButton:SetAttribute("unit", "none")
toggleButton:SetScript("PostClick", function(_, _, down)
    if not down then EzCinematic_Toggle() end
end)

-- Out of combat only.
local function SetClearOnPress(on)
    toggleButton:SetAttribute("type", on and "target" or nil)
end
SetClearOnPress(true)

-- Keys bound to "Toggle cinematic mode" click the button instead of running the binding's Lua.
-- Override bindings are protected in combat: deferred until it ends. Only reapplied when the keys
-- change, since setting them fires UPDATE_BINDINGS again.
local boundKeys = ""
local bindingsPending
local function BindToggleKeys()
    if InCombatLockdown() then
        bindingsPending = true
        return
    end
    bindingsPending = nil
    local keys = { GetBindingKey("EZCINEMATIC_TOGGLE") }
    local list = table.concat(keys, " ")
    if list == boundKeys then return end
    boundKeys = list
    ClearOverrideBindings(toggleButton)
    for _, key in ipairs(keys) do
        SetOverrideBindingClick(toggleButton, false, key, toggleButton:GetName())
    end
end

---------------------------------------------------------------------------
-- Enter / exit
---------------------------------------------------------------------------
local function Enter()
    if InCombatLockdown() then
        return Print("Can't start cinematic mode in combat.")
    end
    -- Leaving cinematic mode may still be fading back to your volumes: those are yours.
    local yours = StopFade()
    db.saved = {}
    Snapshot(ns.SOUND_CVARS)
    if yours then
        for name, value in pairs(yours) do db.saved[name] = value end
    end
    HideNames(ns.HIDE_CVARS)
    if db.hidePlayerNames then HideNames(ns.PLAYER_NAME_CVARS) end
    BoostGraphics()
    FadeSound(SoundTargets())
    SetUIShown(false)
    SetEscOverride(true)
    SetClearOnPress(false)
    if UnitExists("target") then
        -- Started from /cine, which can't clear it.
        Print("Your target's name still shows: press Esc to clear it.")
    end
end

-- Puts back everything Enter changed. Also used after a /reload mid-cinematic.
local function Restore()
    local sound = {}
    for name, value in pairs(db.saved) do
        if IS_SOUND[name] then sound[name] = value else SetCVar(name, value) end
    end
    db.saved = nil
    FadeSound(sound)
    SetUIShown(true)
    SetEscOverride(false)
    SetClearOnPress(true)
end

local function Exit()
    if InCombatLockdown() then
        pendingExit = true
        return
    end
    Restore()
end

function EzCinematic_Toggle()
    if not db then return end
    if pendingExit then return end -- already leaving once combat ends
    if db.saved then Exit() else Enter() end
end

---------------------------------------------------------------------------
-- Key binding and slash command
---------------------------------------------------------------------------
for _, binding in ipairs(ns.BINDINGS) do
    _G["BINDING_NAME_" .. binding.action] = binding.label
end
BINDING_HEADER_EZCINEMATIC = "EzCinematic"

SLASH_EZCINEMATIC1 = "/cine"
SLASH_EZCINEMATIC2 = "/ezcinematic"
SlashCmdList.EZCINEMATIC = function(msg)
    local cmd = strtrim(msg or ""):lower()
    if cmd == "config" or cmd == "options" then
        if ns.settingsCategory then Settings.OpenToCategory(ns.settingsCategory:GetID()) end
    elseif cmd == "" then
        EzCinematic_Toggle()
    else
        Print("/cine - toggle cinematic mode, /cine config - options")
    end
end

---------------------------------------------------------------------------
-- Events
---------------------------------------------------------------------------
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_LOGIN")
events:RegisterEvent("PLAYER_REGEN_DISABLED")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:RegisterEvent("UPDATE_BINDINGS")
events:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        EzCinematicDB = EzCinematicDB or {}
        db = EzCinematicDB
        for key, value in pairs(ns.DEFAULTS) do
            if db[key] == nil then db[key] = value end
        end
        ns.BuildSettings(db)
    elseif event == "UPDATE_BINDINGS" then
        BindToggleKeys()
    elseif event == "PLAYER_LOGIN" then
        BindToggleKeys()
        -- A /reload halfway through a sound fade: put the values it was heading for in place,
        -- unless cinematic mode is still on (restoring it below covers every sound CVar).
        local final = db.fadeTo
        db.fadeTo = nil
        if final and not db.saved then SetFinal(final) end
        -- A /reload or disconnect during cinematic mode leaves names, graphics and sound changed; undo it.
        if db.saved then
            Print("Restoring names, nameplates, graphics and sound from the last cinematic session.")
            Exit()
        end
    elseif event == "PLAYER_REGEN_DISABLED" then
        -- Fires just before combat lockdown, so the UI, nameplates and Esc can still all come back
        -- now; waiting for the fight to end would leave you fighting blind.
        if db and db.saved and not pendingExit then
            Print("Combat started, leaving cinematic mode.")
            Exit()
        end
        -- A press in combat would drop your target and then refuse to start.
        SetClearOnPress(false)
    elseif event == "PLAYER_REGEN_ENABLED" then
        if bindingsPending then BindToggleKeys() end
        if pendingExit then
            pendingExit = nil
            Restore()
        end
        SetClearOnPress(not (db and db.saved))
    end
end)
