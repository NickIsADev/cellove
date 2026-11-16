local BaseCell = require("content/cells/abstract/BaseCell")
local Coins = require("content/effects/Coins")
local Coin = require("content/cells/collectables/Coin")
local constants = require("src/constants")

local CoinExtractor = setmetatable({
    name = "coinextractor",
    k3 = 230,
    title = "Coin Extractor",
    description = "Extracts coins from cells.",
    categories = { "collectables" },
    subtick = { "coinExtractor" },
    directional = true
}, { __index = BaseCell })
CoinExtractor.__index = CoinExtractor

function CoinExtractor:update()
    local grid, facing = self.grid, constants.directions[self.rotation]
    local fx, fy = self.x + facing[1], self.y + facing[2]
    local source, target = grid:get(self.x - facing[1], self.y - facing[2]), grid:get(fx, fy)
    local stored = source and source:effect(Coins)

    if not (grid:bounds(fx, fy) and getmetatable(target) ~= Coin and (stored or getmetatable(source) == Coin)) then return end

    if target then
        Coins:give(target, 1)
    else
        self.simulator.movement:place(fx, fy, Coin:new())
    end

    if stored then
        Coins:give(source, -1)
    else
        self.simulator.movement:destroy(source)
    end
end

return CoinExtractor
