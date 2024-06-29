local lib={}

function lib.clamp(value,max,min)
        max=max or 1
        min=min or 0
        return math.max(math.min(value,max),min)
end
function lib.str_build_delim_list(delim,values)
    local ret=nil
    for _, value in pairs(values) do
        if ret==nil then ret=value
        else ret=ret..delim..value end
    end
    return ret
end

function lib.exclude_tree(name)
    if string.find(name,"dead") then return true
    elseif string.find(name,"garden") then return true
    elseif string.find(name,"puffer") then return true
    elseif string.find(name,"dry") then return true
    elseif name=="swamp-tree" then return true
    elseif name=="temperate-tree" then return true
    elseif name=="desert-tree" then return true
    end
    return false
end

return lib