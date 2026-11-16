local BaseOutcome = require("content/cells/abstract/BaseOutcome")

local FailureSwitch = setmetatable({
    name = "failureswitch",
    k3 = 909,
    title = "Failure Switch",
    description = "Toggles when a cell moves into it. If all Failure Switches of an ID are enabled, you lose the level.",
    categories = { "trashes", "puzzles" },
    outcome = "lose"
}, { __index = BaseOutcome })
FailureSwitch.__index = FailureSwitch

return FailureSwitch
