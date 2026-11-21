local SliderThreeDirectional = require("content/cells/pushables/SliderThreeDirectional")
local BaseSpirit = require("content/cells/abstract/BaseSpirit")

local SpiritSliderThreeDirectional = setmetatable({
    name = "spiritslider_threedirectional",
    k3 = 218,
    title = "Spirit Three-Directional Slider",
    description = "Three-Directional Slider that cannot be generated."
}, { __index = SliderThreeDirectional })
SpiritSliderThreeDirectional.__index = SpiritSliderThreeDirectional

SpiritSliderThreeDirectional.generatable = BaseSpirit.generatable

return SpiritSliderThreeDirectional
