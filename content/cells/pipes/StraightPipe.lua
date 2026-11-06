local BasePipe = require("content/cells/abstract/BasePipe")
local StraightDiverger = require("content/cells/divergers/StraightDiverger")

local StraightPipe = setmetatable({
    name = "straightpipe",
    title = "Straight Pipe",
    description = "Straight Diverger, but cells travel through it one step per tick.",
    faces = StraightDiverger.faces,
    routes = StraightDiverger.routes
}, { __index = BasePipe })
StraightPipe.__index = StraightPipe

return StraightPipe
