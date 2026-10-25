local BaseGate = require("content/cells/abstract/BaseGate")

local NORGate = setmetatable({
    name = "norgate",
    k3 = 35,
    title = "NOR Gate",
    description = "Generates when neither side is fed."
}, { __index = BaseGate })
NORGate.__index = NORGate

function NORGate:condition(left, right)
    return not (left or right)
end

return NORGate
