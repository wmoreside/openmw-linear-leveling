local storage = require("openmw.storage")


local M = {}

local multiplierSettings = storage.playerSection("SettingsPlayerLinearLevelingMultiplier")
local skillValueSettings = storage.playerSection("SettingsPlayerLinearLevelingSkillValues")
local altHealthSettings = storage.playerSection("SettingsPlayerLinearLevelingAltHealth")
local tooltipsSettings = storage.playerSection("SettingsPlayerLinearLevelingTooltips")

M.getSkillIncreasesPerMultiplier = function()
    return multiplierSettings:get("skillIncreasesPerMultiplier") or 2.5
end

M.getMajorSkillValue = function()
    return skillValueSettings:get("majorSkillValue") or 1
end

M.getMinorSkillValue = function()
    return skillValueSettings:get("minorSkillValue") or 1
end

M.getMiscSkillValue = function()
    return skillValueSettings:get("miscSkillValue") or 1
end

M.getAltHealthEnabled = function()
    return altHealthSettings:get("enableAltHealth") or false
end

M.getTooltipsEnabled = function()
    return tooltipsSettings:get("enableTooltips") or true
end

return M
