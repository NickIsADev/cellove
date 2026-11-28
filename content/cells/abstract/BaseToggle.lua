local BaseBarrier = require("content/cells/abstract/BaseBarrier")
local Audio = require("src/engine/audio/Audio")

local BaseToggle = setmetatable({
    name = "toggle"
}, { __index = BaseBarrier })
BaseToggle.__index = BaseToggle

function BaseToggle:_shut(mover)
    return self.solid and not (mover and mover.key == "toggle")
end

function BaseToggle:eats(dx, dy, action, mover)
    return mover ~= nil and mover.key == "toggle"
end

function BaseToggle:ate()
    Audio.play("unlock")
    self.spark = "quantum"
    self.grid:touch(self)
    self:alternate()
end

return BaseToggle
