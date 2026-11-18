local Worm = require("content/cells/worms/Worm")

local TwistWormCW = setmetatable({
    name = "twistworm_cw",
    k3 = 1081,
    title = "Twist Worm (CW)",
    description = "Worm that flips along the diagonal clockwise of its facing when it eats a cell.",
    twist = -1
}, { __index = Worm })
TwistWormCW.__index = TwistWormCW

return TwistWormCW
