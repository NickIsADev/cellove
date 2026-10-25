local BaseGate = require("content/cells/abstract/BaseGate")

local XORGate = setmetatable({
    name = "xorgate",
    k3 = 34,
    title = "XOR Gate",
    description = "Generates when exactly one side is fed."
}, { __index = BaseGate })
XORGate.__index = XORGate

function XORGate:condition(left, right)
    return left ~= right
end

return XORGate
