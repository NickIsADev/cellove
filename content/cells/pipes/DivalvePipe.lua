local BasePipe = require("content/cells/abstract/BasePipe")
local DivalveDiverger = require("content/cells/divergers/DivalveDiverger")

local DivalvePipe = setmetatable({
    name = "divalvepipe",
    title = "Divalve Pipe",
    description = "Divalve Diverger, but cells travel through it one step per tick.",
    routes = DivalveDiverger.routes
}, { __index = BasePipe })
DivalvePipe.__index = DivalvePipe

return DivalvePipe
