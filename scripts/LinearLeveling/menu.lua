local I = require("openmw.interfaces")


I.Settings.registerPage {
    key = "LinearLeveling",
    l10n = "LinearLeveling",
    name = "page_name",
    description = "page_description",
}

I.Settings.registerGroup {
    key = "SettingsPlayerLinearLevelingMultiplier",
    page = "LinearLeveling",
    l10n = "LinearLeveling",
    name = "multiplier_group_name",
    description = "multiplier_group_description",
    permanentStorage = true,
    order = 0,
    settings = {
        {
            key = "skillIncreasesPerMultiplier",
            renderer = "number",
            name = "skillIncreasesPerMultiplier_name",
            default = 2.5,
            argument = {
                integer = false,
                min = 0.1,
            },
        },
    },
}

I.Settings.registerGroup {
    key = "SettingsPlayerLinearLevelingSkillValues",
    page = "LinearLeveling",
    l10n = "LinearLeveling",
    name = "skill_values_group_name",
    description = "skill_values_group_description",
    permanentStorage = true,
    order = 1,
    settings = {
        {
            key = "majorSkillValue",
            renderer = "number",
            name = "majorSkillValue_name",
            default = 1,
            argument = {
                integer = false,
                min = 0,
            },
        },
        {
            key = "minorSkillValue",
            renderer = "number",
            name = "minorSkillValue_name",
            default = 1,
            argument = {
                integer = false,
                min = 0,
            },
        },
        {
            key = "miscSkillValue",
            renderer = "number",
            name = "miscSkillValue_name",
            default = 1,
            argument = {
                integer = false,
                min = 0,
            },
        },
    },
}

I.Settings.registerGroup {
    key = "SettingsPlayerLinearLevelingAltHealth",
    page = "LinearLeveling",
    l10n = "LinearLeveling",
    name = "alt_health_group_name",
    description = "alt_health_group_description",
    permanentStorage = true,
    order = 2,
    settings = {
        {
            key = "enableAltHealth",
            renderer = "checkbox",
            name = "enableAltHealth_name",
            default = false,
        },
    },
}

I.Settings.registerGroup {
    key = "SettingsPlayerLinearLevelingDebug",
    page = "LinearLeveling",
    l10n = "LinearLeveling",
    name = "debug_group_name",
    description = "debug_group_description",
    permanentStorage = true,
    order = 3,
    settings = {
        {
            key = "enableTooltips",
            renderer = "checkbox",
            name = "enableTooltips_name",
            description = "enableTooltips_description",
            default = true,
        },
    },
}
