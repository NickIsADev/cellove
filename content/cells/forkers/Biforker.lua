local BaseForker = require("content/cells/abstract/BaseForker")

local Biforker = setmetatable({
    name = "biforker",
    k3 = 782,
    title = "Biforker",
    description = "Two Forkers at a right angle: clones cells entering from behind or the right, turning the ones that leave sideways.",
    forks = {
        [2] = { -1, 0 },
        [1] = { 0, 1 }
    },
    reverse = { [0] = 0, [3] = 0 },
    rotates = true
}, { __index = BaseForker })
Biforker.__index = Biforker

return Biforker
