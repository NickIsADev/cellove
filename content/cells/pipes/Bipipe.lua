local BasePipe = require("content/cells/abstract/BasePipe")
local Bidiverger = require("content/cells/divergers/Bidiverger")

local Bipipe = setmetatable({
    name = "bipipe",
    title = "Bipipe",
    description = "Bidiverger, but cells travel through it one step per tick.",
    faces = Bidiverger.faces,
    routes = Bidiverger.routes
}, { __index = BasePipe })
Bipipe.__index = Bipipe

return Bipipe
