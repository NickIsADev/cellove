local BaseCell = require("content/cells/abstract/BaseCell")
local utils = require("src/utils")

local BaseSided = setmetatable({
    sweep = { x = 1, y = -1 },
    outputs = { 0, 1, 2, 3 },
    sides = { orthogonal = true }
}, { __index = BaseCell })
BaseSided.__index = BaseSided

function BaseSided:_reaches(dx, dy)
    if dx ~= 0 and dy ~= 0 then return self.sides.diagonal end

    return self.sides.orthogonal and self.lookup.outputs[(utils.direction(dx, dy) - self.rotation) % 4]
end

return BaseSided
