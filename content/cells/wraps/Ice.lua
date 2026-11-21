local BaseCell = require("content/cells/abstract/BaseCell")

local Ice = setmetatable({
    name = "ice",
    k3 = 79,
    title = "Ice",
    description = "Empty tiles next to it, across the direction a cell moves, are slipped past instead of landed on.",
    categories = { "wraps" },
    faces = {},
    slick = true
}, { __index = BaseCell })
Ice.__index = Ice

return Ice
