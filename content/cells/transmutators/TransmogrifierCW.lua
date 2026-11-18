local Transmutator = require("content/cells/transmutators/Transmutator")

local TransmogrifierCW = setmetatable({
    name = "transmogrifier_cw",
    k3 = 511,
    title = "Transmogrifier (CW)",
    description = "Transmutator (CW) that does not turn the cell.",
    bend = 1,
    rotates = false
}, { __index = Transmutator })
TransmogrifierCW.__index = TransmogrifierCW

return TransmogrifierCW
