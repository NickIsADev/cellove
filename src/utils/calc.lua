local calc = {}

function calc.lerp(start, goal, t)
    return start + (goal - start) * t
end

function calc.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function calc.turn(dx, dy, amount)
    for _ = 1, amount % 4 do
        dx, dy = -dy, dx
    end
    return dx, dy
end

function calc.inside(x, y, left, top, width, height)
    return x >= left and x <= left + width and y >= top and y <= top + height
end

return calc
