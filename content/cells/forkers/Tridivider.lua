local BaseForker = require("content/cells/abstract/BaseForker")

local Tridivider = setmetatable({
    name = "tridivider",
    k3 = 100,
    title = "Tridivider",
    description = "Clones cells entering from behind out the front and both sides without turning them.",
    forks = { [2] = { -1, 1, 0 } },
    reverse = { [0] = 0, [1] = -1, [3] = 1 }
}, { __index = BaseForker })
Tridivider.__index = Tridivider

return Tridivider
