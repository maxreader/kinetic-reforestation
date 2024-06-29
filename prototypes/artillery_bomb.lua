local ke_artillery_turret=table.deepcopy(data.raw["artillery-turret"]["artillery-turret"])
local ke_artillery_cannon=table.deepcopy(data.raw.gun["artillery-wagon-cannon"])
local ke_artillery_shell=table.deepcopy(data.raw.ammo["artillery-shell"])
local ke_artillery_remote=table.deepcopy(data.raw.capsule["artillery-targeting-remote"])
local ke_artillery_flare=table.deepcopy(data.raw["artillery-flare"]["artillery-flare"])
local ke_artillery_ammo_category={
    type="ammo-category",
    name="ke-artillery-shell"
}
ke_artillery_turret.name="ke-artillery-turret"
ke_artillery_turret.gun="ke-artillery-cannon"
ke_artillery_turret.minable.result="ke-artillery-turret"
ke_artillery_turret.disable_automatic_firing=true
ke_artillery_turret.icon="__kinetic-reforestation__/graphics/artillery-turret-icon.png"
ke_artillery_turret.base_picture.layers[1].filename="__kinetic-reforestation__/graphics/artillery-turret-base.png"
ke_artillery_turret.base_picture.layers[1].filename="__kinetic-reforestation__/graphics/artillery-turret-base-hr.png"

ke_artillery_cannon.name="ke-artillery-cannon"
ke_artillery_cannon.attack_parameters.ammo_category="ke-artillery-shell"

ke_artillery_shell.name="ke-artillery-shell"
ke_artillery_shell.icon='__kinetic-reforestation__/graphics/artillery-shell.png'
ke_artillery_shell.subgroup=kinetic_reforestation.item_subgroup
ke_artillery_shell.order="d-1"
ke_artillery_shell.ammo_type={
    category = "ke-artillery-shell",
    target_type = "position",
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "artillery",
        projectile = "ke-artillery-projectile",
        starting_speed = 1,
        direction_deviation = 0,
        range_deviation = 0,
        source_effects =
        {
          type = "create-explosion",
          entity_name = "artillery-cannon-muzzle-flash"
        }
      }
    }
  }
ke_artillery_remote.name="ke-artillery-remote"
ke_artillery_remote.capsule_action.flare="ke-artillery-flare"
ke_artillery_remote.icon="__kinetic-reforestation__/graphics/artillery-targeting-remote.png"
ke_artillery_remote.subgroup=kinetic_reforestation.item_subgroup
ke_artillery_remote.order="d-3"

ke_artillery_flare.name="ke-artillery-flare"
ke_artillery_flare.shot_category="ke-artillery-shell"
ke_artillery_flare.map_color={0,255,0,255}
ke_artillery_flare.icon="__kinetic-reforestation__/graphics/artillery-targeting-remote.png"
data.raw["artillery-flare"]["artillery-flare"].shot_category="artillery-shell"

local ke_artillery_projectile=require("__kinetic-reforestation__/prototypes/artillery_bomb_projectile.lua")

data:extend{
    ke_artillery_turret,
    ke_artillery_cannon,
    ke_artillery_shell,
    ke_artillery_remote,
    ke_artillery_flare,
    ke_artillery_ammo_category,
    ke_artillery_projectile,
    {
      type = "item",
      name = "ke-artillery-turret",
      icon = "__kinetic-reforestation__/graphics/artillery-turret-icon.png",
      icon_size = 64, icon_mipmaps = 4,
      subgroup = kinetic_reforestation.item_subgroup,
      order="d-2",
      place_result = "ke-artillery-turret",
      stack_size = 10,
    },
    {
      type = "projectile",
      name = "ke-artillery-bomb-wave",
      flags = {"not-on-map"},
      acceleration = 0,
      speed_modifier = { 1.0, 0.707 },
      action =
      {
        {
          type = "direct",
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              type = "script",
              effect_id = "kinetic-reforestation-artillery-bomb",
            }
          }
        }
      },
      animation = nil,
      shadow = nil
    },
    {
      type = "technology",
      name = "kinetic-reforestation-artillery",
      icon = "__kinetic-reforestation__/graphics/artillery-tech.png",
      icon_size = 256, icon_mipmaps = 4,
      effects = {{
          type = "unlock-recipe",
          recipe = "ke-artillery-turret",
      },{
        type = "unlock-recipe",
        recipe = "ke-artillery-shell",
      },{
        type = "unlock-recipe",
        recipe = "ke-artillery-remote",
      }},
      unit = {
        ingredients =
        {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
          {"military-science-pack", 1},
          {"utility-science-pack", 1}
        },
        time = 30,
        count = 2000
      },
      prerequisites = {"artillery","kinetic-reforestation-tree-grenade"},
    } --[[@as data.TechnologyPrototype]],{
      type = "recipe",
      name = "ke-artillery-shell",
      enabled = false,
      energy_required = 50,
      ingredients =
      {
        {"rocket-control-unit", 10},
        {"explosives", 100},
        {kinetic_reforestation.tree_ingredient, 1200}
      },
      result = "ke-artillery-shell"
    },{
      type = "recipe",
      name = "ke-artillery-turret",
      enabled = false,
      energy_required = 40,
      ingredients =
      {
        {"steel-plate", 60},
        {"concrete", 60},
        {"iron-gear-wheel", 40},
        {"advanced-circuit", 20}
      },
      result = "ke-artillery-turret"
    },{
      type = "recipe",
      name = "ke-artillery-remote",
      enabled = false,
      ingredients =
      {
        {"processing-unit", 1},
        {"radar", 1}
      },
      result = "ke-artillery-remote"
    },
}