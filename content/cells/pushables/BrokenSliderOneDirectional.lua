local SliderOneDirectional = require("content/cells/pushables/SliderOneDirectional")
local BaseBroken = require("content/cells/abstract/BaseBroken")

local BrokenSliderOneDirectional = setmetatable({
    name = "brokenslider_onedirectional",
    k3 = 621,
    title = "Broken One-Directional Slider",
    description = "One-Directional Slider that is destroyed when moved."
}, { __index = SliderOneDirectional })
BrokenSliderOneDirectional.__index = BrokenSliderOneDirectional

BrokenSliderOneDirectional.pushed = BaseBroken.pushed

return BrokenSliderOneDirectional
