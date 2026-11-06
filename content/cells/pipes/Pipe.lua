local BasePipe = require("content/cells/abstract/BasePipe")
local Diverger = require("content/cells/divergers/Diverger")

local Pipe = setmetatable({
    name = "pipe",
    title = "Pipe",
    description = "Diverger, but cells travel through it one step per tick.",
    faces = Diverger.faces,
    routes = Diverger.routes
}, { __index = BasePipe })
Pipe.__index = Pipe

return Pipe
