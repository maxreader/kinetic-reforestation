local sounds = require("__base__.prototypes.entity.sounds")

data:extend{
    {
        type = "technology",
        name = "kinetic-reforestation",
        icon = "__kinetic-reforestation__/graphics/tree-shotgun-tech-new.png",
        icon_size = 256, icon_mipmaps = 4,
        effects = {{
            type = "unlock-recipe",
            recipe = "kinetic-reforestation-tree-shotgun",
        },{
            type = "unlock-recipe",
            recipe = "kinetic-reforestation-seed-pellet",
        }},
        unit = {
            count = 50,
            ingredients = {
                {type = "item", name = "automation-science-pack", amount = 1},
            },
            time = 30,
        },
        prerequisites = {"steel-processing","military"},
    } --[[@as data.TechnologyPrototype]],{
        type = "recipe",
        name = "kinetic-reforestation-tree-shotgun",
        energy_required = 10,
        results = {{type = "item", name = "kinetic-reforestation-tree-shotgun", amount = 1}},
        ingredients = {
            {type = "item", name = "shotgun", amount = 1},
            {type = "item", name = "steel-plate", amount = 1},
            {type = "item", name = "iron-gear-wheel", amount = 5},
        },
        enabled = false
    } --[[@as data.RecipePrototype]],{
        type="ammo-category",
        name="tree"
    },{
        type = "recipe",
        name = "kinetic-reforestation-seed-pellet",
        energy_required = 2,
        results = {{type = "item", name = "kinetic-reforestation-seed-pellet", amount = 5}},
        ingredients = {
            {type = "item", name = kinetic_reforestation.tree_ingredient, amount = 5},
            {type = "item", name = "steel-plate", amount = 1}
        },
        enabled = false
    }--[[@as data.RecipePrototype]],{
        type = "gun",
        name = "kinetic-reforestation-tree-shotgun",
        icon = "__kinetic-reforestation__/graphics/tree-shotgun.png",
        icon_size = 64, icon_mipmaps = 4,
        stack_size = 1,
        attack_parameters = {
            type = "projectile",
            ammo_category = "tree",
            movement_slow_down_factor = 0.5,
            cooldown = 10,
            range = 50,
            sound = sounds.shotgun
        },
        subgroup = kinetic_reforestation.item_subgroup,
        order="b-2"
    } --[[@as data.GunPrototype]],{
        type = "ammo",
        name = "kinetic-reforestation-seed-pellet",
        icon="__kinetic-reforestation__/graphics/tree-pellet.png",
        icon_mipmaps=4,
        icon_size=64,
        stack_size=200,
        magazine_size=1,
        ammo_type={
            category="tree",
            target_type="position",
            action = {
                {
                type = "direct",
                action_delivery = {
                    type = "projectile",
                    projectile = "kinetic-reforestation-tree-pellet-projectile",
                    starting_speed = 0.3
                }
                }
            }
        },
        subgroup = kinetic_reforestation.item_subgroup,
        order="b-1"
    },{
        type="projectile",
        name="kinetic-reforestation-tree-pellet-projectile",
        acceleration = 0.01,
        animation =
        {
        filename = "__base__/graphics/entity/bullet/bullet.png",
        draw_as_glow = true,
        frame_count = 1,
        width = 3,
        height = 50,
        priority = "high",
        tint={r=0,g=0.5,b=0,a=1}
        },
        action={
            type="direct",
            action_delivery = {
                type = "instant",
                target_effects = {
                    type = "script",
                    effect_id = "kinetic-reforestation-tree-pellet",
                },
            },
        }
    }
}