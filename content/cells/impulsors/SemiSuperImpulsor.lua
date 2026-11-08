local SuperImpulsor = require("content/cells/impulsors/SuperImpulsor")

local SemiSuperImpulsor = setmetatable({
    name = "semisuperimpulsor",
    k3 = 729,
    title = "Super Semiimpulsor",
    description = "Super Impulsor that only pulls in front of and behind it.",
    inputs = { 0, 2 }
}, { __index = SuperImpulsor })
SemiSuperImpulsor.__index = SemiSuperImpulsor

return SemiSuperImpulsor
