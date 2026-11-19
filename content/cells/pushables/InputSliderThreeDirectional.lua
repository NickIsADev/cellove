local BaseDraggable = require("content/cells/abstract/BaseDraggable")
local SliderThreeDirectional = require("content/cells/pushables/SliderThreeDirectional")

local InputSliderThreeDirectional = setmetatable({
    name = "inputslider_threedirectional",
    k3 = 914,
    title = "Input Three-Directional Slider",
    description = "Three-Directional Slider that can be dragged around with the mouse while the simulation is running.",
    categories = { "input", "pushables" },
    subtick = { "drag" }
}, { __index = SliderThreeDirectional })
InputSliderThreeDirectional.__index = InputSliderThreeDirectional

InputSliderThreeDirectional.click = BaseDraggable.click
InputSliderThreeDirectional.update = BaseDraggable.update

return InputSliderThreeDirectional
