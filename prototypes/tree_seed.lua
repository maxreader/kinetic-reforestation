data:extend{{
    type = "technology",
    name = "kinetic-reforestation-seed-duplication",
    icons = {
        {
            icon="__kinetic-reforestation__/graphics/seed-duplication.png",
            icon_size=256,
            icon_mipmaps=1,
        },
        {
            icon="__kinetic-reforestation__/graphics/refresh.png",
            icon_size=32,
            icon_mipmaps=1,
            scale=3,
            shift={64,64}
        }
    },
    effects = {{
        type = "unlock-recipe",
        recipe = "kinetic-reforestation-tree-seed",
    }},
    unit = {
        count = 150,
        ingredients = {
            {type = "item", name = "automation-science-pack", amount = 1},
            {type = "item", name = "logistic-science-pack", amount = 1},
        },
        time = 30,
    },
    prerequisites = {"automation-2","kinetic-reforestation"},
} --[[@as data.TechnologyPrototype]],{
    type = "recipe",
    name = "kinetic-reforestation-tree-seed",
    category="advanced-crafting",
    energy_required=120,
    results={{type="item",name="kinetic-reforestation-tree-seed",amount_min=2,amount_max=20}},
    ingredients = {
        {type="item",name="kinetic-reforestation-tree-seed",amount=1},
        {type="fluid",name="water",amount=1000}
    },
    enabled=false
}--[[@as data.RecipePrototype]],{
    type="item",
    name="kinetic-reforestation-tree-seed",
    icon="__kinetic-reforestation__/graphics/acorn-icon.png",
    icon_mipmaps=1,
    icon_size=64,
    stack_size=200,
    fuel_category="chemical",
    fuel_value="100kJ",
    subgroup = kinetic_reforestation.item_subgroup,
    order="a"
}
}