local BaseFilter = require("content/cells/abstract/BaseFilter")
local constants = require("src/constants")

local Restrictor = setmetatable({
    name = "restrictor",
    k3 = 144,
    title = "Restrictor",
    description = "Limits the force pushing or pulling it to 1 unit."
}, { __index = BaseFilter })
Restrictor.__index = Restrictor

function Restrictor:_filter(force)
    return math.min(force, constants.force.unit)
end

return Restrictor
