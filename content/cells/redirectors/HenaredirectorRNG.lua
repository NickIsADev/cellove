local BaseRedirector = require("content/cells/abstract/BaseRedirector")

local HenaredirectorRNG = setmetatable({
    name = "henaredirector_rng",
    k3 = 993,
    title = "Henaredirector (RNG)",
    description = "Turns the cells in front of, to the left of and to the right of it to a random direction every tick. Ignores other redirectors.",
    outputs = { 0, 1, 3 },
    random = true
}, { __index = BaseRedirector })
HenaredirectorRNG.__index = HenaredirectorRNG

return HenaredirectorRNG
