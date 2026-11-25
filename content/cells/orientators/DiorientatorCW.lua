local BaseOrientator = require("content/cells/abstract/BaseOrientator")

local DiorientatorCW = setmetatable({
    name = "cwdiorientator",
    k3 = 575,
    title = "Diorientator (CW)",
    description = "Orientator that outputs forward and clockwise from the cell behind it.",
    outputs = { 0, 1 },
    rear = true
}, { __index = BaseOrientator })
DiorientatorCW.__index = DiorientatorCW

return DiorientatorCW
