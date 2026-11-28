local SliderThreeDirectional = require("content/cells/pushables/SliderThreeDirectional")

local Wall = require("content/cells/walls/Wall")

local ToughSliderThreeDirectional = setmetatable({
    name = "toughslider_threedirectional",
    k3 = 158,
    title = "Tough Three-Directional Slider",
    description = "Three-Directional Slider that cannot be destroyed from its front.",
    mimic = { front = Wall }
}, { __index = SliderThreeDirectional })
ToughSliderThreeDirectional.__index = ToughSliderThreeDirectional

return ToughSliderThreeDirectional
