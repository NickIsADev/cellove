local BaseCell = require("content/cells/abstract/BaseCell")

local RotatorRNG = setmetatable({
    name = "rotator_rng",
    k3 = 960,
    title = "Rotator (RNG)",
    description = "Rotates adjacent cells in a random direction every tick.",
    categories = { "rotators" },
    subtick = { 1 }
}, { __index = BaseCell })
RotatorRNG.__index = RotatorRNG

function RotatorRNG:update()
    local direction = math.random(1, 2) == 1 and -1 or 1
    self:rotateNeighbors(direction)
end

return RotatorRNG
