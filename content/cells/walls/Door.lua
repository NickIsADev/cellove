local BaseCell = require("content/cells/abstract/BaseCell")
local Audio = require("src/engine/audio/Audio")

local Door = setmetatable({
    name = "door",
    k3 = 154,
    title = "Door",
    description = "Cannot be destroyed, except by a Key.",
    categories = { "walls", "unlocking" },
    fixed = true
}, { __index = BaseCell })
Door.__index = Door

function Door:eats(dx, dy, action, mover)
    return action ~= "swap" and mover ~= nil and mover.key == "door"
end

function Door:ate(cell)
    Audio.play("unlock")
    Audio.play("destroy")
    self.spark = "sparkle"
    self:kill()
    return cell.survives
end

return Door
