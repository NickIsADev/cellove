local BaseOrientator = require("content/cells/abstract/BaseOrientator")

local OrientatorCCW = setmetatable({
    name = "ccworientator",
    k3 = 572,
    title = "Orientator (CCW)",
    description = "Orientator that takes its rotation from the counter-clockwise side and turns the cell counter-clockwise.",
    bend = 3
}, { __index = BaseOrientator })
OrientatorCCW.__index = OrientatorCCW

return OrientatorCCW
