local Slope = require("content/cells/slopes/Slope")

local Slant = setmetatable({
    name = "slant",
    k3 = 1017,
    title = "Slant",
    description = "Slope that also moves cells forward a step, the opposite of a Stair.",
    run = 1
}, { __index = Slope })
Slant.__index = Slant

return Slant
