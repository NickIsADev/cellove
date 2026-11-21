local Slider = require("content/cells/pushables/Slider")
local BaseBroken = require("content/cells/abstract/BaseBroken")

local BrokenSlider = setmetatable({
    name = "brokenslider",
    k3 = 620,
    title = "Broken Slider",
    description = "Slider that is destroyed when moved."
}, { __index = Slider })
BrokenSlider.__index = BrokenSlider

BrokenSlider.pushed = BaseBroken.pushed

return BrokenSlider
