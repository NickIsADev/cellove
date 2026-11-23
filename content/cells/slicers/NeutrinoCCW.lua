local Neutrino = require("content/cells/slicers/Neutrino")

local NeutrinoCCW = setmetatable({
    name = "neutrino_ccw",
    k3 = 787,
    title = "Neutrino (CCW)",
    description = "A Neutrino that only pushes cells to the left.",
    bend = -1
}, { __index = Neutrino })
NeutrinoCCW.__index = NeutrinoCCW

return NeutrinoCCW
