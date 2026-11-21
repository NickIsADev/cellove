local Weight = require("content/cells/forces/Weight")
local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local AdjustableWeight = setmetatable({
    name = "adjustableweight",
    k3 = 668,
    title = "Adjustable Weight",
    description = "Absorbs its numerator divided by its denominator units of force from anything pushing or pulling it.",
    properties = { constants.adjustable.numerator, constants.adjustable.denominator }
}, { __index = Weight })
AdjustableWeight.__index = AdjustableWeight

function AdjustableWeight:force()
    return -self.props.numerator / self.props.denominator
end

function AdjustableWeight:draw(renderer, ...)
    BaseCell.draw(self, renderer, ...)
    renderer:drawLabel(self.props.numerator .. "/" .. self.props.denominator, ...)
end

return AdjustableWeight
