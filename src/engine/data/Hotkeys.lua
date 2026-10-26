local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.hotkeys

local Hotkeys = {}
Hotkeys.__index = Hotkeys

function Hotkeys.new(data)
    local self = setmetatable({}, Hotkeys)
    self.settings = data.settings
    self.list = {}

    for _, spec in ipairs(config.list) do
        self:_add(spec)
    end
    for _, tool in ipairs(constants.editor.tools.list) do
        if tool.key then
            self:_add({
                id = tool.id,
                group = config.tools,
                title = tool.title,
                description = tool.description,
                key = tool.key
            })
        end
    end
    return self
end

function Hotkeys:_add(spec)
    self.settings:define(config.prefix .. spec.id, spec.key)
    self.list[#self.list + 1] = spec
end

function Hotkeys:get(id)
    return self.settings:get(config.prefix .. id)
end

function Hotkeys:chord(key)
    local parts = {}

    for _, name in ipairs(config.modifiers) do
        if love.keyboard.isDown("l" .. name, "r" .. name) then parts[#parts + 1] = name end
    end
    parts[#parts + 1] = key
    return table.concat(parts, " ")
end

function Hotkeys:pressed(id, key)
    return self:chord(key) == self:get(id)
end

function Hotkeys:down(id)
    return love.keyboard.isDown(self:get(id):match("%S+$"))
end

function Hotkeys:turn(key)
    return (self:pressed("rotateCW", key) and 1 or 0) - (self:pressed("rotateCCW", key) and 1 or 0)
end

function Hotkeys:label(id)
    return (self:get(id):gsub("%S+", utils.capitalize):gsub(" ", "+"))
end

function Hotkeys:conflicts(id)
    local titles = {}

    for _, other in ipairs(self.list) do
        if other.id ~= id and self:get(other.id) == self:get(id) then titles[#titles + 1] = other.title end
    end
    return titles
end

function Hotkeys:bind(id, chord)
    self.settings:set(config.prefix .. id, chord)
end

function Hotkeys:reset()
    for _, spec in ipairs(self.list) do
        self:bind(spec.id, spec.key)
    end
end

return Hotkeys
