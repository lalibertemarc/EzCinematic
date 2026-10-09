-- EzCinematic: one key for clean screenshots.
local addonName, ns = ...

local GetCVar, SetCVar = C_CVar.GetCVar, C_CVar.SetCVar

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

local function ApplySoundPreset()
    if not (C_AddOns.IsAddOnLoaded("EzSoundMixer") and SlashCmdList.EZSOUNDMIXER) then return end
    SlashCmdList.EZSOUNDMIXER(ns.SOUND_PRESET)
end

---------------------------------------------------------------------------
-- Enter / exit
---------------------------------------------------------------------------
local function Enter()
    if InCombatLockdown() then
        return Print("Can't start cinematic mode in combat.")
    end
    db.saved = {}
    Snapshot(ns.HIDE_CVARS)
    Snapshot(ns.SOUND_CVARS)
    for _, name in ipairs(ns.HIDE_CVARS) do
        if db.saved[name] then SetCVar(name, "0") end
    end
    ApplySoundPreset()
    SetUIShown(false)
end

-- Puts back everything Enter changed. Also used after a /reload mid-cinematic.
local function Restore()
    for name, value in pairs(db.saved) do
        SetCVar(name, value)
    end
    db.saved = nil
    SetUIShown(true)
end

local function Exit()
    if InCombatLockdown() then
        pendingExit = true
        events:RegisterEvent("PLAYER_REGEN_ENABLED")
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
SlashCmdList.EZCINEMATIC = EzCinematic_Toggle

---------------------------------------------------------------------------
-- Events
---------------------------------------------------------------------------
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_LOGIN")
events:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        EzCinematicDB = EzCinematicDB or {}
        db = EzCinematicDB
    elseif event == "PLAYER_LOGIN" then
        -- A /reload or disconnect during cinematic mode leaves names and sound changed; undo it.
        if db.saved then
            Print("Restoring names, nameplates and sound from the last cinematic session.")
            Exit()
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        events:UnregisterEvent("PLAYER_REGEN_ENABLED")
        pendingExit = nil
        Restore()
    end
end)
