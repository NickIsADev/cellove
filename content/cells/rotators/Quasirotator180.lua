local BaseRotator = require("content/cells/abstract/BaseRotator")

local Quasirotator180 = setmetatable({
    name = "quasirotator_180",
    k3 = 996,
    title = "Quasirotator (180)",
    description = "Rotates the cell in front of it 180 degrees every tick.",
    faces = { 0 },
    outputs = { 0 },
    spin = 2
}, { __index = BaseRotator })
Quasirotator180.__index = Quasirotator180

return Quasirotator180
