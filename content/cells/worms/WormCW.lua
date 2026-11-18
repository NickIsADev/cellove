local Worm = require("content/cells/worms/Worm")

local WormCW = setmetatable({
    name = "worm_cw",
    k3 = 1078,
    title = "Worm (CW)",
    description = "Worm that turns clockwise when it eats a cell.",
    spin = 1
}, { __index = Worm })
WormCW.__index = WormCW

return WormCW
