local Triscissor = require("content/cells/scissors/Triscissor")

local Trimultiplier = setmetatable({
    name = "trimultiplier",
    k3 = 181,
    title = "Trimultiplier",
    description = "A Triscissor that doesn't rotate the split cells.",
    rotates = false
}, { __index = Triscissor })
Trimultiplier.__index = Trimultiplier

return Trimultiplier
