local Bidiverger = require("content/cells/divergers/Bidiverger")

local FlipFlopDiverger = setmetatable({
    name = "flipflopdiverger",
    k3 = 702,
    title = "Flip-Flop Diverger",
    description = "Bidiverger that turns itself a quarter turn whenever a cell passes through, flipping where it sends the next one."
}, { __index = Bidiverger })
FlipFlopDiverger.__index = FlipFlopDiverger

function FlipFlopDiverger:passed(_, dx, dy)
    self:rotate(self:_entry(dx, dy) % 2 == 0 and -1 or 1, true, true)
end

return FlipFlopDiverger
