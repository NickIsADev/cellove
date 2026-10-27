local Properties = require("src/engine/registry/Properties")
local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.registry
local categories = {}
for _, category in ipairs(config.categories) do
    categories[category.id] = true
end

local Registry = {}
Registry.__index = Registry

function Registry.new(data)
    local self = setmetatable({}, Registry)
    self.cells = {}
    self:load(config.base.path, config.base.namespace)

    data.mods:each(function(mod)
        self:load(mod.root .. "/" .. constants.mods.cells, mod.id)
        for _, class in ipairs(mod.cells) do
            self:_register(class, mod.id, mod.id .. " cell " .. tostring(class.name))
        end
    end)
    return self
end

function Registry:_register(class, namespace, source)
    assert(rawget(class, "name"), source .. " must define its own name")
    assert(class.name:match(config.pattern), source .. " has an invalid name: " .. class.name)
    assert(class.categories and #class.categories > 0, source .. " must define a category")

    for _, property in ipairs(class.properties) do
        assert(property.id and property.title, source .. " has a property without an id or title")
        assert(Properties.valid(property), source .. " has an invalid definition for property " .. property.id)
    end

    local resolved = {}
    for _, id in ipairs(class.categories) do
        local category = categories[id] and id or namespace .. ":" .. id
        assert(categories[category], source .. " has an invalid category: " .. tostring(id))
        resolved[#resolved + 1] = category
    end
    class.categories = resolved
    rawset(class, "category", resolved[1])

    if class.setup then class:setup() end

    class.lookup = {
        subtick = utils.set(class.subtick),
        outputs = utils.set(class.outputs),
        divert = class.divert ~= BaseCell.divert
    }

    class.id = namespace .. ":" .. class.name
    class.texture = namespace == config.base.namespace and class.name or utils.texture(class.id)
    assert(not self.cells[class.id], "duplicate cell id " .. class.id)
    self.cells[class.id] = class
end

function Registry:_load(path, namespace)
    for _, item in ipairs(love.filesystem.getDirectoryItems(path)) do
        local file = path .. "/" .. item
        local name = item:match("^(.+)%.lua$")

        if love.filesystem.getInfo(file, "directory") then
            if item ~= "abstract" then self:_load(file, namespace) end
        elseif name then
            local module = path .. "/" .. name
            self:_register(require(module), namespace, module)
        end
    end
end

function Registry:load(path, namespace)
    assert(namespace:match(config.pattern), "invalid namespace: " .. namespace)
    self:_load(path, namespace)
end

function Registry:list()
    local list = {}
    for _, class in pairs(self.cells) do
        list[#list + 1] = class
    end

    table.sort(list, function(a, b) return a.id < b.id end)
    return list
end

function Registry:subticks()
    local count, rear, sweeps = 1, {}, {}

    for _, class in pairs(self.cells) do
        for _, subtick in ipairs(class.subtick) do
            count = math.max(count, subtick + 1)
            rear[subtick] = rear[subtick] or class.rear
            sweeps[subtick] = sweeps[subtick] or class.sweep
        end
    end
    return count, rear, sweeps
end

return Registry
