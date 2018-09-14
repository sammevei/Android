local sceneName = Car1Controller

-- Include
local view = require("view.Car1View")
local model = require("model.Car1Model")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )

-- Forward
local forwardPress= function(event)
    if ( event.phase == "began" ) then
        view.forwardButton.alpha = 0.5
        model.updateCar(view.factoryField.text, view.modelField.text)

        composer.removeScene( "controller.Car1Controller" )
        composer.gotoScene( "controller.Car2Controller" )

    elseif ( event.phase == "ended" ) then
        view.forwardButton.alpha = 1
        -- composer.removeScene( "controller.PlacesController" )
        -- composer.showOverlay( "controller.DatesController" )
    end 
end

-- Back
local backPress= function(event)
    if ( event.phase == "began" ) then
        view.backButton.alpha = 0.5
        model.updateCar(view.factoryField.text, view.modelField.text)

        composer.removeScene( "controller.Car1Controller" )
        composer.gotoScene( "controller.RolesController" )

    elseif ( event.phase == "ended" ) then
        view.forwardButton.alpha = 1
        -- composer.removeScene( "controller.PlacesController" )
        -- composer.showOverlay( "controller.DatesController" )
    end 
end

-- Car Factory
local factoryFieldListener = function(event)
    if ( event.phase == "editing" ) then

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then

    end
end


-- Car Model
local modelFieldListener = function(event)
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
    view.factoryField:addEventListener( "userInput", factoryFieldListener )
    view.modelField:addEventListener( "userInput", modelFieldListener )
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

    if view.factoryField ~= nil then
      display.remove( view.factoryField )
      view.factoryField = nil
    end

    if view.modelField ~= nil then
      display.remove( view.modelField )
      view.modelField = nil
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