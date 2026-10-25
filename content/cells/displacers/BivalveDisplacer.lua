local BivalveDiverger = require("content/cells/divergers/BivalveDiverger")

local BivalveDisplacer = setmetatable({
    name = "bivalvedisplacer",
    k3 = 86,
    title = "Bivalve Displacer",
    description = "Bivalve Diverger that doesn't rotate cells.",
    categories = { "displacers" },
    rotates = false
}, { __index = BivalveDiverger })
BivalveDisplacer.__index = BivalveDisplacer

return BivalveDisplacer
