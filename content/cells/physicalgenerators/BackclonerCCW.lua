local BackgeneratorCCW = require("content/cells/physicalgenerators/BackgeneratorCCW")

local BackclonerCCW = setmetatable({
    name = "backcloner_ccw",
    k3 = 760,
    title = "Backcloner (CCW)",
    description = "Backgenerator (CCW) that does not rotate the generated cells.",
    rotates = false
}, { __index = BackgeneratorCCW })
BackclonerCCW.__index = BackclonerCCW

return BackclonerCCW
