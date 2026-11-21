local BaseCell = require("content/cells/abstract/BaseCell")

local BaseCoil = setmetatable({
    categories = { "weights" },
    faces = {}
}, { __index = BaseCell })
BaseCoil.__index = BaseCoil

function BaseCoil:_label()
    return self.props.count
end

function BaseCoil:resist(force)
    local tick = self.grid.simulator.time.tick
    local fresh = self.stamp ~= tick

    if fresh then
        self.props.count = math.max(self.props.count - (tick - (self.stamp or tick)), 0)
        self.stamp = tick
    end
    return self:_open(self.props.amount or force, fresh) and force or 0
end

function BaseCoil:draw(renderer, ...)
    BaseCell.draw(self, renderer, ...)
    renderer:drawLabel(self:_label(), ...)
end

return BaseCoil
