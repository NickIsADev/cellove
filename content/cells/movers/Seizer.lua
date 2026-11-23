local Mover = require("content/cells/movers/Mover")
local constants = require("src/constants")

local Seizer = setmetatable({
    name = "seizer",
    k3 = 781,
    title = "Seizer",
    description = "Takes cells from its sides and puts them in front of itself, then pushes forward."
}, { __index = Mover })
Seizer.__index = Seizer

function Seizer:update()
    local front = self:look(self.rotation)
    if front then
        local x, y, dx, dy = front.x, front.y, front.dx, front.dy
        local sx, sy = dy ~= 0 and 1 or 0, dx ~= 0 and -1 or 0

        for _, side in ipairs({ 1, -1 }) do
            self.simulator.movement:pull(x + sx * side, y + sy * side, -sx * side, -sy * side, constants.force.strength)
        end
    end
    self:push()
end

return Seizer
