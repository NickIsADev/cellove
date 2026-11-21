local SliderThreeDirectional = require("content/cells/pushables/SliderThreeDirectional")
local BaseBroken = require("content/cells/abstract/BaseBroken")

local BrokenSliderThreeDirectional = setmetatable({
    name = "brokenslider_threedirectional",
    k3 = 623,
    title = "Broken Three-Directional Slider",
    description = "Three-Directional Slider that is destroyed when moved."
}, { __index = SliderThreeDirectional })
BrokenSliderThreeDirectional.__index = BrokenSliderThreeDirectional

BrokenSliderThreeDirectional.pushed = BaseBroken.pushed

return BrokenSliderThreeDirectional
