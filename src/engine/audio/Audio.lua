local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.audio

local state = {
    volume = { music = 1, sfx = 1 },
    speed = 1,
    sounds = {},
    tracks = {},
    index = 0
}

local function find(folder, file)
    local path
    for _, id in ipairs(state.packs:stack()) do
        path = string.format("%s/%s/%s", state.packs:path(id), config.folder, folder)
        if file then path = path .. "/" .. file end
        if love.filesystem.getInfo(path) then break end
    end
    return path
end

local function scan(directory)
    local tracks = {}
    for _, item in ipairs(love.filesystem.getDirectoryItems(directory)) do
        if utils.has(config.formats, item:lower():match("%.%w+$")) then
            tracks[#tracks + 1] = directory .. "/" .. item
        end
    end

    table.sort(tracks)
    return tracks
end

local function start(index)
    if state.music then state.music:stop() end

    state.index = index
    state.music = love.audio.newSource(state.tracks[index], "stream")
    state.music:setVolume(state.volume.music)
    state.music:setPitch(state.speed)
    state.music:play()
end

local function load()
    local directory = find(config.music)
    if directory == state.directory then return end

    if state.music then state.music:stop() end
    state.directory, state.tracks, state.music = directory, scan(directory), nil
    if #state.tracks > 0 then start(1) end
end

local Audio = {}

function Audio.new(data)
    state.packs = data.texturePacks

    data.settings:listen("musicVolume", function(percent)
        state.volume.music = percent / 100
        if state.music then state.music:setVolume(state.volume.music) end
    end)
    data.settings:listen("sfxVolume", function(percent) state.volume.sfx = percent / 100 end)
    data.settings:listen("musicSpeed", function(percent)
        state.speed = percent / 100
        if state.music then state.music:setPitch(state.speed) end
    end)
    data.settings:listen("packs", function()
        state.sounds = {}
        load()
    end)
end

function Audio.play(name)
    local sound = state.sounds[name]
    if not sound then
        sound = love.audio.newSource(find(config.sfx, name .. config.extension), "static")
        state.sounds[name] = sound
    end

    sound:stop()
    sound:setVolume(state.volume.sfx)
    sound:play()
end

function Audio.update()
    if state.music and not state.music:isPlaying() then start(state.index % #state.tracks + 1) end
end

function Audio.stats()
    local music = state.music
    return {
        track = state.tracks[state.index],
        index = state.index,
        count = #state.tracks,
        time = music and music:tell() or 0,
        duration = music and music:getDuration() or 0,
        sources = love.audio.getActiveSourceCount()
    }
end

return Audio
