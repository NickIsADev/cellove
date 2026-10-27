local BaseRedirector = require("content/cells/abstract/BaseRedirector")

local InwardsRedirector = setmetatable({
    name = "inwardsredirector",
    k3 = 63,
    title = "Inwards Redirector",
    description = "Turns adjacent cells to face towards it every tick. Ignores other redirectors.",
    around = 2
}, { __index = BaseRedirector })
InwardsRedirector.__index = InwardsRedirector

return InwardsRedirector
