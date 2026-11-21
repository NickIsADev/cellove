local BaseFilter = require("content/cells/abstract/BaseFilter")
local constants = require("src/constants")

local Resistance = setmetatable({
    name = "resistance",
    k3 = 142,
    title = "Resistance",
    description = "Blocks any force that is not exactly 1 unit.",
    inverted = false
}, { __index = BaseFilter })
Resistance.__index = Resistance

function Resistance:_limit()
    return constants.force.unit
end

function Resistance:_filter(force)
    if (force == self:_limit()) == self.inverted then return 0 end

    return force
end

return Resistance
