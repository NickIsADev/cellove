return {
    updates = {
        thread = "src/engine/data/UpdatesThread.lua",
        url = "https://api.github.com/repos/nickisadev/CelLove/releases/latest",
        releases = "https://github.com/nickisadev/CelLove/releases/latest",
        agent = "CelLove",
        pattern = '"tag_name"%s*:%s*"v?([^"]+)"',
        notice = {
            prerelease = {
                title = "Pre-release Build",
                message = "This is a pre-release version. Some things might not work as intended.\n\nIf you encounter any bugs, please report them via the Discord server.",
                confirm = "Okay",
                cancel = "Quit"
            },
            outdated = {
                title = "Update Available",
                message = "Version %s is available! Download it from the GitHub releases page?",
                confirm = "Download"
            }
        }
    }
}
