local BaseRedirector = require("content/cells/abstract/BaseRedirector")

local HemiredirectorRNG = setmetatable({
    name = "hemiredirector_rng",
    k3 = 992,
    title = "Hemiredirector (RNG)",
    description = "Turns the cells in front of and to the left of it to a random direction every tick. Ignores other redirectors.",
    outputs = { 0, 3 },
    random = true
}, { __index = BaseRedirector })
HemiredirectorRNG.__index = HemiredirectorRNG

return HemiredirectorRNG
