local storage = require("openmw.storage")


local M = {}

local multiplierSettings = storage.playerSection("SettingsPlayerLinearLevelingMultiplier")
local skillValueSettings = storage.playerSection("SettingsPlayerLinearLevelingSkillValues")
local altHealthSettings = storage.playerSection("SettingsPlayerLinearLevelingAltHealth")
local tooltipsSettings = storage.playerSection("SettingsPlayerLinearLevelingTooltips")

M.getSkillIncreasesPerMultiplier = function()
    return multiplierSettings:get("skillIncreasesPerMultiplier")
end

M.getMajorSkillValue = function()
    return skillValueSettings:get("majorSkillValue")
end

M.getMinorSkillValue = function()
    return skillValueSettings:get("minorSkillValue")
end

M.getMiscSkillValue = function()
    return skillValueSettings:get("miscSkillValue")
end

M.getAltHealthEnabled = function()
    return altHealthSettings:get("enableAltHealth")
end

M.getTooltipsEnabled = function()
    return tooltipsSettings:get("enableTooltips")
end

return M
