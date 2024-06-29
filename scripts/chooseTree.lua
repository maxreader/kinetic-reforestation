local lib=require("__kinetic-reforestation__/scripts/lib.lua")

local function isNan(v) return type(v)=="number" and v~=v end

local function reverseIter(a, i)
    i = i-1
    local v = a[i]
    if v then
      return i, v
    end
  end
local function reverseIPairs(a)
    return reverseIter, a, #a+1
end

local function get_cached_tree_probabilities(water,temperature,aux,elevation)
    local water_index=lib.clamp(math.ceil(water/global.data_ranges.water.range*property_resolution),property_resolution,1)
    local temperature_index=lib.clamp(math.ceil(temperature/global.data_ranges.temperature.range*property_resolution),property_resolution,1)
    local aux_index=lib.clamp(math.ceil(aux/global.data_ranges.aux.range*property_resolution),property_resolution,1)
    local elevation_index=lib.clamp(math.ceil(elevation/global.data_ranges.elevation.range*property_resolution),property_resolution,1)
    local total_index=lib.str_build_delim_list(".",{water_index,temperature_index,aux_index,elevation_index})
    local probabilities=global["tree_cached_probabilities"][total_index]
    if probabilities~=nil then return probabilities end

    probabilities={}

    local weights_at_this_point={}
    local total_weight=0
    for tree_name,weights in pairs(global["tree_weights"]) do
        local weight=weights["water"][water_index]*weights["temperature"][temperature_index]*weights["aux"][aux_index]*weights["elevation"][elevation_index]
        if weight>(1e-4) then
            weights_at_this_point[tree_name]=weight
            total_weight=total_weight+weight
        end
    end
    local current_weight=0
    local index=1
    if total_weight==0 then return probabilities end
    for tree_name,weight in pairs(weights_at_this_point) do
        current_weight=current_weight+weight
        probabilities[index]={tree=tree_name,weight=current_weight/total_weight}
        index=index+1
    end
    global["tree_cached_probabilities"][total_index]=probabilities
    return probabilities
end

local function check_pipette_setting(player)
    if player==nil then return end
    if player.mod_settings["kinetic-reforestation-pipette"].value==false then return end
    local tree_selection=player.mod_settings["kinetic-reforestation-selected-tree"].value
    if game.entity_prototypes[tree_selection]== nil then return end
    if lib.exclude_tree(tree_selection) then return end
    return tree_selection
end

local function check_tile_properties(surface,target_position)
    local properties=surface.calculate_tile_properties(global.tree_probability_properties,{target_position})
    local probabilities={}
    local total_weight=0
    for property, data in pairs(properties) do
        total_weight=total_weight+data[1]
    end
    local current_weight=0
    local index=1
    for property, data in pairs(properties) do
        local tree_name=string.sub(property,8,string.len(property)-12)
        local weight=data[1]
        current_weight=current_weight+weight
        probabilities[index]={tree=tree_name,weight=current_weight/total_weight}
        index=index+1
    end
    return probabilities
end

local function select_tree_from_probabilities(probabilities)
    if table_size(probabilities)==1 then return probabilities[1].tree end
    local random_value=math.random()
    local last_weight=0
    for _,data in ipairs(probabilities) do
        local weight=data.weight
        local tree_name=data.tree
        if weight>random_value and random_value>last_weight then return tree_name end
        last_weight=weight
    end
end

local function choose_tree(target_position,surface,player)
    local player_selection=check_pipette_setting(player)
    if player_selection~=nil then return player_selection end

    local probabilities={}

    if player.mod_settings["kinetic-reforestation-selection-mode"].value=="heavy" then
        probabilities=check_tile_properties(surface,target_position)
        for k,v in reverseIPairs(probabilities) do
            if isNan(v.weight) then table.remove(probabilities,k) end
        end
    else
        local properties=surface.calculate_tile_properties({"moisture","temperature","aux","elevation"},{target_position})
        local water=properties["moisture"][1]
        local temperature=properties["temperature"][1]
        local aux=properties["aux"][1]
        local elevation=properties["elevation"][1]
        probabilities=get_cached_tree_probabilities(water,temperature,aux,elevation)
    end
    if not next(probabilities) then return global.last_tree end
    local selected_tree=select_tree_from_probabilities(probabilities)
    if selected_tree~=nil then global.last_tree=selected_tree end
    return selected_tree
end

return choose_tree