local BasePipe = require("content/cells/abstract/BasePipe")
local CrossDiverger = require("content/cells/divergers/CrossDiverger")

local CrossPipe = setmetatable({
    name = "crosspipe",
    title = "Cross Pipe",
    description = "Cross Diverger, but cells travel through it one step per tick.",
    faces = CrossDiverger.faces,
    routes = CrossDiverger.routes
}, { __index = BasePipe })
CrossPipe.__index = CrossPipe

return CrossPipe
