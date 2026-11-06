local BasePipe = require("content/cells/abstract/BasePipe")
local EdgeDivergerRNG = require("content/cells/divergers/EdgeDivergerRNG")

local EdgePipeRNG = setmetatable({
    name = "edgepipe_rng",
    title = "Edge Pipe (RNG)",
    description = "Edge Diverger (RNG), but cells travel through it one step per tick.",
    faces = EdgeDivergerRNG.faces,
    routes = EdgeDivergerRNG.routes
}, { __index = BasePipe })
EdgePipeRNG.__index = EdgePipeRNG

return EdgePipeRNG
