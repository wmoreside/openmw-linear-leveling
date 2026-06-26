local core        = require("openmw.core")
local omwself     = require("openmw.self")
local types       = require("openmw.types")
local settings    = require("scripts.LinearLeveling.core.settings")
local state       = require("scripts.LinearLeveling.core.state")
local classSkills = require("scripts.LinearLeveling.core.utils.classSkills")


local M = {}

local function getAttributes()
    return {
        strength = types.Actor.stats.attributes.strength(omwself).base,
        intelligence = types.Actor.stats.attributes.intelligence(omwself).base,
        willpower = types.Actor.stats.attributes.willpower(omwself).base,
        agility = types.Actor.stats.attributes.agility(omwself).base,
        speed = types.Actor.stats.attributes.speed(omwself).base,
        endurance = types.Actor.stats.attributes.endurance(omwself).base,
        personality = types.Actor.stats.attributes.personality(omwself).base,
        luck = types.Actor.stats.attributes.luck(omwself).base,
    }
end

local function getSkillIncreaseValue(skillId)
    local skills = classSkills.get()
    if skills.major[skillId] then return settings.getMajorSkillValue() end
    if skills.minor[skillId] then return settings.getMinorSkillValue() end
    return settings.getMiscSkillValue()
end

local function getVanillaSkillIncreasesRequiredForMultiplier(multiplier)
    if multiplier == 5 then return 10 end
    if multiplier == 4 then return 8 end
    if multiplier == 3 then return 5 end
    if multiplier == 2 then return 1 end
    return 0
end

local function removeSkillIncreasesForIncreasedAttribute(attributeId, attributeIncrease)
    if attributeIncrease < 1 then return end

    local decreaseValue = settings.getSkillIncreasesPerMultiplier() * (attributeIncrease - 1)
    state.skillIncreasesForAttribute[attributeId] =
        state.skillIncreasesForAttribute[attributeId] - decreaseValue
end

local function syncVanillaMultiplierForAttribute(attributeId)
    local multiplier = M.getMultiplier(attributeId)
    local vanillaValue = getVanillaSkillIncreasesRequiredForMultiplier(multiplier)
    types.Actor.stats.level(omwself).skillIncreasesForAttribute[attributeId] = vanillaValue
end

M.getMultiplier = function(attributeId)
    local skillIncreases = state.skillIncreasesForAttribute[attributeId]
    local skillIncreasesPerMultiplier = settings.getSkillIncreasesPerMultiplier()
    local multiplier = math.floor(1 + skillIncreases / skillIncreasesPerMultiplier)
    return math.min(multiplier, 5)
end

M.saveAttributesBeforeLevelUp = function()
    state.attributesBeforeLevelUp = getAttributes()
end

M.updateMultiplierAfterSkillIncrease = function(skillId, _, options)
    if options.skillIncreaseValue < 0 then return end

    local attributeId = core.stats.Skill.record(skillId).attribute
    state.skillIncreasesForAttribute[attributeId] =
        state.skillIncreasesForAttribute[attributeId] + getSkillIncreaseValue(skillId)
    syncVanillaMultiplierForAttribute(attributeId)

    -- Prevents the engine from overriding the value we set.
    options.levelUpAttributeIncreaseValue = nil
end

M.updateMultipliersAfterLevelUp = function()
    local attributesAfterLevelUp = getAttributes()

    for attributeId, oldValue in pairs(state.attributesBeforeLevelUp) do
        local attributeIncrease = attributesAfterLevelUp[attributeId] - oldValue
        removeSkillIncreasesForIncreasedAttribute(attributeId, attributeIncrease)
    end

    for _, attribute in ipairs(core.stats.Attribute.records) do
        syncVanillaMultiplierForAttribute(attribute.id)
    end
end

return M
