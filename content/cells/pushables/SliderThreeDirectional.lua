local Slider = require("content/cells/pushables/Slider")

local SliderThreeDirectional = setmetatable({
    name = "slider_threedirectional",
    k3 = 8,
    title = "Three-Directional Slider",
    description = "Can only be pushed from behind and from its sides."
}, { __index = Slider })
SliderThreeDirectional.__index = SliderThreeDirectional

function SliderThreeDirectional:pushable(dx, dy)
    return self:_alignment(dx, dy) >= 0
end

return SliderThreeDirectional
