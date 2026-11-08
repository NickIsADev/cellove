local Properties = require("src/engine/registry/Properties")
local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.registry
local categories = {}
for _, category in ipairs(config.categories) do
    categories[category.id] = category
end

local function expand(id, source, list, seen)
    local category = categories[id]
    assert(category, source .. " has an invalid category: " .. tostring(id))
    if seen[id] then return end

    seen[id] = true
    if category.parent then expand(category.parent, source, list, seen) end
    list[#list + 1] = id
end

local function sweepOf(class, subtick)
    local sweep = class.sweep
    if not sweep then return end
    return sweep.x and { [constants.simulator.scan] = sweep } or sweep[subtick]
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

    self:_twin()
    self.border = self.cells[config.base.namespace .. ":" .. constants.grid.border]
    return self
end

function Registry:_twin()
    for _, class in pairs(self.cells) do
        local twin = rawget(class, "twin")
            or class.id:match("_ccw$") and class.name:gsub("_ccw$", "_cw")
            or class.id:match("_cw$") and class.name:gsub("_cw$", "_ccw")
        class.flipped = twin and self.cells[(class.id:gsub("[^:]+$", twin))] or false
    end
end

function Registry:_register(class, namespace, source)
    assert(rawget(class, "name"), source .. " must define its own name")
    assert(class.name:match(config.pattern), source .. " has an invalid name: " .. class.name)
    assert(class.categories and #class.categories > 0, source .. " must define a category")

    for _, property in ipairs(class.properties) do
        assert(property.id and property.title, source .. " has a property without an id or title")
        assert(Properties.valid(property), source .. " has an invalid definition for property " .. property.id)
    end

    local resolved, lineage, seen = {}, {}, {}
    for _, id in ipairs(class.categories) do
        local category = categories[id] and id or namespace .. ":" .. id
        expand(category, source, lineage, seen)
        resolved[#resolved + 1] = category
    end
    class.categories = resolved
    class.lineage = lineage
    class.category = resolved[1]

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
    local order, seen, rear, sweeps = {}, {}, {}, {}

    for _, class in pairs(self.cells) do
        for _, subtick in ipairs(class.subtick) do
            if not seen[subtick] then
                seen[subtick] = true
                order[#order + 1] = subtick
            end
            rear[subtick] = rear[subtick] or class.rear
            sweeps[subtick] = sweeps[subtick] or sweepOf(class, subtick)
        end
    end
    table.sort(order)
    return #order > 0 and order or { 0 }, rear, sweeps
end

return Registry
