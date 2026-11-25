local BaseOrientator = require("content/cells/abstract/BaseOrientator")

local DiorientatorCCW = setmetatable({
    name = "ccwdiorientator",
    k3 = 576,
    title = "Diorientator (CCW)",
    description = "Orientator that outputs forward and counter-clockwise from the cell behind it.",
    outputs = { 0, 3 },
    rear = true
}, { __index = BaseOrientator })
DiorientatorCCW.__index = DiorientatorCCW

return DiorientatorCCW
