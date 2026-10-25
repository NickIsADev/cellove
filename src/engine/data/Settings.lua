local constants = require("src/constants")

local config = constants.settings

local Settings = {}
Settings.__index = Settings

function Settings.new()
    local self = setmetatable({}, Settings)
    self.defaults = {}
    self.stored = {}
    self.values = {}
    self.listeners = {}
    self:_load()

    for key, default in pairs(config.defaults) do
        self:define(key, default)
    end
    return self
end

function Settings:_load()
    local text = love.filesystem.read(config.path)
    if not text then return end

    for key, value in text:gmatch("([^\r\n=]+)=([^\r\n]*)") do
        self.stored[key] = value
    end
end

function Settings:_save()
    for key, value in pairs(self.values) do
        self.stored[key] = tostring(value)
    end

    local keys = {}
    for key in pairs(self.stored) do
        keys[#keys + 1] = key
    end
    table.sort(keys)

    local lines = {}
    for _, key in ipairs(keys) do
        lines[#lines + 1] = key .. "=" .. self.stored[key]
    end

    love.filesystem.write(config.path, table.concat(lines, "\n") .. "\n")
end

function Settings:define(key, default)
    local stored, kind = self.stored[key], type(default)
    local value = default

    if kind == "boolean" and (stored == "true" or stored == "false") then
        value = stored == "true"
    elseif kind == "number" and stored then
        value = tonumber(stored) or default
    elseif kind == "string" and stored then
        value = stored
    end

    self.defaults[key], self.values[key] = default, value
end

function Settings:get(key)
    return self.values[key]
end

function Settings:set(key, value)
    assert(self.defaults[key] ~= nil, "unknown setting " .. key)
    if self.values[key] == value then return end

    self.values[key] = value
    self:_save()

    for _, callback in ipairs(self.listeners[key] or {}) do
        callback(value)
    end
end

function Settings:reset()
    for key, default in pairs(self.defaults) do
        self:set(key, default)
    end
end

function Settings:listen(key, callback)
    assert(self.defaults[key] ~= nil, "unknown setting " .. key)

    self.listeners[key] = self.listeners[key] or {}
    table.insert(self.listeners[key], callback)
    callback(self.values[key])
end

return Settings
