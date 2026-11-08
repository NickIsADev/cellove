local TetrapipeCW = require("content/cells/pipes/TetrapipeCW")

local TetratubeCW = setmetatable({
    name = "tetratube_cw",
    title = "Tetratube (CW)",
    description = "Tetrapipe (CW) that doesn't rotate cells.",
    categories = { "tubes" },
    rotates = false
}, { __index = TetrapipeCW })
TetratubeCW.__index = TetratubeCW

return TetratubeCW
