return {
    updates = {
        thread = "src/engine/data/UpdatesThread.lua",
        url = {
            stable = "https://api.github.com/repos/nickisadev/CelLove/releases/latest",
            prerelease = "https://api.github.com/repos/nickisadev/CelLove/releases?per_page=1"
        },
        releases = "https://github.com/nickisadev/CelLove/releases/tag/v%s",
        agent = "CelLove",
        libraries = { "?.dll", "?.so", "../lib/?.so" },
        bundle = ".app/",
        pattern = '"tag_name"%s*:%s*"v?([^"]+)"',
        notice = {
            prerelease = {
                title = "Pre-release Build",
                message = "This is a pre-release version. Some things might not work as intended.\n\nIf you encounter any bugs, please report them via the Discord server.",
                confirm = "Okay",
                cancel = "Quit"
            },
            unsupported = {
                title = "Updates Unavailable",
                message = "This build is not bundled, and therefore cannot check for updates. You may be running an outdated build.\n\nDownload the bundled build for your platform from the GitHub Releases page.",
                confirm = "Okay"
            },
            outdated = {
                title = "Update Available",
                message = "Version %s is available! Download it from the GitHub releases page?",
                confirm = "Download"
            }
        }
    }
}
