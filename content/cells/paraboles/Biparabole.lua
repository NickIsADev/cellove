local Parabole = require("content/cells/paraboles/Parabole")

local Biparabole = setmetatable({
    name = "biparabole",
    k3 = 385,
    title = "Biparabole",
    description = "Two Paraboles in one, pointing opposite ways.",
    faces = { 0, 1 },
    routes = { [0] = -1, [1] = 1, [2] = -1, [3] = 1 }
}, { __index = Parabole })
Biparabole.__index = Biparabole

return Biparabole
