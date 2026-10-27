local BaseMirror = require("content/cells/abstract/BaseMirror")

local BicurvedMirror = setmetatable({
    name = "bicurvedmirror",
    k3 = 630,
    title = "Bicurved Mirror",
    description = "Two Curved Mirrors on opposite corners.",
    swaps = {
        { 0, 1 },
        { 2, 3 }
    }
}, { __index = BaseMirror })
BicurvedMirror.__index = BicurvedMirror

return BicurvedMirror
