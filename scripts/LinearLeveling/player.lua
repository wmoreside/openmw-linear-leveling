local I                   = require("openmw.interfaces")
local healthManager       = require("scripts.LinearLeveling.core.healthManager")
local multiplierManager   = require("scripts.LinearLeveling.core.multiplierManager")
local state               = require("scripts.LinearLeveling.core.state")
local statsWindowExtender = require("scripts.LinearLeveling.integrations.statsWindowExtender")


I.SkillProgression.addSkillLevelUpHandler(multiplierManager.updateMultiplierAfterSkillIncrease)

statsWindowExtender.enable()

return {
    engineHandlers = {
        onSave = state.save,
        onLoad = state.load,
    },
    eventHandlers = {
        UiModeChanged = function(data)
            if data.oldMode == "ChargenClassReview" then
                healthManager.saveStartingHealth()
            elseif data.newMode == "LevelUp" then
                multiplierManager.saveAttributesBeforeLevelUp()
            elseif data.oldMode == "LevelUp" then
                healthManager.updateHealthAfterLevelUp()
                multiplierManager.updateMultipliersAfterLevelUp()
            end
        end
    },
}
