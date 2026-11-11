local BaseRPS = require("content/cells/abstract/BaseRPS")

local Rock = setmetatable({
    name = "rock",
    title = "Rock",
    description = "Spreads into adjacent empty tiles and Scissors every tick. Gets infected by Paper.",
    beats = "scissors"
}, { __index = BaseRPS })
Rock.__index = Rock

return Rock
