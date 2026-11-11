local BaseRotator = require("content/cells/abstract/BaseRotator")

local QuasirotatorCW = setmetatable({
    name = "quasirotator_cw",
    k3 = 994,
    title = "Quasirotator (CW)",
    description = "Rotates the cell in front of it clockwise every tick.",
    faces = { 0 },
    outputs = { 0 }
}, { __index = BaseRotator })
QuasirotatorCW.__index = QuasirotatorCW

return QuasirotatorCW
