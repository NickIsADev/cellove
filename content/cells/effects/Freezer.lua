local BaseFreezer = require("content/cells/abstract/BaseFreezer")

local Freezer = setmetatable({
    name = "freezer",
    k3 = 25,
    title = "Freezer",
    description = "Freezes adjacent cells, stopping them from updating."
}, { __index = BaseFreezer })
Freezer.__index = Freezer

return Freezer
