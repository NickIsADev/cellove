local Mover = require("content/cells/movers/Mover")
local SquishAcid = require("content/cells/destroyers/SquishAcid")

local SquishAlkali = setmetatable({
    name = "squishalkali",
    k3 = 865,
    title = "Squish Alkali",
    description = "Acts like a moving Squish Acid.",
    categories = { "movers", "acids" },
    destroys = true
}, { __index = Mover })
SquishAlkali.__index = SquishAlkali

SquishAlkali.eats = SquishAcid.eats
SquishAlkali.hit = SquishAcid.hit
SquishAlkali.ate = SquishAcid.ate

return SquishAlkali
