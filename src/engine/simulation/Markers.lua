local Markers = {
    areas = { box = true, placeable = true }
}
Markers.__index = Markers

function Markers.offset(marker, dx, dy)
    return {
        kind = marker.kind,
        x = marker.x + dx,
        y = marker.y + dy,
        rotation = marker.rotation,
        text = marker.text,
        color = marker.color,
        width = marker.width,
        height = marker.height
    }
end

function Markers.extent(marker)
    return marker.x + (marker.width or 1) - 1, marker.y + (marker.height or 1) - 1
end

function Markers.new()
    local self = setmetatable({}, Markers)
    self.items = {}
    return self
end

function Markers:at(x, y)
    for index, marker in ipairs(self.items) do
        if not Markers.areas[marker.kind] and marker.x == x and marker.y == y then return marker, index end
    end
end

function Markers:placeableAt(x, y)
    for _, marker in ipairs(self.items) do
        if marker.kind == "placeable" and marker.x == x and marker.y == y then return marker end
    end
end

function Markers:boxAt(x, y)
    for index = #self.items, 1, -1 do
        local marker = self.items[index]
        if marker.kind == "box" then
            local x2, y2 = Markers.extent(marker)
            if x >= marker.x and y >= marker.y and x <= x2 and y <= y2 then return marker end
        end
    end
end

function Markers:set(x, y, marker)
    local _, index = self:at(x, y)
    if index then table.remove(self.items, index) end
    if marker then self.items[#self.items + 1] = marker end
end

function Markers:add(marker)
    self.items[#self.items + 1] = marker
end

function Markers:remove(marker)
    for index, item in ipairs(self.items) do
        if item == marker then return table.remove(self.items, index) end
    end
end

function Markers:load(items)
    self.items = items or {}
end

return Markers
