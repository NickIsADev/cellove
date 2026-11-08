local Pipe = require("content/cells/pipes/Pipe")

local Tube = setmetatable({
    name = "tube",
    title = "Tube",
    description = "Pipe that doesn't rotate cells.",
    categories = { "tubes" },
    rotates = false
}, { __index = Pipe })
Tube.__index = Tube

return Tube
