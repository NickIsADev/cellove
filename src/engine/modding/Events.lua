local constants = require("src/constants")

local text = constants.mods.text

local listeners = {}
local counts = {}
local none = {}

local Events = {}

function Events.on(name, callback)
    listeners[name] = listeners[name] or {}
    counts[name] = counts[name] or 0
    table.insert(listeners[name], callback)
end

function Events.off(name, callback)
    for index, item in ipairs(listeners[name] or {}) do
        if item == callback then return table.remove(listeners[name], index) end
    end
end

function Events.emit(name, ...)
    counts[name] = (counts[name] or 0) + 1

    for _, callback in ipairs(listeners[name] or none) do
        local ok, err = pcall(callback, ...)
        if not ok then print(string.format(text.listener, name, err)) end
    end
end

function Events.stats()
    local list = {}

    for name, count in pairs(counts) do
        list[#list + 1] = {
            name = name,
            count = count,
            listeners = #(listeners[name] or none)
        }
    end
    table.sort(list, function(a, b) return a.name < b.name end)
    return list
end

return Events
