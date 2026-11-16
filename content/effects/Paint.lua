local BaseEffect = require("content/effects/abstract/BaseEffect")

local Paint = setmetatable({
    name = "paint",
    universal = true,
    permanent = true
}, { __index = BaseEffect })
Paint.__index = Paint

function Paint:tint(value)
    return value
end

function Paint:draw()
end

return Paint
