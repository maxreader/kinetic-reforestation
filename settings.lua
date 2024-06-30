data:extend{{
    type = "string-setting",
    name = "kinetic-reforestation-selection-mode",
    setting_type="runtime-per-user",
    default_value = "heavy",
    allowed_values = {
        "light",
        "heavy"
    }
},{
    type = "bool-setting",
    name = "kinetic-reforestation-pipette",
    setting_type="runtime-per-user",
    default_value = true
},{
    type="string-setting",
    name="kinetic-reforestation-selected-tree",
    setting_type="runtime-per-user",
    allow_blank=true,
    default_value=" "
},{
    type="bool-setting",
    name="kinetic-reforestation-use-last-tree",
    setting_type="runtime-per-user",
    default_value=true
},{
    type="bool-setting",
    name="kinetic-reforestation-disable-particles",
    setting_type="runtime-global",
    allow_blank=false,
    default_value=false
},{
    type="bool-setting",
    name="kinetic-reforestation-disable-nuke-effects",
    setting_type="startup",
    allow_blank=false,
    default_value=false
},{
    type="string-setting",
    name="kinetic-reforestation-tree-disable-list",
    setting_type="startup",
    allow_blank=true,
    default_value=mods["alien-biomes"] and "tree-volcanic-a" or  " "
}
}