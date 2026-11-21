local BaseCell = require("content/cells/abstract/BaseCell")

local BaseSuper = setmetatable({}, { __index = BaseCell })
BaseSuper.__index = BaseSuper

function BaseSuper:health()
    return math.huge
end

function BaseSuper:hit() end

return BaseSuper
