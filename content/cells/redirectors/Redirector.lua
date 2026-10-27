local BaseRedirector = require("content/cells/abstract/BaseRedirector")

local Redirector = setmetatable({
    name = "redirector",
    k3 = 17,
    title = "Redirector",
    description = "Turns adjacent cells to face the same direction as it every tick. Ignores other redirectors."
}, { __index = BaseRedirector })
Redirector.__index = Redirector

return Redirector
