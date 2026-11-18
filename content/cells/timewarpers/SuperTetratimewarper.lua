local SuperTimewarper = require("content/cells/timewarpers/SuperTimewarper")

local SuperTetratimewarper = setmetatable({
    name = "supertetratimewarper",
    k3 = 837,
    title = "Super Tetratimewarper",
    description = "Four Super Timewarpers in one, facing every direction.",
    outputs = { 0, 1, 2, 3 }
}, { __index = SuperTimewarper })
SuperTetratimewarper.__index = SuperTetratimewarper

return SuperTetratimewarper
