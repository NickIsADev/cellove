local SliderTwoDirectional = require("content/cells/pushables/SliderTwoDirectional")
local BaseBroken = require("content/cells/abstract/BaseBroken")

local BrokenSliderTwoDirectional = setmetatable({
    name = "brokenslider_twodirectional",
    k3 = 622,
    title = "Broken Two-Directional Slider",
    description = "Two-Directional Slider that is destroyed when moved."
}, { __index = SliderTwoDirectional })
BrokenSliderTwoDirectional.__index = BrokenSliderTwoDirectional

BrokenSliderTwoDirectional.pushed = BaseBroken.pushed

return BrokenSliderTwoDirectional
