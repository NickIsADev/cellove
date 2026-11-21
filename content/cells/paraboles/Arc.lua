local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local Arc = setmetatable({
    name = "arc",
    k3 = 386,
    title = "Arc",
    description = "Diverger that is pushed along in the new direction instead of letting cells through.",
    categories = { "paraboles" },
    solid = true,
    rotates = false,
    routes = { [0] = -1, [1] = 1 }
}, { __index = BaseDiverger })
Arc.__index = Arc

return Arc
