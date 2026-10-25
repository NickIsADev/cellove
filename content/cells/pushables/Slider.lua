local BaseCell = require("content/cells/abstract/BaseCell")

local Slider = setmetatable({
    name = "slider",
    k3 = 5,
    title = "Slider",
    description = "Can only be pushed along its own axis, not sideways.",
    categories = { "pushables" }
}, { __index = BaseCell })
Slider.__index = Slider

function Slider:pushable(dx, dy)
    return self:_alignment(dx, dy) ~= 0
end

return Slider
