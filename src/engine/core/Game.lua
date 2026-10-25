local manager

local function purge()
    local config = require("src/constants").reload

    require("src/engine/modding/Patcher").unhook()
    for name in pairs(package.loaded) do
        if config.roots[name:match("^[^/]+/")] and not config.keep[name] then package.loaded[name] = nil end
    end
end

local function draw(view, assets)
    local utils = require("src/utils")
    local constants = require("src/constants")
    local config, colors = constants.scene.boot, constants.ui.colors
    local loading, bar = constants.scene.loading, config.bar
    local w, h = love.window.fromPixels(love.graphics.getPixelDimensions())
    local cx, cy = w / 2, h / 2 - 16

    local spinner, font = assets.spinner, assets.font
    local sw, sh = spinner:getDimensions()
    local scale = loading.spinner.size / sw
    local top = cy + loading.spinner.size / 2 + 24
    local barY = top + font:getHeight() + bar.gap

    love.graphics.clear(0, 0, 0)
    love.graphics.setColor(utils.fromHex(colors.white))
    love.graphics.draw(spinner, cx, cy, love.timer.getTime() * loading.spinner.speed, scale, scale, sw / 2, sh / 2)

    love.graphics.setFont(font)
    love.graphics.print(view.text, cx - font:getWidth(view.text) / 2, top)

    love.graphics.setColor(utils.fromHex(colors.track))
    love.graphics.rectangle("fill", cx - bar.width / 2, barY, bar.width, bar.height)
    love.graphics.setColor(utils.fromHex(colors.accent))
    love.graphics.rectangle("fill", cx - bar.width / 2, barY, bar.width * view.progress, bar.height)
    love.graphics.setColor(utils.fromHex(colors.white))
end

local function boot()
    local constants = require("src/constants")
    local config = constants.scene.boot

    local function step(name, fraction)
        local stage = config.stages[name]
        coroutine.yield(stage.text, stage.from + (stage.to - stage.from) * (fraction or 0))
    end

    step("settings")
    local Settings = require("src/engine/data/Settings")
    local Mods = require("src/engine/sources/Mods")
    local settings = Settings.new()
    local mods = Mods.new({ settings = settings })

    step("mods")
    mods:load()

    step("scripts")
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

    step("graphics")
    Display.new({ settings = settings })
    local texturePacks = TexturePacks.new({ settings = settings, mods = mods })
    Audio.new({ settings = settings, texturePacks = texturePacks })
    local renderer = Renderer.new({ texturePacks = texturePacks, settings = settings })

    step("registry")
    local registry = Registry.new({ mods = mods })
    local classes = registry:list()

    for first = 1, #classes, config.chunk do
        step("textures", (first - 1) / #classes)
        renderer:preload(classes, first, math.min(first + config.chunk - 1, #classes))
    end

    step("content")
    local contraptions = Contraptions.new({ registry = registry })
    local stamps = Contraptions.new({ registry = registry, root = constants.stamps.root })
    local puzzles = Puzzles.new({ contraptions = contraptions, mods = mods })
    Window.new({ settings = settings, texturePacks = texturePacks })

    step("scenes")
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

local Game = {}

function Game.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    local constants = require("src/constants")
    local config = constants.scene.boot
    local assets = {
        font = love.graphics.newFont(config.font, constants.scene.loading.size, "normal", love.graphics.getDPIScale()),
        spinner = love.graphics.newImage(config.spinner)
    }
    local routine = coroutine.create(boot)
    local view = { text = config.text, progress = 0 }
    local drawn = false

    love.update = function()
        if not drawn then return end

        drawn = false
        local ok, text, progress = coroutine.resume(routine)
        if not ok then error(debug.traceback(routine, text), 0) end
        if coroutine.status(routine) == "suspended" then view.text, view.progress = text, progress end
    end
    love.draw = function()
        draw(view, assets)
        drawn = true
    end
end

function Game.reload()
    love.audio.stop()
    purge()
    Game.load()
end

return Game
