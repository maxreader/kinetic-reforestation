require("util")
local lib=require("__kinetic-reforestation__/scripts/lib.lua")
local cacheTreeData=require("__kinetic-reforestation__/scripts/cacheTreeData.lua")
local chooseTree=require("__kinetic-reforestation__/scripts/chooseTree.lua")

property_resolution=40

local function random_within_range(center,deviation)
    return (math.random()-0.5)*deviation*2+center
end
local function random_vector(deviation)
    return {random_within_range(0,deviation),random_within_range(0,deviation)}
end

local function find_target_position(surface,target_position,tree,radius)
    radius=radius or 10
    local can_place_at_target=surface.can_place_entity{name=tree,position=target_position,build_check_type=defines.build_check_type.manual}
    return can_place_at_target and target_position or surface.find_non_colliding_position(tree,target_position,10,0.35)
end

local function spill_tree(position,surface)
    surface.spill_item_stack(position,{name="kinetic-reforestation-seed-pellet"})
end

local function plant_tree(event,particle_count,radius,spill)
    particle_count=particle_count or 30
    local particle_movement=0.018
    local particle_vertical_speed=0.1
    local target_position = event.target_position --[[@as MapPosition]]
    if target_position==nil then return end

    local surface = game.surfaces[event.surface_index]
    if not surface.valid then return end

    local player=event.source_entity and event.source_entity.player
    if player==nil then
        if global.last_player_index==nil then return end
        player=game.get_player(global.last_player_index)
        particle_count=7
        particle_movement=0.075
        particle_vertical_speed=0.3
    else global.last_player_index=player.index end

    if player==nil then return end

    local tree_to_plant = chooseTree(target_position,surface,player)
    if tree_to_plant==nil then
        if spill then spill_tree(target_position,surface) end
        return
    end

    local position = find_target_position(surface,target_position,tree_to_plant,radius)
    if position==nil then
        if spill then spill_tree(target_position,surface) end
        return
    else
        surface.create_entity{
            name=tree_to_plant,
            position=position,
            raise_built=true
        }
        if settings.global["kinetic-reforestation-disable-particles"].value==true then return end
        for _=1,particle_count,1 do
            local random_offset=random_vector(1)
            surface.create_particle({
                name="leaf-particle",
                position={position.x+random_offset[1],position.y+random_offset[2]},
                movement=random_vector(particle_movement),
                height=random_within_range(2,1),
                vertical_speed=particle_vertical_speed,
                frame_speed=1
            })
        end
    end
end

script.on_init(cacheTreeData)
script.on_configuration_changed(cacheTreeData)

script.on_event(defines.events.on_script_trigger_effect, function(event)
    if event.effect_id=="kinetic-reforestation-tree-pellet" then plant_tree(event,nil,nil,true)
    elseif event.effect_id=="kinetic-reforestation-tree-grenade" then plant_tree(event,10)
    elseif event.effect_id== "kinetic-reforestation-artillery-bomb" then plant_tree(event,0) end
    --if event.effect_id=="kinetic-reforestation-tree-bomb" then for _=1,100 do plant_tree(event,25) end end
end)

script.on_event("kinetic-reforestation-pipette", function(event)
    local player=game.get_player(event.player_index)
    if player==nil then return end
    if player.mod_settings["kinetic-reforestation-pipette"].value==false then return end

    local selection=player.selected
    if selection==nil then player.mod_settings["kinetic-reforestation-selected-tree"]={value=" "} return end
    if selection.type=="tree" and not lib.exclude_tree(selection.name) then player.mod_settings["kinetic-reforestation-selected-tree"]={value=selection.name} end
end)


