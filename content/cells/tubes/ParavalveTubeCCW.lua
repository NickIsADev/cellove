local ParavalvePipeCCW = require("content/cells/pipes/ParavalvePipeCCW")

local ParavalveTubeCCW = setmetatable({
    name = "paravalvetube_ccw",
    title = "Paravalve Tube (CCW)",
    description = "Paravalve Pipe (CCW) that doesn't rotate cells.",
    categories = { "tubes" },
    rotates = false
}, { __index = ParavalvePipeCCW })
ParavalveTubeCCW.__index = ParavalveTubeCCW

return ParavalveTubeCCW
