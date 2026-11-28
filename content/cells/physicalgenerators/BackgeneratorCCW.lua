local Backgenerator = require("content/cells/physicalgenerators/Backgenerator")

local BackgeneratorCCW = setmetatable({
    name = "backgenerator_ccw",
    k3 = 758,
    title = "Backgenerator (CCW)",
    description = "Backgenerator that bends cells counter-clockwise.",
    bend = -1
}, { __index = Backgenerator })
BackgeneratorCCW.__index = BackgeneratorCCW

return BackgeneratorCCW
