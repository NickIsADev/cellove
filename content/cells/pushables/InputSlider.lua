local BaseDraggable = require("content/cells/abstract/BaseDraggable")
local Slider = require("content/cells/pushables/Slider")

local InputSlider = setmetatable({
    name = "inputslider",
    k3 = 911,
    title = "Input Slider",
    description = "Slider that can be dragged around with the mouse while the simulation is running.",
    categories = { "input", "pushables" },
    subtick = { "drag" }
}, { __index = Slider })
InputSlider.__index = InputSlider

InputSlider.click = BaseDraggable.click
InputSlider.update = BaseDraggable.update

return InputSlider
