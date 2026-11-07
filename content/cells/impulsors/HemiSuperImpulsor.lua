local SuperImpulsor = require("content/cells/impulsors/SuperImpulsor")

local HemiSuperImpulsor = setmetatable({
    name = "hemisuperimpulsor",
    k3 = 731,
    title = "Super Hemiimpulsor",
    description = "Super Impulsor that only pulls in front of it and to its left.",
    inputs = { 0, 3 }
}, { __index = SuperImpulsor })
HemiSuperImpulsor.__index = HemiSuperImpulsor

return HemiSuperImpulsor
