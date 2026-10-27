local BaseCell = require("content/cells/abstract/BaseCell")

local BaseGate = setmetatable({
    categories = { "gates" },
    subtick = { 6 },
    directional = true,
    rear = true
}, { __index = BaseCell })

function BaseGate:new(data)
    local cell = BaseCell.new(self, data)
    cell.fed = {}

    return cell
end

function BaseGate:eats(dx, dy)
    return self:_side(dx, dy) ~= 0
end

function BaseGate:pushable(dx, dy)
    return false
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
