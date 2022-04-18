

local luasql = require "luasql.sqlite3"
local lfs = require "lfs"
local luautil = require "luautil"
local luasocket = require "socket"
local luasql = require "luasql.sqlite3"
local luasql_mysql = require "luasql.mysql"
local luasql_odbc = require "luasql.odbc"


local function get_file_list(path)
    local file_list = {}
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = path.."/"..file
            local attr = lfs.attributes (f)
            if attr.mode == "directory" then
                file_list = luautil.table_merge(file_list, get_file_list(f))
            else
                table.insert(file_list, f)
            end
        end
    end
    return file_list
end


function get_file_list_by_ext(path, ext)
    local file_list = {}
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = path.."/"..file
            local attr = lfs.attributes (f)
            if attr.mode == "directory" then
                file_list = luautil.table_merge(file_list, get_file_list_by_ext(f, ext))
            else
                if string.sub(file, -string.len(ext)) == ext then
                    table.insert(file_list, f)
                end
            end
        end
    end
    return file_list
end

local function scanxss()
    local file_list = get_file_list_by_ext(".", "php")
    for _, file in pairs(file_list) do
        local f = io.open(file, "r")
        local content = f:read("*all")
        f:close()
        if string.find(content, "eval") then
            print(file)
        end
    end
end
