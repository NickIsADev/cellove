local Patcher = require("src/engine/modding/Patcher")
local Events = require("src/engine/modding/Events")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.mods
local editor = constants.editor

local function before(list, id, field)
    for index, item in ipairs(list) do
        if item[field or "id"] == id then return index end
    end
    return #list + 1
end

local function drop(list, id, field)
    table.remove(list, before(list, id, field))
end

local function find(path)
    local target = constants
    for key in path:gmatch("[^.]+") do
        target = assert(target[key], "unknown constants path " .. path)
    end
    return target
end

---@class ModAPI
---@field id string the mod's ID
---@field path string the mod's folder
---@field constants table the game's constants, change them with `api.merge`
---@field exports table shared with other mods through `api.mods.get`
---@field on function(name: string, callback: function) listens to an event
---@field off function(name: string, callback: function) removes a listener added with `api.on`

---@class ModCategory
---@field id string unique within the mod, gets the mod prefix
---@field title string name shown in the cell library
---@field icon string texture shown for the category
---@field parent? string full ID of the category it is listed under

---@class ModHotkey
---@field id string unique within the mod, gets the mod prefix
---@field key string default binding, like `"x"` or `"ctrl shift x"`
---@field title string name shown in the hotkeys menu
---@field description string tooltip shown in the hotkeys menu
---@field group? string section of the hotkeys menu, defaults to the mod's name

---@class ModMarker
---@field id string unique within the mod, gets the mod prefix
---@field title string name shown on the button
---@field description? string tooltip, generated from the title by default

---@class ModTool
---@field id string unique within the mod, gets the mod prefix
---@field key? string hotkey, claimed so conflicts are reported
---@field texture string icon shown on the toolbar
---@field title string name shown in the tooltip
---@field description string text shown in the tooltip
---@field class table tool class built from BaseTool

---@class ModMenuButton
---@field id string unique within the mod, gets the mod prefix
---@field folder? string texture folder, defaults to "cells"
---@field texture string icon shown on the button
---@field title string name shown in the tooltip
---@field scene? string scene opened on click
---@field action? function runs on click

---@class ModPauseButton
---@field id string unique within the mod, gets the mod prefix
---@field folder? string texture folder, defaults to "cells"
---@field texture string icon shown on the button
---@field title string name shown on the button
---@field action function runs on click

---@class ModOption
---@field key string setting name, gets the mod prefix
---@field title string name shown in the options menu
---@field kind "slider"|"toggle" input type
---@field default? any value used until the player changes it
---@field min? number lowest slider value
---@field max? number highest slider value
---@field format? function(value: any): string turns the value into the text shown beside the slider
---@field deferred? boolean applies on restart instead of live

local API = {}

