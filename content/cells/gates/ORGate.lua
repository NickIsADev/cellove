local BaseGate = require("content/cells/abstract/BaseGate")

local ORGate = setmetatable({
    name = "orgate",
    k3 = 32,
    title = "OR Gate",
    description = "Generates when either side is fed."
}, { __index = BaseGate })
ORGate.__index = ORGate

function ORGate:condition(left, right)
    return left or right
end

return ORGate
