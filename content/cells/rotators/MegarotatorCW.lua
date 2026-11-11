local BaseRotator = require("content/cells/abstract/BaseRotator")

local MegarotatorCW = setmetatable({
    name = "megarotator_cw",
    k3 = 245,
    title = "Megarotator (CW)",
    description = "Rotates surrounding cells clockwise every tick.",
    sides = { orthogonal = true, diagonal = true }
}, { __index = BaseRotator })
MegarotatorCW.__index = MegarotatorCW

return MegarotatorCW
