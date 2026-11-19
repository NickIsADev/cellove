local Reshifter = require("content/cells/shifters/Reshifter")

local CrossReshifter = setmetatable({
    name = "crossreshifter",
    k3 = 1153,
    title = "Cross Reshifter",
    description = "Two Reshifters combined.",
    outputs = { 0, 3 }
}, { __index = Reshifter })
CrossReshifter.__index = CrossReshifter

return CrossReshifter
