local SliderOneDirectional = require("content/cells/pushables/SliderOneDirectional")
local BaseTough = require("content/cells/abstract/BaseTough")

local ToughSliderOneDirectional = setmetatable({
    name = "toughslider_onedirectional",
    k3 = 157,
    title = "Tough One-Directional Slider",
    description = "One-Directional Slider that can only be destroyed from behind.",
    shields = {
        front = true,
        left = true,
        right = true
    }
}, { __index = SliderOneDirectional })
ToughSliderOneDirectional.__index = ToughSliderOneDirectional

ToughSliderOneDirectional.guarded = BaseTough.guarded

return ToughSliderOneDirectional
