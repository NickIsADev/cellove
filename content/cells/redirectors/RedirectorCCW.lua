local BaseRedirector = require("content/cells/abstract/BaseRedirector")

local RedirectorCCW = setmetatable({
    name = "redirector_ccw",
    k3 = 65,
    title = "Redirector (CCW)",
    description = "Turns adjacent cells to face counter-clockwise around it every tick. Ignores other redirectors.",
    around = 3
}, { __index = BaseRedirector })
RedirectorCCW.__index = RedirectorCCW

return RedirectorCCW
