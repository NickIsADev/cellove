local Slider = require("content/cells/pushables/Slider")
local BaseSuper = require("content/cells/abstract/BaseSuper")

local SuperSlider = setmetatable({
    name = "superslider",
    k3 = 841,
    title = "Super Slider",
    description = "Slider with infinite health."
}, { __index = Slider })
SuperSlider.__index = SuperSlider

SuperSlider.health = BaseSuper.health
SuperSlider.hit = BaseSuper.hit

return SuperSlider
