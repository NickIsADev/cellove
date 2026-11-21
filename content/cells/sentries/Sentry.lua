local BaseWeapon = require("content/cells/abstract/BaseWeapon")
local Missile = require("content/cells/missiles/Missile")

local Sentry = setmetatable({
    name = "sentry",
    k3 = 318,
    title = "Sentry",
    description = "Turns toward Players it can see in a straight line and fires Missiles at them. Can be destroyed like an Enemy. Range 0 sees infinitely far.",
    categories = { "sentries" },
    subtick = { "sentry" },
    properties = {
        { id = "range", title = "Range", default = 0, min = 0, max = 99, names = { [0] = "0 (inf)" } }
    },
    missile = Missile
}, { __index = BaseWeapon })
Sentry.__index = Sentry

function Sentry:update()
    local aim = self:_target(self.props.range, true)
    if not aim then return end

    self:rotate(aim - self.rotation, true)
    self:fire(self.missile)
end

return Sentry
