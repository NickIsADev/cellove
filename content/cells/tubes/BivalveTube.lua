local BivalvePipe = require("content/cells/pipes/BivalvePipe")

local BivalveTube = setmetatable({
    name = "bivalvetube",
    title = "Bivalve Tube",
    description = "Bivalve Pipe that doesn't rotate cells.",
    categories = { "tubes" },
    rotates = false
}, { __index = BivalvePipe })
BivalveTube.__index = BivalveTube

return BivalveTube
