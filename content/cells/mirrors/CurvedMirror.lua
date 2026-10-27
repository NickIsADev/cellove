local BaseMirror = require("content/cells/abstract/BaseMirror")

local CurvedMirror = setmetatable({
    name = "curvedmirror",
    k3 = 629,
    title = "Curved Mirror",
    description = "Swaps the cells on two adjacent sides.",
    swaps = { { 0, 1 } }
}, { __index = BaseMirror })
CurvedMirror.__index = CurvedMirror

return CurvedMirror
