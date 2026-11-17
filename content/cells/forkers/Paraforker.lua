local BaseForker = require("content/cells/abstract/BaseForker")

local Paraforker = setmetatable({
    name = "paraforker",
    k3 = 784,
    title = "Paraforker",
    description = "Two Forkers back to back: clones cells entering from behind or the front out both sides, turning them.",
    forks = {
        [0] = { -1, 1 },
        [2] = { -1, 1 }
    },
    reverse = { [1] = 1, [3] = 1 },
    rotates = true
}, { __index = BaseForker })
Paraforker.__index = Paraforker

return Paraforker
