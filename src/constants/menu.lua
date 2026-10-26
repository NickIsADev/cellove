local info = require("src/constants/version").version

local function percent(value)
    return value .. "%"
end

local rows = {
    font = { text = 24 },
    top = { ratio = 0.16 },
    reset = {
        texture = "rotator_180",
        size = 40,
        margin = 24
    },
    row = {
        width = 640,
        height = 48,
        gap = 12,
        bottom = 8,
        pad = 16,
        margin = 16
    }
}

local function page(title, list)
    for _, row in ipairs(list) do
        row.height = rows.row.height
    end
    return { title = title, rows = list }
end

local options = {
    title = { text = "Options", size = 40 },
    main = "main",
    steps = { left = -1, right = 1 },
    reset = {
        title = "Reset",
        description = "Restores every option to its default.",
        prompt = {
            title = "Reset Options",
            message = "Restore all options to their defaults?",
            confirm = "Reset"
        }
    },
    link = {
        arrow = 32,
        gap = 12,
        none = "None",
        enabled = "%d enabled",
        failed = "%d failed",
        conflicts = "%d conflicting"
    },
    slider = {
        min = 60,
        gap = 16,
        track = 4,
        handle = { width = 8, height = 22 }
    }
}
options.pages = {
    main = page("Options", {
        {
            title = "Graphics",
            description = "Manage display, interface and render quality settings.",
            kind = "link",
            scene = "options",
            page = "graphics"
        },
        {
            title = "Audio",
            description = "Manage audio playback speed and volume.",
            kind = "link",
            scene = "options",
            page = "audio"
        },
        {
            title = "Hotkeys",
            description = "Manage the keyboard shortcuts.",
            kind = "link",
            scene = "hotkeys"
        },
        {
            title = "Texture Packs",
            description = "Enable, disable, and reorder your texture packs.",
            kind = "link",
            scene = "packs",
            source = "texturePacks"
        },
        {
            title = "Mods",
            description = "Enable, disable, and reorder your mods.",
            kind = "link",
            scene = "mods",
            source = "mods"
        },
        {
            key = "tickSpeed",
            title = "Tick Speed",
            description = "The rate at which the simulator steps.",
            kind = "slider",
            min = 1,
            max = 128,
            format = function(value) return value == 1 and "1 tick/s" or value .. " ticks/s" end
        },
        {
            key = "checkUpdates",
            title = "Check for Updates",
            description = "Checks GitHub for a newer release upon launch.",
            kind = "toggle"
        },
        {
            key = "debug",
            title = "Debug Mode",
            description = "Shows developer tools, overlays, and useful debugging statistics.",
            kind = "toggle"
        }
    }),
    graphics = page("Graphics", {
        {
            key = "fullscreen",
            title = "Fullscreen",
            description = "Toggles fullscreen mode.",
            kind = "toggle"
        },
        {
            key = "vsync",
            title = "VSync",
            description = "Syncs the framerate to your display's refresh rate to prevent screen tearing.",
            kind = "toggle"
        },
        {
            key = "uiScale",
            title = "UI Scale",
            description = "The scale of the interface.",
            kind = "slider",
            min = 50,
            max = 200,
            deferred = true,
            format = percent
        },
        {
            key = "showFps",
            title = "Show FPS",
            description = "Displays the frame rate on screen within the Editor.",
            kind = "toggle"
        },
        {
            key = "animatedBackground",
            title = "Animated Background",
            description = "Animates the grid background behind menus like this one.",
            kind = "toggle"
        },
        {
            key = "cellAnimation",
            title = "Cell Animation",
            description = "Animates cell movement and rotation.",
            kind = "toggle"
        },
        {
            key = "cellShadows",
            title = "Cell Shadows",
            description = "Draws shadows under cells.",
            kind = "toggle"
        },
        {
            key = "explosions",
            title = "Explosions",
            description = "Draws particles when cells explode.",
            kind = "toggle"
        },
        {
            key = "detailZoom",
            title = "Detail Zoom",
            description = "The zoom level at which cells stop being animated, shadows stop being drawn, and cell textures lose detail.",
            kind = "slider",
            min = 5,
            max = 100,
            format = percent
        }
    }),
    audio = page("Audio", {
        {
            key = "musicVolume",
            title = "Music Volume",
            description = "The volume of the music.",
            kind = "slider",
            min = 0,
            max = 100,
            format = percent
        },
        {
            key = "musicSpeed",
            title = "Music Speed",
            description = "The playback speed of the music.",
            kind = "slider",
            min = 50,
            max = 200,
            format = percent
        },
        {
            key = "sfxVolume",
            title = "SFX Volume",
            description = "The volume of sound effects.",
            kind = "slider",
            min = 0,
            max = 100,
            format = percent
        }
    })
}

