local BaseMirror = require("content/cells/abstract/BaseMirror")

local Megamirror = setmetatable({
    name = "megamirror",
    k3 = 478,
    title = "Megamirror",
    description = "Mirror that swaps three rows at once.",
    swaps = { { 0, 2 } },
    span = 1
}, { __index = BaseMirror })
Megamirror.__index = Megamirror

return Megamirror
