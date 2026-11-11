local BaseHolder = require("content/cells/abstract/BaseHolder")
local constants = require("src/constants")

local stored = constants.renderer.stored

local MemoryGenerator = setmetatable({
    name = "memorygenerator",
    k3 = 166,
    title = "Memory Generator",
    description = "Like a Generator, but once it sees a cell it will generate that cell infinitely until it sees another. Also updates before other Generators.",
    categories = { "generators" },
    subtick = { "memoryGenerator" },
    directional = true,
    fit = stored.memory,
    source = 2
}, { __index = BaseHolder })
MemoryGenerator.__index = MemoryGenerator

function MemoryGenerator:update()
    local source = self.source
    local look = self:look((self.rotation + source) % 4)
    local target = look and look.target

    if target and target:generatable() then
        self:_hold({ class = target:generated(), rotation = (target.rotation - look.turn) % 4 })
    end

    if self:held() then self:_release(self.rotation) end
end

return MemoryGenerator
