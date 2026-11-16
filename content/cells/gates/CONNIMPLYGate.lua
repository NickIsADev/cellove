local BaseGate = require("content/cells/abstract/BaseGate")

local CONNIMPLYGate = setmetatable({
    name = "connimplygate",
    k3 = 197,
    title = "CON-NIMPLY Gate",
    description = "Generates when only the right side is fed."
}, { __index = BaseGate })
CONNIMPLYGate.__index = CONNIMPLYGate

function CONNIMPLYGate:condition(left, right)
    return not left and right
end

return CONNIMPLYGate
