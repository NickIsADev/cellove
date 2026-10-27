local lists = {}

function lists.has(list, value)
    for _, item in ipairs(list) do
        if item == value then return true end
    end
    return false
end

function lists.set(list)
    local set = {}
    for _, item in ipairs(list) do
        set[item] = true
    end
    return set
end

function lists.indexOf(list, value)
    for index, item in ipairs(list) do
        if item == value then return index end
    end
end

function lists.copy(source)
    local copy = {}
    for key, value in pairs(source) do
        copy[key] = value
    end
    return copy
end

function lists.merge(target, source)
    for key, value in pairs(source) do
        if type(value) == "table" and type(target[key]) == "table" then
            lists.merge(target[key], value)
        else
            target[key] = value
        end
    end
end

function lists.same(a, b)
    a, b = a or {}, b or {}
    for key, value in pairs(a) do
        if b[key] ~= value then return false end
    end
    for key in pairs(b) do
        if a[key] == nil then return false end
    end
    return true
end

return lists
