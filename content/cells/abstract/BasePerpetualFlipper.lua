local BasePerpetual = require("content/cells/abstract/BasePerpetual")
local utils = require("src/utils")

local BasePerpetualFlipper = setmetatable({
    faces = { 0, 2 },
    axis = "straight"
}, { __index = BasePerpetual })
BasePerpetualFlipper.__index = BasePerpetualFlipper

function BasePerpetualFlipper:_value()
    return utils.flip(self.rotation, self.axis)
end

return BasePerpetualFlipper
