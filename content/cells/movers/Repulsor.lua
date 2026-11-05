local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local Repulsor = setmetatable({
    name = "repulsor",
    k3 = 21,
    title = "Repulsor",
    description = "Pushes every adjacent cell away from itself every tick.",
    categories = { "movers" },
    subtick = { 18 },
    outputs = { 0, 1, 2, 3 },
    directional = true
}, { __index = BaseCell })
Repulsor.__index = Repulsor

function Repulsor:force()
    return constants.force.weight
end

function Repulsor:update(_, direction)
    self:repel(direction)
end

return Repulsor
