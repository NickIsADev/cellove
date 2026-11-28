local SuperBackgeneratorCW = require("content/cells/physicalgenerators/SuperBackgeneratorCW")

local SuperBackclonerCW = setmetatable({
    name = "superbackcloner_cw",
    k3 = 779,
    title = "Super Backcloner (CW)",
    description = "Super Backgenerator (CW) that does not rotate the generated cells.",
    rotates = false
}, { __index = SuperBackgeneratorCW })
SuperBackclonerCW.__index = SuperBackclonerCW

return SuperBackclonerCW
