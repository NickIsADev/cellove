local BaseRedirector = require("content/cells/abstract/BaseRedirector")

local OutwardsRedirector = setmetatable({
    name = "outwardsredirector",
    k3 = 62,
    title = "Outwards Redirector",
    description = "Turns adjacent cells to face away from it every tick. Ignores other redirectors.",
    around = 0
}, { __index = BaseRedirector })
OutwardsRedirector.__index = OutwardsRedirector

return OutwardsRedirector
