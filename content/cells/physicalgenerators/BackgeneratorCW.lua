local Backgenerator = require("content/cells/physicalgenerators/Backgenerator")

local BackgeneratorCW = setmetatable({
    name = "backgenerator_cw",
    k3 = 757,
    title = "Backgenerator (CW)",
    description = "Backgenerator that bends cells clockwise.",
    bend = 1
}, { __index = Backgenerator })
BackgeneratorCW.__index = BackgeneratorCW

return BackgeneratorCW
