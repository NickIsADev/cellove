local Slider = require("content/cells/pushables/Slider")
local BaseSpirit = require("content/cells/abstract/BaseSpirit")

local SpiritSlider = setmetatable({
    name = "spiritslider",
    k3 = 215,
    title = "Spirit Slider",
    description = "Slider that cannot be generated."
}, { __index = Slider })
SpiritSlider.__index = SpiritSlider

SpiritSlider.generatable = BaseSpirit.generatable

return SpiritSlider
