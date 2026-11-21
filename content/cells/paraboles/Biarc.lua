local Arc = require("content/cells/paraboles/Arc")

local Biarc = setmetatable({
    name = "biarc",
    k3 = 387,
    title = "Biarc",
    description = "Biparabole that doesn't turn itself.",
    faces = { 0, 1 },
    routes = { [0] = -1, [1] = 1, [2] = -1, [3] = 1 }
}, { __index = Arc })
Biarc.__index = Biarc

return Biarc
