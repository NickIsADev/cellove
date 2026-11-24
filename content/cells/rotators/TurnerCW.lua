local BaseTurner = require("content/cells/abstract/BaseTurner")

local TurnerCW = setmetatable({
    name = "turner_cw",
    k3 = 585,
    title = "Turner (CW)",
    description = "Rotates any cell that pushes it clockwise."
}, { __index = BaseTurner })
TurnerCW.__index = TurnerCW

return TurnerCW
