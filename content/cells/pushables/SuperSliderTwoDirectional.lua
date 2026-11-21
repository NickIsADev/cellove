local SliderTwoDirectional = require("content/cells/pushables/SliderTwoDirectional")
local BaseSuper = require("content/cells/abstract/BaseSuper")

local SuperSliderTwoDirectional = setmetatable({
    name = "superslider_twodirectional",
    k3 = 843,
    title = "Super Two-Directional Slider",
    description = "Two-Directional Slider with infinite health."
}, { __index = SliderTwoDirectional })
SuperSliderTwoDirectional.__index = SuperSliderTwoDirectional

SuperSliderTwoDirectional.health = BaseSuper.health
SuperSliderTwoDirectional.hit = BaseSuper.hit

return SuperSliderTwoDirectional
