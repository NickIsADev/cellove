local Slope = require("content/cells/slopes/Slope")

local Stair = setmetatable({
    name = "stair",
    k3 = 390,
    title = "Stair",
    description = "Slope that also moves cells back a step, so it shifts them more slowly.",
    run = -1
}, { __index = Slope })
Stair.__index = Stair

return Stair
