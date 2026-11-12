local Scissor = require("content/cells/scissors/Scissor")

local Multiplier = setmetatable({
    name = "multiplier",
    k3 = 180,
    title = "Multiplier",
    description = "A Scissor that doesn't rotate the split cells.",
    rotates = false
}, { __index = Scissor })
Multiplier.__index = Multiplier

return Multiplier
