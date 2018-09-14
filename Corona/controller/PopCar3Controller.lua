local sceneName = Car3Controller

-- Include
local view = require("view.PopCar3View")
local model = require("model.PopCar3Model")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )

-- finish car upload
local carUploaded = function( event )
    print("--------------- CAR UPLOADED ---------------")
    print(event.response)

    local vehicle_id = appData.json.decode(event.response)
    vehicle_id = vehicle_id.vehicle_id

    -- update car
    model.updateCarID(vehicle_id )

    -- save car
    model.saveCar() 
end

-- upload car 
local uploadCar = function()
        print("uploading car")

        --prepare data
        local url = "https://api.sammevei.no/api/1/users/current/vehicles" 

        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        headers["Authorization"] = "Bearer "..appData.session.accessToken
          
        local params = {}
        params.headers = headers
        params.body = 
            'license_plate='..
            utils.urlEncode(appData.car.license_plate)..
            '&'..
            'make='..
            utils.urlEncode(appData.car.make)..
            '&'..
            'model='..
            utils.urlEncode(appData.car.model)..
            '&'..
            'year='..
            utils.urlEncode(appData.car.year)..
            '&'..
            'color='..
            utils.urlEncode(appData.car.color)..
            '&'..
            'seats='..
            utils.urlEncode(appData.car.seats)..
            '&'..
            'vehicle_type_id='..
            utils.urlEncode(appData.car.vehicle_type_id)..
            '&'..
            'vehicle_engine_type_id='..
            utils.urlEncode(appData.car.vehicle_engine_type_id)

            print(params.body)

        -- send request
        network.request( url, "POST", carUploaded, params)   
end




-- Forward
local forwardPress= function(event)
    if ( event.phase == "began" ) then
        view.forwardButton.alpha = 0.5
        
        local engineType = "0"
        if (view.petrolSwitch.isOn) then engineType = "1"
        elseif (view.dieselSwitch.isOn) then engineType = "2"
        elseif (view.electricSwitch.isOn) then engineType = "5"
        end

        model.updateCar(engineType)
        model.saveCar()
        uploadCar()

        native.setKeyboardFocus( nil )

        -- composer.removeScene( "controller.PopCar3Controller" )
        composer.hideOverlay()

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

        local engineType = 0
        if (view.petrolSwitch.isOn) then engineType = 1
        elseif (view.dieselSwitch.isOn) then engineType = 2
        elseif (view.electricSwitch.isOn) then engineType = 5
        end

        model.updateCar(engineType)

        composer.removeScene( "controller.Car3Controller" )
        composer.showOverlay( "controller.Car2Controller" )

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
    appData.restart = true
 
    view.sceneGroup = self.view

    -- Show Background
    -- view.showBackground()

    -- Show PostJourney 
    view.showJourneyMenu()

    -- Show Buttons
    view.showButtons()

    -- Add listeners to objects located in the view
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