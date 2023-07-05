--[[
    Just some local utilities to get everything to work properly
]]

local addon = ""
local func_counter = 0
local function ReadFile(path)
    local file = io.open("../panel/" .. path, "r")
    local content = file:read("*a")
    file:close()

    return content
end

local function WriteFile(path, content, mode)
    local file = io.open("../panel/" .. path, mode or "w")
    file:write(content)
    file:close()
end

--[[
    This function create an error with the count of instructions that was given.
    If you use CopyFolder() and then ReplaceLine, but an Error occurs in ReplaceLine, the error will look like this:
    [Your addon #2(2 because ReplaceLine was the second instruction)] found no line!
]]
local orig_error = error
local function error(msg, level)
    orig_error("[" .. addon .. " #" .. tostring(func_counter) .. "]" .. msg, level)
end

--[[
    Some functions for CopyFolder to properly worked.
]]
local BinaryFormat = package.cpath:match("%p[\\|/]?%p(%a+)")
if BinaryFormat == "dll" then
    function os.name()
        return "Windows"
    end
elseif BinaryFormat == "so" then
    function os.name()
        return "Linux"
    end
elseif BinaryFormat == "dylib" then
    function os.name()
        return "MacOS"
    end
end
BinaryFormat = nil

local meta = getmetatable("")
function meta:__index(key)
	local val = string[key]
	if val ~= nil then
		return val
	elseif tonumber(key) then
		return string.sub(self, key, key)
	end
end

local last = 0
function string.Replace(str, rep, new)
    local new_str = str
    last = 0
    for k=1, 10 do
        local found, finish = string.find(new_str, rep, last, true)
        if found then
            new_str = string.sub(new_str, 1, found - 1) .. new .. string.sub(new_str, found + 1)
            last = found + 1
        end
    end

    return new_str
end

local function FindString(content, text)
    for k=1, #content do
        local sub = string.sub(content, k, #text + k)
        local right = 0
        for v=1, #text do
            if text[v] == sub[v] then
                right = right + 1
            end
        end

        if right == #text then
            return k, k + #text
        end
    end

    return false
end

local function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile
    if os.name() == "Windows" then
        pfile = popen('dir "'..directory..'" /b /a') -- Windows
    else
        pfile = popen('find "'..directory..'" -type f') -- Linux
    end

    for filename in pfile:lines() do
        i = i + 1

        t[i] = filename
    end
    pfile:close()
    return t
end

local function GetPath(file)
    local last = 0
    for k=1, 20 do
        local current = string.find(file, "/", last + 1)
        if current == nil then
            break
        end

        last = current
    end

    return string.sub(file, 1, last)
end


--[[
    All functions that can be used.
]]


--[[
    This function will replace the first occurrence of the given line with the given text.
    ReplaceLine:
        1. path = The path to the file like "routes/admin.php". All paths are relative to the panel folder.
        2. line = The line to search for. NOTE: You currently need to have exacly the same spaces.
        3. text = The text to replace the give line with.
]]
function ReplaceLine(path, line, text)
    func_counter = func_counter + 1
    local content = ReadFile(path)
    local pos1, pos2 = string.find(content, line, 1, true)
    if pos1 == nil or pos2 == nil then
        error("Found no line! pos1:" .. (pos or "nil"), 1)
    end

    local part1 = string.sub(content, 0, pos1 - 1)
    local part2 = string.sub(content, pos2 + 1)
    WriteFile(path, part1 .. text .. part2)
end

--[[
    This function will add the given text to the first occurrence of the given line.
    AddAfterLine:
        1. path = The path to the file like "routes/admin.php". All paths are relative to the panel folder.
        2. line = The line to search for. NOTE: You currently need to have exacly the same spaces.
        3. text = The text to add after the given line.
]]
function AddAfterLine(path, line, text)
    func_counter = func_counter + 1
    local content = ReadFile(path)
    local _, pos = string.find(content, line, 1, true)
    if pos == nil then
        error("Found no line! pos:" .. (pos or "nil"), 1)
    end

    local part1 = string.sub(content, 0, pos)
    local part2 = string.sub(content, pos + 1)
    WriteFile(path, part1 .. "\n" .. text .. part2)
end

--[[
    This function will insert the given text above the last occurrence of the given line.
    AddAboveLastLine:
        1. path = The path to the file like "routes/admin.php". All paths are relative to the panel folder.
        2. line = The line to search for. NOTE: You currently need to have exacly the same spaces.
        3. text = The text to add after the given line.
]]
function AddAboveLastLine(path, line, text)
    func_counter = func_counter + 1
    local content = ReadFile(path)
    local pos = 0
    local found
    while found == nil do
        local new_pos = string.find(content, line, pos+1, true)
        if new_pos == nil then
            found = true
        else
            pos = new_pos
        end
    end

    if pos == nil then
        error("Found no line! pos:" .. (pos or "nil") .. " line:"..line, 1)
    end

    pos = pos - 5

    local part1 = string.sub(content, 0, pos)
    local part2 = string.sub(content, pos)
    WriteFile(path, part1 .. text .. part2)
end

--[[
    This function will insert the given text above the first occurrence of the given line.
    AddAboveLine:
        1. path = The path to the file like "routes/admin.php". All paths are relative to the panel folder.
        2. line = The line to search for. NOTE: You currently need to have exacly the same spaces.
        3. text = The text to add after the given line.
]]
function AddAboveLine(path, line, text)
    func_counter = func_counter + 1
    local content = ReadFile(path)
    local pos = string.find(content, line, 1, true)
    if pos == nil then
        error("Found no line! pos:" .. (pos or "nil") .. " line:"..line, 1)
    end

    pos = pos - 5

    local part1 = string.sub(content, 0, pos)
    local part2 = string.sub(content, pos)
    WriteFile(path, part1 .. text .. part2)
end

--[[
    This function will append the given text to the end of the file.
    AppendFile:
        1. path = The path to the file like "routes/admin.php". All paths are relative to the panel folder.
        2. text = The text to append to the end of the file.
]]
function AppendFile(path, text)
    func_counter = func_counter + 1
    WriteFile(path, text, "a")
end

--[[
    This function will copy all files and folder from the given path into the panel folder
    CopyFolder:
        1. folder = The folder containing all files/folders that should be copied into the panel folder.
        2. additional = DO NOT ADD THIS ARGUMENT MANUALLY!
]]
function CopyFolder(folder, additional)
    if not additional then
        folder = addon .. "/" .. folder
    end
    local files = scandir(additional and (folder .. "/".. additional) or folder)
    for k, file in pairs(files) do
        local isfile = string.find(file, ".", 1, true)
        if isfile then
            local f
            if os.name() == "Windows" then
                f = io.open((folder .. "/" .. additional) .. "/" .. file, "rb")
                local content = f:read("*a")
                f:close()

                os.execute([[mkdir ..\panel\]] .. string.Replace(additional, "/", [[\]]))

                f = io.open("../panel/" .. additional .. file, "wb")
                f:write(content)
                f:close()
            else
                f = io.open(file, "rb")
                local content = f:read("*a")
                f:close()

                os.execute([[mkdir ../panel/]] .. string.Replace(GetPath(string.sub(file, #folder + 2)), "/", "/"))

                f = io.open("../panel/" .. string.sub(file, #folder + 2), "wb")
                f:write(content)
                f:close()
            end
        else
            additional = additional or ""
            local new_additional = additional .. (additional[#additional] == "/" and "" or "/") .. file .. "/"
            new_additional = new_additional[1] == "/" and string.sub(new_additional, 2) or new_additional
            CopyFolder(folder, new_additional)
        end
    end
end

--[[
    This function will add a command that should be executed before the panel is compiled.
    AddCommand:
        1. command = The command to execute before compiling the panel.
]]
function AddCommand(cmd)
    func_counter = func_counter + 1
    local f = io.open("additional_cmds.txt", "a")
    f:write(cmd .. "\n")
    f:close()
end

--[[
    This function will load the given addon.
    include:
        1. path = The path to the addon to load. All paths are relative to the addons folder.
]]
addons = {}
function include(path)
    addon = path
    addons[path] = true
    func_counter = 1
    print("Loading Addon: " .. path)
    local func, err = loadfile(path .. "/setup.lua")
    if err then
        error("Failed to load Addon: " .. path .. " error: " .. err)
    end

    func()
end

AddCommand("echo Running Commands") -- A basic command so that the additional_cmds.txt always exist.

include("server_router_icons")