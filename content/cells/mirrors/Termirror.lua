local BaseMirror = require("content/cells/abstract/BaseMirror")

local Termirror = setmetatable({
    name = "termirror",
    k3 = 492,
    title = "Termirror",
    description = "Two Mirrors and a Diagonal Mirror in one.",
    swaps = {
        { 0, 2 },
        { 1, 3 },
        { 1.5, 3.5 }
    }
}, { __index = BaseMirror })
Termirror.__index = Termirror

return Termirror
