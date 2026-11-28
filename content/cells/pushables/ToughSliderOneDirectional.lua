local SliderOneDirectional = require("content/cells/pushables/SliderOneDirectional")

local Wall = require("content/cells/walls/Wall")

local ToughSliderOneDirectional = setmetatable({
    name = "toughslider_onedirectional",
    k3 = 157,
    title = "Tough One-Directional Slider",
    description = "One-Directional Slider that can only be destroyed from behind.",
    mimic = {
        front = Wall,
        left = Wall,
        right = Wall
    }
}, { __index = SliderOneDirectional })
ToughSliderOneDirectional.__index = ToughSliderOneDirectional

return ToughSliderOneDirectional
