local Spooner = require("content/cells/spooners/Spooner")

local SpoonerCW = setmetatable({
    name = "spooner_cw",
    k3 = 188,
    title = "Spooner (CW)",
    description = "Spooner that takes a cell from behind and one from the clockwise side.",
    inputs = { [2] = 0, [1] = 1 },
    reverse = { [0] = 0 }
}, { __index = Spooner })
SpoonerCW.__index = SpoonerCW

return SpoonerCW
