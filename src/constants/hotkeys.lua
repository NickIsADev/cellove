return {
    hotkeys = {
        prefix = "key.",
        modifiers = { "ctrl", "shift", "alt" },
        ignored = {
            lctrl = true,
            rctrl = true,
            lshift = true,
            rshift = true,
            lalt = true,
            ralt = true,
            lgui = true,
            rgui = true
        },
        title = { text = "Hotkeys", size = 40 },
        reset = {
            title = "Reset",
            description = "Restores every hotkey to its default.",
            prompt = {
                title = "Reset Hotkeys",
                message = "Restore all hotkeys to their defaults?",
                confirm = "Reset"
            }
        },
        heading = 32,
        listening = "Press a key...",
        conflict = "Also used by: %s",
        tools = "Tools",
        list = {
            {
                id = "toggle",
                group = "Simulation",
                title = "Play / Pause",
                description = "Runs or pauses the simulation.",
                key = "space"
            },
            {
                id = "step",
                group = "Simulation",
                title = "Step",
                description = "Advances the simulation by one tick.",
                key = "f"
            },
            {
                id = "substep",
                group = "Simulation",
                title = "Substep",
                description = "Advances the simulation by one subtick.",
                key = "shift f"
            },
            {
                id = "reset",
                group = "Simulation",
                title = "Reset",
                description = "Restores the grid to before the simulation started.",
                key = "ctrl r"
            },
            {
                id = "undo",
                group = "Editor",
                title = "Undo",
                description = "Reverts the last change.",
                key = "ctrl z"
            },
            {
                id = "save",
                group = "Editor",
                title = "Save",
                description = "Saves the contraption.",
                key = "ctrl s"
            },
            {
                id = "library",
                group = "Editor",
                title = "Cell Library",
                description = "Opens the cell library.",
                key = "tab"
            },
            {
                id = "toolMenu",
                group = "Editor",
                title = "Tool Menu",
                description = "Opens the tool menu.",
                key = "`"
            },
            {
                id = "rotateCW",
                group = "Editor",
                title = "Rotate Clockwise",
                description = "Rotates the selected cell clockwise.",
                key = "e"
            },
            {
                id = "rotateCCW",
                group = "Editor",
                title = "Rotate Counterclockwise",
                description = "Rotates the selected cell counterclockwise.",
                key = "q"
            },
            {
                id = "selectAll",
                group = "Selection",
                title = "Select All",
                description = "Selects the whole grid.",
                key = "ctrl a"
            },
            {
                id = "copy",
                group = "Selection",
                title = "Copy",
                description = "Copies the selection.",
                key = "ctrl c"
            },
            {
                id = "cut",
                group = "Selection",
                title = "Cut",
                description = "Cuts the selection.",
                key = "ctrl x"
            },
            {
                id = "paste",
                group = "Selection",
                title = "Paste",
                description = "Pastes the copied area.",
                key = "ctrl v"
            },
            {
                id = "export",
                group = "Selection",
                title = "Copy Code",
                description = "Copies the selection as a code.",
                key = "ctrl shift c"
            },
            {
                id = "import",
                group = "Selection",
                title = "Paste Code",
                description = "Pastes a code from the clipboard.",
                key = "ctrl shift v"
            },
            {
                id = "moveUp",
                group = "Camera",
                title = "Move Up",
                description = "Moves the camera up.",
                key = "w"
            },
            {
                id = "moveDown",
                group = "Camera",
                title = "Move Down",
                description = "Moves the camera down.",
                key = "s"
            },
            {
                id = "moveLeft",
                group = "Camera",
                title = "Move Left",
                description = "Moves the camera left.",
                key = "a"
            },
            {
                id = "moveRight",
                group = "Camera",
                title = "Move Right",
                description = "Moves the camera right.",
                key = "d"
            }
        }
    }
}
