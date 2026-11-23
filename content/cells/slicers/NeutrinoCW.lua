local Neutrino = require("content/cells/slicers/Neutrino")

local NeutrinoCW = setmetatable({
    name = "neutrino_cw",
    k3 = 786,
    title = "Neutrino (CW)",
    description = "A Neutrino that only pushes cells to the right.",
    bend = 1
}, { __index = Neutrino })
NeutrinoCW.__index = NeutrinoCW

return NeutrinoCW
