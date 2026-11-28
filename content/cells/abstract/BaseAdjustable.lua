local BaseCell = require("content/cells/abstract/BaseCell")

local BaseAdjustable = setmetatable({}, { __index = BaseCell })
BaseAdjustable.__index = BaseAdjustable

function BaseAdjustable:new(data)
    local cell = BaseCell.new(self, data)

    cell.timer, cell.round = cell.props.time, {}
    return cell
end

function BaseAdjustable:_round()
    local tick = self.grid.simulator.time.tick
    if self.round.tick ~= tick then self.round = { tick = tick, steps = 0 } end

    return self.round
end

function BaseAdjustable:_charge()
    local props, round = self.props, self:_round()

    self.timer = (self.timer + 1) % props.delay
    round.power = 0
    if self.timer ~= 0 then return end

    round.power = props.speed
    return round.steps
end

function BaseAdjustable:pushed(dx, dy)
    if self:_along(dx, dy) <= 0 then return end

    local round = self:_round()
    round.steps = round.steps + 1
end

return BaseAdjustable
