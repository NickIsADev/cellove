local BaseOrientator = require("content/cells/abstract/BaseOrientator")

local AlignerCW = setmetatable({
    name = "cwaligner",
    k3 = 577,
    title = "Aligner (CW)",
    description = "Orientator (CW) that does not turn the cell.",
    bend = 1,
    rotates = false
}, { __index = BaseOrientator })
AlignerCW.__index = AlignerCW

return AlignerCW
