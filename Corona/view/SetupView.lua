local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )

local M = {}

-- background
M.background = function(event)
    appData.background = display.newImageRect( 
    	"images/Default.png", 
    	appData.screenW, 
    	appData.screenW*2.16533333333333 )
    appData.background.x = 160
    appData.background.y = 240
    appData.sceneGroup:insert( appData.background )
end 

return M