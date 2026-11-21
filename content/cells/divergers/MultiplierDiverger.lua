local BaseForker = require("content/cells/abstract/BaseForker")
local constants = require("src/constants")

local MultiplierDiverger = setmetatable({
    name = "multiplierdiverger",
    k3 = 1084,
    title = "Multiplier Diverger",
    description = "Clones cells entering from behind out the front as many times as its amount.",
    categories = { "divergers" },
    forks = { [2] = { 0 } },
    reverse = { [0] = 0 },
    properties = { constants.adjustable.amount }
}, { __index = BaseForker })
MultiplierDiverger.__index = MultiplierDiverger

function MultiplierDiverger:_copies()
    return self.props.amount
end

function MultiplierDiverger:draw(renderer, ...)
    BaseForker.draw(self, renderer, ...)
    renderer:drawTag(self.props.amount, ...)
end

return MultiplierDiverger
