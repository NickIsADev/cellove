local BaseMirror = require("content/cells/abstract/BaseMirror")

local Bimirror = setmetatable({
    name = "bimirror",
    k3 = 489,
    title = "Bimirror",
    description = "Mirror and Diagonal Mirror in one.",
    swaps = {
        { 0, 2 },
        { 1.5, 3.5 }
    }
}, { __index = BaseMirror })
Bimirror.__index = Bimirror

return Bimirror
