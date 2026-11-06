local BasePipe = require("content/cells/abstract/BasePipe")
local ParavalveDivergerCCW = require("content/cells/divergers/ParavalveDivergerCCW")

local ParavalvePipeCCW = setmetatable({
    name = "paravalvepipe_ccw",
    title = "Paravalve Pipe (CCW)",
    description = "Paravalve Diverger (CCW), but cells travel through it one step per tick.",
    faces = ParavalveDivergerCCW.faces,
    routes = ParavalveDivergerCCW.routes
}, { __index = BasePipe })
ParavalvePipeCCW.__index = ParavalvePipeCCW

return ParavalvePipeCCW
