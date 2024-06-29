local sounds = require("__base__.prototypes.entity.sounds")
data:extend{
    {
        type = "technology",
        name = "kinetic-reforestation-tree-grenade",
        icon = "__kinetic-reforestation__/graphics/tree-grenade-tech.png",
        icon_size = 256, icon_mipmaps = 4,
        effects = {{
            type = "unlock-recipe",
            recipe = "kinetic-reforestation-tree-grenade",
        }},
        unit = {
            count = 250,
            ingredients = {
                {type = "item", name = "automation-science-pack", amount = 1},
                {type = "item", name = "logistic-science-pack", amount = 1},
                {type = "item", name = "chemical-science-pack", amount = 1},
            },
            time = 30,
        },
        prerequisites = {"military-3","explosives","kinetic-reforestation"},
    } --[[@as data.TechnologyPrototype]],{
        type = "recipe",
        name = "kinetic-reforestation-tree-grenade",
        energy_required = 10,
        results = {{type = "item", name = "kinetic-reforestation-tree-grenade", amount = 1}},
        ingredients = {
            {type = "item", name = kinetic_reforestation.tree_ingredient, amount = 100},
            {type = "item", name = "explosives", amount = 10},
            {type = "item", name = "steel-plate", amount = 5},
        },
        enabled = false
    } --[[@as data.RecipePrototype]],{
        type = "capsule",
        name = "kinetic-reforestation-tree-grenade",
        icon = "__kinetic-reforestation__/graphics/tree-cluster-grenade-icon.png",
        icon_size = 64, icon_mipmaps = 4,
        stack_size = 100,
        capsule_action =
        {
        type = "throw",
        attack_parameters =
        {
            type = "projectile",
            activation_type = "throw",
            ammo_category = "grenade",
            cooldown = 60,
            projectile_creation_distance = 0.6,
            range = 40,
            ammo_type =
            {
            category = "grenade",
            target_type = "position",
            action = {
                {
                type = "direct",
                action_delivery =
                {
                    type = "projectile",
                    projectile = "kinetic-reforestation-tree-grenade",
                    starting_speed = 0.3
                }
                },{
                type = "direct",
                action_delivery =
                {
                    type = "instant",
                    target_effects =
                    {
                    {
                        type = "play-sound",
                        sound = sounds.throw_projectile
                    }
                    }
                }
                }
            }
            }
        }
        },
        subgroup = kinetic_reforestation.item_subgroup,
        order="c-1",
    },{
        type = "projectile",
        name = "kinetic-reforestation-tree-grenade",
        flags = {"not-on-map"},
        acceleration = 0.005,
        action = {
            {
            type = "direct",
            action_delivery =
            {
                type = "instant",
                target_effects =
                {{
                    type = "script",
                    effect_id = "kinetic-reforestation-tree-grenade",
                }}
            }
            },
            {
            type = "cluster",
            cluster_count = 20,
            distance = 2,
            distance_deviation = 1,
            action_delivery =
            {
                type = "projectile",
                projectile = "kinetic-reforestation-tree-grenade-child",
                direction_deviation = 0.6,
                starting_speed = 0.3,
                starting_speed_deviation = 0.3
            }
            },
            {
            type = "cluster",
            cluster_count = 30,
            distance = 3,
            distance_deviation = 2,
            action_delivery =
            {
                type = "projectile",
                projectile = "kinetic-reforestation-tree-grenade-child",
                direction_deviation = 0.6,
                starting_speed = 0.6,
                starting_speed_deviation = 0.3
            }
            },
            {
            type = "cluster",
            cluster_count = 50,
            distance = 5,
            distance_deviation = 3,
            action_delivery =
            {
                type = "projectile",
                projectile = "kinetic-reforestation-tree-grenade-child",
                direction_deviation = 0.6,
                starting_speed = 1,
                starting_speed_deviation = 0.3
            }
            }
        },
        animation =
        {
            filename = "__kinetic-reforestation__/graphics/tree-cluster-grenade.png",
            draw_as_glow = true,
            frame_count = 15,
            line_length = 8,
            animation_speed = 0.250,
            width = 26,
            height = 28,
            shift = util.by_pixel(1, 1),
            priority = "high",
            hr_version =
            {
            filename = "__kinetic-reforestation__/graphics/hr-tree-cluster-grenade.png",
            draw_as_glow = true,
            frame_count = 15,
            line_length = 8,
            animation_speed = 0.250,
            width = 48,
            height = 54,
            shift = util.by_pixel(0.5, 0.5),
            priority = "high",
            scale = 0.5
            }

        },
        shadow =
        {
            filename = "__base__/graphics/entity/grenade/grenade-shadow.png",
            frame_count = 15,
            line_length = 8,
            animation_speed = 0.250,
            width = 26,
            height = 20,
            shift = util.by_pixel(2, 6),
            priority = "high",
            draw_as_shadow = true,
            hr_version =
            {
            filename = "__base__/graphics/entity/grenade/hr-grenade-shadow.png",
            frame_count = 15,
            line_length = 8,
            animation_speed = 0.250,
            width = 50,
            height = 40,
            shift = util.by_pixel(2, 6),
            priority = "high",
            draw_as_shadow = true,
            scale = 0.5
            }
        }
    },{
        type="projectile",
        name="kinetic-reforestation-tree-grenade-child",
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
                    effect_id = "kinetic-reforestation-tree-grenade",
                },
            },
        }
    }
}