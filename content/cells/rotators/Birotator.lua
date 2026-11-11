local BaseRotator = require("content/cells/abstract/BaseRotator")

local Birotator = setmetatable({
    name = "birotator",
    k3 = 57,
    title = "Birotator",
    description = "Rotates the cells in front of and to the right of it clockwise and the cells behind and to the left of it counter-clockwise every tick.",
    faces = { 0 },
    spins = {
        [0] = 1,
        [1] = 1,
        [2] = -1,
        [3] = -1
    }
}, { __index = BaseRotator })
Birotator.__index = Birotator

return Birotator
