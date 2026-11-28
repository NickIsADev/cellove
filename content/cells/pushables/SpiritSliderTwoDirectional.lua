local SliderTwoDirectional = require("content/cells/pushables/SliderTwoDirectional")
local BaseSpirit = require("content/cells/abstract/BaseSpirit")

local SpiritSliderTwoDirectional = setmetatable({
    name = "spiritslider_twodirectional",
    k3 = 217,
    title = "Spirit Two-Directional Slider",
    description = "Two-Directional Slider that cannot be generated."
}, { __index = SliderTwoDirectional })
SpiritSliderTwoDirectional.__index = SpiritSliderTwoDirectional

SpiritSliderTwoDirectional.cloneable = BaseSpirit.cloneable

return SpiritSliderTwoDirectional
