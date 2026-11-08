local DivalvePipe = require("content/cells/pipes/DivalvePipe")

local DivalveTube = setmetatable({
    name = "divalvetube",
    title = "Divalve Tube",
    description = "Divalve Pipe that doesn't rotate cells.",
    categories = { "tubes" },
    rotates = false
}, { __index = DivalvePipe })
DivalveTube.__index = DivalveTube

return DivalveTube
