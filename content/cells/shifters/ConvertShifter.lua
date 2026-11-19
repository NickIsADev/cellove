local BaseHolder = require("content/cells/abstract/BaseHolder")
local Shifter = require("content/cells/shifters/Shifter")
local constants = require("src/constants")

local stored = constants.renderer.stored

local ConvertShifter = setmetatable({
    name = "convertshifter",
    k3 = 653,
    title = "Convert Shifter",
    description = "Shifter that converts the shifted cell into the cell it holds. (Click to insert cell)",
    stockable = true,
    properties = BaseHolder.properties,
    fit = stored.memory
}, { __index = Shifter })
ConvertShifter.__index = ConvertShifter

ConvertShifter._hold = BaseHolder._hold
ConvertShifter._cell = BaseHolder._cell
ConvertShifter._make = BaseHolder._make
ConvertShifter._release = BaseHolder._release
ConvertShifter.held = BaseHolder.held
ConvertShifter.rotate = BaseHolder.rotate
ConvertShifter.draw = BaseHolder.draw

function ConvertShifter:_emit(facing, scout)
    if not self:held() then return Shifter._emit(self, facing, scout) end

    local clone = self:_make(facing)
    clone.updated, clone.ran = scout.cell.updated, scout.cell.ran
    return self:_release(facing, nil, clone)
end

return ConvertShifter
