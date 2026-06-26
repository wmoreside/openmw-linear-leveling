local I                 = require("openmw.interfaces")
local core              = require("openmw.core")
local omwself           = require("openmw.self")
local multiplierManager = require("scripts.LinearLeveling.core.multiplierManager")
local settings          = require("scripts.LinearLeveling.core.settings")
local state             = require("scripts.LinearLeveling.core.state")


local M = {}

local function levelTooltip()
    local level = omwself.type.stats.level(omwself)
    local levelUpTotal = core.getGMST("iLevelupTotal")
    local mults = {}

    for attribute, skillIncreases in pairs(state.skillIncreasesForAttribute) do
        if skillIncreases > 0 then
            local multiplier = multiplierManager.getMultiplier(attribute)
            local tooltipsEnabled = settings.getTooltipsEnabled()
            if tooltipsEnabled then
                mults[attribute] = multiplier .. " #dfc99f(" .. skillIncreases .. ")"
            elseif not tooltipsEnabled and multiplier > 1 then
                mults[attribute] = multiplier
            end
        end
    end

    local stats = I.StatsWindow.Templates.STATS
    local progressBar = stats.levelProgressBar(level.progress, levelUpTotal, mults)
    return stats.tooltip(8, progressBar, "level")
end

M.enable = function()
    if not I.StatsWindow then return end

    I.StatsWindow.modifyLine("level", { tooltip = levelTooltip })
end

return M
