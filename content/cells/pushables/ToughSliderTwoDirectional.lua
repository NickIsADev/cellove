local SliderTwoDirectional = require("content/cells/pushables/SliderTwoDirectional")
local BaseTough = require("content/cells/abstract/BaseTough")

local ToughSliderTwoDirectional = setmetatable({
    name = "toughslider_twodirectional",
    k3 = 140,
    title = "Tough Two-Directional Slider",
    description = "Two-Directional Slider that can only be destroyed from behind and its right.",
    shields = { front = true, left = true }
}, { __index = SliderTwoDirectional })
ToughSliderTwoDirectional.__index = ToughSliderTwoDirectional

ToughSliderTwoDirectional.guarded = BaseTough.guarded

return ToughSliderTwoDirectional
