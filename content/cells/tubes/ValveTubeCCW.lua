local ValvePipeCCW = require("content/cells/pipes/ValvePipeCCW")

local ValveTubeCCW = setmetatable({
    name = "valvetube_ccw",
    title = "Valve Tube (CCW)",
    description = "Valve Pipe (CCW) that doesn't rotate cells.",
    categories = { "tubes" },
    rotates = false
}, { __index = ValvePipeCCW })
ValveTubeCCW.__index = ValveTubeCCW

return ValveTubeCCW
