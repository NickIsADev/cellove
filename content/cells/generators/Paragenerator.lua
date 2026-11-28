local Generator = require("content/cells/generators/Generator")

local Paragenerator = setmetatable({
    name = "paragenerator",
    k3 = 363,
    title = "Paragenerator",
    description = "Two opposing Generators combined.",
    outputs = { 0, 2 }
}, { __index = Generator })
Paragenerator.__index = Paragenerator

function Paragenerator:_options(direction)
    local options = Generator._options(self, direction)

    if direction == 0 or direction == 3 then
        local front = self:look(direction)
        self.shared = front and front.target
        return options
    end

    options.cell, self.shared = self.shared, nil
    return options.cell and options
end

return Paragenerator
