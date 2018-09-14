local sceneName = RolesController

-- Include
local view = require("view.RolesView")
local model = require("model.RolesModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )

-- USER MODE
local modeUploaded = function(event)
    print("mode uploaded")
    print(event.response)
end

local uploadMode = function()
    print("uploading mode")

    --prepare data
    local url = "https://api.sammevei.no/api/1/users/current/settings" 

    if (view.driverSwitch.isOn) then appData.mode = "driver"
    elseif (view.passengerSwitch.isOn) then appData.mode = "passenger"
    elseif (view.bothSwitch.isOn) then appData.mode = "both"
    end

    local predominant 
    
    if appData.mode == "passenger" then
        predominant = "1"
    elseif  appData.mode == "driver" then   
        predominant = "2"
    elseif appData.mode == "both" then
        predominant = "3" 
    end     

    local headers = {}
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Authorization"] = "Bearer "..appData.session.accessToken
      
    local params = {}
    params.headers = headers
    params.body = 'predominant='..utils.urlEncode(predominant)
    print(params.body)

    -- send request
    network.request( url, "PUT", modeUploaded, params)  
end

-- SCHEDULE
-- ------------------------------------------------------------------------------------------ --

-- save current schedule
local saveSchedule = function(event)
    print("--------------- SCHEDULE DOWNLOADED ---------------")
    print(event.response)

    -- decode
    appData.schedule = appData.json.decode( event.response )

    -- sort
    appData.schedule = model.sortSchedule(appData.schedule)

    -- save
    model.saveSchedule(appData.schedule) 

    -- Go Further
    if (appData.mode == "passenger") then
        composer.removeScene( "controller.RolesController" )
        composer.gotoScene( "controller.SetupController" )
    else
        composer.removeScene( "controller.RolesController" )
        composer.gotoScene( "controller.Car1Controller" )
    end 
end

-- get current schedule
local getSchedule = function()

    --prepare data
    local url = "https://api.sammevei.no/api/1/users/current/schedules"

    local headers = {}
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Authorization"] = "Bearer "..appData.session.accessToken
      
    local params = {}
    params.headers = headers

    -- send request
    network.request( url, "GET", saveSchedule, params)    
end

-- finish schedule upload
local scheduleUploaded = function( event )
    print("--------------- SCHEDULE UPLOADED ---------------")
    print(event.response)
    getSchedule()
end

-- upload schedule 
local uploadSchedule = function()

    print("uploading schedule in setup")

    --prepare data
    local url = "https://api.sammevei.no/api/1/users/current/schedules" 

    local headers = {}
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Authorization"] = "Bearer "..appData.session.accessToken
      
    local params = {}
    params.headers = headers

    -- MONDAY ------------------------------------------------

    local monday = 
    -- morning
    utils.urlEncode('mon[0][from_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[1].from_address_id)..
    '&'..

    utils.urlEncode('mon[0][to_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[1].to_address_id)..
    '&'..

    utils.urlEncode('mon[0][time_offset]')..
    '='..
    utils.urlEncode(appData.schedule[1].time_offset)..
    '&'..

    utils.urlEncode('mon[0][mode]')..
    '='..
    utils.urlEncode(appData.schedule[1].mode)..
    '&'..

    utils.urlEncode('mon[0][is_enabled]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[1].is_enabled))..
    '&'..

    utils.urlEncode('mon[0][time_flex]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[1].time_flex/60))..
    '&'..

    -- afternoon 
    utils.urlEncode('mon[1][from_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[2].from_address_id)..
    '&'..

    utils.urlEncode('mon[1][to_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[2].to_address_id)..
    '&'..

    utils.urlEncode('mon[1][time_offset]')..
    '='..
    utils.urlEncode(appData.schedule[2].time_offset)..
    '&'..

    utils.urlEncode('mon[1][mode]')..
    '='..
    utils.urlEncode(appData.schedule[2].mode)..
    '&'..

    utils.urlEncode('mon[1][is_enabled]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[2].is_enabled)) ..
    '&'..

    utils.urlEncode('mon[1][time_flex]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[2].time_flex/60))..
    '&'

    -- TUESDAY ------------------------------------------------
    local tuesday = 
    -- morning
    utils.urlEncode('tue[0][from_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[3].from_address_id)..
    '&'..

    utils.urlEncode('tue[0][to_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[3].to_address_id)..
    '&'..

    utils.urlEncode('tue[0][time_offset]')..
    '='..
    utils.urlEncode(appData.schedule[3].time_offset)..
    '&'..

    utils.urlEncode('tue[0][mode]')..
    '='..
    utils.urlEncode(appData.schedule[3].mode)..
    '&'..

    utils.urlEncode('tue[0][is_enabled]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[3].is_enabled))..
    '&'..

    utils.urlEncode('tue[0][time_flex]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[3].time_flex/60))..
    '&'..

    -- afternoon 
    utils.urlEncode('tue[1][from_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[4].from_address_id)..
    '&'..

    utils.urlEncode('tue[1][to_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[4].to_address_id)..
    '&'..

    utils.urlEncode('tue[1][time_offset]')..
    '='..
    utils.urlEncode(appData.schedule[4].time_offset)..
    '&'..

    utils.urlEncode('tue[1][mode]')..
    '='..
    utils.urlEncode(appData.schedule[4].mode)..
    '&'..

    utils.urlEncode('tue[1][is_enabled]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[4].is_enabled)) ..
    '&'..

    utils.urlEncode('tue[1][time_flex]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[4].time_flex/60))..
    '&'  


    -- WEDNESDAY ------------------------------------------------
    local wednesday =
    -- morning
    utils.urlEncode('wed[0][from_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[5].from_address_id)..
    '&'..

    utils.urlEncode('wed[0][to_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[5].to_address_id)..
    '&'..

    utils.urlEncode('wed[0][time_offset]')..
    '='..
    utils.urlEncode(appData.schedule[5].time_offset)..
    '&'..

    utils.urlEncode('wed[0][mode]')..
    '='..
    utils.urlEncode(appData.schedule[5].mode)..
    '&'..

    utils.urlEncode('wed[0][is_enabled]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[5].is_enabled))..
    '&'..

    utils.urlEncode('wed[0][time_flex]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[5].time_flex/60))..
    '&'..

    -- afternoon 
    utils.urlEncode('wed[1][from_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[6].from_address_id)..
    '&'..

    utils.urlEncode('wed[1][to_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[6].to_address_id)..
    '&'..

    utils.urlEncode('wed[1][time_offset]')..
    '='..
    utils.urlEncode(appData.schedule[6].time_offset)..
    '&'..

    utils.urlEncode('wed[1][mode]')..
    '='..
    utils.urlEncode(appData.schedule[6].mode)..
    '&'..

    utils.urlEncode('wed[1][is_enabled]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[6].is_enabled)) ..
    '&'..

    utils.urlEncode('wed[1][time_flex]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[6].time_flex/60))..
    '&'  


    -- THURSDAY ------------------------------------------------
    local thursday = 
    -- morning
    utils.urlEncode('thu[0][from_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[7].from_address_id)..
    '&'..

    utils.urlEncode('thu[0][to_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[7].to_address_id)..
    '&'..

    utils.urlEncode('thu[0][time_offset]')..
    '='..
    utils.urlEncode(appData.schedule[7].time_offset)..
    '&'..

    utils.urlEncode('thu[0][mode]')..
    '='..
    utils.urlEncode(appData.schedule[7].mode)..
    '&'..

    utils.urlEncode('thu[0][is_enabled]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[7].is_enabled))..
    '&'..
    
    utils.urlEncode('thu[0][time_flex]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[7].time_flex/60))..
    '&'..

    -- afternoon 
    utils.urlEncode('thu[1][from_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[8].from_address_id)..
    '&'..

    utils.urlEncode('thu[1][to_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[8].to_address_id)..
    '&'..

    utils.urlEncode('thu[1][time_offset]')..
    '='..
    utils.urlEncode(appData.schedule[8].time_offset)..
    '&'..

    utils.urlEncode('thu[1][mode]')..
    '='..
    utils.urlEncode(appData.schedule[8].mode)..
    '&'..

    utils.urlEncode('thu[1][is_enabled]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[8].is_enabled)) ..
    '&'..

    utils.urlEncode('thu[1][time_flex]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[8].time_flex/60))..
    '&'    

    -- FRIDAY ------------------------------------------------
    local friday = 
    -- morning
    utils.urlEncode('fri[0][from_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[9].from_address_id)..
    '&'..

    utils.urlEncode('fri[0][to_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[9].to_address_id)..
    '&'..

    utils.urlEncode('fri[0][time_offset]')..
    '='..
    utils.urlEncode(appData.schedule[9].time_offset)..
    '&'..

    utils.urlEncode('fri[0][mode]')..
    '='..
    utils.urlEncode(appData.schedule[9].mode)..
    '&'..

    utils.urlEncode('fri[0][is_enabled]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[9].is_enabled))..
    '&'..

    utils.urlEncode('fri[0][time_flex]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[9].time_flex/60))..
    '&'..

    -- afternoon 
    utils.urlEncode('fri[1][from_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[10].from_address_id)..
    '&'..

    utils.urlEncode('fri[1][to_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[10].to_address_id)..
    '&'..

    utils.urlEncode('fri[1][time_offset]')..
    '='..
    utils.urlEncode(appData.schedule[10].time_offset)..
    '&'..

    utils.urlEncode('fri[1][mode]')..
    '='..
    utils.urlEncode(appData.schedule[10].mode)..
    '&'..

    utils.urlEncode('fri[1][is_enabled]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[10].is_enabled)) ..
    '&'..

    utils.urlEncode('fri[1][time_flex]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[10].time_flex/60))..
    '&' 


    -- SATURDAY ------------------------------------------------
    local saturday = 
    -- morning
    utils.urlEncode('sat[0][from_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[11].from_address_id)..
    '&'..

    utils.urlEncode('sat[0][to_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[11].to_address_id)..
    '&'..

    utils.urlEncode('sat[0][time_offset]')..
    '='..
    utils.urlEncode(appData.schedule[11].time_offset)..
    '&'..

    utils.urlEncode('sat[0][mode]')..
    '='..
    utils.urlEncode(appData.schedule[11].mode)..
    '&'..

    utils.urlEncode('sat[0][is_enabled]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[11].is_enabled))..
    '&'..

    utils.urlEncode('sat[0][time_flex]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[11].time_flex/60))..
    '&'..

    -- afternoon 
    utils.urlEncode('sat[1][from_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[12].from_address_id)..
    '&'..

    utils.urlEncode('sat[1][to_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[12].to_address_id)..
    '&'..

    utils.urlEncode('sat[1][time_offset]')..
    '='..
    utils.urlEncode(appData.schedule[12].time_offset)..
    '&'..

    utils.urlEncode('sat[1][mode]')..
    '='..
    utils.urlEncode(appData.schedule[12].mode)..
    '&'..

    utils.urlEncode('sat[1][is_enabled]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[12].is_enabled)) ..
    '&'..

    utils.urlEncode('sat[1][time_flex]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[12].time_flex/60))..
    '&'

    -- SUNDAY ------------------------------------------------
    local sunday =
    -- morning
    utils.urlEncode('sun[0][from_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[13].from_address_id)..
    '&'..

    utils.urlEncode('sun[0][to_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[13].to_address_id)..
    '&'..

    utils.urlEncode('sun[0][time_offset]')..
    '='..
    utils.urlEncode(appData.schedule[13].time_offset)..
    '&'..

    utils.urlEncode('sun[0][mode]')..
    '='..
    utils.urlEncode(appData.schedule[13].mode)..
    '&'..

    utils.urlEncode('sun[0][is_enabled]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[13].is_enabled))..
    '&'..

    utils.urlEncode('sun[0][time_flex]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[13].time_flex/60))..
    '&'..    

    -- afternoon 
    utils.urlEncode('sun[1][from_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[14].from_address_id)..
    '&'..

    utils.urlEncode('sun[1][to_address_id]')..
    '='..
    utils.urlEncode(appData.schedule[14].to_address_id)..
    '&'..

    utils.urlEncode('sun[1][time_offset]')..
    '='..
    utils.urlEncode(appData.schedule[14].time_offset)..
    '&'..

    utils.urlEncode('sun[1][mode]')..
    '='..
    utils.urlEncode(appData.schedule[14].mode)..
    '&'..

    utils.urlEncode('sun[1][is_enabled]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[14].is_enabled))..
    '&'..

    utils.urlEncode('sun[1][time_flex]')..
    '='..
    utils.urlEncode(tostring(appData.schedule[14].time_flex/60))
    
    params.body = monday..
                tuesday..
                wednesday..
                thursday..
                friday..
                saturday..
                sunday

   print(params.body)
   -- print(monday)

    -- send request
    network.request( url, "POST", scheduleUploaded, params)   
end
-- Forward ---------------------------------------------------------------------------
appData.mode = ""

local forwardPress = function(event)
    if ( event.phase == "began" ) then
        view.forwardButton.alpha = 0.3

        if (view.driverSwitch.isOn) then appData.mode = "driver"
        elseif (view.passengerSwitch.isOn) then appData.mode = "passenger"
        elseif (view.bothSwitch.isOn) then appData.mode = "both"
        end
       
        model.updateUser(mode)
        -- model.saveUser()
        uploadMode()
        native.setKeyboardFocus( nil )

        --print("=========n I WILL CREATE AND UPLAD SCHEDULE ============")
        -- Create Schedule
        -- model.createSchedule()

        -- Upload Schedule
        -- uploadSchedule()

                -- Go Further
        if (appData.mode == "passenger") then
            composer.removeScene( "controller.RolesController" )
            composer.gotoScene( "controller.SetupController" )
        else
            composer.removeScene( "controller.RolesController" )
            composer.gotoScene( "controller.Car1Controller" )
        end 

    elseif ( event.phase == "ended" ) then
        view.forwardButton.alpha = 1
    end    
end

-- Back ------------------------------------------------------------------------------
local backPress= function(event)
    if ( event.phase == "began" ) then
        view.backButton.alpha = 0.5

        local mode = ""
        if (view.driverSwitch.isOn) then mode = "driver"
        elseif (view.passengerSwitch.isOn) then mode = "passenger"
        elseif (view.bothSwitch.isOn) then mode = "both"
        end

        model.updateTransport(mode)

        composer.removeScene( "controller.RolesController" )
        composer.gotoScene( "controller.DatesController" )

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
    appData.restart = false
 
    view.sceneGroup = self.view

    -- Show Background
    -- view.showBackground()

    -- Show TimeMenu
    view.showMenu()

    -- Show TimeButtons
    view.showButtons()

    -- Assign Listeners
    view.backButton:addEventListener( "touch", backPress)
    view.forwardButton:addEventListener( "touch", forwardPress)
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