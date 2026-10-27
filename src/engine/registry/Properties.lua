local utf8 = require("utf8")
local utils = require("src/utils")

local Properties = {}

local function holds(value)
    return type(value) == "table" and value.class and type(value.rotation) == "number"
end

local types = {
    number = {
        input = "stepper",
        valid = function(property)
            return property.min >= 0 and property.min <= property.default and property.default <= property.max
        end,
        clean = function(property, value)
            return utils.clamp(value, property.min, property.max)
        end,
        pack = utils.packVarint,
        unpack = utils.unpackVarint
    },
    boolean = {
        input = "toggle",
        valid = function()
            return true
        end,
        clean = function(_, value)
            return value
        end,
        pack = function(value)
            return utils.packVarint(value and 1 or 0)
        end,
        unpack = function(data, position)
            local value
            value, position = utils.unpackVarint(data, position)
            return value == 1, position
        end
    },
    string = {
        input = "field",
        valid = function(property)
            return property.limit and utf8.len(property.default) <= property.limit
        end,
        clean = function(property, value)
            return value:sub(1, (utf8.offset(value, property.limit + 1) or #value + 1) - 1)
        end,
        pack = utils.packString,
        unpack = utils.unpackString
    },
    table = {
        valid = function(property)
            return next(property.default) == nil
        end,
        clean = function(property, value)
            return holds(value) and value or property.default
        end,
        pack = function(value)
            if not holds(value) then return utils.packString("") end

            local parts = { utils.packString(value.class.id), utils.packVarint(value.rotation) }
            for _, property in ipairs(value.class.properties) do
                parts[#parts + 1] = Properties.pack(property, Properties.value(value.props, property))
            end
            return utils.packString(table.concat(parts))
        end,
        unpack = function(data, position, registry)
            local blob
            blob, position = utils.unpackString(data, position)
            if not blob then return end

            local id, at = utils.unpackString(blob, 1)
            local class = id and registry.cells[id]
            if not class then return {}, position end

            local rotation
            rotation, at = utils.unpackVarint(blob, at)
            if not rotation then return {}, position end

            local props = {}
            for _, property in ipairs(class.properties) do
                props[property.id], at = Properties.unpack(property, blob, at, registry)
                if not at then return {}, position end
            end
            return { class = class, rotation = rotation % 4, props = props }, position
        end
    }
}

function Properties.valid(property)
    local kind = types[type(property.default)]
    return kind and kind.valid(property)
end

function Properties.value(props, property)
    local kind = type(property.default)
    local value = props and props[property.id]

    if type(value) ~= kind then return property.default end
    return types[kind].clean(property, value)
end

function Properties.specs(properties, props)
    local specs = {}
    for _, property in ipairs(properties) do
        local input = types[type(property.default)].input
        if input then
            specs[#specs + 1] = {
                kind = input,
                key = property.id,
                label = property.title,
                min = property.min,
                max = property.max,
                limit = property.limit,
                value = Properties.value(props, property)
            }
        end
    end
    return specs
end

function Properties.pack(property, value)
    return types[type(property.default)].pack(value)
end

function Properties.unpack(property, data, position, registry)
    return types[type(property.default)].unpack(data, position, registry)
end

return Properties
