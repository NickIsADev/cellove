local Scissor = require("content/cells/scissors/Scissor")

local Triscissor = setmetatable({
    name = "triscissor",
    k3 = 179,
    title = "Triscissor",
    description = "A Scissor that also pushes a copy out its back.",
    splits = { "back", "left", "right" }
}, { __index = Scissor })
Triscissor.__index = Triscissor

return Triscissor
