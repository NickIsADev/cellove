local Worm = require("content/cells/worms/Worm")

local WormCCW = setmetatable({
    name = "worm_ccw",
    k3 = 1079,
    title = "Worm (CCW)",
    description = "Worm that turns counter-clockwise when it eats a cell.",
    spin = -1
}, { __index = Worm })
WormCCW.__index = WormCCW

return WormCCW
