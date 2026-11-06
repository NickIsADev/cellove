local BasePipe = require("content/cells/abstract/BasePipe")
local DiodeDiverger = require("content/cells/divergers/DiodeDiverger")

local DiodePipe = setmetatable({
    name = "diodepipe",
    title = "Diode Pipe",
    description = "Diode Diverger, but cells travel through it one step per tick.",
    routes = DiodeDiverger.routes
}, { __index = BasePipe })
DiodePipe.__index = DiodePipe

return DiodePipe
