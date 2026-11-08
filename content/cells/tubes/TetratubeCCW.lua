local TetrapipeCCW = require("content/cells/pipes/TetrapipeCCW")

local TetratubeCCW = setmetatable({
    name = "tetratube_ccw",
    title = "Tetratube (CCW)",
    description = "Tetrapipe (CCW) that doesn't rotate cells.",
    categories = { "tubes" },
    rotates = false
}, { __index = TetrapipeCCW })
TetratubeCCW.__index = TetratubeCCW

return TetratubeCCW
