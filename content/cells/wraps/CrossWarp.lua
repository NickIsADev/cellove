local BaseWrap = require("content/cells/abstract/BaseWrap")

local CrossWarp = setmetatable({
    name = "crosswarp",
    k3 = 748,
    title = "Cross Warp",
    description = "Two Warps in one, pointing along both axes.",
    jumps = {
        [0] = -1,
        [1] = 1,
        [2] = 1,
        [3] = -1
    }
}, { __index = BaseWrap })
CrossWarp.__index = CrossWarp

return CrossWarp
