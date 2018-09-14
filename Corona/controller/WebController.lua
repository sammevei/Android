local sceneName = MainController

-- Include
local view = require("view.CommutingView")
local model = require("model.CommutingModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )

-- -----------------------------------------------------------------------------------
-- Scene components
-- -----------------------------------------------------------------------------------
local scene = composer.newScene()

-- create()
function scene:create( event )
 
    view.sceneGroup = self.view

    -- Show Background
    view.showBackground()

    -- Show WebApp
    local function webListener( event )
      
    end

    local function loadWeb( self, event )       
            local webView = native.newWebView( 
                0 + display.screenOriginX, 
                0 + display.screenOriginY, 
                appData.screenW, 
                appData.screenH)
            webView:request( "https://digest.sammevei.no/prototype" )
            webView:addEventListener( "urlRequest", webListener )
            webView.alpha = 1;       
    end
   
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
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