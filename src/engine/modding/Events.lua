local constants = require("src/constants")

local text = constants.mods.text

local listeners = {}

local Events = {}

function Events.on(name, callback)
    listeners[name] = listeners[name] or {}
    table.insert(listeners[name], callback)
end

function Events.off(name, callback)
    for index, item in ipairs(listeners[name] or {}) do
        if item == callback then return table.remove(listeners[name], index) end
    end
end

function Events.emit(name, ...)
    for _, callback in ipairs(listeners[name] or {}) do
        local ok, err = pcall(callback, ...)
        if not ok then print(string.format(text.listener, name, err)) end
    end
end

return Events
