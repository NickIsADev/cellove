local BaseRotator = require("content/cells/abstract/BaseRotator")

local MegarotatorCCW = setmetatable({
    name = "megarotator_ccw",
    k3 = 246,
    title = "Megarotator (CCW)",
    description = "Rotates surrounding cells counter-clockwise every tick.",
    sides = { orthogonal = true, diagonal = true },
    spin = -1
}, { __index = BaseRotator })
MegarotatorCCW.__index = MegarotatorCCW

return MegarotatorCCW
