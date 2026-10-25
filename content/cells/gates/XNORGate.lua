local BaseGate = require("content/cells/abstract/BaseGate")

local XNORGate = setmetatable({
    name = "xnorgate",
    k3 = 37,
    title = "XNOR Gate",
    description = "Generates when both or neither side is fed."
}, { __index = BaseGate })
XNORGate.__index = XNORGate

function XNORGate:condition(left, right)
    return left == right
end

return XNORGate
