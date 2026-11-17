local BaseForker = require("content/cells/abstract/BaseForker")

local Paradivider = setmetatable({
    name = "paradivider",
    k3 = 785,
    title = "Paradivider",
    description = "Two Dividers back to back: clones cells entering from behind or the front out both sides without turning them.",
    forks = {
        [0] = { -1, 1 },
        [2] = { -1, 1 }
    },
    reverse = { [1] = 1, [3] = 1 }
}, { __index = BaseForker })
Paradivider.__index = Paradivider

return Paradivider
