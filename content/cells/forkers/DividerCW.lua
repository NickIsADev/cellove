local BaseForker = require("content/cells/abstract/BaseForker")

local DividerCW = setmetatable({
    name = "divider_cw",
    k3 = 101,
    title = "Divider (CW)",
    description = "Clones cells entering from behind out the front and the right without turning them.",
    forks = { [2] = { 1, 0 } },
    reverse = { [0] = 0, [1] = -1 }
}, { __index = BaseForker })
DividerCW.__index = DividerCW

return DividerCW
