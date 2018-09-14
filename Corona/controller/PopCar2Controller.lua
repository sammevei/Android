local sceneName = Car2Controller

-- Include
local view = require("view.PopCar2View")
local model = require("model.PopCar2Model")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )

-- Forward
local forwardPress= function(event)
    if ( event.phase == "began" ) then
        view.forwardButton.alpha = 0.5
        model.updateCar(view.colorField.text, view.plateField.text)

        -- composer.removeScene( "controller.Car2Controller" )
        composer.showOverlay( "controller.PopCar3Controller" )        

    elseif ( event.phase == "ended" ) then
        view.forwardButton.alpha = 1
        -- composer.removeScene( "controller.PlacesController" )
        -- composer.showOverlay( "controller.DatesController" )
    end 
end

-- Back
local backPress= function(event)
    if ( event.phase == "began" ) then
        view.forwardButton.alpha = 0.5
        model.updateCar(view.colorField.text, view.plateField.text)

        composer.removeScene( "controller.Car2Controller" )
        composer.showOverlay( "controller.Car1Controller" )

    elseif ( event.phase == "ended" ) then
        view.forwardButton.alpha = 1
    end 
end

-- Car Factory
local colorFieldListener = function(event)
    if ( event.phase == "editing" ) then

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then

    end
end


-- Car Model
local plateFieldListener = function(event)
    if ( event.phase == "editing" ) then
     
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        
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

    -- Show PostJourney 
    view.showJourneyMenu()

    -- Show Buttons
    view.showButtons()

    -- Add listeners to objects located in the view
    view.colorField:addEventListener( "userInput", colorFieldListener )
    view.plateField:addEventListener( "userInput", plateFieldListener )
    view.forwardButton:addEventListener( "touch", forwardPress )
    view.backButton:addEventListener( "touch", backPress )
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

    if view.colorField ~= nil then
      display.remove( view.colorField )
      view.colorField = nil
    end

    if view.plateField ~= nil then
      display.remove( view.plateField )
      view.plateField = nil
    end    
 
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