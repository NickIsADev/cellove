local BaseWrap = require("content/cells/abstract/BaseWrap")

local Wrap = setmetatable({
    name = "wrap",
    k3 = 428,
    title = "Wrap",
    description = "Sends cells to the nearest Wrap behind them, or the edge of the grid if there isn't one.",
    jumps = {
        [0] = -1,
        [1] = -1,
        [2] = -1,
        [3] = -1
    }
}, { __index = BaseWrap })
Wrap.__index = Wrap

return Wrap
