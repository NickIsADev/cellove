local BaseRedirector = require("content/cells/abstract/BaseRedirector")

local SemiredirectorRNG = setmetatable({
    name = "semiredirector_rng",
    k3 = 990,
    title = "Semiredirector (RNG)",
    description = "Turns the cells in front of and behind it to a random direction every tick. Ignores other redirectors.",
    outputs = { 0, 2 },
    random = true
}, { __index = BaseRedirector })
SemiredirectorRNG.__index = SemiredirectorRNG

return SemiredirectorRNG
