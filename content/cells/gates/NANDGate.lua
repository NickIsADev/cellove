local BaseGate = require("content/cells/abstract/BaseGate")

local NANDGate = setmetatable({
    name = "nandgate",
    k3 = 36,
    title = "NAND Gate",
    description = "Generates unless both sides are fed."
}, { __index = BaseGate })
NANDGate.__index = NANDGate

function NANDGate:condition(left, right)
    return not (left and right)
end

return NANDGate
