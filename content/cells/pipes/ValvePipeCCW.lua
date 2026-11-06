local BasePipe = require("content/cells/abstract/BasePipe")
local ValveDivergerCCW = require("content/cells/divergers/ValveDivergerCCW")

local ValvePipeCCW = setmetatable({
    name = "valvepipe_ccw",
    title = "Valve Pipe (CCW)",
    description = "Valve Diverger (CCW), but cells travel through it one step per tick.",
    routes = ValveDivergerCCW.routes
}, { __index = BasePipe })
ValvePipeCCW.__index = ValvePipeCCW

return ValvePipeCCW
