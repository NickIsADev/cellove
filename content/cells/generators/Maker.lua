local BaseHolder = require("content/cells/abstract/BaseHolder")
local constants = require("src/constants")

local stored = constants.renderer.stored

local Maker = setmetatable({
    name = "maker",
    k3 = 526,
    title = "Maker",
    description = "Creates cells of any type. (Click to insert cell)",
    categories = { "generators" },
    subtick = { 0 },
    directional = true,
    fit = stored.maker
}, { __index = BaseHolder })
Maker.__index = Maker

function Maker:update(_, direction)
    if self:held() then self:_release(direction) end
end

return Maker
