local sceneName = IntroController

-- Include
local view = require("view.IntroView")
local model = require("model.IntroModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )




-- Controller Functions
local r

-- -------------------------------------------------------------------
-- NOTIFICATIONS
-- -------------------------------------------------------------------
local passengerMap
local specLat = 10

local changeParams = function()
    -- change lat
    specLat = specLat + 0.001

    print("changing params")
    print(specLat)

    -- send param
    local t = tostring(specLat)
    passengerMap:request("passengermap.html?t=" .. t, system.DocumentsDirectory)
end

timer.performWithDelay( 1000, changeParams, -1 )


local createPassengerMap = function(lat1, lon1, lat2, lon2, transport_id, accessToken)

    -- MAPBOX
    ------------------------
    --REQUIRED VARIABLES
    ------------------------
     
    local APIkey = "AIzaSyAj5D-S7WTwtU7h8ZKYAI3T_4n1r3zxHoM" 
    local path = system.pathForFile( "passengermap.html", system.DocumentsDirectory )
     
    local lat1 = tostring(lat1)
    local lon1 = tostring(lon1)
    local lat2 = tostring(lat2)
    local lon2 = tostring(lon2)

    ------------------------
    --HTML & JAVASCRIPT CODE
    ------------------------
     
    local mapString = [[
    <html>
        <head>
        <meta charset=utf-8 />
        <title>passenger map</title>
        <meta name='viewport' content='initial-scale=1,maximum-scale=1,user-scalable=no' />
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src='https://api.mapbox.com/mapbox.js/v3.1.1/mapbox.js'></script>
        <script src='http://silver.tf/libraries/mb_directions.js'></script>
        <link href='https://api.mapbox.com/mapbox.js/v3.1.1/mapbox.css' rel='stylesheet' />
        <style>
          body { margin:0; padding:0; }
          #map { position:absolute; top:0; bottom:0; width:100%; }
        </style>
        </head>
        <body>
        <div id='map'></div>
        <script>

        function getURLParameter(name) {
            return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.href)||[,""])[1].replace(/\+/g, '%20'))||null;
        }


    // ========================================================================================== //

        L.mapbox.accessToken = 'pk.eyJ1Ijoib2NoZWxzZXQiLCJhIjoiY2ltbmZqbXA4MDAxdXgza3E2OW44ZzZ2NyJ9.Kgl_Fc5Gu2QnpXcvL9UXRQ';

        // example origin and destination
        var start = {lat: ]]..lat1..[[, lon: ]]..lon1..[[}; 
        var finish = {lat: ]]..lat2..[[, lon: ]]..lon2..[[};
        var driver = {lat: start.lat, lon: start.lon};
        
        var url = "https://api.sammevei.no/api/1/users/current/transports/]]..
        transport_id..
        [[/position"
        var authorization = "]]..accessToken..[["
    // ================================================================================================
    
        var map = L.mapbox.map('map', 'mapbox.streets', {
             zoomControl: false }).setView([finish.lat, finish.lon], 9); 
             
    var myLayer;
    var timerVar = setInterval(myTimer, 10);
    var i = 0;
    
    var settings = {
      // "async": true,
      // "crossDomain": true,
      // "url": url,
      // "method": "GET",
      // "headers": {
      // "Authorization": authorization
      // }
    }

    // ================================================================================================

         // DIRECTIONS ===================================================================== //
         map.attributionControl.setPosition('bottomleft'); 
         var directions = L.mapbox.directions({
            profile: 'mapbox.driving' 
            });
            
        
        // Set the origin and destination for the direction and call the routing service
        directions.setOrigin(L.latLng(start.lat, start.lon)); // driver
        directions.setDestination(L.latLng(finish.lat, finish.lon)); // passenger 
        
        // directions.query(); 

        // var directionsLayer = L.mapbox.directions.layer(directions).addTo(map); 
        // var directionsRoutesControl = L.mapbox.directions.routesControl('routes', directions)
        //    .addTo(map);
            
        // MOVE A CAR ON THE MAP =========================================================== //
        
        function getURLParameter(name) {
            return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.href)||[,""])[1].replace(/\+/g, '%20'))||null;
        }              

        // ---------------------------------------------------------------------------------- // 
        
        function myTimer() {

        console.log("great");
        name = getURLParameter("t")
        console.log(name);
        driver.lon = name
    
        var geojson = [
          {
            type: 'Feature',
            
            geometry: {
                type: 'Point',
                coordinates: [driver.lon, driver.lat] // lon, lat
            },
            
            properties: {
              'marker-color': '#00cc00',
              'marker-size': 'large',
              'marker-symbol': 'car'
            }
            
          }
        ];  

        if (i > 0) {
            map.removeLayer(myLayer )
        }
        
       


        myLayer = L.mapbox.featureLayer().setGeoJSON(geojson).addTo(map);
        i++
    }          
        // ========================================================================================== //

        </script>
        </body>
        </html>]]

    --This string is the text that will be written to the HTML file.
     
    ------------------------
    --HTML FILE CREATION
    ------------------------
     
    local htmlFile = io.open( path, "w" )
    htmlFile:write( mapString )
    io.close( htmlFile )

    --The above code writes our "mapString" variable to an HTML file and saves it in the Documents directory.
