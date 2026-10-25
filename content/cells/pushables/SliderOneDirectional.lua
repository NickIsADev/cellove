local Slider = require("content/cells/pushables/Slider")

local SliderOneDirectional = setmetatable({
    name = "slider_onedirectional",
    k3 = 6,
    title = "One-Directional Slider",
    description = "Can only be pushed from behind."
}, { __index = Slider })
SliderOneDirectional.__index = SliderOneDirectional

function SliderOneDirectional:pushable(dx, dy)
    return self:_alignment(dx, dy) > 0
end

return SliderOneDirectional
