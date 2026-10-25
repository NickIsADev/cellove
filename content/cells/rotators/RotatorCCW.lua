local BaseCell = require("content/cells/abstract/BaseCell")

local RotatorCCW = setmetatable({
    name = "rotator_ccw",
    k3 = 10,
    title = "Rotator (CCW)",
    description = "Rotates adjacent cells counter-clockwise every tick.",
    categories = { "rotators" },
    subtick = { 1 }
}, { __index = BaseCell })
RotatorCCW.__index = RotatorCCW

function RotatorCCW:update()
    self:rotateNeighbors(-1)
end

return RotatorCCW
