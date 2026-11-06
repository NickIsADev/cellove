local BasePipe = require("content/cells/abstract/BasePipe")
local CrossDiodeDiverger = require("content/cells/divergers/CrossDiodeDiverger")

local CrossDiodePipe = setmetatable({
    name = "crossdiodepipe",
    title = "Crossdiode Pipe",
    description = "Crossdiode Diverger, but cells travel through it one step per tick.",
    faces = CrossDiodeDiverger.faces,
    routes = CrossDiodeDiverger.routes
}, { __index = BasePipe })
CrossDiodePipe.__index = CrossDiodePipe

return CrossDiodePipe
