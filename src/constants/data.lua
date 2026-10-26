local toolbar = require("src/constants/toolbar").toolbar
local markers = require("src/constants/markers").markers

return {
    settings = {
        path = "settings.cfg",
        defaults = {
            tickSpeed = 5,
            fullscreen = false,
            vsync = true,
            uiScale = 100,
            showFps = true,
            animatedBackground = true,
            cellAnimation = true,
            cellShadows = true,
            explosions = true,
            detailZoom = 30,
            musicVolume = 50,
            musicSpeed = 100,
            sfxVolume = 70,
            checkUpdates = true,
            debug = false,
            packs = "",
            mods = "",
            toolbar = table.concat(toolbar.layout, ","),
            seen = ""
        }
    },

    contraptions = {
        root = "contraptions",
        extension = ".cellove",
        pattern = "^(.+)%.[cC][eE][lL][lL][oO][vV][eE]$",
        prefix = { raw = "cl0:", deflate = "cl1:" },
        compression = "deflate",
        level = 9,
        alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!#$%()*+-;=?@^_{|}~,./:",
        kinds = markers.kinds,
        colorFlag = 64,
        custom = { code = 63, kinds = {} },
        maxName = 40,
        forbidden = "[\\/:*?\"<>|%c]",
        defaultName = "Contraption",
        importName = "Imported Contraption",
        errors = {
            prefix = "That's not a CelLove contraption.",
            corrupt = "Oh no! The contraption data is corrupted.",
            empty = "There's nothing in your clipboard to import.",
            unreadable = "The file couldn't be read."
        }
    },

    k3 = {
        prefix = "K3",
        alphabet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!$%&+-.=?^{}/#_*':,@~|",
        markers = {
            [117] = "x",
            [118] = "warning",
            [119] = "check",
            [120] = "question",
            [121] = "arrow",
            [122] = "diagonal_arrow",
            [680] = "exclamation",
            [681] = "stop",
            [682] = "like",
            [683] = "dislike",
            [708] = "label"
        },
        label = "?"
    },

    stamps = {
        root = "stamps",
        width = 560,
        height = 520,
        margin = 24,
        pad = 12,
        gap = 8,
        dim = 0.6,
        font = { title = 22, empty = 20 },
        folder = {
            size = 40,
            title = "Stamps Folder",
            description = "Opens the stamps folder."
        },
        exit = {
            size = 40,
            title = "Close",
            description = "Closes the stamps menu."
        },
        row = {
            height = 64,
            pad = 12,
            icon = 32,
            delete = 32,
            lineGap = 4,
            font = { name = 18, detail = 14 }
        },
        text = {
            title = "Stamps",
            empty = "No stamps yet...",
            invalid = "Unreadable file",
            detail = "%dx%d grid - %d cells",
            remove = { title = "Delete", description = "Deletes the stamp." },
            delete = {
                title = "Delete Stamp",
                message = "Delete \"%s\"? This can't be undone.",
                confirm = "Delete"
            }
        }
    },

    progress = { path = "progress.txt" }
}
