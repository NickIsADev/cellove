local BaseMirror = require("content/cells/abstract/BaseMirror")

local Mirror = setmetatable({
    name = "mirror",
    k3 = 15,
    title = "Mirror",
    description = "Swaps the two cells its arrows point to. Ignores divergers.",
    swaps = { { 0, 2 } }
}, { __index = BaseMirror })
Mirror.__index = Mirror

return Mirror
