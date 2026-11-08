local LoopPipe = require("content/cells/pipes/LoopPipe")

local LoopTube = setmetatable({
    name = "looptube",
    title = "Loop Tube",
    description = "Loop Pipe that doesn't rotate cells.",
    categories = { "tubes" },
    rotates = false
}, { __index = LoopPipe })
LoopTube.__index = LoopTube

return LoopTube
