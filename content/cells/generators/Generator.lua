local BaseCell = require("content/cells/abstract/BaseCell")

local Generator = setmetatable({
    name = "generator",
    k3 = 3,
    title = "Generator",
    description = "Clones the cell behind it and pushes it out the front.",
    categories = { "generators" },
    subtick = { "generator" },
    directional = true,
    pushing = {}
}, { __index = BaseCell })
Generator.__index = Generator

function Generator:_source()
    local offset = self.bend or self.source or self.aligns and 2
    return offset and (self.rotation + offset) % 4
end

function Generator:_turn(direction)
    if self.rotates == false then return end
    return self.bend or self.aligns and direction - self.rotation
end

function Generator:_options(direction)
    return {
        source = self:_source(direction),
        turn = self:_turn(direction),
        retreat = self.retreat,
        force = self.pushing.force,
        bend = self.pushing.bend
    }
end

function Generator:_back(direction, options)
    return self:look(options.source or (direction + 2) % 4, true)
end

function Generator:generated()
end

function Generator:update(_, direction)
    local options = self:_options(direction)
    if not options then return end

    local done, clone, turn = self:generate(direction, options)
    if not done then return end

    if not (clone and clone.x and self.grid:get(clone.x, clone.y) == clone) then clone = nil end
    self:generated(clone, direction, turn)
end

return Generator
