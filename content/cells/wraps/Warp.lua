local BaseWrap = require("content/cells/abstract/BaseWrap")

local Warp = setmetatable({
    name = "warp",
    k3 = 747,
    title = "Warp",
    description = "Wrap on its front and Anti-Wrap on its back. Blocks the other sides.",
    faces = { 0, 2 },
    jumps = { [0] = -1, [2] = 1 }
}, { __index = BaseWrap })
Warp.__index = Warp

return Warp
