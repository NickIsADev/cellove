local BasePipe = require("content/cells/abstract/BasePipe")
local BivalveDiverger = require("content/cells/divergers/BivalveDiverger")

local BivalvePipe = setmetatable({
    name = "bivalvepipe",
    title = "Bivalve Pipe",
    description = "Bivalve Diverger, but cells travel through it one step per tick.",
    routes = BivalveDiverger.routes
}, { __index = BasePipe })
BivalvePipe.__index = BivalvePipe

return BivalvePipe
