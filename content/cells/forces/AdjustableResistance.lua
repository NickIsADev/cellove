local Resistance = require("content/cells/forces/Resistance")
local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local AdjustableResistance = setmetatable({
    name = "adjustableresistance",
    k3 = 669,
    title = "Adjustable Resistance",
    description = "Blocks any force that is not equal to its numerator divided by its denominator.",
    properties = { constants.adjustable.numerator, constants.adjustable.denominator }
}, { __index = Resistance })
AdjustableResistance.__index = AdjustableResistance

function AdjustableResistance:_limit()
    return self.props.numerator / self.props.denominator
end

function AdjustableResistance:draw(renderer, ...)
    BaseCell.draw(self, renderer, ...)
    renderer:drawLabel(self.props.numerator .. "/" .. self.props.denominator, ...)
end

return AdjustableResistance
