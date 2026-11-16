local BaseOutcome = require("content/cells/abstract/BaseOutcome")

local VictorySwitch = setmetatable({
    name = "victoryswitch",
    k3 = 908,
    title = "Victory Switch",
    description = "Toggles when a cell moves into it. If all Victory Switches of an ID are enabled, you win the level.",
    categories = { "trashes", "puzzles" },
    outcome = "win"
}, { __index = BaseOutcome })
VictorySwitch.__index = VictorySwitch

return VictorySwitch
