local pattern = "^(%d+)%.(%d+)%.(%d+)"

local version = {}

function version.prerelease(text)
    return text:find("-", 1, true) ~= nil
end

function version.outdated(current, latest)
    local a, b = { current:match(pattern) }, { latest:match(pattern) }
    if #a < 3 or #b < 3 then return false end

    for index = 1, 3 do
        local old, new = tonumber(a[index]), tonumber(b[index])
        if old ~= new then return new > old end
    end
    return version.prerelease(current) and not version.prerelease(latest)
end

return version
