local BaseDraggable = require("content/cells/abstract/BaseDraggable")
local Pushable = require("content/cells/pushables/Pushable")

local InputPushable = setmetatable({
    name = "inputpushable",
    k3 = 910,
    title = "Input Pushable",
    description = "Pushable that can be dragged around with the mouse while the simulation is running.",
    categories = { "input", "pushables" },
    subtick = { "drag" }
}, { __index = Pushable })
InputPushable.__index = InputPushable

InputPushable.click = BaseDraggable.click
InputPushable.update = BaseDraggable.update

return InputPushable
