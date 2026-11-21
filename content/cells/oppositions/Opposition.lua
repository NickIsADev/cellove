local BaseOpposition = require("content/cells/abstract/BaseOpposition")

local Opposition = setmetatable({
    name = "opposition",
    k3 = 52,
    title = "Opposition",
    description = "Can only be pushed forwards, pulled backwards, and grabbed sideways.",
    moves = {
        push = { back = true },
        pull = { front = true },
        grab = { left = true, right = true }
    }
}, { __index = BaseOpposition })
Opposition.__index = Opposition

return Opposition
