local async = require("openmw.async")
local omwself = require("openmw.self")
local types = require("openmw.types")
local state = require("scripts.LinearLeveling.core.state")


local M = {}

local healthAffectingSkills = {
    heavyarmor = true,
    mediumarmor = true,
    lightarmor = true,
    unarmored = true,
    block = true,
    axe = true,
    bluntweapon = true,
    handtohand = true,
    longblade = true,
    marksman = true,
    shortblade = true,
    spear = true,
    acrobatics = true,
    athletics = true,
}

local function getHealthAffectingSkillsCount()
    local player = types.NPC.record(omwself)
    local class = types.NPC.classes.record(player.class)
    local count = 0

    local function tally(skillList)
        for _, skillId in ipairs(skillList) do
            if healthAffectingSkills[skillId] then
                count = count + 1
            end
        end
    end

    tally(class.majorSkills)
    tally(class.minorSkills)

    return count
end

M.saveStartingHealth = function()
    if not state.isChargenComplete then
        state.startingHealth = types.Actor.stats.dynamic.health(omwself).base
    end

    if not state.isChargenComplete then
        async:newUnsavableSimulationTimer(0, function()
            if state.isChargenComplete then return end
            state.isChargenComplete = true
        end)
    end
end

M.updateHealthAfterLevelUp = function()
    if state.startingHealth == nil then return end

    local level = types.Actor.stats.level(omwself).current
    local endurance = types.Actor.stats.attributes.endurance(omwself).base

    local currentHealth = types.Actor.stats.dynamic.health(omwself)
    local currentDamage = (currentHealth.base + currentHealth.modifier) - currentHealth.current

    local endurancePart = (level - 1) * 0.05 * endurance
    local skillsPart = (level - 1) * 0.5 * getHealthAffectingSkillsCount()
    local newBaseHealth = state.startingHealth + endurancePart + skillsPart
    local newCurrentHealth = math.max(1, (newBaseHealth + currentHealth.modifier) - currentDamage)

    currentHealth.base = newBaseHealth
    currentHealth.current = newCurrentHealth
end

return M
