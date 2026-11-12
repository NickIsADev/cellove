local Cutter = require("content/cells/drillers/Cutter")

local Chiseler = setmetatable({
    name = "chiseler",
    k3 = 280,
    title = "Chiseler",
    description = "A Cutter that also drags the cells at its sides along with it.",
    categories = { "grabbers", "drillers" },
    grabs = true
}, { __index = Cutter })
Chiseler.__index = Chiseler

return Chiseler
