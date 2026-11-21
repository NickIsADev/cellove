local BaseBarrier = require("content/cells/abstract/BaseBarrier")
local BaseCell = require("content/cells/abstract/BaseCell")

local RegenerativeStaller = setmetatable({
    name = "regenerativestaller",
    k3 = 566,
    title = "Regenerative Staller",
    description = "Stops any cell trying to move into it and breaks, then regenerates after a number of ticks.",
    properties = {
        { id = "time", title = "Time", default = 1, min = 0, max = 99 }
    }
}, { __index = BaseBarrier })
RegenerativeStaller.__index = RegenerativeStaller

function RegenerativeStaller:_shut()
    return not self.mended or self.grid.simulator.time.tick >= self.mended
end

function RegenerativeStaller:bump()
    self.mended = self.grid.simulator.time.tick + self.props.time + 1
    self.simulator.movement:defer(function() self.grid:invalidate() end)
end

function RegenerativeStaller:sprite()
    return self:_shut() and self.texture or self.texture .. "_broken"
end

function RegenerativeStaller:draw(renderer, ...)
    BaseCell.draw(self, renderer, ...)
    renderer:drawTag(self.props.time, ...)
end

return RegenerativeStaller
