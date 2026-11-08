local ValvePipeCW = require("content/cells/pipes/ValvePipeCW")

local ValveTubeCW = setmetatable({
    name = "valvetube_cw",
    title = "Valve Tube (CW)",
    description = "Valve Pipe (CW) that doesn't rotate cells.",
    categories = { "tubes" },
    rotates = false
}, { __index = ValvePipeCW })
ValveTubeCW.__index = ValveTubeCW

return ValveTubeCW
