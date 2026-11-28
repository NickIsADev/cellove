local Mover = require("content/cells/movers/Mover")

local Wall = require("content/cells/walls/Wall")

local ToughMover = setmetatable({
    name = "toughmover",
    k3 = 213,
    title = "Tough Mover",
    description = "Mover that cannot be destroyed from its sides.",
    mimic = { left = Wall, right = Wall }
}, { __index = Mover })
ToughMover.__index = ToughMover

return ToughMover
