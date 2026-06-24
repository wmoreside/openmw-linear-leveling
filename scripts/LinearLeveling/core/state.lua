local M = {
    attributesBeforeLevelUp = nil,
    isChargenComplete = false,
    skillIncreasesForAttribute = {
        strength = 0,
        intelligence = 0,
        willpower = 0,
        agility = 0,
        speed = 0,
        endurance = 0,
        personality = 0,
        luck = 0,
    },
    startingHealth = nil,
}

M.load = function(data)
    if data then
        for k, v in pairs(data) do
            M[k] = v
        end
    end
end

M.save = function()
    return {
        isChargenComplete = M.isChargenComplete,
        skillIncreasesForAttribute = M.skillIncreasesForAttribute,
        startingHealth = M.startingHealth,
    }
end

return M
