local BaseCell = require("content/cells/abstract/BaseCell")

local RotatorCW = setmetatable({
    name = "rotator_cw",
    k3 = 9,
    title = "Rotator (CW)",
    description = "Rotates adjacent cells clockwise every tick.",
    categories = { "rotators" },
    subtick = { 1 }
}, { __index = BaseCell })
RotatorCW.__index = RotatorCW

function RotatorCW:update()
    self:rotateNeighbors(1)
end

return RotatorCW
