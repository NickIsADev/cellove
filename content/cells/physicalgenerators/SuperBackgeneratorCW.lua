local SuperBackgenerator = require("content/cells/physicalgenerators/SuperBackgenerator")

local SuperBackgeneratorCW = setmetatable({
    name = "superbackgenerator_cw",
    k3 = 777,
    title = "Super Backgenerator (CW)",
    description = "Super Backgenerator that bends cells clockwise.",
    bend = 1
}, { __index = SuperBackgenerator })
SuperBackgeneratorCW.__index = SuperBackgeneratorCW

return SuperBackgeneratorCW
