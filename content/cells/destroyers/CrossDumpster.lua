local Dumpster = require("content/cells/destroyers/Dumpster")

local CrossDumpster = setmetatable({
    name = "crossdumpster",
    k3 = 437,
    title = "Cross Dumpster",
    description = "Deletes any cell that moves into it. Every tick, also deletes every cell in its row and column, up to the nearest immovable cell.",
    outputs = { 0, 1, 2, 3 }
}, { __index = Dumpster })
CrossDumpster.__index = CrossDumpster

return CrossDumpster
