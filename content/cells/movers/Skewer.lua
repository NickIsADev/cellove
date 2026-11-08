local Thruster = require("content/cells/movers/Thruster")

local Skewer = setmetatable({
    name = "skewer",
    k3 = "bmplus skewer",
    title = "Skewer",
    description = "Moves forward into empty space, dragging the cells at its front and back diagonals along with it. Cannot push or pull."
}, { __index = Thruster })
Skewer.__index = Skewer

function Skewer:update()
    local movement = self.simulator.movement
    local x, y, dx, dy = self.x, self.y, self:_aim()

    if self:grab() then
        movement:flank(x, y, dx, dy, -1)
    else
        movement:grab(x, y, dx, dy, -1)
    end
end

return Skewer
