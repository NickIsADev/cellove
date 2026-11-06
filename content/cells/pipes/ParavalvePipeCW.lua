local BasePipe = require("content/cells/abstract/BasePipe")
local ParavalveDivergerCW = require("content/cells/divergers/ParavalveDivergerCW")

local ParavalvePipeCW = setmetatable({
    name = "paravalvepipe_cw",
    title = "Paravalve Pipe (CW)",
    description = "Paravalve Diverger (CW), but cells travel through it one step per tick.",
    faces = ParavalveDivergerCW.faces,
    routes = ParavalveDivergerCW.routes
}, { __index = BasePipe })
ParavalvePipeCW.__index = ParavalvePipeCW

return ParavalvePipeCW
