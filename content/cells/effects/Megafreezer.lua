local BaseFreezer = require("content/cells/abstract/BaseFreezer")

local Megafreezer = setmetatable({
    name = "megafreezer",
    k3 = 286,
    title = "Megafreezer",
    description = "Freezes surrounding cells, stopping them from updating.",
    sides = { orthogonal = true, diagonal = true }
}, { __index = BaseFreezer })
Megafreezer.__index = Megafreezer

return Megafreezer
