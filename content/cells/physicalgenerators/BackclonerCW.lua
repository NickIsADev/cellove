local BackgeneratorCW = require("content/cells/physicalgenerators/BackgeneratorCW")

local BackclonerCW = setmetatable({
    name = "backcloner_cw",
    k3 = 759,
    title = "Backcloner (CW)",
    description = "Backgenerator (CW) that does not rotate the generated cells.",
    rotates = false
}, { __index = BackgeneratorCW })
BackclonerCW.__index = BackclonerCW

return BackclonerCW
