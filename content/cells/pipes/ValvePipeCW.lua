local BasePipe = require("content/cells/abstract/BasePipe")
local ValveDivergerCW = require("content/cells/divergers/ValveDivergerCW")

local ValvePipeCW = setmetatable({
    name = "valvepipe_cw",
    title = "Valve Pipe (CW)",
    description = "Valve Diverger (CW), but cells travel through it one step per tick.",
    routes = ValveDivergerCW.routes
}, { __index = BasePipe })
ValvePipeCW.__index = ValvePipeCW

return ValvePipeCW
