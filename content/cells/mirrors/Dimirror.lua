local BaseMirror = require("content/cells/abstract/BaseMirror")

local Dimirror = setmetatable({
    name = "dimirror",
    k3 = 490,
    title = "Dimirror",
    description = "Mirror and Diagonal Mirror in one, with the diagonal pointing the other way.",
    swaps = {
        { 0, 2 },
        { 0.5, 2.5 }
    }
}, { __index = BaseMirror })
Dimirror.__index = Dimirror

return Dimirror
