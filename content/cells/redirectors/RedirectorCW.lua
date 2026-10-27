local BaseRedirector = require("content/cells/abstract/BaseRedirector")

local RedirectorCW = setmetatable({
    name = "redirector_cw",
    k3 = 64,
    title = "Redirector (CW)",
    description = "Turns adjacent cells to face clockwise around it every tick. Ignores other redirectors.",
    around = 1
}, { __index = BaseRedirector })
RedirectorCW.__index = RedirectorCW

return RedirectorCW
