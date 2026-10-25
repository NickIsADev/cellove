local load = require
local pending = {}

local Patcher = {}

function Patcher.hook()
    function require(path)
        local fresh = package.loaded[path] == nil
        local module = load(path)
        if not (fresh and pending[path]) then return module end

        for _, patch in ipairs(pending[path]) do
            module = patch(module) or module
        end
        pending[path] = nil
        package.loaded[path] = module
        return module
    end
end

function Patcher.unhook()
    require = load
end

function Patcher.patch(path, patch)
    local module = package.loaded[path]
    if not module then
        pending[path] = pending[path] or {}
        table.insert(pending[path], patch)
        return
    end

    local result = patch(module)
    assert(result == nil or result == module, path .. " is already loaded, it can only be patched in place")
end

function Patcher.replace(path, replacement)
    Patcher.patch(path, function() return replacement end)
end

function Patcher.wrap(path, method, wrapper)
    Patcher.patch(path, function(class)
        local original = class[method]
        class[method] = function(...) return wrapper(original, ...) end
    end)
end

return Patcher
