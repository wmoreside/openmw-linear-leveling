local I = require("openmw.interfaces")
local health = require("scripts.LinearLeveling.core.health")
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
            if data.oldMode == "ChargenClassReview" then
                health.saveStartingHealth()
            elseif data.newMode == "LevelUp" then
                multipliers.saveAttributesBeforeLevelUp()
            elseif data.oldMode == "LevelUp" then
                health.updateHealthAfterLevelUp()
                multipliers.updateMultipliersAfterLevelUp()
            end
        end
    },
}
