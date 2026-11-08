local BaseCell = require("content/cells/abstract/BaseCell")

local BaseGate = setmetatable({
    categories = { "gates" },
    subtick = { 33 },
    directional = true,
    rear = true
}, { __index = BaseCell })

function BaseGate:new(data)
    local cell = BaseCell.new(self, data)
    cell.fed = {}

    return cell
end

function BaseGate:eats(dx, dy)
    return (dx == 0 or dy == 0) and self:_side(dx, dy) ~= 0
end

function BaseGate:swapped(dx, dy)
    if self:eats(dx, dy) then self:absorb(self, dx, dy) end
end

function BaseGate:pushable(dx, dy, bare)
    return bare
end

function BaseGate:absorb(cell, dx, dy)
    local side = self:_side(dx, dy) > 0 and "left" or "right"
    self.fed[side] = self.simulator:position()
end

function BaseGate:update()
    local tick = self.simulator:position()
    if self:condition(self.fed.left == tick, self.fed.right == tick) then
        self:generate()
    end
end

return BaseGate
