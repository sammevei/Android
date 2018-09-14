local sceneName = SummaryController

-- Include
local view = require("view.SummaryView")
local model = require("model.SummaryModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )

-- Forward ---------------------------------------------------------------------------
local enterPress = function(event)
    if ( event.phase == "began" ) then
        view.enterButton.alpha = 0.3

        -- Post Transport


    elseif ( event.phase == "ended" ) then
        view.enterButton.alpha = 1
    end    
end

-- Back ------------------------------------------------------------------------------
local backPress= function(event)
    if ( event.phase == "began" ) then
        view.backButton.alpha = 0.5

        if (appData.transport.role == "passenger") then
            composer.removeScene( "controller.SummaryController" )
            composer.showOverlay( "controller.RolesController" )
        else
            composer.removeScene( "controller.SummaryController" )
            composer.showOverlay( "controller.Car3Controller" )            
        end    

    elseif ( event.phase == "ended" ) then
        view.backButton.alpha = 1
    end 
end

-- -----------------------------------------------------------------------------------
-- Scene components
-- -----------------------------------------------------------------------------------
local scene = composer.newScene()

-- create()
function scene:create( event )
 
    view.sceneGroup = self.view

    -- Show Background
    -- view.showBackground()

    -- Show TimeMenu
    view.showMenu()

    -- Show TimeButtons
    view.showButtons()

    -- Assign Listeners
    view.enterButton:addEventListener( "touch", enterPress)
    view.backButton:addEventListener( "touch", backPress)
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