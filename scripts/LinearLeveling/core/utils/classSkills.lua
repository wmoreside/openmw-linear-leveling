local omwself = require("openmw.self")
local types   = require("openmw.types")


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

local cache = nil

local function getCache()
    if cache then return cache end

    local player = types.NPC.record(omwself)
    local class = types.NPC.classes.record(player.class)
    local skills = { major = {}, minor = {} }
    local count = 0

    for _, skillId in ipairs(class.majorSkills) do
        skills.major[skillId] = true
        if healthAffectingSkills[skillId] then
            count = count + 1
        end
    end

    for _, skillId in ipairs(class.minorSkills) do
        skills.minor[skillId] = true
        if healthAffectingSkills[skillId] then
            count = count + 1
        end
    end

    cache = {
        classSkills = skills,
        healthAffectingSkillsCount = count
    }

    return cache
end

M.get = function()
    return getCache().classSkills
end

M.getHealthAffectingSkillsCount = function()
    return getCache().healthAffectingSkillsCount
end

return M
