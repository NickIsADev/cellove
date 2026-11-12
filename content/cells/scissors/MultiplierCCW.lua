local ScissorCCW = require("content/cells/scissors/ScissorCCW")

local MultiplierCCW = setmetatable({
    name = "multiplier_ccw",
    k3 = 185,
    title = "Multiplier (CCW)",
    description = "A Scissor (CCW) that doesn't rotate the split cells.",
    rotates = false
}, { __index = ScissorCCW })
MultiplierCCW.__index = MultiplierCCW

return MultiplierCCW
