local BaseCell = require("content/cells/abstract/BaseCell")

local BaseSpirit = setmetatable({}, { __index = BaseCell })
BaseSpirit.__index = BaseSpirit

function BaseSpirit:cloneable()
    return false
end

return BaseSpirit
