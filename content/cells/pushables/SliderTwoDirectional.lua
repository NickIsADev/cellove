local Slider = require("content/cells/pushables/Slider")

local SliderTwoDirectional = setmetatable({
    name = "slider_twodirectional",
    k3 = 7,
    title = "Two-Directional Slider",
    description = "Can only be pushed from behind and from its right."
}, { __index = Slider })
SliderTwoDirectional.__index = SliderTwoDirectional

function SliderTwoDirectional:pushable(dx, dy)
    return self:_alignment(dx, dy) > 0 or self:_side(dx, dy) < 0
end

return SliderTwoDirectional
