local BaseBarrier = require("content/cells/abstract/BaseBarrier")
local Switches = require("content/stores/Switches")

local BaseSwitchGate = setmetatable({
    name = "switchgate",
    properties = {
        { id = "id", title = "ID", default = 0, min = 0, max = 99 }
    }
}, { __index = BaseBarrier })
BaseSwitchGate.__index = BaseSwitchGate

function BaseSwitchGate:_shut()
    return Switches.on(self.grid, self.props.id) ~= self.solid
end

function BaseSwitchGate:draw(renderer, ...)
    BaseBarrier.draw(self, renderer, ...)
    renderer:drawTag(self.props.id, ...)
end

return BaseSwitchGate
