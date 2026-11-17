local BaseForker = require("content/cells/abstract/BaseForker")

local Bidivider = setmetatable({
    name = "bidivider",
    k3 = 783,
    title = "Bidivider",
    description = "Two Dividers at a right angle: clones cells entering from behind or the right without turning them.",
    forks = {
        [2] = { -1, 0 },
        [1] = { 0, 1 }
    },
    reverse = { [0] = 0, [3] = 0 }
}, { __index = BaseForker })
Bidivider.__index = Bidivider

return Bidivider
