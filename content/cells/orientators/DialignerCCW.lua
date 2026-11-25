local BaseOrientator = require("content/cells/abstract/BaseOrientator")

local DialignerCCW = setmetatable({
    name = "ccwdialigner",
    k3 = 582,
    title = "Dialigner (CCW)",
    description = "Diorientator (CCW) that does not turn the cell.",
    outputs = { 0, 3 },
    rear = true,
    rotates = false
}, { __index = BaseOrientator })
DialignerCCW.__index = DialignerCCW

return DialignerCCW
