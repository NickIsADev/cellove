local BaseMirror = require("content/cells/abstract/BaseMirror")

local TricurvedMirror = setmetatable({
    name = "tricurvedmirror",
    k3 = 657,
    title = "Tricurved Mirror",
    description = "Two Curved Mirrors and a Diagonal Mirror in one.",
    subtick = { "mirror", "curvedMirror" },
    swaps = {
        { 0, 1 },
        { 2, 3 },
        { 1.5, 3.5 }
    }
}, { __index = BaseMirror })
TricurvedMirror.__index = TricurvedMirror

function TricurvedMirror:mirrors(dx, dy)
    return (dx == 0 or dy == 0) and BaseMirror.mirrors(self, dx, dy)
end

return TricurvedMirror
