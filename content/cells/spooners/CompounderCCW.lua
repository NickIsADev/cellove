local SpoonerCCW = require("content/cells/spooners/SpoonerCCW")

local CompounderCCW = setmetatable({
    name = "compounder_ccw",
    k3 = 193,
    title = "Compounder (CCW)",
    description = "CCW Spooner that doesn't rotate cells.",
    rotates = false
}, { __index = SpoonerCCW })
CompounderCCW.__index = CompounderCCW

return CompounderCCW
