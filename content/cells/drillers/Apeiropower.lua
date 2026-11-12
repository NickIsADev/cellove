local Lacerator = require("content/cells/drillers/Lacerator")

local Apeiropower = setmetatable({
    name = "apeiropower",
    k3 = 283,
    title = "Apeiropower",
    description = "A Lacerator that also pulls everything behind it.",
    categories = { "movers", "pullers", "grabbers", "drillers" },
    pulls = true
}, { __index = Lacerator })
Apeiropower.__index = Apeiropower

return Apeiropower
