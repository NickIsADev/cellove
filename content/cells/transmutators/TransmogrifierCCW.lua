local Transmutator = require("content/cells/transmutators/Transmutator")

local TransmogrifierCCW = setmetatable({
    name = "transmogrifier_ccw",
    k3 = 512,
    title = "Transmogrifier (CCW)",
    description = "Transmutator (CCW) that does not turn the cell.",
    bend = -1,
    rotates = false
}, { __index = Transmutator })
TransmogrifierCCW.__index = TransmogrifierCCW

return TransmogrifierCCW
