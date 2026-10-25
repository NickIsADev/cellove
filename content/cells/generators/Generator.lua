local BaseCell = require("content/cells/abstract/BaseCell")

local Generator = setmetatable({
    name = "generator",
    k3 = 3,
    title = "Generator",
    description = "Clones the cell behind it and pushes it out the front.",
    categories = { "generators" },
    subtick = { 0 },
    directional = true
}, { __index = BaseCell })
Generator.__index = Generator

function Generator:update(_, direction)
    local class = getmetatable(self)

    if class.bend then
        self:generate(direction, { source = (self.rotation + class.bend) % 4, turn = class.bend })
    elseif class.aligns then
        self:generate(direction, { source = (self.rotation + 2) % 4, turn = direction - self.rotation })
    else
        self:generate(direction)
    end
end

return Generator
