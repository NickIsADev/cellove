local Driller = require("content/cells/drillers/Driller")

local Auger = setmetatable({
    name = "auger",
    k3 = 59,
    title = "Auger",
    description = "A Driller that pushes the cell in front of it before drilling.",
    categories = { "movers", "drillers" },
    pushes = true
}, { __index = Driller })
Auger.__index = Auger

return Auger
