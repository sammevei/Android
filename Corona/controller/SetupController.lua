local sceneName = SetupController

-- Include
local view = require("view.SetupView")
local model = require("model.SetupModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )

-- Controller Functions
local r
local t1
local uploadSchedule
local temporarySchedule

local networkError = function(event)
    if ( event.action == "clicked" ) then
        local i = event.index
        if ( i == 1 ) then
            native.requestExit()
        elseif ( i == 2 ) then
             -- Do nothing; dialog will simply dismiss
        end
    end    
end 

showAlert = function()
    local alert = native.showAlert( 
        "",
        "Ooops... det synes å være et problem med forbindelsen din. ".. 
        "Vi kunne ikke koble deg til våre servere. ".. 
        "Vennligst sjekk innstillinger din.",
        { "OK", "" },
        networkError 
        )
end

local firebaseRegistered = function(event)
    -- model.saveFirebaseToken(appData.firebaseToken)
    print("FCM REGISTERED ================================== FCM REGISTERED")
    print(event.response)
end 

local iterations = 0
local goFurther = function()
    print("GOING FURTHER ================ SETUP ================= GOING FURTHER")

    if appData.car.vehicle_id == "" then appData.car.vehicle_id = nil end


    -- if it's getting too long, try request again
    if iterations == 10 or iterations == 20 then
        -- upload Schedule
        uploadSchedule() 
    end    

    -- if we are waiting too long, check what's available and ask for missing data
    if iterations > 30 then

        if appData.session.accessToken == "" then
            timer.cancel( t1 ) 
            showAlert() 
            return true     
        elseif appData.user.phoneNumber == ""
        or appData.user.phoneNumber == nil    
        then  
            appData.composer.removeScene( "controller.SetupController" ) 
            appData.composer.gotoScene( "controller.PhoneController" ) 
            timer.cancel( t1 ) 
            return true       
        elseif (appData.addresses.work.location == ""
        or appData.addresses.home.location == "" )   
        then
            appData.composer.removeScene( "controller.SetupController" )  
            appData.composer.gotoScene( "controller.PlacesController" )
            timer.cancel( t1 )
            return true
        elseif temporarySchedule == nil then
            appData.composer.removeScene( "controller.SetupController" )  
            appData.composer.gotoScene( "controller.PlacesController" )
            timer.cancel( t1 )
            return true     
        elseif appData.schedule == nil then
            appData.composer.removeScene( "controller.SetupController" )  
            appData.composer.gotoScene( "controller.PlacesController" )
            timer.cancel( t1 )
            return true               
        elseif appData.schedule[1] == nil then
            appData.composer.removeScene( "controller.SetupController" )  
            appData.composer.gotoScene( "controller.PlacesController" )
            timer.cancel( t1 )
            return true             
        elseif appData.schedule[1].time_offset == "" then
            appData.composer.removeScene( "controller.SetupController" )  
            appData.composer.gotoScene( "controller.PlacesController" )
            timer.cancel( t1 )
            return true                        
        else 
            timer.cancel( t1 ) 
            showAlert()
            return true 
        end
    end    

    -- if everything ok, go to schedule ---------------------------------------------
    if appData.schedule == nil then
        iterations = iterations + 1
        print("ITERATION 0: "..iterations)
        return true
    elseif appData.schedule[1] == nil then
        iterations = iterations + 1
        print("ITERATION 1: "..iterations)
        return true
    elseif appData.schedule[1].time_offset == nil then
        iterations = iterations + 1
        print("ITERATION 2: "..iterations)
        return true
    elseif appData.schedule[1].time_offset == "" then
        iterations = iterations + 1
        print("ITERATION 3: "..iterations)
        return true           
    end  

    if  appData.addresses.work.location ~= ""
    and appData.addresses.home.location ~= ""    
    and appData.schedule[1].time_offset ~= nil
    and appData.schedule[1].time_offset ~= ""
    and temporarySchedule ~= nil
    then  

        -- cancel timer 
        timer.cancel( t1 )

        -- set commuting addresses every time the user starts the app just to be sure 
        -- setAddresses()

        -- register FCM token if not found on the device
        if (appData.useNotifications == true ) then 

            print("xxxxxxxxxxxxxxxxxxxxxxxx")
            
            -- Register for Notifications
            appData.firebaseToken = appData.notifications.getDeviceToken()

            print("FCM ================================== FCM")
            print(appData.firebaseToken)
            print("FCM ================================== FCM")

            --Prepare Data
            local url = "https://api.sammevei.no/api/1/clients/current/token" 

            local headers = {}
            headers["Content-Type"] = "application/x-www-form-urlencoded"
            headers["Authorization"] = "Bearer "..appData.session.accessToken
              
            local params = {}
            params.headers = headers
            params.body = 
                'token='..appData.firebaseToken..'&'..
                'type='..utils.urlEncode(appData.system.phoneType)..'&'..
                'version='..appData.system.appVersion..'&'..
                'build='..utils.urlEncode(appData.system.appBuild)..'&'..
                'locale='..utils.urlEncode(appData.system.userLocale)..'&'..
                'timezone='..utils.urlEncode(appData.system.userTimezone)..'&'..
                'model='..utils.urlEncode(appData.system.phoneModel)..'&'..
                'os_name='..utils.urlEncode(appData.system.osName)..'&'..
                'os_version='..utils.urlEncode(appData.system.osVersion)

            print(params.body)    

            print(" ############################################################")
            print(" ############################################################")
            print(" ############################################################")
            print(" ############################################################")
            print(" ############################################################")
            print(" ############################################################")
            print(" ############################################################")
            print(" ####################   CLIENT CREATED   ####################")
            print(" ############################################################")
            print(" ############################################################")
            print(" ############################################################")
            print(" ############################################################")
            print(" ############################################################")
            print(" ############################################################")
            print(" ############################################################")            

            -- send request
            network.request( url, "POST", firebaseRegistered, params)        
        end
        
        -- go to schedule
        local options = {
            effect = "fade",
            time = 1200
        }

        appData.composer.removeScene( "controller.PlacesController" ) 
        -- appData.composer.gotoScene( "controller.ScheduleController", options ) 
        appData.composer.gotoScene( "controller.GreetingController", options )
        return true 
    else
        iterations = iterations + 1
        print("ITERATION 4: "..iterations)
        print(appData.addresses.work.location)
        print(appData.addresses.home.location)
        print(appData.addresses.work.location)
        print(appData.schedule[1].time_offset)
        print(temporarySchedule)
        return true
    end    
end


-- ------------------------------------------------------------------------------------------ --
-- ADDRESSES
-- ------------------------------------------------------------------------------------------ --

-- finish setting addreses
local addressesSet = function(event)
    print("--------------- ADDRESSES SET ---------------")
    print(event.response)   
end

-- set addresses
local setAddresses = function()

    if tonumber(appData.addresses.home.address_id) > 2
    and tonumber(appData.addresses.work.address_id) > 2
    then  

        --prepare data
        local url = "https://api.sammevei.no/api/1/users/current/addresses" 

        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        headers["Authorization"] = "Bearer "..appData.session.accessToken
          
        local params = {}
        params.headers = headers
        params.body = 
            'a='..
            utils.urlEncode(tostring(appData.addresses.home.address_id))..
            '&'..
            'b='..
            utils.urlEncode(tostring(appData.addresses.work.address_id))

        -- send request
        print(params.body)
        network.request( url, "POST", addressesSet, params)
    end      
end 

-- ------------------------------------------------------------------------------------------ --
-- SCHEDULE
-- ------------------------------------------------------------------------------------------ --

-- save current schedule
local saveSchedule = function(event)
    print("--------------- SCHEDULE DOWNLOADED --------------- setup")
    print(event.response)

    -- decode
    temporarySchedule = appData.json.decode( event.response )

    if temporarySchedule == nil then 
        print(" =================== SCHEDULE EMPTY 1 =====================")
        appData.ready.schedule = true
        return true
    elseif temporarySchedule[1] == nil then 
        print(" =================== SCHEDULE EMPTY  2 =====================")
        appData.ready.schedule = true
        return true
    else
        appData.schedule = temporarySchedule
    end 

    -- sort
    appData.schedule = model.sortSchedule(appData.schedule)

    -- save
    model.saveSchedule(appData.schedule) 
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
uploadSchedule = function()
    if appData.refreshing == true then
        print("uploading schedule in setup")
        --[[
        if appData.schedule[1] == nil then 
            appData.composer.gotoScene( "controller.IntroController" )
            return true
        end 
        --]]   

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
end



-- -----------------------------------------------------------------------------------
-- Scene components
-- -----------------------------------------------------------------------------------
local scene = composer.newScene()

-- create()
function scene:create( event )

    print("SETUP CREATE")
 
    appData.sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Show background image fullscreen
    view.background()

    -- set Addresses
    setAddresses()

    -- create schedule
    model.createSchedule()
    model.saveSchedule(appData.schedule)

    -- upload Schedule
    appData.refreshing = true
    timer.performWithDelay( 2000, uploadSchedule, 1 ) 

    -- go further
    t1 = timer.performWithDelay( 1000, goFurther, -1 )
end
 
-- show()
function scene:show( event )

    print("SETUP SHOW")
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    local destDir = system.DocumentsDirectory  -- Location where the file is stored
    local result, reason
    
    result, reason = os.remove( system.pathForFile( "map.html", destDir ) )
    result, reason = os.remove( system.pathForFile( "drivermap.html", destDir ) )
    result, reason = os.remove( system.pathForFile( "driverinfomap.html", destDir ) )
    result, reason = os.remove( system.pathForFile( "passengermap.html", destDir ) )
  
    if result then
       print( "File removed ----------------------------------------------------->" )
    else
       -- print( "File does not exist", reason )  --> File does not exist    apple.txt: No such file or directory
    end 

    appData.firebaseToken = model.openFirebaseToken()
    print("==========") 
    print(appData.firebaseToken) 
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

 
    end
end
 
-- hide()
function scene:hide( event )

    print("SETUP HIDE")
 
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

    print("SETUP DESTROY")
 
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