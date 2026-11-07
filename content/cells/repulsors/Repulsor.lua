local BaseCell = require("content/cells/abstract/BaseCell")

local Repulsor = setmetatable({
    name = "repulsor",
    k3 = 21,
    title = "Repulsor",
    description = "Pushes every adjacent cell away from itself every tick.",
    categories = { "forces", "repulsors" },
    subtick = { 24 },
    directional = true,
    outputs = {  0, 1, 2, 3  }
}, { __index = BaseCell })
Repulsor.__index = Repulsor

function Repulsor:update(_, direction)
    self:repel(direction, nil, self.row)
end

return Repulsor
