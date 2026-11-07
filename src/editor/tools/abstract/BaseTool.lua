local ToolPanel = require("src/editor/panels/ToolPanel")

local BaseTool = {}
BaseTool.__index = BaseTool

function BaseTool:_drag(gx, gy)
    local dx, dy = gx - self.x, gy - self.y
    local steps = math.max(math.abs(dx), math.abs(dy))

    for i = 1, steps do
        local t = i / steps
        self:_paint(math.floor(self.x + dx * t + 0.5), math.floor(self.y + dy * t + 0.5))
    end
    self.x, self.y = gx, gy
end

function BaseTool:setup(editor, specs)
    self.editor = editor
    self.widgets, self.byId = ToolPanel.build(editor.renderer, specs)
end

function BaseTool:click(id)
end

function BaseTool:refresh()
end

function BaseTool:press(gx, gy, button)
end

function BaseTool:move(gx, gy)
end

function BaseTool:release(gx, gy)
end

function BaseTool:keypressed(key)
end

function BaseTool:wheel(amount)
    return false
end

function BaseTool:draw(gx, gy)
end

function BaseTool:leave()
end

function BaseTool:reset()
end

return BaseTool
