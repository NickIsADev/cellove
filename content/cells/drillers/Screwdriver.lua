local Cutter = require("content/cells/drillers/Cutter")

local Screwdriver = setmetatable({
    name = "screwdriver",
    k3 = 277,
    title = "Screwdriver",
    description = "A Cutter that pushes the cell in front of it before slicing.",
    categories = { "movers", "drillers" },
    pushes = true
}, { __index = Cutter })
Screwdriver.__index = Screwdriver

return Screwdriver
