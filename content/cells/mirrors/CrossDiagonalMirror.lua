local BaseMirror = require("content/cells/abstract/BaseMirror")

local CrossDiagonalMirror = setmetatable({
    name = "crossdiagonalmirror",
    k3 = 316,
    title = "Cross Diagonal Mirror",
    description = "Two Diagonal Mirrors in one.",
    swaps = {
        { 0.5, 2.5 },
        { 1.5, 3.5 }
    }
}, { __index = BaseMirror })
CrossDiagonalMirror.__index = CrossDiagonalMirror

return CrossDiagonalMirror
