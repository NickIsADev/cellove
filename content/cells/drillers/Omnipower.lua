local Borer = require("content/cells/drillers/Borer")

local Omnipower = setmetatable({
    name = "omnipower",
    k3 = 78,
    title = "Omnipower",
    description = "A Borer that also pulls everything behind it.",
    categories = { "movers", "pullers", "grabbers", "drillers" },
    pulls = true
}, { __index = Borer })
Omnipower.__index = Omnipower

return Omnipower
