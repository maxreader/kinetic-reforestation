require("__core__/lualib/util.lua")

data:extend{{
        type="custom-input",
        name="kinetic-reforestation-pipette",
        key_sequence="Q",
        linked_game_control="smart-pipette"
    },{
        type="item-subgroup",
        name="kinetic-reforestation",
        group="combat",
        order="ba"
    }
}

require("__kinetic-reforestation__/prototypes/compat_init.lua")
require("__kinetic-reforestation__/prototypes/tree_shotgun.lua")
require("__kinetic-reforestation__/prototypes/tree_grenade.lua")
require("__kinetic-reforestation__/prototypes/artillery_bomb")

if mods["angelsbioprocessing"]~=nil then
    data.raw["technology"]["kinetic-reforestation"].prerequisites={"bio-arboretum-1","steel-processing","military"}
    data.raw["item-subgroup"]["kinetic-reforestation"].group="bio-processing-nauvis"
    data.raw["item-subgroup"]["kinetic-reforestation"].order="y"
end

