local BaseTurner = require("content/cells/abstract/BaseTurner")

local Turner180 = setmetatable({
    name = "turner_180",
    k3 = 587,
    title = "Turner (180)",
    description = "Rotates any cell that pushes it 180 degrees.",
    spin = 2
}, { __index = BaseTurner })
Turner180.__index = Turner180

return Turner180
