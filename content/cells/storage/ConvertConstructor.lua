local BaseConverter = require("content/cells/abstract/BaseConverter")
local constants = require("src/constants")

local stored = constants.renderer.stored

local ConvertConstructor = setmetatable({
    name = "convertconstructor",
    k3 = 1088,
    title = "Convert Constructor",
    description = "Like a Constructor that only outputs whatever it contains.",
    fit = stored.memory,
    fixed = true,
    anchored = true
}, { __index = BaseConverter })
ConvertConstructor.__index = ConvertConstructor

function ConvertConstructor:_convert()
    self:_release(self.rotation)
end

function ConvertConstructor:eats()
    return false
end

return ConvertConstructor
