local BaseForker = require("content/cells/abstract/BaseForker")

local DividerCCW = setmetatable({
    name = "divider_ccw",
    k3 = 102,
    title = "Divider (CCW)",
    description = "Clones cells entering from behind out the front and the left without turning them.",
    forks = { [2] = { -1, 0 } },
    reverse = { [0] = 0, [3] = 1 }
}, { __index = BaseForker })
DividerCCW.__index = DividerCCW

return DividerCCW
