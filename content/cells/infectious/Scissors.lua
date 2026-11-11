local BaseRPS = require("content/cells/abstract/BaseRPS")

local Scissors = setmetatable({
    name = "scissors",
    title = "Scissors",
    description = "Spreads into adjacent empty tiles and Paper every tick. Gets infected by Rock.",
    beats = "paper"
}, { __index = BaseRPS })
Scissors.__index = Scissors

return Scissors
