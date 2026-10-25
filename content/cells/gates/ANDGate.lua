local BaseGate = require("content/cells/abstract/BaseGate")

local ANDGate = setmetatable({
    name = "andgate",
    k3 = 33,
    title = "AND Gate",
    description = "Generates when both sides are fed."
}, { __index = BaseGate })
ANDGate.__index = ANDGate

function ANDGate:condition(left, right)
    return left and right
end

return ANDGate
