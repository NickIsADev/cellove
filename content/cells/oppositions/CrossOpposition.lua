local BaseOpposition = require("content/cells/abstract/BaseOpposition")

local CrossOpposition = setmetatable({
    name = "crossopposition",
    k3 = 53,
    title = "Cross Opposition",
    description = "Can only be pushed from behind and from its right, and pulled from its front and left.",
    faces = { 0, 3 },
    moves = {
        push = { back = true, right = true },
        pull = { front = true, left = true }
    }
}, { __index = BaseOpposition })
CrossOpposition.__index = CrossOpposition

return CrossOpposition
