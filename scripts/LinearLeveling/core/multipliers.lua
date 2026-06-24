local core = require("openmw.core")
local omwself = require("openmw.self")
local types = require("openmw.types")
local state = require("scripts.LinearLeveling.core.state")


local SKILL_INCREASES_PER_MULTIPLIER = 2.5
local MAJOR_SKILL_INCREASE_VALUE = 1
local MINOR_SKILL_INCREASE_VALUE = 1
local MISC_SKILL_INCREASE_VALUE = 0

local M = {}

local classSkillsCache = nil
local function getClassSkills()
    if classSkillsCache ~= nil then return classSkillsCache end

    local player = types.NPC.record(omwself)
    local class = types.NPC.classes.record(player.class)
    local skills = { major = {}, minor = {} }

    for _, skillId in ipairs(class.majorSkills) do
        skills.major[skillId] = true
    end

    for _, skillId in ipairs(class.minorSkills) do
        skills.minor[skillId] = true
    end

    classSkillsCache = skills
    return classSkillsCache
end

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
    local skills = getClassSkills()
    if skills.major[skillId] then return MAJOR_SKILL_INCREASE_VALUE end
    if skills.minor[skillId] then return MINOR_SKILL_INCREASE_VALUE end
    return MISC_SKILL_INCREASE_VALUE
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

    local decreaseValue = SKILL_INCREASES_PER_MULTIPLIER * (attributeIncrease - 1)
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
    local multiplier = math.floor(1 + skillIncreases / SKILL_INCREASES_PER_MULTIPLIER)
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
