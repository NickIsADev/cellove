local Scissor = require("content/cells/scissors/Scissor")

local ScissorCCW = setmetatable({
    name = "scissor_ccw",
    k3 = 183,
    title = "Scissor (CCW)",
    description = "A Scissor that only pushes copies out its back and its right side.",
    splits = { "back", "right" }
}, { __index = Scissor })
ScissorCCW.__index = ScissorCCW

return ScissorCCW
