local BaseOrientator = require("content/cells/abstract/BaseOrientator")

local AlignerCCW = setmetatable({
    name = "ccwaligner",
    k3 = 578,
    title = "Aligner (CCW)",
    description = "Orientator (CCW) that does not turn the cell.",
    bend = 3,
    rotates = false
}, { __index = BaseOrientator })
AlignerCCW.__index = AlignerCCW

return AlignerCCW
