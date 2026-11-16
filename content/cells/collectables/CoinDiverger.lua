local CrossDiverger = require("content/cells/divergers/CrossDiverger")
local Coins = require("content/effects/Coins")

local CoinDiverger = setmetatable({
    name = "coindiverger",
    k3 = 224,
    title = "Coin Diverger",
    description = "Acts like a Cross Diverger to cells with enough coins, acts like a Wall otherwise. Also subtracts that amount of coins from the cell when they pass through.",
    categories = { "collectables" },
    fixed = true,
    properties = {
        { id = "cost", title = "Coins", default = 1, min = 1, max = 999 }
    }
}, { __index = CrossDiverger })
CoinDiverger.__index = CoinDiverger

function CoinDiverger:divert(dx, dy, reverse, mover)
    if mover and (mover:effect(Coins) or 0) >= self.props.cost then
        return CrossDiverger.divert(self, dx, dy, reverse)
    end
end

function CoinDiverger:passed(mover)
    Coins:give(mover, -self.props.cost)
end

function CoinDiverger:draw(renderer, ...)
    CrossDiverger.draw(self, renderer, ...)
    renderer:drawTag(self.props.cost, ...)
end

return CoinDiverger
