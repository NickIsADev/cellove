local Driller = require("content/cells/drillers/Driller")

local Raker = setmetatable({
    name = "raker",
    k3 = 75,
    title = "Raker",
    description = "A Driller that drags the cells at its sides along with it.",
    categories = { "grabbers", "drillers" },
    grabs = true
}, { __index = Driller })
Raker.__index = Raker

return Raker
