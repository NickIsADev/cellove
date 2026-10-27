local BaseCell = require("content/cells/abstract/BaseCell")

local Repulsor = setmetatable({
    name = "repulsor",
    k3 = 21,
    title = "Repulsor",
    description = "Pushes every adjacent cell away from itself every tick.",
    categories = { "forces" },
    subtick = { 4 }
}, { __index = BaseCell })
Repulsor.__index = Repulsor

function Repulsor:update()
    for direction = 0, 3 do
        self:repel(direction)
    end
end

return Repulsor
