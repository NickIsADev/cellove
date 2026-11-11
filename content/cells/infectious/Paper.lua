local BaseRPS = require("content/cells/abstract/BaseRPS")

local Paper = setmetatable({
    name = "paper",
    title = "Paper",
    description = "Spreads into adjacent empty tiles and Rock every tick. Gets infected by Scissors.",
    beats = "rock"
}, { __index = BaseRPS })
Paper.__index = Paper

return Paper
