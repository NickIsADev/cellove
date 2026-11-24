local BaseTwirler = require("content/cells/abstract/BaseTwirler")

local TwirlerCCW = setmetatable({
    name = "twirler_ccw",
    k3 = 1127,
    title = "Twirler (CCW)",
    description = "When pushed, rotates the cell it pushes into counter-clockwise.",
    spin = -1
}, { __index = BaseTwirler })
TwirlerCCW.__index = TwirlerCCW

return TwirlerCCW
