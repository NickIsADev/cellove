local BaseForker = require("content/cells/abstract/BaseForker")

local Divider = setmetatable({
    name = "divider",
    k3 = 99,
    title = "Divider",
    description = "Clones cells entering from behind out both sides without turning them.",
    forks = { [2] = { -1, 1 } },
    reverse = { [1] = -1, [3] = 1 }
}, { __index = BaseForker })
Divider.__index = Divider

return Divider
