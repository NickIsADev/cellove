local SpoonerCW = require("content/cells/spooners/SpoonerCW")

local CompounderCW = setmetatable({
    name = "compounder_cw",
    k3 = 192,
    title = "Compounder (CW)",
    description = "CW Spooner that doesn't rotate cells.",
    rotates = false
}, { __index = SpoonerCW })
CompounderCW.__index = CompounderCW

return CompounderCW
