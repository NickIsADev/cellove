local BaseCell = require("content/cells/abstract/BaseCell")

local Wall = setmetatable({
    name = "wall",
    k3 = 1,
    title = "Wall",
    description = "Cannot be pushed, rotated, or destroyed.",
    categories = { "walls" },
    fixed = true,
    anchored = true
}, { __index = BaseCell })
Wall.__index = Wall

return Wall
