local SquishTrash = require("content/cells/destroyers/SquishTrash")
local Enemy = require("content/cells/destroyers/Enemy")

local SquishAcid = setmetatable({
    name = "squishacid",
    k3 = 717,
    title = "Squish Acid",
    description = "Acts like a Pushable, but when it is squished against something immovable, it and the cell that pushes it destroy each other.",
    categories = { "acids" }
}, { __index = SquishTrash })
SquishAcid.__index = SquishAcid

SquishAcid.hit = Enemy.hit
SquishAcid.ate = Enemy.ate

return SquishAcid
