local Timewarper = require("content/cells/timewarpers/Timewarper")

local Tetratimewarper = setmetatable({
    name = "tetratimewarper",
    k3 = 617,
    title = "Tetratimewarper",
    description = "Four Timewarpers in one, facing every direction.",
    outputs = { 0, 1, 2, 3 }
}, { __index = Timewarper })
Tetratimewarper.__index = Tetratimewarper

return Tetratimewarper
