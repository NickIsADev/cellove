local BaseCell = require("content/cells/abstract/BaseCell")

local Generator = setmetatable({
    name = "generator",
    k3 = 3,
    title = "Generator",
    description = "Clones the cell behind it and pushes it out the front.",
    categories = { "generators" },
    subtick = { 6 },
    directional = true
}, { __index = BaseCell })
Generator.__index = Generator

function Generator:update(_, direction)
    if self.bend then
        self:generate(direction, { source = (self.rotation + self.bend) % 4, turn = self.bend })
    elseif self.aligns then
        self:generate(direction, { source = (self.rotation + 2) % 4, turn = direction - self.rotation })
    else
        self:generate(direction)
    end
end

return Generator
