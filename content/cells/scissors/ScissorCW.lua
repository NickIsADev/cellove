local Scissor = require("content/cells/scissors/Scissor")

local ScissorCW = setmetatable({
    name = "scissor_cw",
    k3 = 182,
    title = "Scissor (CW)",
    description = "A Scissor that only pushes copies out its back and its left side.",
    splits = { "back", "left" }
}, { __index = Scissor })
ScissorCW.__index = ScissorCW

return ScissorCW
