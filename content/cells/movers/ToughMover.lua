local Mover = require("content/cells/movers/Mover")
local BaseTough = require("content/cells/abstract/BaseTough")

local ToughMover = setmetatable({
    name = "toughmover",
    k3 = 213,
    title = "Tough Mover",
    description = "Mover that cannot be destroyed from its sides.",
    shields = { left = true, right = true }
}, { __index = Mover })
ToughMover.__index = ToughMover

ToughMover.guarded = BaseTough.guarded

return ToughMover
