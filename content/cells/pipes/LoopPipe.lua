local BasePipe = require("content/cells/abstract/BasePipe")
local LoopDiverger = require("content/cells/divergers/LoopDiverger")

local LoopPipe = setmetatable({
    name = "looppipe",
    title = "Loop Pipe",
    description = "Loop Diverger, but cells travel through it one step per tick.",
    routes = LoopDiverger.routes
}, { __index = BasePipe })
LoopPipe.__index = LoopPipe

return LoopPipe
