local BaseMirror = require("content/cells/abstract/BaseMirror")

local CrossSuperMirror = setmetatable({
    name = "crosssupermirror",
    k3 = 314,
    title = "Cross Super Mirror",
    description = "Two Super Mirrors in one.",
    swaps = {
        { 0, 2 },
        { 1, 3 }
    },
    reach = math.huge
}, { __index = BaseMirror })
CrossSuperMirror.__index = CrossSuperMirror

return CrossSuperMirror
