local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )

local M = {}

-- background
M.background = function()
    appData.background = display.newImageRect( "images/IntroViewBackground.png", appData.screenH / 1.5, 0 )
    appData.background.x = 160
    appData.background.y = 5000
    appData.sceneGroup:insert( appData.background )
end 

return M