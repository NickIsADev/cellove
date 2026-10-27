local BaseConverter = require("content/cells/abstract/BaseConverter")
local constants = require("src/constants")

local stored = constants.renderer.stored

local ConvertConstructor = setmetatable({
    name = "convertconstructor",
    k3 = 1088,
    title = "Convert Constructor",
    description = "Like a Constructor that only outputs whatever it contains.",
    fit = stored.memory
}, { __index = BaseConverter })
ConvertConstructor.__index = ConvertConstructor

function ConvertConstructor:transformable()
    return false
end

function ConvertConstructor:absorb(cell)
    if self:held() then BaseConverter.absorb(self, cell) end
end

return ConvertConstructor
