local BaseMirror = require("content/cells/abstract/BaseMirror")

local DiagonalMirror = setmetatable({
    name = "diagonalmirror",
    k3 = 315,
    title = "Diagonal Mirror",
    description = "Mirror that swaps the diagonal neighbors.",
    swaps = { { 1.5, 3.5 } }
}, { __index = BaseMirror })
DiagonalMirror.__index = DiagonalMirror

return DiagonalMirror
