local BaseDraggable = require("content/cells/abstract/BaseDraggable")
local SliderTwoDirectional = require("content/cells/pushables/SliderTwoDirectional")

local InputSliderTwoDirectional = setmetatable({
    name = "inputslider_twodirectional",
    k3 = 913,
    title = "Input Two-Directional Slider",
    description = "Two-Directional Slider that can be dragged around with the mouse while the simulation is running.",
    categories = { "input", "pushables" },
    subtick = { "drag" }
}, { __index = SliderTwoDirectional })
InputSliderTwoDirectional.__index = InputSliderTwoDirectional

InputSliderTwoDirectional.click = BaseDraggable.click
InputSliderTwoDirectional.update = BaseDraggable.update

return InputSliderTwoDirectional
