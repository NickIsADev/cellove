local BaseCell = require("content/cells/abstract/BaseCell")

local BaseBroken = setmetatable({}, { __index = BaseCell })
BaseBroken.__index = BaseBroken

function BaseBroken:pushed()
    self.simulator.movement:destroy(self)
end

return BaseBroken
