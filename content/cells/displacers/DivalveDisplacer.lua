local DivalveDiverger = require("content/cells/divergers/DivalveDiverger")

local DivalveDisplacer = setmetatable({
    name = "divalvedisplacer",
    k3 = 434,
    title = "Divalve Displacer",
    description = "Divalve Diverger that doesn't rotate cells.",
    categories = { "displacers" },
    rotates = false
}, { __index = DivalveDiverger })
DivalveDisplacer.__index = DivalveDisplacer

return DivalveDisplacer
