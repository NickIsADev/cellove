local ParavalveDivergerCW = require("content/cells/divergers/ParavalveDivergerCW")

local ParavalveDisplacerCW = setmetatable({
    name = "paravalvedisplacer_cw",
    k3 = 87,
    title = "Paravalve Displacer (CW)",
    description = "Paravalve Diverger (CW) that doesn't rotate cells.",
    categories = { "displacers" },
    rotates = false
}, { __index = ParavalveDivergerCW })
ParavalveDisplacerCW.__index = ParavalveDisplacerCW

return ParavalveDisplacerCW
