local Fresh = {}
Fresh.__index = Fresh

function Fresh.new(data)
    local self = setmetatable({}, Fresh)
    local text = data.settings:get("seen")
    local seen, ids = {}, {}
    self.ids = {}

    for id in text:gmatch("[^,]+") do
        seen[id] = true
    end

    for _, class in ipairs(data.registry:list()) do
        ids[#ids + 1] = class.id
        if text ~= "" and not seen[class.id] then self.ids[class.id] = true end
    end

    data.settings:set("seen", table.concat(ids, ","))
    return self
end

function Fresh:has(class)
    return self.ids[class.id]
end

function Fresh:clear(class)
    self.ids[class.id] = nil
end

return Fresh
