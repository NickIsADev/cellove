local Slider = require("content/cells/pushables/Slider")

local SliderTwoDirectional = setmetatable({
    name = "slider_twodirectional",
    k3 = 7,
    title = "Two-Directional Slider",
    description = "Can only be pushed from behind and from its right.",
    faces = { 0, 3 }
}, { __index = Slider })
SliderTwoDirectional.__index = SliderTwoDirectional

function SliderTwoDirectional:pushable(dx, dy)
    return self:_along(dx, dy) > 0 or self:_across(dx, dy) < 0
end

return SliderTwoDirectional
