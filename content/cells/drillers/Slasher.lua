local Screwdriver = require("content/cells/drillers/Screwdriver")

local Slasher = setmetatable({
    name = "slasher",
    k3 = 279,
    title = "Slasher",
    description = "A Screwdriver that also pulls everything behind it.",
    categories = { "movers", "pullers", "drillers" },
    pulls = true
}, { __index = Screwdriver })
Slasher.__index = Slasher

return Slasher
