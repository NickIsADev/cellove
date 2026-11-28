local SliderTwoDirectional = require("content/cells/pushables/SliderTwoDirectional")

local Wall = require("content/cells/walls/Wall")

local ToughSliderTwoDirectional = setmetatable({
    name = "toughslider_twodirectional",
    k3 = 140,
    title = "Tough Two-Directional Slider",
    description = "Two-Directional Slider that can only be destroyed from behind and its right.",
    mimic = { front = Wall, left = Wall }
}, { __index = SliderTwoDirectional })
ToughSliderTwoDirectional.__index = ToughSliderTwoDirectional

return ToughSliderTwoDirectional
