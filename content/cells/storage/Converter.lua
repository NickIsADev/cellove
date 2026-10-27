local BaseConverter = require("content/cells/abstract/BaseConverter")

local Converter = setmetatable({
    name = "converter",
    k3 = 198,
    title = "Converter",
    description = "When a cell enters for the first time, the Converter stores the cell. The next time a cell enters, it will be converted into the stored cell."
}, { __index = BaseConverter })
Converter.__index = Converter

return Converter
