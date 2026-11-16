local BaseEffect = require("content/effects/abstract/BaseEffect")

local modes = { "settle", "moto" }

local Compel = setmetatable({
    name = "compel",
    permanent = true,
    subtick = { "compel" }
}, { __index = BaseEffect })
Compel.__index = Compel

function Compel:update(cell, value)
    if cell:moved() == (value == 1) then cell:kill() end
end

function Compel:texture(value)
    return self.name .. "_" .. modes[value]
end

return Compel
