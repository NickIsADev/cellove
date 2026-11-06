local BasePipe = require("content/cells/abstract/BasePipe")
local DivergerRNG = require("content/cells/divergers/DivergerRNG")

local PipeRNG = setmetatable({
    name = "pipe_rng",
    title = "Pipe (RNG)",
    description = "Diverger (RNG), but cells travel through it one step per tick.",
    faces = DivergerRNG.faces,
    routes = DivergerRNG.routes
}, { __index = BasePipe })
PipeRNG.__index = PipeRNG

return PipeRNG
