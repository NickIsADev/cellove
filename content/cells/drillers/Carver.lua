local Chiseler = require("content/cells/drillers/Chiseler")

local Carver = setmetatable({
    name = "carver",
    k3 = 282,
    title = "Carver",
    description = "A Chiseler that also pulls everything behind it.",
    categories = { "pullers", "grabbers", "drillers" },
    pulls = true
}, { __index = Chiseler })
Carver.__index = Carver

return Carver
