local BaseGate = require("content/cells/abstract/BaseGate")

local IMPLYGate = setmetatable({
    name = "implygate",
    k3 = 194,
    title = "IMPLY Gate",
    description = "Generates unless only the left side is fed."
}, { __index = BaseGate })
IMPLYGate.__index = IMPLYGate

function IMPLYGate:condition(left, right)
    return not left or right
end

return IMPLYGate
