local FlipFlopDiverger = require("content/cells/divergers/FlipFlopDiverger")

local FlipFlopDisplacer = setmetatable({
    name = "flipflopdisplacer",
    k3 = 703,
    title = "Flip-Flop Displacer",
    description = "Flip-Flop Diverger that doesn't rotate cells.",
    categories = { "displacers" },
    rotates = false
}, { __index = FlipFlopDiverger })
FlipFlopDisplacer.__index = FlipFlopDisplacer

return FlipFlopDisplacer
