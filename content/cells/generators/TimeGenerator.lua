local Generator = require("content/cells/generators/Generator")
local Initial = require("content/stores/Initial")

local TimeGenerator = setmetatable({
    name = "timegenerator",
    k3 = 147,
    title = "Time Generator",
    description = "Generates whatever the space behind it had in the initial state."
}, { __index = Generator })
TimeGenerator.__index = TimeGenerator

function TimeGenerator:_options(direction)
    local options = Generator._options(self, direction)
    local back = self:_back(direction, options)
    local initial = back and Initial.at(self.grid, back.x, back.y)
    if not initial then return end

    options.cell = initial.class:new({ rotation = initial.rotation, props = initial.props })
    return options
end

return TimeGenerator
