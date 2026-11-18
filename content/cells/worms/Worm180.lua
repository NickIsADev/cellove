local Worm = require("content/cells/worms/Worm")

local Worm180 = setmetatable({
    name = "worm_180",
    k3 = 1080,
    title = "Worm (180)",
    description = "Worm that turns 180 degrees when it eats a cell.",
    spin = 2
}, { __index = Worm })
Worm180.__index = Worm180

return Worm180
