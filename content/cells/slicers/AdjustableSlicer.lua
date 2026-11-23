local Slicer = require("content/cells/slicers/Slicer")
local BaseAdjustable = require("content/cells/abstract/BaseAdjustable")
local constants = require("src/constants")

local adjustable = constants.adjustable

local AdjustableSlicer = setmetatable({
    name = "adjustableslicer",
    k3 = 356,
    title = "Adjustable Slicer",
    description = "The speed and delay of this Slicer can be changed! (Time is ticks since last movement)",
    properties = {
        adjustable.speed,
        adjustable.delay,
        adjustable.time
    },
    drive = {}
}, { __index = Slicer })
AdjustableSlicer.__index = AdjustableSlicer

AdjustableSlicer.new = BaseAdjustable.new
AdjustableSlicer._round = BaseAdjustable._round
AdjustableSlicer._charge = BaseAdjustable._charge
AdjustableSlicer.pushed = BaseAdjustable.pushed

function AdjustableSlicer:update()
    local first = self:_charge()
    if not first then return end

    for _ = first, self.props.speed - 1 do
        if self.grid:get(self.x, self.y) ~= self or not self:slice() then return end
    end
end

function AdjustableSlicer:draw(renderer, ...)
    Slicer.draw(self, renderer, ...)

    local props = self.props
    renderer:drawLabel(props.speed .. "/" .. props.delay, ...)
end

return AdjustableSlicer
