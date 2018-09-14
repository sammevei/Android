local sceneName = FirstTransportController

-- Include
local view = require("view.FirstTransportView")
-- local model = require("model.CreateTransportModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )
local routines = require( "misc.appRoutines" )

-- -----------------------------------------------------------------------
-- Variables
-- -----------------------------------------------------------------------
appData.appIsRunning = false
local snapshot

local showingNextTrip
local changing
local changeWasJustClosed
local places
local rows = {}

local readyGPS

local morningTransportEnabled
local afternoonTransportEnabled
local departureSet = false
local destinationSet = false
local hiddenTrip 
appData.refreshing = false

-- move schedule slide
local webViewHeight
local yMin = -1100
local yMax = 0

local optionsVisible = false
local clicked 
local wheelVisible = false
local matches = {
    morningMatch = false,
    afternoonMatch = false,
    tomorrowMorningMatch = false,
    tomorrowAfternoonMatch = false,
    nextTrip = false
}

local morningTransportID = "" 
local afternoonTransportID = "" 
local morningRating = ""
local afternoonRating = ""

-- timers
local t1; local t2; local t3; local t4; local t5; local t6; local t7;
local t8; local t9; local t10; local t11; local t12; local t13; local t14;

-- -----------------------------------------------------------------------
-- Functions
-- -----------------------------------------------------------------------
local webListener
local catcher
local checkGPS
local tokenRefreshed
local nextTrip
local tokenRefreshed
local startGoogleMaps
local keepDriving
local driveEnded
local closeDriving
local closeDrivingAlert
local showRouteMap
local showMyRoute
local showDirections
local driveStarted
local startDrive
local setTransportData
local showTransportRoleWheel
local showTransportToleranceWheel
local setTransportTolerance
local showTransportTimeWheel
local showTransportDateWheel
local saveTransports
local transportUpdated
local routeMap1
local resetMap
local onTripChangeEnd
local onTripChangeStart
local homeAddressUploaded
local workAddressUploaded
local uploadHomeAddress
local uploadWorkAddress
local showScene
local hideTransport

-- DEPARTURE
local departureGeoSearchListener
local handleDepartureKeyboard
local despartureGeoSearch
local departureSearchEnd
local departureSearchAutocomplete
local departureSearch
local departureFieldListener

-- DESTINATION
local destinationGeoSearchListener
local handleDestinationKeyboard
local destinationGeoSearch
local destinationSearchEnd
local destinationSearchAutocomplete
local destinationSearch
local destinationFieldListener

-- GPS
local uploadedGPS
local uploadGPS

-- Countdowns
local passengerCountdown
local driverCountdown

-- Message the partner
local onTomorrowMorningChat
local onTomorrowAfternoonChat
local onMorningChat
local onAfternoonChat
local onTransportChat

-- Call the partner
local onTomorrowMorningCall
local onTomorrowAfternoonCall
local onMorningCall
local onAfternoonCall
local onTransportCall

-- Enable Transport
local enableMorningTransport
local enableAfternoonTransport

-- Handle Today Fields 
local handleToday

-- Reset Address ID's
local resetAddressID

-- Set Switches  
local setSwitches

-- Set Time
local onTime

-- Download Matches
local morningMatchDownloaded
local afternoonMatchDownloaded
local tomorrowMorningMatchDownloaded
local tomorrowAfternoonMatchDownloaded
local downloadMatches

-- Move Schedule
local moveScheduleSlide

-- Options
local onKeyEvent
local showOptions

-- Transports
local cancelMorningSwitch
local cancelAfternoonSwitch
local setMorningSwitch
local setAfternoonSwitch
local transportCanceled
local cancelTransport
local transportUploaded
local uploadTransport
local onSwitch
local onRowBar
local addTransport
local showMap

-- Rating
local showRating
local rateTrip
local ratingFinished

-- Handle Info Box
local hideTrip

-- -----------------------------------------------------------------------
-- Adjustments
-- -----------------------------------------------------------------------
composer.recycleOnSceneChange = true
  
-- -----------------------------------------------------------------------
-- Scene Function Declarations
-- -----------------------------------------------------------------------

hideTransport = function(event)
    appData.composer.hideOverlay()
    if event.phase == "began" then
        event.target.alpha = 0.6
        print("[1]")
        return true
    elseif event.phase == "ended" then 
        event.target.alpha = 0.9
        -- appData.composer.hideOverlay()
        print("[2]")
        return true
    end  
end

local options = {
    isModal = true,
    effect = "fade",
    time = 1
}

onRowBar = function(event)
    appData.composer.setVariable( "i", event.target.id )
    appData.composer.showOverlay( "controller.TransportDetailsController", options)
end

addTransport = function(event)
    if event.phase == "began" then
        event.target.alpha = 0.6
        return true
    elseif event.phase == "ended" then 
        event.target.alpha = 0.9
        return true
    end   
end

-- MISC & UTILS ==========================================================

-- catches click through
catcher = function()
    return true
end    

showMap = function()

    local temp

    temp = utils.split(appData.tempAddresses.home.location, ",")
    local lon1 = temp[1]
    local lat1 = temp[2]    

    temp = utils.split(appData.tempAddresses.work.location, ",")
    local lon2 = temp[1]
    local lat2 = temp[2]

    -- create map
    routines.createMap(lat1, lon1, lat2, lon2)

    local lon1 = "lon1="..lon1
    local lat1 = "lat1="..lat1
    local lon2 = "lon2="..lon2
    local lat2 = "lat2="..lat2

    local params = lon1.."&"..lat1.."&"..lon2.."&"..lat2
    print("- - - - - - - - - "..params)

    view.transportMap:request( "map.html?"..params, system.DocumentsDirectory )
end


-- TRIP CHANGE =============================================================

-- save transport data when changed
setTransportData = function(event)
    -- view.tripChangeGroup.y = display.screenOriginY + 55
    view.departureField.y = 3
    view.destinationField.y = 47

    transition.to( view.tripChangeGroup, { time = 100, 
        y = appData.contentH - display.screenOriginY - 175 } )  
    
    -- set wheel not visible
    wheelVisible = false

    -- show trip map if changing
    if changing == true then
        -- routeMap1()
    end  

    print("JUMP")  
    transition.to( view.whiteBackground, { time = 25, alpha = 0 } )
    transition.to( view.wheelButton, { time = 25, alpha = 0 } )

    if view.transportDateWheel.y ~= -3000 then
        transition.to( view.transportDateWheel, { time = 25, y = -3000 } )
        local values = view.transportDateWheel:getValues()
        view.tripDate.text = values[2].value
    end    

    if view.transportTimeWheel.y ~= -3000 then
        transition.to( view.transportTimeWheel, { time = 25, y = -3000 } )
        local values = view.transportTimeWheel:getValues()
        view.tripTime.text = values[2].value..values[3].value..values[4].value
    end

    if view.transportToleranceWheel.y ~= -3000 then
        transition.to( view.transportToleranceWheel, { time = 25, y = -3000 } )
        local values = view.transportToleranceWheel:getValues()
        view.tripTolerance.text = "+/- "..values[2].value
    end    

    if view.transportRoleWheel.y ~= -3000 then
        transition.to( view.transportRoleWheel, { time = 25, y = -3000 } )
        local values = view.transportRoleWheel:getValues()

        if values[2].value == "driver" 
        and appData.car.vehicle_id == nil 
        then
            local alert = native.showAlert( 
                "", 
                'For å endre innstillingen til "Sjåfør", vennligst legg inn informasjon om bilen din under "Mitt kjøretøy" først.', 
                { "OK", "" }
                )
            return true
        end

        if values[2].value == "Sjåfør" 
        and appData.car.vehicle_id == nil 
        then
            local alert = native.showAlert( 
                "", 
                'For å endre innstillingen til "Sjåfør", vennligst legg inn informasjon om bilen din under "Mitt kjøretøy" først.', 
                { "OK", "" }
                )        
                return true
        end

        view.tripRole.text = values[2].value
    end    

    return true
end

-- Show Trip Role Wheel --------------------------------------------------
showTransportRoleWheel = function(event)

   -- Handle text fields
    clicked = false

    -- Fill In Address Fields
    handleDepartureKeyboard() 
    handleDestinationKeyboard()

    -- show background
    print("showing role wheel")

    -- set wheel visible
    wheelVisible = true

    -- move the menu out of sight
    view.departureField.y = 3000
    view.destinationField.y = 3000
    transition.to( view.tripChangeGroup, { time = 100, y = 35 + display.screenOriginY } )

    -- view.routeMap2.y = 3000
    -- view.routeMap1.y = 3000

    transition.to( view.transportRoleWheel, { time = 25, y = appData.contentH/2 } )
    transition.to( view.whiteBackground, { time = 25, alpha = 1 } )
    transition.to( view.wheelButton, { time = 25, alpha = 1 } ) 


    if view.tripRole.text == "passenger" then
        view.transportRoleWheel:selectValue( 2, 1 )
    else
        view.transportRoleWheel:selectValue( 2, 2 )
    end    

    return true   
end

-- Show Trip Tolerance Wheel --------------------------------------------------
showTransportToleranceWheel = function(event)

   -- Handle text fields
    clicked = false

    -- Fill In Address Fields
    handleDepartureKeyboard() 
    handleDestinationKeyboard()

    -- set wheel visible
    wheelVisible = true

    -- move menu out of sight
    view.departureField.y = 3000
    view.destinationField.y = 3000
    transition.to( view.tripChangeGroup, { time = 100, y = 35 + display.screenOriginY } )

    -- view.routeMap2.y = 3000
    -- view.routeMap1.y = 3000

    transition.to( view.transportToleranceWheel, { time = 25, y = appData.contentH/2 } )
    transition.to( view.whiteBackground, { time = 25, alpha = 1 } )
    transition.to( view.wheelButton, { time = 25, alpha = 1 } )

    view.transportToleranceWheel:selectValue( 2, 5 )

    return true       
end

-- 
setTransportTolerance = function()

    -- set wheel visible
    wheelVisible = true

    view.routeMap2.y = display.screenOriginY + 130 + 50
    view.routeMap1.y = display.screenOriginY + 130 + 50
    -- view.routeMap1.x = 0

    transition.to( view.transportToleranceWheel, { time = 25, y = -3000 } )
    transition.to( view.whiteBackground, { time = 25, alpha = 0 } )
    local values = view.transportToleranceWheel:getValues()
    view.tripTolerance.text = "+/- "..values[1].value

    return true
end

-- Show Trip Time Wheel --------------------------------------------------
showTransportTimeWheel = function(event)

    -- Handle text fields
    clicked = false

    -- Fill In Address Fields
    handleDepartureKeyboard() 
    handleDestinationKeyboard()

    -- set wheel visible
    wheelVisible = true    

    -- Move menu out of sight
    view.departureField.y = 3000
    view.destinationField.y = 3000
    transition.to( view.tripChangeGroup, { time = 100, y = 35 + display.screenOriginY } )

    -- view.routeMap2.y = 3000
    -- view.routeMap1.y = 3000

    transition.to( view.transportTimeWheel, { time = 25, y = appData.contentH/2 } )
    transition.to( view.whiteBackground, { time = 25, alpha = 1 } )
    transition.to( view.wheelButton, { time = 25, alpha = 1 } ) 

    if appData.period == "m" then
        view.transportTimeWheel:selectValue( 2, 3 )
    elseif appData.period == "a" then 
        view.transportTimeWheel:selectValue( 2, 8 ) 
    end

    return true       
end

-- Show Trip Date Wheel --------------------------------------------------
showTransportDateWheel = function(event)

    -- Handle text fields
    clicked = false

    -- Fill In Address Fields
    handleDepartureKeyboard() 
    handleDestinationKeyboard()

    -- set wheel visible
    wheelVisible = true    

    -- Move menu out of sight
    view.departureField.y = 3000
    view.destinationField.y = 3000
    transition.to( view.tripChangeGroup, { time = 100, y = 35 + display.screenOriginY } )

    -- view.routeMap2.y = 3000
    -- view.routeMap1.y = 3000

    transition.to( view.transportDateWheel, { time = 25, y = appData.contentH/2 } )
    transition.to( view.whiteBackground, { time = 25, alpha = 1 } )
    transition.to( view.wheelButton, { time = 25, alpha = 1 } ) 

    view.transportDateWheel:selectValue( 2, 3 )
 
    return true       
end

-- Finish Downloading  Transports
saveTransports = function(event)
    print("downloading and saving transports! -----------------------------------") 
    appData.transports = appData.json.decode(event.response) -- [2] load transports from server
    model.saveTransports()
    appData.refreshTable = true

    -- hide Create Transport
    appData.composer.hideOverlay()
end

-- Finish Updated Transport
transportUpdated = function(event)   
    print("--------------- TRANSPORT UPDATED ---------------")
    print("TRANSPORT: "..event.response)

    local data = appData.json.decode(event.response)

    if data == nil then
        local alert = native.showAlert( 
            "Ooops. Feil!", 
            'En feil skjedde oppdatering av turen. Vennligst prøv igjen', 
            { "OK", "" }
            ) 

        return true
    end    

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

-- End of trip change ----------------------------------------------------
changing = false
changeWasJustClosed = false

onTripChangeEnd = function(event)

    print("tripChangeEnd")
    print(changing)
    print(appData.i)

    local time_offset
    local time_flex

    

    if changing == true then
        changing = false
        view.routeMap1.x = 3000
        view.tripChangeGroup.y = -3000 

                local i = appData.i 
                print("the trip was changed ------------ "..i)

                -- Handle text fields
                clicked = false
                handleDepartureKeyboard()
                handleDestinationKeyboard()

                departureSet = false
                destinationSet = false

                -- move map up
                if view.nextTrip == nil and view.startDrivingGroup == nil then
                    view.routeMap2.y = display.screenOriginY + 35
                    view.routeMap2.height = appData.contentH - display.screenOriginY - 195

                    view.routeMap1.y = display.screenOriginY + 35
                    view.routeMap1.height = appData.contentH - display.screenOriginY - 195
                    view.routeMap1.x = 3000
                else
                    print("map moving up ------------ ")
                    view.routeMap2.y = display.screenOriginY + 130
                    view.routeMap2.height = appData.contentH - display.screenOriginY - 195 - 95

                    view.routeMap1.y = display.screenOriginY + 130
                    view.routeMap1.height = appData.contentH - display.screenOriginY - 195 - 95
                    view.routeMap1.x = 3000
                end 

                -- show info boxes
                if view.nextTripGroup ~= nil then
                    view.nextTripGroup.alpha = 1
                end 

                if view.pickUpGroup ~= nil then
                    view.pickUpGroup.alpha = 1
                end 

                if view.startDrivingGroup ~= nil then
                    view.startDrivingGroup.alpha = 1
                end

                if view.drivingGroup ~= nil then
                    view.drivingGroup.alpha = 1
                end

                -- hide all dots
                for a = 1, #appData.dummyTransports/2 do
                    view.dots.morning[a].alpha = 0
                    view.dots.afternoon[a].alpha = 0
                end    


                -- hide the dot
                local integralPart, fractionalPart = math.modf( i/2 )

                if fractionalPart ~= 0 then
                    i = integralPart + 1
                    view.dots.morning[i].alpha = 0   
                else
                    i = i/2
                    view.dots.afternoon[i].alpha = 0
                end  

                -- save data from interface
                i = appData.i
                local hours = string.sub(view.tripTime.text, 1, 2)
                hours = tonumber(hours)
                local minutes = string.sub(view.tripTime.text, 4, 5)
                minutes = tonumber(minutes)
                time_offset = hours*60 + minutes -- OFFSET
                time_flex = string.sub(view.tripTolerance.text, 5, 6) -- TOLERANCE

                --- calculate UTC
                local integralPart, fractionalPart = math.modf( (i+1)/2 )
                local dayPart 
                local dayShift = integralPart

                if fractionalPart == 0 then dayPart = "m" end
                if fractionalPart > 0 then dayPart = "a" end

                print("Days Shift  = "..dayShift)
                print("Day Part  = "..dayPart)
                print("i  = "..i)

                local utcTime = model.calculateChangedTransportUTC(dayShift, dayPart, time_offset) 
                appData.dummyTransports[i].starting_at=utcTime
                appData.dummyTransports[i].flexibility=time_flex*60

                if view.tripRole.text == "passenger" 
                or view.tripRole.text == "Passasjer" 
                then 
                    appData.dummyTransports[i].vehicle = {}
                    appData.dummyTransports[i].vehicle.id = "0"
                    appData.schedule[i].mode = 1
                    print("PASSENGER 1")
                elseif view.tripRole.text == "driver" 
                and appData.car.vehicle_id == "" 
                or view.tripRole.text == "Sjåfør" 
                and appData.car.vehicle_id == "" 
                then
                    appData.dummyTransports[i].vehicle = {}
                    appData.dummyTransports[i].vehicle.id = "0"
                    appData.schedule[i].mode = 1
                    print("PASSENGER 2")
                    native.showAlert( "Advice", "Register a car to be able to submit as a driver, please." ,  { "OK", "" } )
                else    
                    appData.dummyTransports[i].vehicle = {}
                    appData.dummyTransports[i].vehicle.id = "9"
                    appData.schedule[i].mode = 2
                    print("DRIVER")
                end 

                appData.dummyTransports[i].route.from_address = view.departureField.text
                appData.dummyTransports[i].route.to_address = view.destinationField.text
                print("ADDRESS SAVED -------------- ")

                local myDeparture = {ln, tl}
                local myDestination = {ln, tl}
                local temp 
                
                -- from location
                if dayPart == "m" then
                    temp = utils.split(appData.tempAddresses.home.location, ",")
                else 
                    temp = utils.split(appData.tempAddresses.work.location, ",")
                end  
                     
                myDeparture.ln = temp[1]
                myDeparture.lt = temp[2]

                appData.dummyTransports[i].route.from_location.coordinates[1] = myDeparture.ln
                appData.dummyTransports[i].route.from_location.coordinates[2] = myDeparture.lt

                if dayPart == "m" then
                    temp = utils.split(appData.tempAddresses.work.location, ",")
                else 
                    temp = utils.split(appData.tempAddresses.home.location, ",")
                end  
                     
                myDestination.ln = temp[1]
                myDestination.lt = temp[2]

                appData.dummyTransports[i].route.to_location.coordinates[1] = myDestination.ln 
                appData.dummyTransports[i].route.to_location.coordinates[2] = myDestination.lt             
                print("LOCATION SAVED -------------- ")

                -- update and save dummy transports
                model.updateDummyTransports() 

                -- update time on display


                -- hide interface
                view.tripChangeGroup.y = -3000

                -- adjust Pick Up f applicable
                if view.showingPickUp == true then
                    view.pickUpGroup:toFront()
                end 
                
                print("NOT ACTIVE TRANSPORT WAS CHANGED")
                view.routeMap1.x = 3000

                changeWasJustClosed = true

        if appData.dummyTransports[appData.i].created_at ~= "" then  
                      
                      print("-------------- UPDATING TRANSPORT --------------------")
                      -- prepare url
                      local transport_id = appData.dummyTransports[appData.i].transport_id
                      url = "https://api.sammevei.no/api/1/users/current/transports/"..transport_id

                      local params = {}

                      -- HEADERS
                      local headers = {}
                      headers["Content-Type"] = "application/x-www-form-urlencoded"
                      headers["Authorization"] = "Bearer "..appData.session.accessToken      
                      params.headers = headers

                      local fromAddress = "0"
                      local toAddress = "0"
                      local flexibility
                      local vehicle_id
                      local fromStreetAddress
                      local toStreetAddress
                      
                    -- BODY
                    -- from
                    fromAddress = tostring(appData.dummyTransports[i].route.from_location.coordinates[1])..
                        ","..
                        tostring(appData.dummyTransports[i].route.from_location.coordinates[2])
                    fromStreetAddress=tostring(appData.dummyTransports[i].route.from_address)
               
                    -- to
                    toAddress = tostring(appData.dummyTransports[i].route.to_location.coordinates[1])..
                        ","..
                        tostring(appData.dummyTransports[i].route.to_location.coordinates[2])
                    toStreetAddress = tostring(appData.dummyTransports[i].route.to_address)
              
                    -- flexibility
                    flexibility = tostring(appData.dummyTransports[i].flexibility)



                    -- set car parameters
                    if (appData.user.mode == "passenger") then
                        vehicle_id = "0"
                        capacity = "1"
                    else
                        vehicle_id = tostring(appData.car.vehicle_id)
                        capacity = "1" 
                    end   

                    -- mode
                    local mode

                    if appData.dummyTransports[i].vehicle.id == nil
                    or appData.dummyTransports[i].vehicle.id == 0
                    or appData.dummyTransports[i].vehicle.id == "0"
                    then 
                        mode = "passenger" 
                        print("---------------- PASSENGER")
                    else 
                        mode = "driver" 
                        print("---------------- DRIVER")
                    end

                    if mode == "driver" and appData.car.vehicle_id == nil then
                        local alert = native.showAlert( 
                            "", 
                            'For å endre innstillingen til "Sjåfør", vennligst legg inn informasjon om bilen din under "Mitt kjøretøy" først.', 
                            { "OK", "" }
                            ) 

                        return true
                    end 

                    -- set car parameters
                    if mode == "passenger" then
                        vehicle_id = "0"
                        capacity = "1"
                    else
                        vehicle_id = tostring(appData.car.vehicle_id)
                        capacity = "1" 
                    end         

                  params.body = 
                      'mode='..
                      utils.urlEncode(mode)..
                      '&'..
                      'from='..
                      fromAddress..
                      '&'..
                      'to='..
                      toAddress..
                      '&'..
                      'ts='..
                      utils.urlEncode(utcTime)..
                      '&'..
                      'vehicle_id='..
                      utils.urlEncode(vehicle_id)..
                      '&'..
                      'capacity='..
                      utils.urlEncode(capacity)..
                      '&'..
                      'flexibility='..
                      utils.urlEncode(tostring(flexibility))..
                      '&'..
                      'from_address='..
                      utils.urlEncode(fromStreetAddress)..
                      '&'..
                      'to_address='..
                      utils.urlEncode(toStreetAddress)

                      print("UPDATING TRIP: "..params.body)

                -- 4 send request ---------------------------------------------------------------------
                if fromAddress ~= "0" and toAddress ~= "0" then
                    network.request( url, "PUT", transportUpdated, params)
                end  
        end
    end
    -- Change Map

    -- [1] move routeMap1 right --------------------------------------------
    view.routeMap1.x = 3000 
    print("************************************************>>> routeMap1.x is 3000")

    -- update route on the map
    -- print("--------------- will update map")
    if view.routeMap2 ~= nil then
        -- print("--------------- updated map")

        local myDeparture = {ln, tl}
        local myDestination = {ln, tl} 

        local temp = utils.split(appData.addresses.home.location, ",")
        myDeparture.ln = temp[1]
        myDeparture.lt = temp[2]

        local temp = utils.split(appData.addresses.work.location, ",")
        myDestination.ln = temp[1]
        myDestination.lt = temp[2]

        local lon1 = "lon1="..myDeparture.ln
        local lat1 = "lat1="..myDeparture.lt
        local lon2 = "lon2="..myDestination.ln
        local lat2 = "lat2="..myDestination.lt

        lon1 = "lon1="..10.70
        lat1 = "lat1="..59.95
        lon2 = "lon2="..10.70
        lat2 = "lat2="..59.95

        if (view.nextTripGroup ~= nil or view.pickUpGroup ~= nil) then

            local myDeparture = {ln=59.93, lt=10.760}
            local myDestination = {ln=59.9935, lt=10.765} 

            if appData.match.tomorrowAfternoon.id ~= nil and appData.time.afternoon.myDeparture > os.time() then  
                myDeparture.ln = appData.location.afternoon.pick_up.ln
                myDeparture.lt = appData.location.afternoon.pick_up.lt
                myDestination.ln = appData.location.afternoon.pick_up.ln
                myDestination.lt = appData.location.afternoon.pick_up.lt
                print("------ 111")   
            end  

            if appData.match.tomorrowMorning.id ~= nil and appData.time.morning.myDeparture > os.time() then 
                myDeparture.ln = appData.location.morning.pick_up.ln
                myDeparture.lt = appData.location.morning.pick_up.lt
                myDestination.ln = appData.location.morning.pick_up.ln
                myDestination.lt = appData.location.morning.pick_up.lt
                print("------ 112")
            end  

            if appData.match.afternoon.id ~= nil and appData.time.afternoon.myDeparture > os.time() then 
                myDeparture.ln = appData.location.afternoon.pick_up.ln
                myDeparture.lt = appData.location.afternoon.pick_up.lt
                myDestination.ln = appData.location.afternoon.pick_up.ln
                myDestination.lt = appData.location.afternoon.pick_up.lt
                print("------ 113")
            end 

            if appData.match.morning.id ~= nil and appData.time.morning.myDeparture > os.time() then 
                myDeparture.ln = appData.location.morning.pick_up.ln
                myDeparture.lt = appData.location.morning.pick_up.lt
                myDestination.ln = appData.location.morning.pick_up.ln
                myDestination.lt = appData.location.morning.pick_up.lt
                print("------ 114")
            end
        end 

        lon1 = "lon1="..myDeparture.ln
        lat1 = "lat1="..myDeparture.lt
        lon2 = "lon2="..myDestination.ln
        lat2 = "lat2="..myDestination.lt 

        lon1 = "lon1="..10.70
        lat1 = "lat1="..59.95
        lon2 = "lon2="..10.70
        lat2 = "lat2="..59.95  

        params = lon1.."&"..lat1.."&"..lon2.."&"..lat2

        print("this is params: "..params)

        -- view.routeMap2:request( "map.html?"..params, system.DocumentsDirectory )
    end 

    -- nextTrip()
  
    return true   
end    

-- Start Change of Trip --------------------------------------------------
onTripChangeStart = function(event)

    print( "Start on: " .. "1" )
    if changeWasJustClosed == true then 
        changeWasJustClosed = false 
    elseif changing == false and changeWasJustClosed == false then

        local i = 1
        changing = true

        appData.i = 1
        print("the trip will change")

        -- show the interface
        view.tripChangeGroup.y = appData.contentH 
                               - display.screenOriginY 
                               - 175                      

        -- view.tripChangeGroup.y = 100

        transition.to( view.departureFieldBackground, 
            { transition=easing.outSine, 
              delay = 10, 
              time = 10, 
              x = appData.contentW/2,
              alpha = 1 
              })

        transition.to( view.departureField, 
            { transition=easing.outSine, 
              delay = 20, 
              time = 10, 
              x = appData.contentW/2 + appData.margin,
              alpha = 1   
              })

        transition.to( view.destinationFieldBackground, 
            { transition=easing.outSine, 
              delay = 10, 
              time = 10, 
              x = appData.contentW/2,
              alpha = 1  
              })

        transition.to( view.destinationField, 
            { transition=easing.outSine, 
              delay = 20, 
              time = 10, 
              x = appData.contentW/2 + appData.margin*2,
              alpha = 1  
              })


        -- fill in the interface
        
        i = 1 -- reset i

        -- view.tripTolerance.text = "+/- 30 min"
        -- view.tripRole.text = "Passasjer"

        -- view.destinationField.text = ""
        -- view.destinationField.placeholder = "Til:"
        -- view.departureField.text = ""
        -- view.departureField.placeholder = "Fra:"
        

        -- Change Map
        --[[
        if view.routeMap1 ~= nil then
            -- print("--------------- updated map for change")

            local myDeparture = {ln, tl}
            local myDestination = {ln, tl} 

            
            -- from
            local fromAddress
            fromAddress = tostring(appData.dummyTransports[i].route.from_location.coordinates[1])
            -- print("- - - - - - - - - - - - - -"..fromAddress)
            local temp = utils.split(fromAddress, ",")

            myDeparture.ln = temp[1]
            myDeparture.lt = temp[2]

            if myDeparture.lt == nil then
                myDeparture.ln = tostring(appData.dummyTransports[i].route.from_location.coordinates[1])
                myDeparture.lt = tostring(appData.dummyTransports[i].route.from_location.coordinates[2])
            end

            -- to
            local toAddress
            toAddress = tostring(appData.dummyTransports[i].route.to_location.coordinates[1])
            local temp = utils.split(toAddress, ",")

            myDestination.ln = temp[1]
            myDestination.lt = temp[2]

            if myDestination.lt == nil then
                myDestination.ln = tostring(appData.dummyTransports[i].route.to_location.coordinates[1])
                myDestination.lt = tostring(appData.dummyTransports[i].route.to_location.coordinates[2])
            end

            local lon1 = "lon1="..myDeparture.ln
            local lat1 = "lat1="..myDeparture.lt
            local lon2 = "lon2="..myDestination.ln
            local lat2 = "lat2="..myDestination.lt

            params = lon1.."&"..lat1.."&"..lon2.."&"..lat2

            print("this is params for routeMap1: "..params)


            -- [1] set routeMap1 size
            view.routeMap1.y = display.screenOriginY + 130 + 50
            view.routeMap1.height = appData.contentH - display.screenOriginY - 195 - 145
            -- view.routeMap1.x = 0

            -- [2] move routeMap1 right --------------------------------------------
            view.routeMap1.x = 3000

            -- [3] set routeMap1 transparent ---------------------------------------
            view.routeMap1.alpha = 0

            -- [4] send reuest -----------------------------------------------------
            view.routeMap1:request( "map.html?"..params, system.DocumentsDirectory )
            view.routeMap1.x = 0

            -- [5] adjust appData.tempAddresses.home.location and appData.tempAddresses.work.location
            local integralPart, fractionalPart = math.modf( (i+1)/2 )
            local dayPart 
            local dayShift = integralPart

            if fractionalPart == 0 then dayPart = "m" end
            if fractionalPart > 0 then dayPart = "a" end
 
            if dayPart == "m" then
                appData.tempAddresses.home.location = myDeparture.ln..","..myDeparture.lt
                appData.tempAddresses.work.location = myDestination.ln..","..myDestination.lt 
            else    
                appData.tempAddresses.work.location = myDeparture.ln..","..myDeparture.lt
                appData.tempAddresses.home.location = myDestination.ln..","..myDestination.lt
            end     
        end  
        --]]  
    end

    return true  
end

-- GEO SEARCH + Addresses ------------------------------------------------
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

-- UPLOAD ADDRESSES

-- finish home address upload
homeAddressUploaded = function( event )
    print("--------------- HOME ADDRESS UPLOADED ---------------")
    -- print(event.response)

    local id = appData.json.decode(event.response)
    id = id.id

    -- update home address
    -- model.updateAdressID("from", id)

    -- save home address
    -- model.saveAdresses()   
end

-- finish work address upload
workAddressUploaded = function( event )
    print("--------------- WORK ADDRESS UPLOADED ---------------")
    print(event.response)

    local id = appData.json.decode(event.response)

    if (id ~= nil) then
        id = id.id

        -- update work address
        -- model.updateAdressID("to", id)

        -- save work address
        -- model.saveAdresses() 
    end
end

-- upload home address
uploadHomeAddress = function()
    print("uploading home address")

    --prepare data
    local url = "https://api.sammevei.no/api/1/addresses" 

    local headers = {}
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Authorization"] = "Bearer "..appData.session.accessToken
      
    local params = {}
    params.headers = headers
    params.body = 
        'location='..
        utils.urlEncode(appData.addresses.home.location)..
        '&'..
        'address='..
        utils.urlEncode(appData.addresses.home.address)..
        '&'..
        'postcode='..
        utils.urlEncode(appData.addresses.home.postcode)..
        '&'..
        'place='..
        utils.urlEncode(appData.addresses.home.place)..
        '&'..
        'region='..
        utils.urlEncode(appData.addresses.home.region)..
        '&'..
        'country='..
        utils.urlEncode(appData.addresses.home.country)

    -- send request
    network.request( url, "POST", homeAddressUploaded, params)   
end

-- upload work address
uploadWorkAddress = function()
    print("uploading work address")

    --prepare data
    local url = "https://api.sammevei.no/api/1/addresses" 

    local headers = {}
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Authorization"] = "Bearer "..appData.session.accessToken
      
    local params = {}
    params.headers = headers
    params.body = 
        'location='..
        utils.urlEncode(appData.addresses.work.location)..
        '&'..
        'address='..
        utils.urlEncode(appData.addresses.work.address)..
        '&'..
        'postcode='..
        utils.urlEncode(appData.addresses.work.postcode)..
        '&'..
        'place='..
        utils.urlEncode(appData.addresses.work.place)..
        '&'..
        'region='..
        utils.urlEncode(appData.addresses.work.region)..
        '&'..
        'country='..
        utils.urlEncode(appData.addresses.work.country)

    -- send request
    network.request( url, "POST", workAddressUploaded, params)   
end






-- DEPARTURE
departureGeoSearchListener = function(event)
    print("departureGeoSearchListener")
    -- print(event.response)

    local spot = appData.json.decode(event.response)
    spot = spot.result

     -- update addresses
     model.updateAdresses(
        "from",
        spot.geometry.location.lat,
        spot.geometry.location.lng, 
        view.departureField.text
        ) 

     uploadHomeAddress()
     -- model.saveAdresses()
     departureSet = true
end

handleDepartureKeyboard = function()

    if clicked == false then

        print("DEPARTURE --------------- KEYBOARD")
        -- view.routeMap2.x = 0 

        listNumber = 1

        if appData.places == nil then appData.places = {} end
        
        if appData.places[listNumber] ~= nil then
            if appData.places[listNumber].place_id ~= nil then
                view.departureField.text = appData.places[listNumber].description

                print("THIS IS LIST NUMBER:"..listNumber)
                print("place_id:"..appData.places[listNumber].place_id)

                local place_id = appData.places[listNumber].place_id

                -- Make Geo Search String
                local requestString = 
                    "https://maps.googleapis.com/maps/api/place/details/json?placeid="..
                    place_id..
                    "&key="..
                    appData.googlePlaces.APIkey

                -- Geo Search
                network.request( requestString, "GET", departureGeoSearchListener )
            else 
                -- Fill In Address Fields 
                if departureSet == false then                   
                    view.departureField.text = tostring(appData.dummyTransports[appData.i].route.from_address)
                end
            end
        else
            -- Fill In Address Fields
            if departureSet == false then                     
                -- view.departureField.text = tostring(appData.dummyTransports[appData.i].route.from_address)           
            end
        end 

        -- Enable Destination Field
        view.destinationField.x = appData.contentW/2+appData.margin*2

        -- Hide Departure Search Results
        if view.departureSearchResults ~= nil then
            view.departureSearchResults:removeSelf()
            view.departureSearchResults = nil
            native.setKeyboardFocus( nil )
        end

        clicked = false
    end 

    if appData.places ~= nil then
        for i = #appData.places,1,-1 do
            table.remove(appData.places,i)
        end 
    end 

    if view.destinationField.text ~= "" and view.departureField.text ~= "" then 
        showMap()
        transition.to( view.tripChangeGroup, { time = 100, 
            y = appData.contentH - display.screenOriginY - 175 } )    
    end  

    -- departureSet = false
end 

departureGeoSearch = function(event)

    clicked = true
    print(event.phase)
    print("departureGeoSearch")

    listNumber = event.target.index
    view.departureField.text = appData.places[listNumber].description

    print("THIS IS LIST NUMBER:"..listNumber)
    print("place_id:"..appData.places[listNumber].place_id)

    local place_id = appData.places[listNumber].place_id

    -- Make Geo Search String
    local requestString = 
        "https://maps.googleapis.com/maps/api/place/details/json?placeid="..
        place_id..
        "&location=59.95,10.70&radius=500000"..
        "&key="..
        appData.googlePlaces.APIkey

    -- Geo Search
    network.request( requestString, "GET", departureGeoSearchListener )

    -- Enable Destination Field
    view.destinationField.x = appData.contentW/2+appData.margin*2

    -- Hide Departure Search Results
    if view.departureSearchResults ~= nil then
        view.departureSearchResults:removeSelf()
        view.departureSearchResults = nil
        native.setKeyboardFocus( nil )
    end

    -- Show Maps
    -- view.routeMap1.x = 0
    -- view.routeMap2.x = 0
    
    return true   
end

departureSearchEnd = function(event)
    print("departureSearchEnd")
    view.destinationField.x = appData.contentW/2+appData.margin*2  

    -- Hide Departure Search Results
    if view.departureSearchResults ~= nil then
        view.departureSearchResults:removeSelf()
        view.departureSearchResults = nil
        native.setKeyboardFocus( nil )
    end

    -- Show Maps
    -- view.routeMap1.x = 0
    view.routeMap2.x = 0 
end

departureSearchAutocomplete = function(event)
    print("departureSearchAutocomplete")
    appData.places = appData.json.decode(event.response)
    appData.places = appData.places.predictions

    if appData.places[1] ~= nil then
        -- move maps to the side
        -- view.routeMap1.x = 3000
        -- view.routeMap2.x = 3000

        -- reverse order in places
        -- routines.reverseTable(appData.places)

        -- show results
        view.showDepartureSearchResults(appData.places)

        -- Add touch listener to table view rows
        for i = 1, 5 do
            rows[i] = view.departureSearchResults:getRowAtIndex( i )
            rows[i]:addEventListener( "tap", departureGeoSearch )
        end
    else
        -- departureSearchEnd()
    end    
end

departureSearch = function(place)
    print("departureSearch")

    local requestString = 
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
        -- "https://maps.googleapis.com/maps/api/place/queryautocomplete/json?"
        -- "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        .."key="..appData.googlePlaces.APIkey        
        .."&input="..place
        .."&location=59.9419591,10.7169925.7"
        .."&radius=90000"
        .."&language=NO" 
        .."&components=country:no"

    network.request( requestString, "GET", departureSearchAutocomplete )
end

departureFieldListener = function(event)
    if ( event.phase == "began" ) then

        transition.to( view.tripChangeGroup, { time = 100, y = 35 + display.screenOriginY } )
        -- view.tripChangeGroup.y = 35 + display.screenOriginY

        view.departureField.text = ""

        if view.destinationField.text == "" then         
            -- view.destinationField.placeholder = ""
            -- view.destinationField.text = tostring(appData.dummyTransports[appData.i].route.to_address)       
        end 

        clicked = false
    elseif ( event.phase == "editing" ) then
        print("departureFieldListener")
        departureSearch(model.urlEncode(event.target.text))
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        timer.performWithDelay( 300, handleDepartureKeyboard, 1 )
    end
end

-- DESTINATION
destinationGeoSearchListener = function(event)
    -- print(event.response)

    local spot = appData.json.decode(event.response)
    spot = spot.result

     -- update transport
    model.updateAdresses(
        "to", 
        spot.geometry.location.lat, 
        spot.geometry.location.lng,
        view.destinationField.text
        ) 

    uploadWorkAddress()
    -- save addresses
    -- model.saveAdresses() 
    destinationSet = true
end

handleDestinationKeyboard = function()
    print("DESTINATION --------------- KEYBOARD 1")
    if clicked == false then
       -- view.routeMap2.x = 0 

        print("DESTINATION --------------- KEYBOARD 2")

        view.destinationField.x = appData.contentW/2+appData.margin*2
        listNumber = 1

        if appData.places == nil then appData.places = {} end

        if appData.places[listNumber] ~= nil then
            if appData.places[listNumber].place_id ~= nil then
                view.destinationField.text = appData.places[listNumber].description

                print("THIS IS LIST NUMBER:"..listNumber)
                print("place_id:"..appData.places[listNumber].place_id)

                local place_id = appData.places[listNumber].place_id

                -- Make Geo Search String
                local requestString = 
                    "https://maps.googleapis.com/maps/api/place/details/json?placeid="..
                    place_id..
                    "&key="..
                    appData.googlePlaces.APIkey

                -- Geo Search
                network.request( requestString, "GET", destinationGeoSearchListener )
            else 
                if destinationSet == false then
                    -- view.destinationField.text = tostring(appData.dummyTransports[appData.i].route.to_address)                 
                end
            end
        else
               if destinationSet == false then
                    -- view.destinationField.text = tostring(appData.dummyTransports[appData.i].route.to_address)                 
               end
        end 

        -- Hide Departure Search Results
        if view.destinationSearchResults ~= nil then
            view.destinationSearchResults:removeSelf()
            view.destinationSearchResults = nil
            native.setKeyboardFocus( nil )
        end

        clicked = false
    end 

    if appData.places ~= nil then
        for i = #appData.places,1,-1 do
            table.remove(appData.places,i)
        end 
    end

    if view.destinationField.text ~= "" and view.departureField.text ~= "" then 
        showMap()
        transition.to( view.tripChangeGroup, { time = 100, 
            y = appData.contentH - display.screenOriginY - 175 } )
    end
end 

destinationGeoSearch = function(event)

    clicked = true

    -- view.routeMap2.x = 0

    listNumber = event.target.index
    view.destinationField.text = appData.places[listNumber].description

    print("THIS IS LIST NUMBER:"..listNumber)
    print("place_id:"..appData.places[listNumber].place_id)

    local place_id = appData.places[listNumber].place_id

    -- Make Geo Search String
    local requestString = 
        "https://maps.googleapis.com/maps/api/place/details/json?placeid="..
        place_id..
        "&key="..
        appData.googlePlaces.APIkey

    -- Geo Search
    network.request( requestString, "GET", destinationGeoSearchListener )

    -- Hide Destination Search Results
    if view.destinationSearchResults ~= nil then
        view.destinationSearchResults:removeSelf()
        view.destinationSearchResults = nil
        native.setKeyboardFocus( nil )
    end 

    return true  
end

destinationSearchEnd = function(event)
    view.destinationField.x = appData.contentW/2+appData.margin*2  

    -- Hide Destination Search Results
    if view.destinationSearchResults ~= nil then
        view.destinationSearchResults:removeSelf()
        view.destinationSearchResults = nil
        native.setKeyboardFocus( nil )
    end 

    -- Show Maps
    -- view.routeMap1.x = 0
    view.routeMap2.x = 0 
end

destinationSearchAutocomplete = function(event)
    -- print(event.response)
    appData.places = appData.json.decode(event.response)
    appData.places = appData.places.predictions

    if appData.places[1] ~= nil then

        -- move maps to the side
        -- view.routeMap1.x = 3000
        -- view.routeMap2.x = 3000

        -- show search results
        view.showDestinationSearchResults(appData.places)

        -- Add touch listener to table view rows
        for i = 1, 5 do
            rows[i] = view.destinationSearchResults:getRowAtIndex( i )
            rows[i]:addEventListener( "tap", destinationGeoSearch )
        end
    else
        -- destinationSearchEnd()
    end    
end

destinationSearch = function(place)

    local requestString = 
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
        -- "https://maps.googleapis.com/maps/api/place/queryautocomplete/json?"
        -- "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        .."key="..appData.googlePlaces.APIkey        
        .."&input="..place
        .."&location=59.9419591,10.7169925.7"
        .."&radius=90000"
        .."&language=NO" 
        .."&components=country:no"  

    network.request( requestString, "GET", destinationSearchAutocomplete )
end

local destinationFieldListener = function(event)
    if ( event.phase == "began" ) then


        -- view.tripChangeGroup.y = 35 + display.screenOriginY
        transition.to( view.tripChangeGroup, { time = 100, y = 35 + display.screenOriginY } )

        view.destinationField.text = ""

        if view.departureField.text == "" then         
            -- view.departureField.placeholder = ""
            -- view.departureField.text = tostring(appData.dummyTransports[appData.i].route.from_address)       
        end 

        clicked = false
        appData.destinationAddress = false
    elseif ( event.phase == "editing" ) then
        destinationSearch(model.urlEncode(event.target.text))
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        timer.performWithDelay( 300, handleDestinationKeyboard, 1 )
    end
end




















-- Reset Address ID's
resetAddressID = function()

    -- MORNINGS
    for i=1, #appData.schedule, 2 do
        -- print("1 FROM ADDRESS ID: "..appData.schedule[i].from_address_id)

        local isActive = false
        local dayShift = math.ceil((i)/2)
        local dayPart
        local UTC

        dayPart = "m"
        UTC = model.calculateTransportUTC(dayShift, dayPart, i)
        -- print("utc   "..UTC)

        for j=1, #appData.transports do
            if UTC == appData.transports[j].starting_at then
                isActive = true
                -- print("found active trip")
            else    
                -- print("din NOT found active trip")
            end    
        end 

        -- print("this is field number: "..i.." isActive = "..tostring(isActive))

        if isActive == false then
            -- print("field number: "..i.." was updated ")
            appData.schedule[i].from_address_id = appData.addresses.home.address_id
            appData.schedule[i].to_address_id = appData.addresses.work.address_id 
        else 
            -- print("field number: "..i.." was NOT updated ")        
        end
        
        -- print("2 FROM ADDRESS ID: "..appData.schedule[i].from_address_id)
        -- print(".") 
        -- print(".")
    end 


    -- AFTERNOONS
    for i=2, #appData.schedule, 2 do
        -- print("1 FROM ADDRESS ID: "..appData.schedule[i].from_address_id)

        local isActive = false
        local dayShift = math.ceil((i)/2)
        local dayPart
        local UTC

        dayPart = "m"
        UTC = model.calculateTransportUTC(dayShift, dayPart, i)
        -- print("utc   "..UTC)

        for j=1, #appData.transports do
            if UTC == appData.transports[j].starting_at then
                isActive = true
                -- print("found active trip")
            else    
                -- print("din NOT found active trip")
            end    
        end 

        -- print("this is field number: "..i.." isActive = "..tostring(isActive))

        if isActive == false then
            -- print("field number: "..i.." was updated ")
            appData.schedule[i].from_address_id = appData.addresses.work.address_id
            appData.schedule[i].to_address_id = appData.addresses.home.address_id 
        else 
            -- print("field number: "..i.." was NOT updated ")        
        end
        
        -- print("2 FROM ADDRESS ID: "..appData.schedule[i].from_address_id)
        -- print(".") 
        -- print(".") 
    end    
end

-- TRANSPORTS ============================================================

-- transports cancelled
transportCanceled = function(event)

    local data = appData.json.decode(event.response)

    if data == nil then
        local alert = native.showAlert( 
            "Ooops. Feil!", 
            'En feil skjedde deaktivering av turen. Vennligst prøv igjen', 
            { "OK", "" }
            ) 

        if appData.dayPart == "m" then 
            view.switches.morning[appData.dayShift]:setState( { isOn=false } )
            view.status.morning[appData.dayShift].text = "Aktivert"
            timer.performWithDelay(1000, cancelMorningSwitch, 1) 
        elseif appData.dayPart == "a" then  
            view.switches.afternoon[appData.dayShift]:setState( { isOn=false } )
            view.status.afternoon[appData.dayShift].text = "Aktivert"
            timer.performWithDelay(1000, cancelAfternoonSwitch, 1) 
        end    

        return true
    end 

    --prepare data
    local url = "https://api.sammevei.no/api/1/users/current/transports" 

    local headers = {}
    headers["Authorization"] = "Bearer "..appData.session.accessToken
      
    local params = {}
    params.headers = headers

    -- send request
    network.request( url, "GET", saveTransports, params) 
   
    print("MY CANCELED TRANSPORTS: "..event.response)
end

-- cancel transport
cancelTransport = function(utcTime)
    print("canceling transport")
    -- search for utc start time in the transports array and register the field


    for i=1, #appData.transports do
        if (appData.transports[i].starting_at == utcTime) then
                print("H U R R A Y !")

            -- get transport id
            local transport_id = appData.transports[i].transport_id  

            -- prepare data
            local url = "https://api.sammevei.no/api/1/users/current/transports/"..
                         transport_id..
                         "/cancel" 

            -- HEADERS
            local params = {}
            local headers = {}
            headers["Authorization"] = "Bearer "..appData.session.accessToken      
            params.headers = headers             

            -- send request
            network.request( url, "PUT", transportCanceled, params)

            -- delete transport from appData.transports
            -- table.remove( appData.transports, i )

            -- save updated appData.transports 
            -- (might need to be moved to transportCanceled)
            -- model.saveTransports()

            -- change transport status info
        end
    end
end
  

-- finish uploading transport
transportUploaded = function(event)
    print("-------------------------------------- TRANSPORT UPLOADED ----------------------------------")
    print("TRANSPORT "..event.response)
    print("-------------------------------------- TRANSPORT UPLOADED ----------------------------------")

    local data = appData.json.decode(event.response)

        if data == nil then
            local alert = native.showAlert( 
                "Ooops. Feil!", 
                'En feil skjedde vedaktivering av turen. Vennligst prøv igjen', 
                { "OK", "" }
                )   

            return true
        end 

        if data.id == nil then
            local alert = native.showAlert( 
                "Ooops. Feil!", 
                'En feil skjedde vedaktivering av turen. Vennligst prøv igjen', 
                { "OK", "" }
                )                            

            return true
        end    

        --prepare data
        local url = "https://api.sammevei.no/api/1/users/current/transports" 

        local headers = {}
        headers["Authorization"] = "Bearer "..appData.session.accessToken
          
        local params = {}
        params.headers = headers

        -- send request
        network.request( url, "GET", saveTransports, params) 
end

-- upload transport
uploadTransport = function()
   
    if view.tripRole.text == "Passasjer" then 
        appData.user.mode = "passnger"
    else 
        appData.user.mode = "driver"
    end    

    -- check whether the driver has registered car
    if ( appData.user.mode == "driver" and appData.car.vehicle_id == "0" )
    or ( appData.user.mode == "driver" and appData.car.vehicle_id == nil ) 
    then

        if view.tripRole.text ~= "passenger" 
        and view.tripRole.text ~= "Passasjer"
        then   

            local alert = native.showAlert( 
                "", 
                'For å endre innstillingen til "Sjåfør", vennligst legg inn informasjon om bilen din under "Mitt kjøretøy" først.', 
                { "OK", "" }
                )

            return true
        end 

    end    

    -- upload transport if everything is ok    
    print("uploading transport")

    --prepare data
    local url = "https://api.sammevei.no/api/1/users/current/transports" 

    local params = {}

    -- HEADERS
    local headers = {}
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Authorization"] = "Bearer "..appData.session.accessToken      
    params.headers = headers

    local fromAddress = "0"
    local toAddress = "0"
    local utcTime
    local fromStreetAddress
    local toStreetAddress
    local flexibility
    local vehicle_id
    local mode

    -- BODY ---------------------------------------------------------

    -- mode
    if view.tripRole.text == "Passasjer" then
        mode = "passenger"
    else  
        mode = "driver"    
    end  
  
    -- from
    fromAddress = appData.tempAddresses.home.location         
    fromStreetAddress=appData.tempAddresses.home.address

    -- to
    toAddress = appData.tempAddresses.work.location             
    toStreetAddress = appData.tempAddresses.work.address

    if fromStreetAddress == ""
    or fromStreetAddress == nil   
    or toStreetAddress == "" 
    or toStreetAddress == nil 
    or view.departureField.text == ""   
    or view.departureField.text == nil 
    or view.destinationField.text == ""   
    or view.destinationField.text == nil 
    then
        local alert = native.showAlert( 
            "", 
            'Venligst lagre adresser din.', 
            { "OK", "" }
            )
        return true        
    end     

    -- utcTime
    utcTime = "2018"
            .."-"
            ..string.sub(view.tripDate.text,4,5)
            .."-"
            ..string.sub(view.tripDate.text,1,2)
            .."T"
            ..view.tripTime.text
            ..":00.000Z"

    -- flexibility
    flexibility = string.sub(view.tripTolerance.text, 5, 6)

    -- set car parameters
    if mode == "passenger" then
        vehicle_id = "0"
        capacity = "1"
    else
        vehicle_id = tostring(appData.car.vehicle_id)
        capacity = "1" 
    end              

    params.body = 
        'mode='..
        utils.urlEncode(tostring(mode))..
        '&'..
        'from='..
        utils.urlEncode(fromAddress)..
        '&'..
        'to='..
        utils.urlEncode(toAddress)..
        '&'..
        'ts='..
        utils.urlEncode(utcTime)..
        '&'..
        'vehicle_id='..
        utils.urlEncode(vehicle_id)..
        '&'..
        'capacity='..
        utils.urlEncode(capacity)..
        '&'..
        'flexibility='..
        utils.urlEncode(tostring(flexibility))..
        '&'..
        'from_address='..
        utils.urlEncode(fromStreetAddress)..
        '&'..
        'to_address='..
        utils.urlEncode(toStreetAddress)..
        '&'..
        'rate=0'

        -- print(params.body)

    -- send request
    if fromAddress ~= "0" and toAddress ~= "0" then
        network.request( url, "POST", transportUploaded, params) 
    end    
end
































-- -------------------------------------------------------------------------
-- Scene components
-- -------------------------------------------------------------------------
local scene = composer.newScene()

-- create()
function scene:create( event )
    appData.restart = true
    view.sceneGroup = self.view

    print("THE SCENE WAS CREATED")
    
    -- view.showBackground()
    -- view.showTripChange()
    -- onTripChangeStart()

    view.showFooter()
    view.footerGroup:toFront() 
end
 
-- show()
function scene:show( event )
 
    view.sceneGroup = self.view
    local phase = event.phase

     print("THE CTC WAS SHOWN 1")
 
    if ( phase == "will" ) then

        -- Code here runs when the scene is still off screen 
        -- view.departureField:addEventListener( "userInput", departureFieldListener )
        -- view.destinationField:addEventListener( "userInput", destinationFieldListener )

        -- view.whiteBackground:addEventListener( "tap", catcher )
        -- view.wheelButton:addEventListener( "tap", setTransportData )

        -- view.tripDateBackground:addEventListener( "tap", showTransportDateWheel )
        -- view.tripTimeBackground:addEventListener( "tap", showTransportTimeWheel )
        -- view.tripToleranceBackground:addEventListener( "tap", showTransportToleranceWheel )
        -- view.tripRoleBackground:addEventListener( "tap", showTransportRoleWheel ) 

        -- view.backButton:addEventListener( "tap", hideTransport ) 
        -- view.saveButton:addEventListener( "tap", uploadTransport ) 


    elseif ( phase == "did" ) then   
          
    end 
end
 
-- hide()
function scene:hide( event )
 
    view.sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then

 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        print("THE CTC WAS HIDDEN")
 
    end
end
 
-- destroy()
function scene:destroy( event )
 
    view.sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

    print("THE CTC WAS DESTROYED")
end

-- ------------------------------------------------------------------------
-- Scene event function listeners
-- ------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- ------------------------------------------------------------------------
 
return scene