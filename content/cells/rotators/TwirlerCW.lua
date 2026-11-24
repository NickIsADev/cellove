local BaseTwirler = require("content/cells/abstract/BaseTwirler")

local TwirlerCW = setmetatable({
    name = "twirler_cw",
    k3 = 1126,
    title = "Twirler (CW)",
    description = "When pushed, rotates the cell it pushes into clockwise."
}, { __index = BaseTwirler })
TwirlerCW.__index = TwirlerCW

return TwirlerCW
