local BaseMirror = require("content/cells/abstract/BaseMirror")

local CrossMirror = setmetatable({
    name = "crossmirror",
    k3 = 56,
    title = "Cross Mirror",
    description = "Two Mirrors in one, pointing along both axes.",
    swaps = {
        { 0, 2 },
        { 1, 3 }
    }
}, { __index = BaseMirror })
CrossMirror.__index = CrossMirror

return CrossMirror
