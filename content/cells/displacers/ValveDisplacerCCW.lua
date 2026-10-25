local ValveDivergerCCW = require("content/cells/divergers/ValveDivergerCCW")

local ValveDisplacerCCW = setmetatable({
    name = "valvedisplacer_ccw",
    k3 = 96,
    title = "Valve Displacer (CCW)",
    description = "Valve Diverger (CCW) that doesn't rotate cells.",
    categories = { "displacers" },
    rotates = false
}, { __index = ValveDivergerCCW })
ValveDisplacerCCW.__index = ValveDisplacerCCW

return ValveDisplacerCCW
