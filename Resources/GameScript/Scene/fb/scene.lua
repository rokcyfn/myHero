--[[
称雄
]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local FbLayer = require(SRC.."Scene/fb/fbLayer")


local M = {}

function M:create()
	local scene = display.newScene("fb")

	---------------插入layer---------------------
	local Layer = FbLayer:new(0,0)
	scene:addChild(Layer:getLayer())

	---------------------------------------------

	return scene
end

return M
