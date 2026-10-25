local ValveDivergerCW = require("content/cells/divergers/ValveDivergerCW")

local ValveDisplacerCW = setmetatable({
    name = "valvedisplacer_cw",
    k3 = 95,
    title = "Valve Displacer (CW)",
    description = "Valve Diverger (CW) that doesn't rotate cells.",
    categories = { "displacers" },
    rotates = false
}, { __index = ValveDivergerCW })
ValveDisplacerCW.__index = ValveDisplacerCW

return ValveDisplacerCW
