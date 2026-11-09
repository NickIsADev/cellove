local BaseWrap = require("content/cells/abstract/BaseWrap")

local AntiWrap = setmetatable({
    name = "antiwrap",
    k3 = 746,
    title = "Anti-Wrap",
    description = "Wrap, but it sends cells to the nearest Anti-Wrap ahead of them. Blocks cells if there isn't one.",
    jumps = {
        [0] = 1,
        [1] = 1,
        [2] = 1,
        [3] = 1
    }
}, { __index = BaseWrap })
AntiWrap.__index = AntiWrap

return AntiWrap
