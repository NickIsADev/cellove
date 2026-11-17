local BaseForker = require("content/cells/abstract/BaseForker")

local Forker = setmetatable({
    name = "forker",
    k3 = 48,
    title = "Forker",
    description = "Clones cells entering from behind out both sides, turning them.",
    forks = { [2] = { -1, 1 } },
    reverse = { [1] = -1, [3] = 1 },
    rotates = true
}, { __index = BaseForker })
Forker.__index = Forker

return Forker
