local Driller = require("content/cells/drillers/Driller")

local Cutter = setmetatable({
    name = "cutter",
    k3 = 276,
    title = "Cutter",
    description = "A Driller that slices the cell in front of it before drilling.",
    categories = { "drillers" },
    slices = true
}, { __index = Driller })
Cutter.__index = Cutter

return Cutter
