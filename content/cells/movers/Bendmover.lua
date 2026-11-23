local Mover = require("content/cells/movers/Mover")

local Bendmover = setmetatable({
    name = "bendmover",
    k3 = 700,
    title = "Bendmover",
    description = "If its push is blocked, it will attempt to bend the push.",
    options = { bend = true }
}, { __index = Mover })
Bendmover.__index = Bendmover

return Bendmover
