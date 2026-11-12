local ScissorCW = require("content/cells/scissors/ScissorCW")

local MultiplierCW = setmetatable({
    name = "multiplier_cw",
    k3 = 184,
    title = "Multiplier (CW)",
    description = "A Scissor (CW) that doesn't rotate the split cells.",
    rotates = false
}, { __index = ScissorCW })
MultiplierCW.__index = MultiplierCW

return MultiplierCW