function API.new(mods, mod)
    local id = mod.id
    local api = {
        id = id,
        path = mod.root,
        constants = constants,
        on = Events.on,
        off = Events.off,
        exports = mod.exports,
        settings = {},
        mods = {},
        codecs = {},
        categories = {},
        cells = {},
        hotkeys = {},
        splash = {},
        logos = {},
        markers = {},
        tools = {},
        scenes = {},
        menu = {},
        pause = {},
        options = {}
    }

    local hotkeys

    local function key(name)
        return id .. ":" .. name
    end

    Events.on("game:ready", function(context)
        hotkeys = context.hotkeys
    end)

    ---Deep-merges values into a constants path such as `background.logo`.
    ---@param path string dotted path into the constants
    ---@param values table keys to merge in
    ---@example
    ---api.merge("menu.splash", { color = 0xFF6AFF, size = 24 })
    function api.merge(path, values)
        for name in pairs(values) do
            mods:claim(mod, path .. "." .. name)
        end
        utils.merge(find(path), values)
    end

    ---Replaces a constants table, like the splash list at `menu.splash.list`. Unlike `api.merge`, entries missing from values are removed.
    ---@param path string dotted path into the constants
    ---@param values table the new contents of the table
    ---@example
    ---api.overwrite("menu.splash.list", { "hello!", "goodbye!" })
    function api.overwrite(path, values)
        mods:claim(mod, path)
        utils.overwrite(find(path), values)
    end

    ---Runs patch(module) when the module first loads, or at once if it already has. The module is changed in place.
    ---@param path string module require path
    ---@param patch function(module: table) edits the module
    ---@example
    ---api.patch("src/engine/simulation/Simulator", function(Simulator)
    ---    function Simulator:hello()
    ---        print("hello")
    ---    end
    ---end)
    function api.patch(path, patch)
        mods:claim(mod, path)
        Patcher.patch(path, patch)
    end

    ---Swaps a module that has not loaded yet for another value.
    ---@param path string module require path
    ---@param replacement any value `require` returns instead
    ---@example
    ---api.replace("src/engine/audio/Audio", api.require("audio"))
    function api.replace(path, replacement)
        mods:claim(mod, path)
        Patcher.replace(path, replacement)
    end

    ---Wraps a method; wrapper receives the original function first.
    ---@param path string module require path
    ---@param method string name of the method to wrap
    ---@param wrapper function(original: function, ...): ... runs in place of the method
    ---@example
    ---api.wrap("src/engine/simulation/Simulator", "push", function(original, self, ...)
    ---    print("pushing")
    ---    return original(self, ...)
    ---end)
    function api.wrap(path, method, wrapper)
        mods:claim(mod, path .. ":" .. method)
        Patcher.wrap(path, method, wrapper)
    end

    ---Requires a file relative to the mod folder.
    ---@param path string file path without the extension
    ---@return any
    ---@example
    ---local util = api.require("util")
    function api.require(path)
        return require(mod.root .. "/" .. path)
    end

    ---Emits `<modId>:<name>` to listeners.
    ---@param name string event name without the mod prefix
    ---@param ... any arguments passed to each listener
    ---@example
    ---api.emit("powered", cell)
    function api.emit(name, ...)
        Events.emit(key(name), ...)
    end

    ---Registers a setting under the mod namespace with a default. Its type is set by the default and the value is saved between sessions.
    ---@param name string
    ---@param default any value used until the setting is changed
    ---@example
    ---api.settings.define("volume", 5)
    function api.settings.define(name, default)
        mods.settings:define(key(name), default)
    end

    ---Returns the setting's current value.
    ---@param name string
    ---@return any
    ---@example
    ---local volume = api.settings.get("volume")
    function api.settings.get(name)
        return mods.settings:get(key(name))
    end

    ---Changes a setting and saves it. The setting has to be defined first.
    ---@param name string
    ---@param value any
    ---@example
    ---api.settings.set("volume", 8)
    function api.settings.set(name, value)
        mods.settings:set(key(name), value)
    end

    ---Calls callback with the new value when the setting changes.
    ---@param name string
    ---@param callback function(value: any)
    ---@example
    ---api.settings.listen("volume", function(value)
    ---    print("volume is now", value)
    ---end)
    function api.settings.listen(name, callback)
        mods.settings:listen(key(name), callback)
    end

    ---True if the mod is loaded without errors.
    ---@param name string mod ID
    ---@return boolean
    ---@example
    ---if api.mods.has("othermod") then
    ---    print("othermod is loaded")
    ---end
    function api.mods.has(name)
        local other = mods.byId[name]
        return other ~= nil and not other.error
    end

    ---Returns the other mod's exports table, if it loaded.
    ---@param name string mod ID
    ---@return table?
    ---@example
    ---local other = api.mods.get("othermod")
    ---if other then other.hello() end
    function api.mods.get(name)
        local other = mods.byId[name]
        return other and not other.error and other.exports
    end

    ---Adds a contraption codec; it needs new(data), decode and encode.
    ---@param Codec table codec class
    ---@example
    ---api.codecs.add(api.require("MyCodec"))
    function api.codecs.add(Codec)
        Patcher.patch("src/engine/data/Contraptions", function(Contraptions)
            table.insert(Contraptions.codecs, Codec)
        end)
    end

    ---Adds a cell library category, ID gets the mod prefix.
    ---@param spec ModCategory
    ---@example
    ---api.categories.add({
    ---    id = "machines",
    ---    title = "Machines",
    ---    icon = "mymod/thing"
    ---})
    function api.categories.add(spec)
        table.insert(constants.registry.categories, {
            id = key(spec.id),
            title = spec.title,
            icon = spec.icon,
            parent = spec.parent
        })
    end

    ---Registers a cell class defined in code instead of the cells folder.
    ---@param class table cell class built from BaseCell
    ---@example
    ---api.cells.add(api.require("Eraser"))
    function api.cells.add(class)
        table.insert(mod.cells, class)
    end

    ---Adds a rebindable hotkey to the hotkeys menu, ID gets the mod prefix. Check it with `api.hotkeys.pressed` or `api.hotkeys.down`.
    ---@param spec ModHotkey
    ---@example
    ---api.hotkeys.add({
    ---    id = "flag",
    ---    key = "ctrl f",
    ---    title = "Place Flag",
    ---    description = "Places a flag under the cursor."
    ---})
    function api.hotkeys.add(spec)
        mods:claim(mod, "hotkey " .. spec.key)

        table.insert(constants.hotkeys.list, {
            id = key(spec.id),
            group = spec.group or mod.name,
            title = spec.title,
            description = spec.description,
            key = spec.key
        })
    end

    ---True if the pressed key completes the hotkey's current binding. False until the game has loaded.
    ---@param name string hotkey ID without the mod prefix
    ---@param pressed string key from `game:keypressed`
    ---@return boolean
    ---@example
    ---api.on("game:keypressed", function(pressed)
    ---    if api.hotkeys.pressed("flag", pressed) then print("flag") end
    ---end)
    function api.hotkeys.pressed(name, pressed)
        return hotkeys ~= nil and hotkeys:pressed(key(name), pressed)
    end

    ---True while the hotkey's key is held. False until the game has loaded.
    ---@param name string hotkey ID without the mod prefix
    ---@return boolean
    ---@example
    ---api.on("game:update", function()
    ---    if api.hotkeys.down("flag") then print("holding flag") end
    ---end)
    function api.hotkeys.down(name)
        return hotkeys ~= nil and hotkeys:down(key(name))
    end

    ---Adds a line to the splash texts on the main menu.
    ---@param text string
    ---@example
    ---api.splash.add("now with mods!")
    function api.splash.add(text)
        table.insert(constants.menu.splash.list, text)
    end

    ---Adds a texture to the logos scattered across the scrolling background.
    ---@param texture string texture name
    ---@example
    ---api.logos.add("mymod/logo")
    function api.logos.add(texture)
        table.insert(constants.background.logo.textures, texture)
    end

    ---Adds an editor marker button.
    ---@param spec ModMarker
    ---@example
    ---api.markers.add({
    ---    id = "flag",
    ---    title = "Flag"
    ---})
    function api.markers.add(spec)
        local kind = key(spec.id)
        local buttons = editor.marker.buttons

        table.insert(buttons, before(buttons, "divider"), {
            kind = "icon",
            id = kind,
            folder = "markers",
            texture = utils.texture(kind),
            title = spec.title,
            description = spec.description or "Places the " .. spec.title:lower() .. " marker."
        })
        constants.contraptions.custom.kinds[kind] = true
    end

    ---Removes an editor marker button, like a built-in one.
    ---@param id string full marker ID
    ---@example
    ---api.markers.remove("mymod:flag")
    function api.markers.remove(id)
        drop(editor.marker.buttons, id)
    end

    ---Adds an editor tool.
    ---@param spec ModTool
    ---@example
    ---api.tools.add({
    ---    id = "stamp",
    ---    key = "x",
    ---    texture = "mymod/stamp",
    ---    title = "Stamp",
    ---    description = "Places a stamp.",
    ---    class = api.require("Stamp")
    ---})
    function api.tools.add(spec)
        if spec.key then mods:claim(mod, "hotkey " .. spec.key) end

        table.insert(editor.tools.list, {
            id = key(spec.id),
            key = spec.key,
            texture = spec.texture,
            title = spec.title,
            description = spec.description,
            class = spec.class
        })
    end

    ---Registers a scene and returns its prefixed name.
    ---@param name string
    ---@param Scene table scene class
    ---@return string
    ---@example
    ---local name = api.scenes.add("gallery", api.require("Gallery"))
    function api.scenes.add(name, Scene)
        mods.scenes[key(name)] = Scene
        return key(name)
    end

    ---Adds a button to the main menu.
    ---@param spec ModMenuButton
    ---@example
    ---api.menu.add({
    ---    id = "gallery",
    ---    texture = "mymod/gallery",
    ---    title = "Gallery",
    ---    scene = api.scenes.add("gallery", api.require("Gallery"))
    ---})
    function api.menu.add(spec)
        table.insert(constants.menu.button.list, {
            id = key(spec.id),
            folder = spec.folder or "cells",
            texture = spec.texture,
            title = spec.title,
            scene = spec.scene,
            action = spec.action
        })
    end

    ---Removes a button from the main menu, like a built-in one.
    ---@param id string full button ID
    ---@example
    ---api.menu.remove("mymod:gallery")
    function api.menu.remove(id)
        drop(constants.menu.button.list, id)
    end

    ---Adds an entry above "back" in the "editor" or "puzzle" pause menu.
    ---@param layout "editor"|"puzzle" menu the entry goes in
    ---@param spec ModPauseButton
    ---@example
    ---api.pause.add("editor", {
    ---    id = "export",
    ---    texture = "mymod/export",
    ---    title = "Export",
    ---    action = function() print("exported") end
    ---})
    function api.pause.add(layout, spec)
        local entry = {
            id = key(spec.id),
            folder = spec.folder or "cells",
            texture = spec.texture,
            title = spec.title,
            action = spec.action
        }

        for _, name in ipairs(config.layouts[layout]) do
            local list = constants.pauseMenu.layouts[name]
            table.insert(list, before(list, "back"), entry)
        end
    end

    ---Removes an entry from the "editor" or "puzzle" pause menu, like a built-in one.
    ---@param layout "editor"|"puzzle" menu the entry is in
    ---@param id string full entry ID
    ---@example
    ---api.pause.remove("editor", "mymod:export")
    function api.pause.remove(layout, id)
        for _, name in ipairs(config.layouts[layout]) do
            drop(constants.pauseMenu.layouts[name], id)
        end
    end

    ---Adds a row to the options menu. A default also defines the setting.
    ---@param spec ModOption
    ---@example
    ---api.options.add({
    ---    key = "volume",
    ---    title = "Volume",
    ---    kind = "slider",
    ---    default = 5,
    ---    min = 0,
    ---    max = 10
    ---})
    function api.options.add(spec)
        if spec.default ~= nil then api.settings.define(spec.key, spec.default) end

        table.insert(constants.options.pages.main.rows, {
            key = key(spec.key),
            title = spec.title,
            kind = spec.kind,
            min = spec.min,
            max = spec.max,
            format = spec.format or tostring,
            deferred = spec.deferred,
            height = constants.rows.row.height
        })
    end

    ---Removes a row from the options menu, like a built-in one. The setting itself stays.
    ---@param name string full setting name
    ---@example
    ---api.options.remove("mymod:volume")
    function api.options.remove(name)
        drop(constants.options.pages.main.rows, name, "key")
    end

    return api
end

return API
