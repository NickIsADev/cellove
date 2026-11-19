local BaseDraggable = require("content/cells/abstract/BaseDraggable")
local SliderOneDirectional = require("content/cells/pushables/SliderOneDirectional")

local InputSliderOneDirectional = setmetatable({
    name = "inputslider_onedirectional",
    k3 = 912,
    title = "Input One-Directional Slider",
    description = "One-Directional Slider that can be dragged around with the mouse while the simulation is running.",
    categories = { "input", "pushables" },
    subtick = { "drag" }
}, { __index = SliderOneDirectional })
InputSliderOneDirectional.__index = InputSliderOneDirectional

InputSliderOneDirectional.click = BaseDraggable.click
InputSliderOneDirectional.update = BaseDraggable.update

return InputSliderOneDirectional
