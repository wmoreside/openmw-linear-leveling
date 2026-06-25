local async = require("openmw.async")
local omwself = require("openmw.self")
local types = require("openmw.types")
local settings = require("scripts.LinearLeveling.core.settings")
local state = require("scripts.LinearLeveling.core.state")
local classSkills = require("scripts.LinearLeveling.core.utils.classSkills")


local M = {}

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
    if not settings.getAltHealthEnabled() then return end

    local level = types.Actor.stats.level(omwself).current
    local endurance = types.Actor.stats.attributes.endurance(omwself).base

    local currentHealth = types.Actor.stats.dynamic.health(omwself)
    local currentDamage = (currentHealth.base + currentHealth.modifier) - currentHealth.current

    local endurancePart = (level - 1) * 0.06 * endurance
    local skillsPart = (level - 1) * 0.4 * classSkills.getHealthAffectingSkillsCount()
    local newBaseHealth = state.startingHealth + endurancePart + skillsPart
    local newCurrentHealth = math.max(1, (newBaseHealth + currentHealth.modifier) - currentDamage)

    currentHealth.base = newBaseHealth
    currentHealth.current = newCurrentHealth
end

return M
