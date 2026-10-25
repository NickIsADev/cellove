local BaseCell = require("content/cells/abstract/BaseCell")

local Rotator180 = setmetatable({
    name = "rotator_180",
    k3 = 11,
    title = "Rotator (180)",
    description = "Rotates adjacent cells 180 degrees every tick.",
    categories = { "rotators" },
    subtick = { 1 }
}, { __index = BaseCell })
Rotator180.__index = Rotator180

function Rotator180:update()
    self:rotateNeighbors(2)
end

return Rotator180
