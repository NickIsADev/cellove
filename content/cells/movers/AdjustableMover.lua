local Mover = require("content/cells/movers/Mover")
local BaseAdjustable = require("content/cells/abstract/BaseAdjustable")
local constants = require("src/constants")

local adjustable = constants.adjustable

local AdjustableMover = setmetatable({
    name = "adjustablemover",
    k3 = 352,
    title = "Adjustable Mover",
    description = "The speed, delay, and maximum moved cells of this Mover can be changed! (Time is ticks since last movement)",
    properties = {
        adjustable.speed,
        adjustable.delay,
        adjustable.time,
        adjustable.maximum
    },
    drive = {}
}, { __index = Mover })
AdjustableMover.__index = AdjustableMover

AdjustableMover.new = BaseAdjustable.new
AdjustableMover._round = BaseAdjustable._round
AdjustableMover._charge = BaseAdjustable._charge

function AdjustableMover:_power()
    return self:_round().power or (self.timer == self.props.delay - 1 and self.props.speed or 0)
end

function AdjustableMover:force(dx, dy, action)
    if action ~= "push" then return 0 end
    return self:_along(dx, dy) * self:_power()
end

function AdjustableMover:pushed(dx, dy, action)
    if action == "push" and self:_power() == 0 then return end
    BaseAdjustable.pushed(self, dx, dy)
end

function AdjustableMover:update()
    local first = self:_charge()
    if not first then return end

    local props = self.props
    local limit = props.maximum > 0 and props.maximum or nil

    for step = first, props.speed - 1 do
        if self.grid:get(self.x, self.y) ~= self or not self:push(nil, nil, { force = -step, limit = limit }) then return end
    end
end

function AdjustableMover:draw(renderer, ...)
    Mover.draw(self, renderer, ...)

    local props = self.props
    renderer:drawLabel(props.speed .. "/" .. props.delay .. (props.maximum > 0 and " M" .. props.maximum or ""), ...)
end

return AdjustableMover
