local BaseHolder = require("content/cells/abstract/BaseHolder")
local BaseTransformer = require("content/cells/abstract/BaseTransformer")
local constants = require("src/constants")

local stored = constants.renderer.stored

local MemoryTransformer = setmetatable({
    name = "memorytransformer",
    k3 = 761,
    title = "Memory Transformer",
    description = "Like a Transformer, but once it sees a cell it will transform into that cell infinitely until it sees another.",
    categories = { "transformers" },
    subtick = { "transformer" },
    directional = true,
    fit = stored.memory
}, { __index = BaseHolder })
MemoryTransformer.__index = MemoryTransformer

MemoryTransformer._plan = BaseTransformer._plan
MemoryTransformer._scout = BaseTransformer._scout
MemoryTransformer._movable = BaseTransformer._movable
MemoryTransformer._withdraw = BaseTransformer._withdraw

function MemoryTransformer:_store(scout)
    local cell = scout.cell
    if not cell then return end

    local class, _, rotation = cell:generated()
    self:_hold({ class = class, rotation = ((rotation or cell.rotation) + scout.turn) % 4, effects = cell:kept() })
end

function MemoryTransformer:update(_, direction)
    local scout = self:_scout(direction)
    if not scout then return end

    self:_store(scout)
    if not self:held() then return end

    local clone = self:_make(direction)
    if self:_movable(clone, scout) then self:transform(direction, clone) end
end

return MemoryTransformer
