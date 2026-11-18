local Worm = require("content/cells/worms/Worm")

local TwistWormCCW = setmetatable({
    name = "twistworm_ccw",
    k3 = 1082,
    title = "Twist Worm (CCW)",
    description = "Worm that flips along the diagonal counter-clockwise of its facing when it eats a cell.",
    twist = 1
}, { __index = Worm })
TwistWormCCW.__index = TwistWormCCW

return TwistWormCCW
