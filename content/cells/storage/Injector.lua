local BaseConverter = require("content/cells/abstract/BaseConverter")

local Injector = setmetatable({
    name = "injector",
    k3 = 1043,
    title = "Injector",
    description = "Like a Converter, but instead, it transforms the cell in front of it to whatever it holds."
}, { __index = BaseConverter })
Injector.__index = Injector

function Injector:_convert()
    self:transform(self.rotation, self:_make(self.rotation))
end

return Injector
