local sceneName = IntroController

-- Include
local view = require("view.ResumeView")
local model = require("model.ResumeModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )

-- Controller Functions
local r

local goFurther = function()

    -- cancel timer 
    timer.cancel( t1 )
    
    print("-----------------"..appData.user.mode)


    -- continue to next scene
    if (appData.user.lastName == "") then
        appData.composer.removeScene( "controller.IntroController" ) 
        appData.composer.gotoScene( "controller.UpdateUserController" )         
    elseif (appData.user.phoneNumber == "") then  
        appData.composer.removeScene( "controller.IntroController" ) 
        appData.composer.gotoScene( "controller.PhoneController" )      
    elseif  (appData.addresses.work.location == "") then
        appData.composer.removeScene( "controller.IntroController" )  
        appData.composer.gotoScene( "controller.PlacesController" )
    elseif  ((appData.car.color == "" or appData.car.plate == "") and 
        (appData.user.mode ~= "passenger")) then
        appData.composer.removeScene( "controller.IntroController" )  
        appData.composer.gotoScene( "controller.Car1Controller" )
    else    
        appData.composer.removeScene( "controller.IntroController" ) 
        appData.composer.gotoScene( "controller.ScheduleController" ) 
    end

end


-- ------------------------------------------------------------------------------------------ --
-- TRANSPORTS
-- ------------------------------------------------------------------------------------------ --

-- Save Transports
local saveTransports = function(event)

    appData.transports = appData.json.decode(event.response)
    t1 = timer.performWithDelay( 1000, goFurther, -1 )

end

-- Download Transports
local downloadTransports = function()

  --prepare data
    local url = "https://api.sammevei.no/api/1/users/current/transports" 

    local headers = {}
    headers["Authorization"] = "Bearer "..appData.session.accessToken
      
    local params = {}
    params.headers = headers

    -- send request
    network.request( url, "GET", saveTransports, params) 
    print("downloading transports!")

end

-- ------------------------------------------------------------------------------------------ --
-- ADDRESSES
-- ------------------------------------------------------------------------------------------ --



-- ------------------------------------------------------------------------------------------ --
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

    -- download transports
    downloadTransports()
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

-- open schedule

-- ------------------------------------------------------------------------------------------ --
-- AUTH
-- ------------------------------------------------------------------------------------------ --

-- Finish Auth
local finishAuth = function( event )
    print(event.response)

    if event.response == nil then
        local alert = native.showAlert( 
            "Connection Problem!",
            "Enable Internet in your phone settings and restart the app, please!", 
            { "OK", "" } 
            )
    else    
        local data = appData.json.decode(event.response)
        
        if data == nil then
            local alert = native.showAlert( 
                "Connection Problem!",
                "Enable Internet in your phone settings and restart the app, please!", 
                { "OK", "" }
                )
        else    
            -- store tokens
            appData.session.accessToken = data.token.accessToken
            appData.session.refreshToken = data.token.refreshToken
            
            -- is schedule doesn't exist, make it and upload, otherwise download transports
            if appData.schedule[1].id == "" then
                print("=========n I WILL CREATE AND UPLAD SCHEDULE ============")
                -- Create Schedule
                model.createSchedule()

                -- Upload Schedule
                uploadSchedule()
            else
                -- sort
                appData.schedule = model.sortSchedule(appData.schedule)

                -- save
                model.saveSchedule(appData.schedule)

                -- download transports
                downloadTransports()
            end    
        end
    end
end

-- Auto Login User
local autoLoginUser = function()
  --prepare data
    local url = "https://api.sammevei.no/api/1/auth/login" 

    local headers = {}
    headers["Content-Type"] = "application/x-www-form-urlencoded"
      
    local params = {}
    params.headers = headers
    params.body = 
        'username='..
        utils.urlEncode(appData.user.userName)..
        '&'..
        'password='..
        utils.urlEncode(appData.user.passWord)..
        '&'..
        'permanent=true'

    -- send request
    network.request( url, "POST", finishAuth, params)

    print("logging user!")
end

-- -----------------------------------------------------------------------------------
-- Scene components
-- -----------------------------------------------------------------------------------
local scene = composer.newScene()

-- create()
function scene:create( event )
 
    appData.sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Show background image fullscreen
    view.background()

    -- Check whether User, Addresses and Car are registered
    local userRegistered = false
    local carRegistered = false
    local addressesRegistered = false

    userRegistered = model.openUser()
    carRegistered = model.openCar()
    addressesRegistered = model.openAddresses()
    scheduleCreated = model.openSchedule()
    model.openAddressList()

    print("<--------- opening schedule ------------>")
    print(scheduleCreated)
    -- model.openTransports()

    if (userRegistered == false) then
        -- register user
        appData.composer.gotoScene( "controller.RegisterEmailController" ) 
    else
        -- auto login user
        t2 = timer.performWithDelay( 2000, autoLoginUser, 1 ) 
    end
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    local destDir = system.DocumentsDirectory  -- Location where the file is stored
    local result, reason
    
    result, reason = os.remove( system.pathForFile( "map.html", destDir ) )
    result, reason = os.remove( system.pathForFile( "drivermap.html", destDir ) )
    result, reason = os.remove( system.pathForFile( "passengermap.html", destDir ) )
  
if result then
   print( "File removed" )
else
   print( "File does not exist", reason )  --> File does not exist    apple.txt: No such file or directory
end    
 
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