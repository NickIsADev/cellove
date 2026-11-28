local SliderOneDirectional = require("content/cells/pushables/SliderOneDirectional")
local BaseSpirit = require("content/cells/abstract/BaseSpirit")

local SpiritSliderOneDirectional = setmetatable({
    name = "spiritslider_onedirectional",
    k3 = 216,
    title = "Spirit One-Directional Slider",
    description = "One-Directional Slider that cannot be generated."
}, { __index = SliderOneDirectional })
SpiritSliderOneDirectional.__index = SpiritSliderOneDirectional

SpiritSliderOneDirectional.cloneable = BaseSpirit.cloneable

return SpiritSliderOneDirectional