end
local firebaseRegistered = function(event)
    model.saveFirebaseToken(appData.firebaseToken)
end

local goFurther = function()

        -- register FCM
        if (system.getInfo( "environment" ) ~= "simulator" and appData.firebaseToken == false) then 

            print("xxxxxxxxxxxxxxxxxxxxxxxx")
            
            -- Register for Notifications
            appData.firebaseToken = appData.notifications.getDeviceToken()
            local phoneType = "android"
            local appVersion = "3.25"
            local appBuild = "325"
            local countryLocale = "nb_NO"
            local timeZone = "Europe/Oslo"

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
                'type='..utils.urlEncode(phoneType)..'&'..
                'version ='..utils.urlEncode(appVersion)..'&'..
                'build='..utils.urlEncode(appBuild)..'&'..
                'locale='..utils.urlEncode(countryLocale)..'&'.. 
                'timezone ='..utils.urlEncode(timeZone)

            -- send request
            network.request( url, "POST", firebaseRegistered, params)
        
        end
    
        -- cancel timer 
        timer.cancel( t1 )

        -- register for notifications


        -- continue to next scene
        --[[
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
        --]]
end


-- ------------------------------------------------------------------------------------------ --
-- TRANSPORTS
-- ------------------------------------------------------------------------------------------ --

-- Save Transports
local saveTransports = function(event)

    appData.transports = appData.json.decode(event.response)
    print("==================================================================")
    print(event.response)
    print("==================================================================")
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

    print("uploading schedule")

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
    utils.urlEncode(tostring(appData.schedule[14].is_enabled))

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



-- Finish Auth
local finishAuth = function( event )
    print("------ login response ------")
    print(event.response)

    if event.response == nil then
        local alert = native.showAlert( 
            "",
            "There seems to be some connection problem. Enable Internet in your phone settings and restart the app, please!", 
            { "OK", "" },
            networkError 
            )

        -- appData.composer.removeScene( "controller.IntroController" )
        -- appData.composer.gotoScene( "controller.RegisterEmailController" )
    else    
        local data = appData.json.decode(event.response)
        
        if data == nil then
            local alert = native.showAlert( 
                "",
                "There seems to be some connection problem. Enable Internet in your phone settings and restart the app, please!", 
                { "OK", "" },
                networkError
                )
            
            -- appData.composer.removeScene( "controller.IntroController" )
            -- appData.composer.gotoScene( "controller.RegisterEmailController" )
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
        -- appData.composer.gotoScene( "controller.RegisterEmailController" ) 
    else
        -- auto login user
        autoLoginUser() 
    end

    -- ----------------------------------------------------------------------------- --
    -- MAP TESY
    -- ----------------------------------------------------------------------------- --
    createPassengerMap("10", "10", "10.1", "10", "1", "123456")

    print("showing passenger map")
    passengerMap = native.newWebView( 
        0, 
        0, 
        display.contentWidth, 
        appData.contentH - 100 - 90 - 35 - display.screenOriginY*2
    )

    local p = "t=10.2"
    passengerMap:request( "passengermap.html?" .. p, system.DocumentsDirectory )

    passengerMap.anchorX = 0
    passengerMap.anchorY = 0
    passengerMap.x = 0
    passengerMap.y = display.screenOriginY + 130
    --sceneGroup:insert( passengerMap ) 
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
    result, reason = os.remove( system.pathForFile( "driverinfomap.html", destDir ) )
    -- result, reason = os.remove( system.pathForFile( "passengermap.html", destDir ) )
  
    if result then
       print( "File removed" )
    else
       print( "File does not exist", reason )  --> File does not exist    apple.txt: No such file or directory
    end 

    appData.firebaseToken = model.openFirebaseToken()
    print("==========") 
    print(appData.firebaseToken) 

    timer.performWithDelay(changeParams, 1000, -1)
 
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