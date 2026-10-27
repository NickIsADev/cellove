local BaseMirror = require("content/cells/abstract/BaseMirror")

local TricurvedMirror = setmetatable({
    name = "tricurvedmirror",
    k3 = 657,
    title = "Tricurved Mirror",
    description = "Two Curved Mirrors and a Diagonal Mirror in one.",
    swaps = {
        { 0, 1 },
        { 2, 3 },
        { 1.5, 3.5 }
    }
}, { __index = BaseMirror })
TricurvedMirror.__index = TricurvedMirror

return TricurvedMirror
