local pattern = "^(%d+)%.(%d+)%.(%d+)%-?([^+]*)"

local function identifiers(text)
    local list = {}
    for part in text:gmatch("[^.]+") do
        list[#list + 1] = tonumber(part) or part
    end
    return list
end

local function precedes(a, b)
    for index = 1, math.max(#a, #b) do
        local old, new = a[index], b[index]
        if old == nil then return true end
        if new == nil then return false end
        if old ~= new then
            if type(old) ~= type(new) then return type(old) == "number" end
            return old < new
        end
    end
    return false
end

local version = {}

function version.prerelease(text)
    return text:find("-", 1, true) ~= nil
end

function version.outdated(current, latest)
    local a, b = { current:match(pattern) }, { latest:match(pattern) }
    if #a < 4 or #b < 4 then return false end

    for index = 1, 3 do
        local old, new = tonumber(a[index]), tonumber(b[index])
        if old ~= new then return new > old end
    end
    if b[4] == "" then return a[4] ~= "" end
    return a[4] ~= "" and precedes(identifiers(a[4]), identifiers(b[4]))
end

return version
