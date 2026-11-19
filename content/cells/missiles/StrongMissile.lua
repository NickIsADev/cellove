local Missile = require("content/cells/missiles/Missile")

local StrongMissile = setmetatable({
    name = "strongmissile",
    k3 = 358,
    title = "Strong Missile",
    description = "Takes two hits to destroy. Becomes a Missile when hit.",
    weak = Missile
}, { __index = Missile })
StrongMissile.__index = StrongMissile

return StrongMissile
