local BaseTwirler = require("content/cells/abstract/BaseTwirler")

local Twirler180 = setmetatable({
    name = "twirler_180",
    k3 = 1128,
    title = "Twirler (180)",
    description = "When pushed, rotates the cell it pushes into 180 degrees.",
    spin = 2
}, { __index = BaseTwirler })
Twirler180.__index = Twirler180

return Twirler180
