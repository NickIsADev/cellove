local LoopDiverger = require("content/cells/divergers/LoopDiverger")

local LoopDisplacer = setmetatable({
    name = "loopdisplacer",
    title = "Loop Displacer",
    description = "Loop Diverger that doesn't rotate cells.",
    categories = { "displacers" },
    rotates = false
}, { __index = LoopDiverger })
LoopDisplacer.__index = LoopDisplacer

return LoopDisplacer
