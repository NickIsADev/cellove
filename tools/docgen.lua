-- this tool is for generating docs for the modding api
-- it is not called from the game whatsoever, only used for development :ahyes:

local source = "src/engine/modding/API.lua"
local target = "docs/API-Reference.md"
local markers = { first = "<!-- api:start -->", last = "<!-- api:end -->" }

local function escape(text)
    return (text:gsub("|", "\\|"))
end

local function anchor(text)
    return (text:lower():gsub("[^%w%s_-]", ""):gsub("%s", "-"))
end

local function lower(text)
    return (text:gsub("^%u%l", string.lower))
end

local function split(rest)
    local name, tail = rest:match("^(%S+)%s*(.*)$")
    local depth = 0

    for index = 1, #tail do
        local char = tail:sub(index, index)
        depth = depth + (char == "(" and 1 or char == ")" and -1 or 0)
        if char == " " and depth == 0 and tail:sub(index - 1, index - 1) ~= ":" then return name, tail:sub(1, index - 1), tail:sub(index + 1) end
    end
    return name, tail, ""
end

local function parse(path)
    local file = assert(io.open(path))
    local classes, functions, pending = {}, {}, { lines = {}, params = {}, example = {} }
    local class, writing

    for line in file:lines() do
        local text = line:match("^%s*%-%-%-(.*)$")
        local name, args = line:match("^%s*function ([%w_.]+)%((.-)%)")

        if name then
            if #pending.lines > 0 or #pending.params > 0 then
                functions[#functions + 1] = {
                    name = name,
                    args = args,
                    description = table.concat(pending.lines, " "),
                    params = pending.params,
                    returns = pending.returns,
                    example = pending.example
                }
            end
            pending = { lines = {}, params = {}, example = {} }
            writing = nil
        elseif text then
            local tag, rest = text:match("^@(%w+)%s*(.*)$")
            if tag == "class" then
                class = { name = rest, fields = {} }
                classes[#classes + 1] = class
            elseif tag == "field" then
                local field, kind, note = split(rest)
                class.fields[#class.fields + 1] = { name = field, type = kind, note = note }
            elseif tag == "param" then
                local param, kind, note = split(rest)
                pending.params[#pending.params + 1] = { name = param, type = kind, note = note }
            elseif tag == "return" then
                pending.returns = rest
            elseif tag == "example" then
                writing = pending.example
            elseif not tag and writing then
                writing[#writing + 1] = text
            elseif not tag then
                pending.lines[#pending.lines + 1] = (text:gsub("^%s+", ""))
            end
        elseif not line:match("^%s*$") then
            class = nil
        end
    end
    file:close()
    return classes, functions
end

local function group(functions)
    local sections, list = {}, {}

    for _, func in ipairs(functions) do
        local title = "api" .. (func.name:match("^api(%.%w+)%.") or "")
        if not sections[title] then
            sections[title] = { title = title, functions = {} }
            list[#list + 1] = sections[title]
        end
        table.insert(sections[title].functions, func)
    end
    return list
end

local function summary(func)
    return ((func.description:match("^(.-%.)%s") or func.description):gsub("%.$", ""))
end

local function signature(func)
    return string.format("%s(%s)", func.name, func.args)
end

local function render(classes, functions)
    local sections = group(functions)
    local out = { "## Contents", "" }

    for _, section in ipairs(sections) do
        out[#out + 1] = string.format("- [`%s`](#%s)", section.title, anchor(section.title))
    end
    out[#out + 1] = "- [Types](#types)"
    out[#out + 1] = ""

    for _, section in ipairs(sections) do
        out[#out + 1] = "## `" .. section.title .. "`"
        out[#out + 1] = ""
        out[#out + 1] = "| function | description |"
        out[#out + 1] = "| --- | --- |"
        for _, func in ipairs(section.functions) do
            out[#out + 1] = string.format("| [`%s`](#%s) | %s |", func.name, anchor(signature(func)), escape(lower(summary(func))))
        end
        out[#out + 1] = ""

        for _, func in ipairs(section.functions) do
            out[#out + 1] = "### `" .. signature(func) .. "`"
            out[#out + 1] = ""
            out[#out + 1] = func.description
            out[#out + 1] = ""
            if #func.params > 0 then
                out[#out + 1] = "| parameter | type | description |"
                out[#out + 1] = "| --- | --- | --- |"
                for _, param in ipairs(func.params) do
                    out[#out + 1] = string.format("| `%s` | `%s` | %s |", param.name, escape(param.type), escape(param.note))
                end
                out[#out + 1] = ""
            end
            if func.returns then
                out[#out + 1] = "**Returns** `" .. func.returns .. "`"
                out[#out + 1] = ""
            end
            if #func.example > 0 then
                out[#out + 1] = "```lua"
                for _, line in ipairs(func.example) do
                    out[#out + 1] = line
                end
                out[#out + 1] = "```"
                out[#out + 1] = ""
            end
        end
    end

    out[#out + 1] = "## Types"
    out[#out + 1] = ""
    out[#out + 1] = "Tables passed to the `add` functions. A trailing `?` marks an optional field."
    out[#out + 1] = ""
    for _, class in ipairs(classes) do
        out[#out + 1] = "### `" .. class.name .. "`"
        out[#out + 1] = ""
        out[#out + 1] = "| field | type | description |"
        out[#out + 1] = "| --- | --- | --- |"
        for _, field in ipairs(class.fields) do
            out[#out + 1] = string.format("| `%s` | `%s` | %s |", field.name, escape(field.type), escape(field.note))
        end
        out[#out + 1] = ""
    end
    return table.concat(out, "\n")
end

local file = assert(io.open(target))
local page = file:read("*a")
file:close()

local first = assert(page:find(markers.first, 1, true))
local last = assert(page:find(markers.last, 1, true))
local body = render(parse(source))

file = assert(io.open(target, "w"))
file:write(page:sub(1, first + #markers.first - 1), "\n", body, "\n", page:sub(last))
file:close()
