local SliderOneDirectional = require("content/cells/pushables/SliderOneDirectional")
local BaseSuper = require("content/cells/abstract/BaseSuper")

local SuperSliderOneDirectional = setmetatable({
    name = "superslider_onedirectional",
    k3 = 842,
    title = "Super One-Directional Slider",
    description = "One-Directional Slider with infinite health."
}, { __index = SliderOneDirectional })
SuperSliderOneDirectional.__index = SuperSliderOneDirectional

SuperSliderOneDirectional.health = BaseSuper.health
SuperSliderOneDirectional.hit = BaseSuper.hit

return SuperSliderOneDirectional
