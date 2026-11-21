local SliderThreeDirectional = require("content/cells/pushables/SliderThreeDirectional")
local BaseSuper = require("content/cells/abstract/BaseSuper")

local SuperSliderThreeDirectional = setmetatable({
    name = "superslider_threedirectional",
    k3 = 844,
    title = "Super Three-Directional Slider",
    description = "Three-Directional Slider with infinite health."
}, { __index = SliderThreeDirectional })
SuperSliderThreeDirectional.__index = SuperSliderThreeDirectional

SuperSliderThreeDirectional.health = BaseSuper.health
SuperSliderThreeDirectional.hit = BaseSuper.hit

return SuperSliderThreeDirectional
