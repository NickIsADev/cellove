local BaseCell = require("content/cells/abstract/BaseCell")

local CelLove = setmetatable({
    name = "cellove",
    title = "CelLove",
    description = "Moves diagonally and bounces off anything in its way.",
    categories = { "misc" },
    subtick = { 35 }
}, { __index = BaseCell })
CelLove.__index = CelLove

function CelLove:new(data)
    local cell = BaseCell.new(self, data)
    local x, y = cell:_aim()
    cell.dx, cell.dy = x + y, y - x

    return cell
end

function CelLove:_free(dx, dy)
    local grid, x, y = self.simulator.grid, self.x + dx, self.y + dy
    return grid:bounds(x, y) and not grid:get(x, y)
end

function CelLove:update()
    local dx, dy = self.dx, self.dy

    if not self:_free(dx, 0) then self.dx = -dx end
    if not self:_free(0, dy) then self.dy = -dy end
    if self.dx == dx and self.dy == dy and not self:_free(dx, dy) then self.dx, self.dy = -dx, -dy end

    self:nudge(self.dx, self.dy)
end

return CelLove
