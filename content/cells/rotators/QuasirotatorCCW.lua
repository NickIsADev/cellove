local BaseRotator = require("content/cells/abstract/BaseRotator")

local QuasirotatorCCW = setmetatable({
    name = "quasirotator_ccw",
    k3 = 995,
    title = "Quasirotator (CCW)",
    description = "Rotates the cell in front of it counter-clockwise every tick.",
    faces = { 0 },
    outputs = { 0 },
    spin = -1
}, { __index = BaseRotator })
QuasirotatorCCW.__index = QuasirotatorCCW

return QuasirotatorCCW
