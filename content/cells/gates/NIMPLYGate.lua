local BaseGate = require("content/cells/abstract/BaseGate")

local NIMPLYGate = setmetatable({
    name = "nimplygate",
    k3 = 196,
    title = "NIMPLY Gate",
    description = "Generates when only the left side is fed."
}, { __index = BaseGate })
NIMPLYGate.__index = NIMPLYGate

function NIMPLYGate:condition(left, right)
    return left and not right
end

return NIMPLYGate
