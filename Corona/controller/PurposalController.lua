local sceneName = DatesController

-- Include
local view = require("view.PurposalView")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )
local routines = require( "misc.appRoutines" )

-- -----------------------------------------------------------------------------------
-- Scene Variables
-- -----------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------
-- Scene Functions

local onKeyEvent = function( event )
    if ( event.keyName == "back" ) then
        -- appData.showingMap = true
        -- appData.composer.hideOverlay()
        -- return true
    end
end

local hideTransportDetails = function(event)
    appData.showingMap = true
    appData.transportDetails = 0
    appData.appIsRunning = true
    appData.composer.hideOverlay()
    return true
end

local acceptProposal = function(event)
    -- access API


    -- hide proposal
    appData.showingMap = true
    appData.transportDetails = 0
    appData.appIsRunning = true
    appData.composer.hideOverlay()
    return true
end

local rejectProposal = function(event)
    -- access API

    -- hide proposal
    appData.showingMap = true
    appData.transportDetails = 0
    appData.appIsRunning = true
    appData.composer.hideOverlay()
    return true
end
-- Scene components
-- -----------------------------------------------------------------------------------
local scene = composer.newScene()

-- create()
function scene:create( event )

    print("TRANSPORT DETAILS CREATED")
    view.sceneGroup = self.view
    view.showBackground()
    view.showFooter(true)
    view.showDetails()
    view.showMap()
    view.showHeader()
end

-- show()
function scene:show( event )

    print("TRANSPORT DETAILS SHOW")

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)


    elseif ( phase == "did" ) then
        view.jaButton:addEventListener( "tap", acceptProposal )
        view.neiButton:addEventListener( "tap", rejectProposal )        
    end
end

-- hide()
function scene:hide( event )

    print("TRANSPORT DETAILS HIDE")

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

    print("TRANSPORT DETAILS DESTROY")

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
Runtime:addEventListener( "key", onKeyEvent )
-- -----------------------------------------------------------------------------------

return scene
