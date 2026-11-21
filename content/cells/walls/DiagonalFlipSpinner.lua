local FlipSpinner = require("content/cells/walls/FlipSpinner")

local DiagonalFlipSpinner = setmetatable({
    name = "diagonalflipspinner",
    k3 = 710,
    title = "Diagonal Flip Spinner",
    description = "Cannot be pushed, rotated, or destroyed. Flips any cell that tries to push it across the diagonal axis it is facing.",
    axis = "diagonal"
}, { __index = FlipSpinner })
DiagonalFlipSpinner.__index = DiagonalFlipSpinner

return DiagonalFlipSpinner
