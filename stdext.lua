function table.hasDuplicates(list)
    -- checks for dulicates in given list.
    -- if any are found, returns them;
    -- else returns false
    occurence = {}
    duplicates = {}
    for _, item in ipairs(list) do
        if not occurence[item] then
            occurence[item] = true
        else
            table.insert(duplicates, item)
        end
    end

    if #duplicates == 0 then
        return false
    else
        return #duplicates
    end
end


function table.elementInTable(t, e)
    -- checks if the given element is in the given list
    -- returns it's index in the list or false
    for i, v in ipairs(t) do
        if e == v then
            return i
        end
    end

    return false
end


function table.joinList(list, sep)
    str = ''
    if not sep then sep = ' '
    else sep = tostring(sep) end

    for i, item in ipairs(list) do
        str = str .. tostring(item)

        if i ~= #list then      -- prevent adding a separator in the end
            str = str .. sep
        end
    end
    return str
end


function math.clamp(n, min, max)
    -- puts n in range min <= n <= max
    if min and n <= min then
        return min
    elseif max and n >= max then
        return max
    else
        return n
    end
end


function math.round(num) 
    if num >= 0 then return math.floor(num+.5) 
    else return math.ceil(num-.5) end
end


return stdext