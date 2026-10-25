local graphics, mouse = love.graphics, love.mouse
local real = {
    dimensions = graphics.getDimensions,
    position = mouse.getPosition,
    scissor = graphics.setScissor
}

local Display = { scale = 1 }

function Display.new(data)
    data.settings:listen("uiScale", function(percent) Display.scale = percent / 100 end)
end

function Display.size()
    return real.dimensions()
end

function Display.dpi()
    return graphics.getDPIScale() * Display.scale
end

function Display.point(x, y, ...)
    return x / Display.scale, y / Display.scale, ...
end

function graphics.getDimensions()
    local w, h = real.dimensions()
    return w / Display.scale, h / Display.scale
end

function graphics.getWidth()
    return (graphics.getDimensions())
end

function graphics.getHeight()
    return select(2, graphics.getDimensions())
end

function graphics.setScissor(x, y, w, h)
    if not x then return real.scissor() end
    local scale = Display.scale
    return real.scissor(x * scale, y * scale, w * scale, h * scale)
end

function mouse.getPosition()
    return Display.point(real.position())
end

function mouse.getX()
    return (mouse.getPosition())
end

function mouse.getY()
    return select(2, mouse.getPosition())
end

return Display
