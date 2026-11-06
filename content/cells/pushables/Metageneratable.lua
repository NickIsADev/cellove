local BaseHolder = require("content/cells/abstract/BaseHolder")
local utils = require("src/utils")

local Metageneratable = setmetatable({
    name = "metageneratable",
    k3 = 645,
    title = "Metageneratable",
    description = "A pushable that stores the first cell that moves into it. Each generation removes one, then it generates the stored cell.",
    faces = {},
    categories = { "pushables", "storage" },
    properties = {
        BaseHolder.properties[1],
        { id = "generations", title = "Generations", default = 1, min = 1, max = 99 }
    }
}, { __index = BaseHolder })
Metageneratable.__index = Metageneratable

function Metageneratable:eats()
    return not self:held()
end

function Metageneratable:swapped()
    if not self:held() then self:absorb(self) end
end

function Metageneratable:generated()
    local stored, generations = self.props.stored, self.props.generations

    if generations > 1 then
        local props = utils.copy(self.props)
        props.generations = generations - 1
        return getmetatable(self), props
    end
    return stored.class, stored.props, stored.rotation
end

function Metageneratable:draw(renderer, ...)
    BaseHolder.draw(self, renderer, ...)
    renderer:drawTag(self.props.generations, ...)
end

return Metageneratable
