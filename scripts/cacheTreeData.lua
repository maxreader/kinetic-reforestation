local lib=require("__kinetic-reforestation__/scripts/lib.lua")

local function max_or_min_to_value(max_or_min)
    return max_or_min=="max" and -math.huge or max_or_min=="min" and math.huge or 0
end

local function get_tree_extreme(peaks,property,max_or_min)
    if peaks==nil then return max_or_min_to_value(max_or_min) end
    if peaks[property.."_optimal"]==nil then return max_or_min_to_value(max_or_min) end
    local max_range=peaks[property.."_max_range"] or peaks[property.."_range"]
    if max_or_min=="max" then
        return peaks[property.."_optimal"]+max_range
    elseif max_or_min=="min" then
        return peaks[property.."_optimal"]-max_range
    end
end

local function calculate_tree_weight(variable,value,tree_name)
    local optimal_value=global["tree_data"][tree_name][variable.."_optimal"]
    local optimal_range=global["tree_data"][tree_name][variable.."_range"]
    local max_range=global["tree_data"][tree_name][variable.."_max_range"] or optimal_range
    local ret=0
    if optimal_value==nil then ret=1
    elseif (value>(optimal_value+max_range)) or (value<(optimal_value-max_range)) then ret=0
    elseif (value<(optimal_value+optimal_range)) and (value>(optimal_value-optimal_range)) then ret=1
    elseif value>optimal_value then ret=1-(value-(optimal_value+optimal_range))/(max_range-optimal_range)
    elseif value<optimal_value then ret=1-(optimal_value-optimal_range-value)/(max_range-optimal_range)
    end
    return lib.clamp(ret,1,0)
end

local function cache_tree_names()
    local trees=game.get_filtered_entity_prototypes{{filter="type",type="tree"}}
    local index=1
    global.tree_names={}
    global.tree_probability_properties={}
    for name, tree in pairs(trees) do
        if not lib.exclude_tree(name) then
            global.tree_names[index]=name
            global.tree_probability_properties[index]="entity:"..name..":probability"
            index=index+1
        end
    end
end

local function parse_tree_autoplace(autoplace)
    local tree_autoplace={}
    for k, peak in pairs(autoplace.peaks) do
        for property,_ in pairs(global.data_ranges) do
            tree_autoplace[property.."_optimal"]=peak[property.."_optimal"] or tree_autoplace[property.."_optimal"]
            tree_autoplace[property.."_max_range"]=math.max(tree_autoplace[property.."_max_range"] or 0,peak[property.."_max_range"] or 0)
            tree_autoplace[property.."_range"]=math.max(tree_autoplace[property.."_range"] or 0,peak[property.."_range"] or 0)
        end
    end
    return tree_autoplace
end

local function cacheAllTreeAutoplace()
    global["tree_data"]={}
    global.data_ranges={
        water={
            max=-math.huge,
            min=math.huge
        },
        temperature={
            max=-math.huge,
            min=math.huge
        },
        aux={
            max=-math.huge,
            min=math.huge
        },
        elevation={
            max=-math.huge,
            min=math.huge
        },
    }
    global.tree_weights={}
    local tree_weight_template={
        water={},
        temperature={},
        aux={},
        elevation={}
    }
    local trees=game.get_filtered_entity_prototypes{{filter="type",type="tree"}}

    for name, tree in pairs(trees) do
        if lib.exclude_tree(name) then goto continue end
        local autoplace=tree.autoplace_specification
        if autoplace~=nil then
            this_tree_data=parse_tree_autoplace(autoplace)
            global["tree_data"][tree.name]=this_tree_data
            global.data_ranges.water.max=math.max(global.data_ranges.water.max,get_tree_extreme(this_tree_data,"water","max"))
            global.data_ranges.water.min=math.min(global.data_ranges.water.min,get_tree_extreme(this_tree_data,"water","min"))
            global.data_ranges.temperature.max=math.max(global.data_ranges.temperature.max,get_tree_extreme(this_tree_data,"temperature","max"))
            global.data_ranges.temperature.min=math.min(global.data_ranges.temperature.min,get_tree_extreme(this_tree_data,"temperature","min"))
            global.data_ranges.aux.max=math.max(global.data_ranges.aux.max,get_tree_extreme(this_tree_data,"aux","max"))
            global.data_ranges.aux.min=math.min(global.data_ranges.aux.min,get_tree_extreme(this_tree_data,"aux","min"))
            global.data_ranges.elevation.max=math.max(global.data_ranges.elevation.max,get_tree_extreme(this_tree_data,"elevation","max"))
            global.data_ranges.elevation.min=math.min(global.data_ranges.elevation.min,get_tree_extreme(this_tree_data,"elevation","min"))
            global.tree_weights[tree.name]=table.deepcopy(tree_weight_template)
        end
        ::continue::
    end
    global.data_ranges.elevation.max=global.data_ranges.elevation.max*2
    for variable,variable_bounds in pairs(global.data_ranges) do
        local range=variable_bounds.max-variable_bounds.min
        global.data_ranges[variable].range=range
        local step_size=range/property_resolution
        for index=1,property_resolution do
            local value=variable_bounds.min+step_size*index
            for tree_name, _ in pairs(global["tree_data"]) do
                global["tree_weights"][tree_name][variable][index]=calculate_tree_weight(variable,value,tree_name)+0.001
            end
        end
    end
    global["tree_data"]=nil
    global["tree_cached_probabilities"]={{{{{}}}}}
    cache_tree_names()
end

return cacheAllTreeAutoplace