return {
    menu = {
        title = {
            lines = { "CelLove", "Machine" },
            logo = { scale = 0.85, gap = 16 },
            bob = { speed = 2, height = 10 },
            y = 0.28,
            font = {
                min = 32,
                max = 64,
                step = 8,
                width = 12,
                height = 8
            }
        },
        button = {
            size = 100,
            gap = 56,
            y = 0.64,
            font = 16,
            label = { gap = 20 },
            list = {
                {
                    id = "sandbox",
                    folder = "cells",
                    texture = "mover",
                    title = "Sandbox",
                    scene = "contraptions"
                },
                {
                    id = "puzzles",
                    folder = "ui",
                    texture = "puzzle",
                    title = "Puzzles",
                    scene = "puzzles"
                },
                {
                    id = "options",
                    folder = "ui",
                    texture = "settings",
                    title = "Options",
                    scene = "options"
                }
            }
        },
        splash = {
            size = 20,
            shadow = 2,
            color = 0xFFE94D,
            angle = -0.2,
            pulse = { speed = 5, amount = 0.06 },
            list = {
                "push! push! push!",
                "debloated!",
                "please submit your cell suggestions",
                "quack!",
                "yes, it's written in Lua.",
                "a full rewrite of CelLua!",
                "powered by Love2D!",
                "cells... they're everywhere!",
                "thank you Sam Hogan!",
                "feel free to contribute!",
                "tick tock, tick tock!",
                "i wonder if you can build a computer with this",
                "hmm... what does this cell do?",
                "it's like Minecraft redstone!",
                "machine? engine? simulator?",
                "infinite possibilities!",
                "yippee kyyay!",
                "fast!",
                "batteries ARE included :)",
                "moddable!"
            }
        },
        credits = {
            button = {
                size = 40,
                margin = 12,
                alpha = { idle = 0.5, hover = 0.75 },
                title = "Credits",
                description = "See developers and contributors."
            },
            panel = {
                width = 440,
                pad = 28,
                gap = 16,
                row = 48,
                logo = 40,
                dim = 0.6,
                cap = 0.875,
                font = {
                    title = 32,
                    role = 14,
                    name = 20,
                    hint = 12
                }
            },
            title = "Credits",
            hint = "Click anywhere to close",
            entries = {
                { role = "Programming", name = "troptopreal" },
                { role = "UI Design", name = "troptopreal" },
                { role = "Textures", name = "KyYay" },
                { role = "Music/SFX", name = "KyYay" },
                { role = "Cell Machine", name = "Sam Hogan" }
            }
        },
        version = {
            text = {
                number = "v" .. info.number,
                build = "build " .. info.build,
                outdated = "Update available: v%s"
            },
            font = 12,
            margin = 12,
            alpha = { number = 0.7, build = 0.4, warning = 0.9 }
        },
        discord = {
            size = 40,
            gap = 8,
            alpha = { idle = 0.5, hover = 0.75 },
            title = "Discord",
            description = "Join our Discord server!",
            url = "https://discord.gg/sgyE9DmZXP"
        },
        quit = {
            size = 40,
            margin = 12,
            alpha = { idle = 0.5, hover = 0.75 },
            title = "Quit",
            description = "Closes the game."
        }
    },

    rows = rows,
    options = options,

    selector = {
        title = { text = "Contraptions", size = 40 },
        width = 580,
        margin = 16,
        gap = 12,
        top = {
            ratio = 0.16,
            min = 64,
            room = 320
        },
        bar = {
            size = 40,
            gap = 8,
            group = 16,
            inset = 8,
            font = 16
        },
        row = {
            height = 80,
            pad = 16,
            icon = 40,
            lineGap = 6,
            font = { name = 20, detail = 16 }
        },
        icons = { valid = "mover", invalid = "trash", missing = "ghost" },
        buttons = {
            {
                id = "new",
                group = 1,
                folder = "ui",
                texture = "add",
                title = "New",
                description = "Creates a new contraption."
            },
            {
                id = "import",
                group = 1,
                folder = "cells",
                texture = "generator",
                rotation = math.pi / 2,
                title = "Import",
                description = "Imports a contraption from the clipboard."
            },
            {
                id = "folder",
                group = 1,
                folder = "ui",
                texture = "folder",
                title = "Folder",
                description = "Opens the contraptions folder."
            },
            {
                id = "open",
                group = 2,
                folder = "cells",
                texture = "mover",
                title = "Open",
                description = "Opens the selected contraption."
            },
            {
                id = "puzzle",
                group = 2,
                folder = "ui",
                texture = "puzzle",
                title = "Load as Puzzle",
                description = "Plays the selected contraption as a puzzle."
            },
            {
                id = "rename",
                group = 2,
                folder = "ui",
                texture = "pencil",
                title = "Rename",
                description = "Renames the selected contraption."
            },
            {
                id = "export",
                group = 2,
                folder = "cells",
                texture = "generator",
                rotation = -math.pi / 2,
                title = "Export",
                description = "Copies the selected contraption to the clipboard."
            },
            {
                id = "delete",
                group = 2,
                folder = "cells",
                texture = "trash",
                title = "Delete",
                description = "Deletes the selected contraption."
            }
        },
        text = {
            empty = "Nothing to show here...",
            invalid = "Unreadable file",
            detail = "%dx%d grid - %d cells",
            date = "%d/%m/%Y %H:%M",
            count = { one = "%d contraption", other = "%d contraptions" },
            width = "Width",
            height = "Height",
            new = {
                title = "New Contraption",
                message = "Name your contraption.",
                confirm = "Create"
            },
            import = {
                title = "Import Contraption",
                message = "Name the imported contraption.",
                confirm = "Import"
            },
            rename = {
                title = "Rename Contraption",
                message = "Enter a new name.",
                confirm = "Rename"
            },
            delete = {
                title = "Delete Contraption",
                message = "Delete \"%s\"? This can't be undone.",
                confirm = "Delete"
            },
            missing = {
                title = "Missing Cells",
                message = "This contraption uses cells from mods that aren't loaded (%s). Editing or saving it will permanently erase those cells.",
                confirm = "Open"
            },
            toast = {
                imported = "Imported \"%s\"",
                renamed = "Renamed \"%s\" to \"%s\"",
                copied = "Copied \"%s\" to the clipboard",
                deleted = "Deleted \"%s\"",
                saved = "Saved \"%s\"",
                notSaved = "Couldn't save \"%s\"",
                saveFailed = "Couldn't write the file."
            }
        }
    }
}
