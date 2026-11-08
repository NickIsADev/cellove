local SuperImpulsor = require("content/cells/impulsors/SuperImpulsor")

local HenaSuperImpulsor = setmetatable({
    name = "henasuperimpulsor",
    k3 = 732,
    title = "Super Henaimpulsor",
    description = "Super Impulsor that only pulls in front of it and to both its sides.",
    inputs = { 0, 1, 3 }
}, { __index = SuperImpulsor })
HenaSuperImpulsor.__index = HenaSuperImpulsor

return HenaSuperImpulsor
