local I = require("openmw.interfaces")
local multipliers = require("scripts.LinearLeveling.core.multipliers")
local state = require("scripts.LinearLeveling.core.state")
local statsWindowExtender = require("scripts.LinearLeveling.integrations.statsWindowExtender")


I.SkillProgression.addSkillLevelUpHandler(multipliers.updateMultiplierAfterSkillIncrease)

statsWindowExtender.enable()

return {
    engineHandlers = {
        onSave = state.save,
        onLoad = state.load,
    },
    eventHandlers = {
        UiModeChanged = function(data)
            if data.newMode == "LevelUp" then
                multipliers.saveAttributesBeforeLevelUp()
            elseif data.oldMode == "LevelUp" then
                multipliers.updateMultipliersAfterLevelUp()
            end
        end
    },
}
