local manager

local function purge()
    local config = require("src/constants").reload

    require("src/engine/modding/Patcher").unhook()
    for name in pairs(package.loaded) do
        if config.roots[name:match("^[^/]+/")] and not config.keep[name] then package.loaded[name] = nil end
    end
end

local Game = {}

function Game.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    local Settings = require("src/engine/data/Settings")
    local Mods = require("src/engine/sources/Mods")
    local settings = Settings.new()
    local mods = Mods.new({ settings = settings })
    mods:load()

    local SceneManager = require("src/engine/core/SceneManager")
    local Contraptions = require("src/engine/data/Contraptions")
    local Puzzles = require("src/engine/data/Puzzles")
    local Registry = require("src/engine/registry/Registry")
    local Progress = require("src/engine/data/Progress")
    local Audio = require("src/engine/audio/Audio")
    local Window = require("src/engine/graphics/Window")
    local Display = require("src/engine/graphics/Display")
    local Renderer = require("src/engine/graphics/Renderer")
    local TexturePacks = require("src/engine/sources/TexturePacks")
    local Debug = require("src/engine/debug/Debug")
    local Events = require("src/engine/modding/Events")
    local constants = require("src/constants")

    local scenes = {
        menu = require("src/scenes/MenuScene"),
        options = require("src/scenes/OptionsScene"),
        packs = require("src/scenes/PacksScene"),
        mods = require("src/scenes/ModsScene"),
        contraptions = require("src/scenes/ContraptionsScene"),
        puzzles = require("src/scenes/PuzzlesScene"),
        puzzle = require("src/scenes/PuzzleScene"),
        game = require("src/scenes/GameScene")
    }
    for name, Scene in pairs(mods.scenes) do
        scenes[name] = Scene
    end

    Display.new({ settings = settings })
    local texturePacks = TexturePacks.new({ settings = settings, mods = mods })
    Audio.new({ settings = settings, texturePacks = texturePacks })
    local renderer = Renderer.new({ texturePacks = texturePacks, settings = settings })
    local registry = Registry.new({ mods = mods })
    renderer:preload(registry:list())
    local contraptions = Contraptions.new({ registry = registry })
    local stamps = Contraptions.new({ registry = registry, root = constants.stamps.root })
    local puzzles = Puzzles.new({ contraptions = contraptions, mods = mods })
    Window.new({ settings = settings, texturePacks = texturePacks })

    manager = SceneManager.new({
        renderer = renderer,
        debug = Debug.new({ settings = settings, renderer = renderer })
    })
    local context = {
        manager = manager,
        renderer = renderer,
        settings = settings,
        texturePacks = texturePacks,
        contraptions = contraptions,
        stamps = stamps,
        puzzles = puzzles,
        progress = Progress.new(),
        registry = registry,
        mods = mods
    }
    for name, Scene in pairs(scenes) do
        manager:register(name, Scene.new(context))
    end
    for _, callback in ipairs(SceneManager.callbacks) do
        love[callback] = function(...) manager[callback](manager, ...) end
    end

    Events.emit("game:ready", context)
    manager:switch("menu")
end

function Game.reload()
    love.audio.stop()
    purge()
    Game.load()
end

return Game
