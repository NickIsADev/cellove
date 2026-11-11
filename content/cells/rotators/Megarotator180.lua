local BaseRotator = require("content/cells/abstract/BaseRotator")

local Megarotator180 = setmetatable({
    name = "megarotator_180",
    k3 = 247,
    title = "Megarotator (180)",
    description = "Rotates surrounding cells 180 degrees every tick.",
    sides = { orthogonal = true, diagonal = true },
    spin = 2
}, { __index = BaseRotator })
Megarotator180.__index = Megarotator180

return Megarotator180
