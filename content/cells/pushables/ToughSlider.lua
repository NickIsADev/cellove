local Slider = require("content/cells/pushables/Slider")

local Wall = require("content/cells/walls/Wall")

local ToughSlider = setmetatable({
    name = "toughslider",
    k3 = 69,
    title = "Tough Slider",
    description = "Slider that cannot be destroyed from its sides.",
    mimic = { left = Wall, right = Wall }
}, { __index = Slider })
ToughSlider.__index = ToughSlider

return ToughSlider
