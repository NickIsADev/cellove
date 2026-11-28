local SuperBackgeneratorCCW = require("content/cells/physicalgenerators/SuperBackgeneratorCCW")

local SuperBackclonerCCW = setmetatable({
    name = "superbackcloner_ccw",
    k3 = 780,
    title = "Super Backcloner (CCW)",
    description = "Super Backgenerator (CCW) that does not rotate the generated cells.",
    rotates = false
}, { __index = SuperBackgeneratorCCW })
SuperBackclonerCCW.__index = SuperBackclonerCCW

return SuperBackclonerCCW
