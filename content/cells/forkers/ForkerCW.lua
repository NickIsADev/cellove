local BaseForker = require("content/cells/abstract/BaseForker")

local ForkerCW = setmetatable({
    name = "forker_cw",
    k3 = 97,
    title = "Forker (CW)",
    description = "Clones cells entering from behind out the front and the right, turning the one that goes right.",
    forks = { [2] = { 1, 0 } },
    reverse = { [0] = 0, [1] = -1 },
    rotates = true
}, { __index = BaseForker })
ForkerCW.__index = ForkerCW

return ForkerCW
