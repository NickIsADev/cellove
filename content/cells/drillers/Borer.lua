local Raker = require("content/cells/drillers/Raker")

local Borer = setmetatable({
    name = "borer",
    k3 = 76,
    title = "Borer",
    description = "A Raker that pushes the cell in front of it before drilling.",
    categories = { "movers", "grabbers", "drillers" },
    pushes = true
}, { __index = Raker })
Borer.__index = Borer

return Borer
