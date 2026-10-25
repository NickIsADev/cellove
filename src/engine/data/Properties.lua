local utf8 = require("utf8")
local utils = require("src/utils")

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
    }
}

local Properties = {}

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
        specs[#specs + 1] = {
            kind = types[type(property.default)].input,
            key = property.id,
            label = property.title,
            min = property.min,
            max = property.max,
            limit = property.limit,
            value = Properties.value(props, property)
        }
    end
    return specs
end

function Properties.pack(property, value)
    return types[type(property.default)].pack(value)
end

function Properties.unpack(property, data, position)
    return types[type(property.default)].unpack(data, position)
end

return Properties
