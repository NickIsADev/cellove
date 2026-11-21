local Slider = require("content/cells/pushables/Slider")
local BaseTough = require("content/cells/abstract/BaseTough")

local ToughSlider = setmetatable({
    name = "toughslider",
    k3 = 69,
    title = "Tough Slider",
    description = "Slider that cannot be destroyed from its sides.",
    shields = { left = true, right = true }
}, { __index = Slider })
ToughSlider.__index = ToughSlider

ToughSlider.guarded = BaseTough.guarded

return ToughSlider
