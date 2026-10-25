local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local Bias = setmetatable({
    name = "bias",
    k3 = 42,
    title = "Bias",
    description = "Adds to any force going its direction and subtracts from any force going against it.",
    categories = { "forces" }
}, { __index = BaseCell })
Bias.__index = Bias

function Bias:force(dx, dy)
    return self:_alignment(dx, dy) * constants.force.strength
end

return Bias
