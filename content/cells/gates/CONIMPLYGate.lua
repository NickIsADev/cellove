local BaseGate = require("content/cells/abstract/BaseGate")

local CONIMPLYGate = setmetatable({
    name = "conimplygate",
    k3 = 195,
    title = "CON-IMPLY Gate",
    description = "Generates unless only the right side is fed."
}, { __index = BaseGate })
CONIMPLYGate.__index = CONIMPLYGate

function CONIMPLYGate:condition(left, right)
    return left or not right
end

return CONIMPLYGate
