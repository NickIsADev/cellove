local BaseHolder = require("content/cells/abstract/BaseHolder")
local Generator = require("content/cells/generators/Generator")
local constants = require("src/constants")

local stored = constants.renderer.stored

local ConvertGenerator = setmetatable({
    name = "convertgenerator",
    k3 = 652,
    title = "Convert Generator",
    description = "Generator that converts the generated cell into the cell it holds. (Click to insert cell)",
    stockable = true,
    properties = BaseHolder.properties,
    fit = stored.memory
}, { __index = Generator })
ConvertGenerator.__index = ConvertGenerator

ConvertGenerator._hold = BaseHolder._hold
ConvertGenerator._cell = BaseHolder._cell
ConvertGenerator.held = BaseHolder.held
ConvertGenerator.rotate = BaseHolder.rotate
ConvertGenerator.draw = BaseHolder.draw

function ConvertGenerator:_options(direction)
    local options = Generator._options(self, direction)
    if not self:held() then return options end

    local back = self:_back(direction, options)
    local target = back and back.target
    if not (target and target:cloneable()) then return end

    options.cell = self:_cell(self.props.stored)
    return options
end

return ConvertGenerator
