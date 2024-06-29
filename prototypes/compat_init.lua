kinetic_reforestation={}

if mods["angelsbioprocessing"]~=nil then
    kinetic_reforestation.tree_ingredient="solid-tree"
    kinetic_reforestation.item_subgroup="kinetic-reforestation"
else
    kinetic_reforestation.tree_ingredient="kinetic-reforestation-tree-seed"
    kinetic_reforestation.item_subgroup="kinetic-reforestation"
end

if kinetic_reforestation.tree_ingredient=="kinetic-reforestation-tree-seed" then
    require("__kinetic-reforestation__/prototypes/tree_seed.lua")
    for tree_name, tree in pairs(data.raw.tree) do
        local results={}
        if tree.minable and tree.minable.results then
            results=table.deepcopy(tree.minable.results) --[[@as data.ProductPrototype]]
        else
            results={{type="item",name="wood",amount=4}}
        end
        table.insert(results,{type="item",name="kinetic-reforestation-tree-seed",amount=5,probability=0.01})
        tree.minable.results=results
    end
end