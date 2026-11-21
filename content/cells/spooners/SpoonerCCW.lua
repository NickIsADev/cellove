local Spooner = require("content/cells/spooners/Spooner")

local SpoonerCCW = setmetatable({
    name = "spooner_ccw",
    k3 = 189,
    title = "Spooner (CCW)",
    description = "Spooner that takes a cell from behind and one from the counter-clockwise side.",
    inputs = { [3] = -1, [2] = 0 },
    reverse = { [0] = 0 }
}, { __index = Spooner })
SpoonerCCW.__index = SpoonerCCW

return SpoonerCCW
