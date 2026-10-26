local markers = require("src/constants/markers").markers

return {
    editor = {
        history = { max = 200 },
        grid = {
            text = {
                clear = {
                    title = "Clear Grid",
                    message = "Remove every cell and marker from the grid?",
                    confirm = "Clear",
                    done = "Cleared the grid",
                    empty = "The grid is already empty"
                },
                initial = { done = "Set the initial state" },
                resize = {
                    title = "Resize Grid",
                    message = "Cells outside the new size are removed.",
                    restart = " The simulation will be reset.",
                    confirm = "Resize",
                    width = "Width",
                    height = "Height",
                    done = "Resized the grid to %dx%d",
                    same = "The grid is already that size"
                }
            }
        },
        rotationEase = 20,
        turns = { e = 1, q = -1 },
        ghost = 0.5,
        label = {
            font = 12,
            margin = 12,
            left = 64,
            alpha = 0.5,
            fps = "%d fps",
            tick = "%d:%d",
            pass = "%d:%d.%d"
        },
        tools = {
            default = "brush",
            list = {
                {
                    id = "brush",
                    key = "1",
                    texture = "pencil",
                    title = "Brush",
                    description = "Paints the selected cell."
                },
                {
                    id = "bucket",
                    key = "2",
                    texture = "bucket",
                    title = "Bucket",
                    description = "Fills an area with the selected cell."
                },
                {
                    id = "selector",
                    key = "3",
                    texture = "select",
                    title = "Selector",
                    description = "Selects an area to copy, cut and paste."
                },
                {
                    id = "marker",
                    key = "4",
                    texture = "marker",
                    title = "Marker",
                    description = "Places visual markers and backgrounds."
                }
            }
        },
        properties = {
            margin = 12,
            pad = 12,
            gap = 8,
            control = 240,
            font = 20,
            label = { font = 16, gap = 12 }
        },
        brush = {
            default = { size = 1, shape = "square" },
            size = { min = 1, max = 32 },
            shapes = {
                square = {
                    texture = "brush_square",
                    title = "Square",
                    description = "Paints a square area."
                },
                circle = {
                    texture = "brush_circle",
                    title = "Circle",
                    description = "Paints a circular area."
                }
            },
            buttons = {
                {
                    kind = "icon",
                    id = "shape",
                    texture = "brush_square",
                    title = "Square",
                    description = ""
                },
                { kind = "separator", id = "divider" },
                {
                    kind = "icon",
                    id = "decrease",
                    texture = "brush_decrease",
                    title = "Smaller",
                    description = "Decreases the brush size.",
                    gap = 0
                },
                {
                    kind = "label",
                    id = "size",
                    width = 32,
                    gap = 0
                },
                {
                    kind = "icon",
                    id = "increase",
                    texture = "brush_increase",
                    title = "Larger",
                    description = "Increases the brush size."
                }
            }
        },
        selection = {
            shortcuts = {
                plain = {
                    c = "copy",
                    x = "cut",
                    v = "paste"
                },
                shifted = { c = "export", v = "import" }
            },
            buttons = {
                {
                    kind = "icon",
                    id = "copy",
                    texture = "copy",
                    title = "Copy",
                    description = "Copies the selection."
                },
                {
                    kind = "icon",
                    id = "cut",
                    texture = "cut",
                    title = "Cut",
                    description = "Cuts the selection."
                },
                {
                    kind = "icon",
                    id = "paste",
                    texture = "paste",
                    title = "Paste",
                    description = "Pastes the copied area."
                },
                {
                    kind = "icon",
                    id = "export",
                    folder = "cells",
                    texture = "generator",
                    rotation = -math.pi / 2,
                    title = "Copy Code",
                    description = "Copies the selection as a code."
                },
                {
                    kind = "icon",
                    id = "import",
                    folder = "cells",
                    texture = "generator",
                    rotation = math.pi / 2,
                    title = "Paste Code",
                    description = "Pastes a code from the clipboard."
                },
                {
                    kind = "icon",
                    id = "stamps",
                    texture = "stamp",
                    title = "Stamps",
                    description = "Opens your saved stamps."
                },
                {
                    kind = "icon",
                    id = "save",
                    texture = "stamp_add",
                    title = "Save Stamp",
                    description = "Saves the selection as a stamp."
                }
            },
            text = {
                copied = "Copied selection",
                cut = "Cut selection",
                exported = "Copied selection code to the clipboard",
                empty = "Nothing to paste",
                stamp = {
                    title = "Save Stamp",
                    message = "Name your stamp.",
                    confirm = "Save",
                    default = "Stamp",
                    saved = "Saved stamp \"%s\"",
                    failed = "Couldn't save the stamp"
                }
            }
        },
        marker = {
            default = "arrow",
            color = 0xFFFFFF,
            rotating = markers.rotating,
            buttons = markers.buttons,
            prompt = {
                title = "Text Label",
                message = "Enter the text to display.",
                confirm = "Place"
            }
        }
    },

    controls = {
        slot = 40,
        pad = 8,
        margin = 12,
        play = {
            texture = "mover",
            rotation = 0,
            title = "Play",
            description = "Runs the simulation."
        },
        pause = {
            texture = "slider",
            rotation = math.pi / 2,
            title = "Pause",
            description = "Pauses the simulation."
        },
        buttons = {
            {
                id = "step",
                texture = "nudger",
                rotation = 0,
                title = "Step",
                description = "Advances the simulation by one tick.",
                col = 1,
                row = 0
            },
            {
                id = "toggle",
                col = 0,
                row = 0
            },
            {
                id = "reset",
                texture = "rotator_180",
                rotation = 0,
                title = "Reset",
                description = "Restores the grid to before the simulation started.",
                col = 0,
                row = 1,
                needsStart = true
            },
            {
                id = "initial",
                folder = "cells",
                texture = "timewarper",
                rotation = 0,
                col = 1,
                row = 1,
                needsStart = true,
                title = "Set Initial",
                description = "Sets the current grid as the initial state."
            }
        }
    },

    pauseMenu = {
        button = {
            size = 40,
            margin = 12,
            title = "Menu",
            description = "Opens the pause menu."
        },
        width = 340,
        pad = 12,
        row = {
            height = 48,
            icon = 28,
            gap = 14,
            font = 20
        },
        dim = 0.6,
        layouts = {
            editor = {
                {
                    id = "continue",
                    folder = "cells",
                    texture = "mover",
                    title = "Continue Editing"
                },
                {
                    id = "resize",
                    folder = "cells",
                    texture = "tetradisplacer_cw",
                    title = "Resize Grid"
                },
                {
                    id = "clear",
                    folder = "cells",
                    texture = "trash",
                    title = "Clear Grid"
                },
                {
                    id = "export",
                    folder = "cells",
                    texture = "generator",
                    rotation = -math.pi / 2,
                    title = "Export Level"
                },
                {
                    id = "puzzle",
                    folder = "ui",
                    texture = "puzzle",
                    title = "Load as Puzzle"
                },
                {
                    id = "options",
                    folder = "ui",
                    texture = "settings",
                    title = "Options"
                },
                {
                    id = "back",
                    folder = "cells",
                    texture = "rotator_ccw",
                    title = "Back to Contraptions"
                }
            },
            puzzle = {
                {
                    id = "continue",
                    folder = "cells",
                    texture = "mover",
                    title = "Continue Playing"
                },
                {
                    id = "reset",
                    folder = "cells",
                    texture = "rotator_180",
                    title = "Reset Puzzle"
                },
                {
                    id = "options",
                    folder = "ui",
                    texture = "settings",
                    title = "Options"
                },
                {
                    id = "back",
                    folder = "cells",
                    texture = "rotator_ccw",
                    title = "Back to Puzzles"
                }
            },
            custom = {
                {
                    id = "continue",
                    folder = "cells",
                    texture = "mover",
                    title = "Continue Playing"
                },
                {
                    id = "reset",
                    folder = "cells",
                    texture = "rotator_180",
                    title = "Reset Puzzle"
                },
                {
                    id = "options",
                    folder = "ui",
                    texture = "settings",
                    title = "Options"
                },
                {
                    id = "back",
                    folder = "cells",
                    texture = "rotator_ccw",
                    title = "Exit Puzzle"
                }
            }
        }
    },

    toolMenu = {
        card = {
            width = 160,
            gap = 12,
            pad = 14
        },
        icon = 64,
        font = {
            title = 20,
            text = 12,
            key = 16
        },
        dim = 0.6
    },

    library = {
        width = 860,
        height = 560,
        margin = 24,
        pad = 12,
        gap = 8,
        dim = 0.6,
        sidebar = 200,
        placeholder = "Search cells...",
        empty = "No cells found...",
        all = { title = "All", icon = "cellove" },
        category = {
            height = 44,
            font = 16,
            inset = 10,
            icon = 28,
            gap = 10,
            count = { font = 12, alpha = 0.4 }
        },
        row = {
            height = 56,
            icon = 40,
            add = 24,
            pad = 12,
            font = { title = 16, category = 12 }
        },
        sort = {
            width = 200,
            height = 36,
            font = 16,
            inset = 12,
            slide = 10,
            speed = 20
        },
        filter = {
            size = 40,
            title = "Sort",
            description = "Changes how cells are ordered."
        },
        reset = {
            texture = "rotator_180",
            size = 40,
            title = "Reset Toolbar",
            description = "Restores the default toolbar layout.",
            prompt = {
                title = "Reset Toolbar",
                message = "Restore the toolbar's orignal cell layout?",
                confirm = "Reset"
            }
        },
        add = { title = "Add to Toolbar", description = "Adds the cell to the toolbar." },
        remove = { title = "Remove from Toolbar", description = "Removes the cell from the toolbar." },
        sorts = {
            { id = "category", title = "Category (A-Z)" },
            { id = "name", title = "Name (A-Z)" },
            { id = "nameDesc", title = "Name (Z-A)" },
            { id = "subtick", title = "Subtick" }
        }
    }
}
