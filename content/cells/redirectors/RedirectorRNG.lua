local BaseRedirector = require("content/cells/abstract/BaseRedirector")

local RedirectorRNG = setmetatable({
    name = "redirector_rng",
    k3 = 989,
    title = "Redirector (RNG)",
    description = "Turns adjacent cells to a random direction every tick. Ignores other redirectors.",
    random = true
}, { __index = BaseRedirector })
RedirectorRNG.__index = RedirectorRNG

return RedirectorRNG
