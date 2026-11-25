local BaseOrientator = require("content/cells/abstract/BaseOrientator")

local OrientatorCW = setmetatable({
    name = "cworientator",
    k3 = 571,
    title = "Orientator (CW)",
    description = "Orientator that takes its rotation from the clockwise side and turns the cell clockwise.",
    bend = 1
}, { __index = BaseOrientator })
OrientatorCW.__index = OrientatorCW

return OrientatorCW
