local SuperBackgenerator = require("content/cells/physicalgenerators/SuperBackgenerator")

local SuperBackgeneratorCCW = setmetatable({
    name = "superbackgenerator_ccw",
    k3 = 778,
    title = "Super Backgenerator (CCW)",
    description = "Super Backgenerator that bends cells counter-clockwise.",
    bend = -1
}, { __index = SuperBackgenerator })
SuperBackgeneratorCCW.__index = SuperBackgeneratorCCW

return SuperBackgeneratorCCW
