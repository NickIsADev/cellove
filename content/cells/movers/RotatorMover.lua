local Mover = require("content/cells/movers/Mover")
local constants = require("src/constants")

local RotatorMover = setmetatable({
    name = "rotatormover",
    title = "Rotator Mover",
    description = "Rotates the cell in front of it clockwise and the cell behind it counterclockwise, then pushes forward.",
    categories = { "movers", "rotators" },
    subtick = { 1, 4 }
}, { __index = Mover })
RotatorMover.__index = RotatorMover

function RotatorMover:_spin()
    local facing = constants.directions[self.rotation]

    self:rotateNeighbors(1, function(cell)
        return cell.x - self.x == facing[1] and cell.y - self.y == facing[2]
    end)

    self:rotateNeighbors(-1, function(cell)
        return cell.x - self.x == -facing[1] and cell.y - self.y == -facing[2]
    end)
end

function RotatorMover:update(subtick)
    if subtick == 1 then self:_spin() else self:push() end
end

return RotatorMover
