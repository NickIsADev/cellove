local BaseTurner = require("content/cells/abstract/BaseTurner")

local TurnerCCW = setmetatable({
    name = "turner_ccw",
    k3 = 586,
    title = "Turner (CCW)",
    description = "Rotates any cell that pushes it counter-clockwise.",
    spin = -1
}, { __index = BaseTurner })
TurnerCCW.__index = TurnerCCW

return TurnerCCW
