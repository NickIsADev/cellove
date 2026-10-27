local BaseMirror = require("content/cells/abstract/BaseMirror")

local Trimirror = setmetatable({
    name = "trimirror",
    k3 = 491,
    title = "Trimirror",
    description = "Mirror and two Diagonal Mirrors in one.",
    swaps = {
        { 0, 2 },
        { 0.5, 2.5 },
        { 1.5, 3.5 }
    }
}, { __index = BaseMirror })
Trimirror.__index = Trimirror

return Trimirror
