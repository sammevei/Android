local sceneName = EmptyController

-- Include
-- Include
local view = require("view.EmptyView")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )



-- -----------------------------------------------------------------------------------
-- Scene Functions
-- -----------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- Scene components
-- -----------------------------------------------------------------------------------
local scene = composer.newScene()
local sceneGroup

-- create()
function scene:create( event )
    view.sceneGroup = self.view
    local phase = event.phase 

    view.background()   
end
 
function scene:show( event )
 
    view.sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then

    elseif ( phase == "did" ) then

    end
end
 
-- hide()
function scene:hide( event )
 
    view.sceneGroup = self.view
    local phase = event.phase

end

-- destroy()
function scene:destroy( event )
 
    view.sceneGroup = self.view
    local phase = event.phase

end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene