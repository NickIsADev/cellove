local Slope = require("content/cells/slopes/Slope")
local constants = require("src/constants")

local AdjustableSlope = setmetatable({
    name = "adjustableslope",
    k3 = 1091,
    title = "Adjustable Slope",
    description = "Slope that shifts cells forward by its run and sideways by its rise.",
    properties = { constants.adjustable.run, constants.adjustable.rise }
}, { __index = Slope })
AdjustableSlope.__index = AdjustableSlope

function AdjustableSlope:measure()
    return self.props.run, self.props.rise
end

function AdjustableSlope:draw(renderer, ...)
    Slope.draw(self, renderer, ...)
    renderer:drawLabel(self.props.run .. ", " .. self.props.rise, ...)
end

return AdjustableSlope
