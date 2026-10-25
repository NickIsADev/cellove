local ParavalveDivergerCCW = require("content/cells/divergers/ParavalveDivergerCCW")

local ParavalveDisplacerCCW = setmetatable({
    name = "paravalvedisplacer_ccw",
    k3 = 88,
    title = "Paravalve Displacer (CCW)",
    description = "Paravalve Diverger (CCW) that doesn't rotate cells.",
    categories = { "displacers" },
    rotates = false
}, { __index = ParavalveDivergerCCW })
ParavalveDisplacerCCW.__index = ParavalveDisplacerCCW

return ParavalveDisplacerCCW
