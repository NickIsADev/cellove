local BaseRedirector = require("content/cells/abstract/BaseRedirector")

local QuasiredirectorRNG = setmetatable({
    name = "quasiredirector_rng",
    k3 = 991,
    title = "Quasiredirector (RNG)",
    description = "Turns the cell in front of it to a random direction every tick. Ignores other redirectors.",
    outputs = { 0 },
    random = true
}, { __index = BaseRedirector })
QuasiredirectorRNG.__index = QuasiredirectorRNG

return QuasiredirectorRNG
