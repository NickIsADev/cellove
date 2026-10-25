return {
    reload = {
        roots = {
            ["src/"] = true,
            ["content/"] = true,
            ["mods/"] = true
        },
        keep = { ["src/engine/core/Game"] = true, ["src/engine/graphics/Display"] = true } -- these are kept during a mod reload, otherwise game would basically explode :boom:
    }
}
