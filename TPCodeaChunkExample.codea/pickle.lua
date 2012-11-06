-- pickle

-- Based on pickle.lua at http://failboat.me/2010/serializing-lua-objects-into-lua-code/
-- Modified to work with Codea by Aaron Pendley (November 2012)
-- license unknown

local objects = {}
setmetatable(objects, {__index={["subset"]=function(object, proxies)
    for _,o in ipairs(proxies) do
        if object == o then return true end
    end
end}})

function _pickle(object, seen, indent)
    --if not seen then seen = {} end
    if not indent then indent = "" end

    local serialize_key = function(key)
        if type(key) == "string" then
            return "[\""..key.."\"]"
        elseif type(key) == "table" then
            return "[".._pickle(key):gsub("\n"," ").."]"
        else
            return "["..key.."]"
        end
        return key
    end

    local escape = function(o)
        return o:gsub("\\","\\\\"):gsub("'","\\'"):gsub('"','\\"')
    end

    --Switch Object type:
    if type(object) == "table" then
        local serialize = "{\n"
        for key, value in pairs(object) do
            serialize = serialize .. indent.."\t" .. serialize_key(key) .. " = " .. tostring(_pickle(value, seen, indent.."\t")) .. ",\n"
        end
        serialize = serialize .. indent .. "}"

        return serialize
    elseif type(object) == "string" then
        return '"' .. escape(object) .. '"'
    elseif type(object) == "function" then
        return "loadstring([["..string.dump(object).."]])"
    elseif objects.subset(object, {"userdata"}) then
        return nil
    end
    return tostring(object)
end

pickle = {}

function pickle.dumps(object)
    return "return ".. _pickle(object)
end

function pickle.dump(object, key)
    local dump = pickle.dumps(object)
    saveProjectData(key, dump)
    return dump
end

function pickle.loads(object)
    local fn = loadstring(object)
    if fn then
        return fn()
    end
end

function pickle.load(key)
    local dump = readProjectData(key)
    if dump then
        return pickle.loads(dump)
    end
end