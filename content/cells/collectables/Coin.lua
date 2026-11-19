local BaseCell = require("content/cells/abstract/BaseCell")
local Audio = require("src/engine/audio/Audio")
local Coins = require("content/effects/Coins")

local Coin = setmetatable({
    name = "coin",
    k3 = 223,
    title = "Coin",
    description = "Adds 1 to a cell's coin count.",
    categories = { "collectables" },
    hollow = true
}, { __index = BaseCell })
Coin.__index = Coin

function Coin:eats(dx, dy, action)
    return action ~= "swap"
end

function Coin:absorb(cell)
    Coins:give(cell, 1)
    Audio.play("coin")
    self.spark = "coin"
    self:kill()
    return true
end

return Coin
