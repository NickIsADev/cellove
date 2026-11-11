local BaseRotator = require("content/cells/abstract/BaseRotator")

local Pararotator = setmetatable({
    name = "pararotator",
    k3 = 70,
    title = "Pararotator",
    description = "Rotates the cells in front of and behind it clockwise and the cells to its left and right counter-clockwise every tick.",
    faces = { 0, 2 },
    spins = {
        [0] = 1,
        [1] = -1,
        [2] = 1,
        [3] = -1
    }
}, { __index = BaseRotator })
Pararotator.__index = Pararotator

return Pararotator
