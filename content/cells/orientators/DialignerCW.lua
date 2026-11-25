local BaseOrientator = require("content/cells/abstract/BaseOrientator")

local DialignerCW = setmetatable({
    name = "cwdialigner",
    k3 = 581,
    title = "Dialigner (CW)",
    description = "Diorientator (CW) that does not turn the cell.",
    outputs = { 0, 1 },
    rear = true,
    rotates = false
}, { __index = BaseOrientator })
DialignerCW.__index = DialignerCW

return DialignerCW
