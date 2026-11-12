local Screwdriver = require("content/cells/drillers/Screwdriver")

local Lacerator = setmetatable({
    name = "lacerator",
    k3 = 281,
    title = "Lacerator",
    description = "A Screwdriver that also drags the cells at its sides along with it.",
    categories = { "movers", "grabbers", "drillers" },
    grabs = true
}, { __index = Screwdriver })
Lacerator.__index = Lacerator

return Lacerator
