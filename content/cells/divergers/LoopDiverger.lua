local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local LoopDiverger = setmetatable({
    name = "loopdiverger",
    title = "Loop Diverger",
    description = "Turns cells entering its front around 180 degrees. Blocks the other sides.",
    routes = { [0] = 2 }
}, { __index = BaseDiverger })
LoopDiverger.__index = LoopDiverger

return LoopDiverger
