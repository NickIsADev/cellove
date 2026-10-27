local BaseMirror = require("content/cells/abstract/BaseMirror")

local SuperMirror = setmetatable({
    name = "supermirror",
    k3 = 313,
    title = "Super Mirror",
    description = "Swaps an entire row of cells.",
    swaps = { { 0, 2 } },
    reach = math.huge
}, { __index = BaseMirror })
SuperMirror.__index = SuperMirror

return SuperMirror
