local SliderThreeDirectional = require("content/cells/pushables/SliderThreeDirectional")
local BaseTough = require("content/cells/abstract/BaseTough")

local ToughSliderThreeDirectional = setmetatable({
    name = "toughslider_threedirectional",
    k3 = 158,
    title = "Tough Three-Directional Slider",
    description = "Three-Directional Slider that cannot be destroyed from its front.",
    shields = { front = true }
}, { __index = SliderThreeDirectional })
ToughSliderThreeDirectional.__index = ToughSliderThreeDirectional

ToughSliderThreeDirectional.guarded = BaseTough.guarded

return ToughSliderThreeDirectional
