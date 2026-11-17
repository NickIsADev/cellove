local BaseForker = require("content/cells/abstract/BaseForker")

local ForkerCCW = setmetatable({
    name = "forker_ccw",
    k3 = 98,
    title = "Forker (CCW)",
    description = "Clones cells entering from behind out the front and the left, turning the one that goes left.",
    forks = { [2] = { -1, 0 } },
    reverse = { [0] = 0, [3] = 1 },
    rotates = true
}, { __index = BaseForker })
ForkerCCW.__index = ForkerCCW

return ForkerCCW
