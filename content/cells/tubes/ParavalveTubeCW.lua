local ParavalvePipeCW = require("content/cells/pipes/ParavalvePipeCW")

local ParavalveTubeCW = setmetatable({
    name = "paravalvetube_cw",
    title = "Paravalve Tube (CW)",
    description = "Paravalve Pipe (CW) that doesn't rotate cells.",
    categories = { "tubes" },
    rotates = false
}, { __index = ParavalvePipeCW })
ParavalveTubeCW.__index = ParavalveTubeCW

return ParavalveTubeCW
