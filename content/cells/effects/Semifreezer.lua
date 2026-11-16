local BaseFreezer = require("content/cells/abstract/BaseFreezer")

local Semifreezer = setmetatable({
    name = "semifreezer",
    k3 = 287,
    title = "Semifreezer",
    description = "Freezes the cells in front of and behind it, stopping them from updating.",
    faces = { 0, 2 },
    outputs = { 0, 2 }
}, { __index = BaseFreezer })
Semifreezer.__index = Semifreezer

return Semifreezer
