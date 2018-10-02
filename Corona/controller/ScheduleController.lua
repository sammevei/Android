local sceneName = ScheduleController

-- Include
local view = require("view.ScheduleView")
local model = require("model.ScheduleModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )
local routines = require( "misc.appRoutines" )

-- -----------------------------------------------------------------------
-- Variables
-- -----------------------------------------------------------------------
appData.appIsRunning = false
appData.showingMap = true
appData.routeMap1Y = display.screenOriginY + 35
appData.routeMap2Y = display.screenOriginY + 35

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
local saveTransports
local transportUpdated
-- appData.transportBarListeners
local routeMap1
local resetMap
local onTripChangeEnd
local onTripChangeStart
local homeAddressUploaded
local workAddressUploaded
local uploadHomeAddress
local uploadWorkAddress
local showScene
local showMap
local showFirstTransport

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
local onChat

-- Call the partner
local onTomorrowMorningCall
local onTomorrowAfternoonCall
local onMorningCall
local onAfternoonCall
local onTransportCall
local onCall

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
local getTransports
local refreshTable
local addTrip
local showProposal

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

if appData.addressList == nil then
    appData.addressList = {}
    model.adjustAddresses()
    model.saveAddressList()
end   

-- -----------------------------------------------------------------------
-- Scene Function Declarations
-- -----------------------------------------------------------------------
showProposal = function()
    if appData.showProposal == true then
        appData.showProposal = false
        appData.composer.showOverlay("controller.PurposalController")
    end    
end    


showMap = function()
    -- print(tostring(appData.showingMap))
    if appData.showingMap == false then
        view.routeMap1.y = 4000
        view.routeMap2.y = 4000
    end    
    if appData.showingMap == true and showingNextTrip  == false then
        view.routeMap1.y = appData.routeMap1Y
        view.routeMap2.y = appData.routeMap2Y
    end     
    if appData.showingMap == true and showingNextTrip  == true then
        view.routeMap1.y = appData.routeMap1Y + 100
        view.routeMap2.y = appData.routeMap2Y + 100
    end     
    if appData.showingMap == true and view.showingStartDriving == true then
        view.routeMap1.y = appData.routeMap1Y + 100
        view.routeMap2.y = appData.routeMap2Y + 100
    end       
    if appData.showingMap == true and view.showingDrivingInfo == true then
        view.routeMap1.y = appData.routeMap1Y + 100
        view.routeMap2.y = appData.routeMap2Y + 100
    end      
    if appData.showingMap == true and view.showingDriverMap == true then
        view.routeMap1.y = appData.routeMap1Y + 100
        view.routeMap2.y = appData.routeMap2Y + 100                       
    end    
end

appData.transportBarListeners = function(bar)
    view.rowBar[bar]:addEventListener( "tap", onRowBar ) 

    if appData.transports[bar].matches[1] ~= nil then
        -- print("_____ ______ ______ ______ _____ "..bar)
        view.transportPhones[bar]:addEventListener( "tap", onCall ) 
        view.transportChats[bar]:addEventListener( "tap", onChat )  
    end    
end

refreshTable = function()
    if appData.refreshTable == true and appData.transports ~= nil then

        -- hide first trip button
        if view.firstTransportGroup ~= nil then
            view.firstTransportGroup.alpha = 0
        end    

        -- remove old table view
        if  view.transportsTableView ~= nil then
            view.transportsTableView:removeSelf()
            view.transportsTableView = nil
        end 

        -- remove 
        if  view.transportsGroup ~= nil then
            view.transportsGroup:removeSelf()
            view.transportsGroup = nil
        end 

        -- Remove terminated and finished transports
        for i = 1, #appData.transports do

            print("++++++++++++ +++++++++ +++++++ "..i)

            if appData.transports[i] == nil then
                return true
            end
                
            if appData.transports[i].status ~= nil then
                if appData.transports[i].status == "finish" 
                or appData.transports[i].status == "terminated" 
                then
                    table.remove( appData.transports, i )
                end
            end    
        end    

        -- Create transport table
        view.showTransports() 

        if appData.transports[1] ~= nil then
            if view.firstTransportGroup ~= nil then
                view.firstTransportGroup:removeSelf()
                view.firstTransportGroup = nil
            end
        else
            if view.footerGroup == nil then
                view.showFirstTransport()
                view.firstButton:addEventListener( "touch", addTransport ) 
            end
        end       

        appData.refreshTable = false
    end 

    if view.transportView ~= nil then 
        view.transportView:toFront()
    end      
end

local options = {
    isModal = true,
    effect = "fade",
    time = 1
}

onRowBar = function(event)
    print("---------------- ROW BAR -------------------"..event.target.id)
    appData.transportDetails = event.target.id
    appData.composer.setVariable( "i", event.target.id )
    appData.composer.showOverlay( "controller.TransportDetailsController", options)
end

addTransport = function(event)
    print("----------")
    if event.phase == "began" then
        -- event.target.alpha = 0.5
    elseif event.phase == "ended" then 
        -- event.target.alpha = 1.0
        appData.composer.showOverlay( "controller.CreateTransportController", options)
        appData.showingMap = false
        -- appData.routeMap1Y = view.routeMap1.y
        -- appData.routeMap2Y = view.routeMap2.y
        appData.tempAddresses.home.location = "0,0"
        appData.tempAddresses.work.location = "0,0"
    end   
end

-- MISC & UTILS ==========================================================

-- catches click through
catcher = function()
    return true
end    

-- Refresh Token
tokenRefreshed = function(event)
    local data = appData.json.decode(event.response)

    if data ~= nil then
        if data.token.accessToken ~= nil then
            appData.session.accessToken = data.token.accessToken
        end 
    end   
end

refreshToken = function()
    print("refreshing token")

        -- prepare data
        local url = "https://api.sammevei.no/api/1/auth/token" 


        local params = {}

        -- HEADERS
        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        headers["Authorization"] = "Bearer "..appData.session.accessToken      
        params.headers = headers

        -- BODY
        params.body = 'refreshToken='..appData.session.refreshToken
        print(params.body)

        -- send request
        network.request( url, "POST", tokenRefreshed, params)  
end  

-- Show Scene After Start
showScene = function() 

    -- print ("------------  ready ------------")
    -- print(tostring(matches.morningMatch))
    -- print(tostring(matches.afternoonMatch))
    -- print(tostring(matches.tomorrowMorningMatch))
    -- print(tostring(matches.tomorrowAfternoonMatch))
    -- print(tostring(showingNextTrip))   

    if matches.morningMatch == true 
    and matches.afternoonMatch == true
    and matches.tomorrowMorningMatch == true 
    and matches.tomorrowAfternoonMatch == true 
    then  
        -- print("SHOWING SCHEDULE ----------- 1")  
        -- move scene to view
        view.sceneGroup.x = 0

        -- hide background
        if appData.background ~= nil then
            appData.background:removeSelf()
            appData.background = nil
        end    

    elseif appData.transports == nil then
        -- print("SHOWING SCHEDULE ----------- 2")  
        -- move scene to view
        view.sceneGroup.x = 0 

        -- hide background
        if appData.background ~= nil then
            appData.background:removeSelf()
            appData.background = nil
        end    

    elseif #appData.transports == 0 then 
        -- print("SHOWING SCHEDULE ----------- 3")  
        -- move scene to view
        view.sceneGroup.x = 0 

        -- hide background
        if appData.background ~= nil then
            appData.background:removeSelf()
            appData.background = nil
        end    

    elseif showingNextTrip == true then
        -- print("SHOWING SCHEDULE ----------- 4")  
        -- move scene to view
        view.sceneGroup.x = 0 

        -- hide background
        if appData.background ~= nil then
            appData.background:removeSelf()
            appData.background = nil
        end                     
    

    elseif morningTransportEnabled == true then
        -- print("SHOWING SCHEDULE ----------- 5")  
        -- move scene to view
        view.sceneGroup.x = 0 

        -- hide background
        if appData.background ~= nil then
            appData.background:removeSelf()
            appData.background = nil
        end 

    elseif afternoonTransportEnabled == true then
        -- print("SHOWING SCHEDULE ----------- 6")  
        -- move scene to view
        view.sceneGroup.x = 0 

        -- hide background
        if appData.background ~= nil then
            appData.background:removeSelf()
            appData.background = nil
        end 
    else
        -- print("SHOWING SCHEDULE ----------- 7")  
        -- move scene to view
        view.sceneGroup.x = 0 

        -- hide background
        if appData.background ~= nil then
            appData.background:removeSelf()
            appData.background = nil
        end         

    end
end 

-- 


-- RATING ================================================================
ratingFinished = function(event)
    print(event.response)
end    

rateTrip = function(event)
        print("rating! -------------- "..event.target.id)
        

        if event.target.id == "todayMorningThumbsDown" then

            if morningRating == "-1"
            or morningRating == "1"
            then
                return true
            end

            event.target.alpha = 1
            view.todayMorningThumbsUp.alpha = 0.5

            print("rating trip 1")
            
            --prepare data
            local url = "https://api.sammevei.no/api/1/users/current/transports/"
            ..morningTransportID
            .."/rating" 

            local headers = {}
            headers["Content-Type"] = "application/x-www-form-urlencoded"
            headers["Authorization"] = "Bearer "..appData.session.accessToken
              
            local params = {}
            params.headers = headers
            params.body = 'rating=-1'

            -- send request
            network.request( url, "POST", ratingFinished, params) 

        elseif event.target.id == "todayMorningThumbsUp" then

            if morningRating == "-1"
            or morningRating == "1"
            then
                return true
            end

            event.target.alpha = 1
            view.todayMorningThumbsDown.alpha = 0.5

            print("rating trip 2")
            
            --prepare data
            local url = "https://api.sammevei.no/api/1/users/current/transports/"
            ..morningTransportID
            .."/rating" 

            local headers = {}
            headers["Content-Type"] = "application/x-www-form-urlencoded"
            headers["Authorization"] = "Bearer "..appData.session.accessToken
              
            local params = {}
            params.headers = headers
            params.body = 'rating=1'

            -- send request
            network.request( url, "POST", ratingFinished, params) 

        elseif event.target.id == "todayAfternoonThumbsDown" then

            if afternoonRating == "-1"
            or afternoonRating == "1"
            then
                return true
            end

            event.target.alpha = 1
            view.todayAfternoonThumbsUp.alpha = 0.5

            print("rating trip 3")
            
            --prepare data
            local url = "https://api.sammevei.no/api/1/users/current/transports/"
            ..afternoonTransportID
            .."/rating" 

            local headers = {}
            headers["Content-Type"] = "application/x-www-form-urlencoded"
            headers["Authorization"] = "Bearer "..appData.session.accessToken
              
            local params = {}
            params.headers = headers
            params.body = 'rating=-1'

            -- send request
            network.request( url, "POST", ratingFinished, params)    

        elseif event.target.id == "todayAfternoonThumbsUp" then

            if afternoonRating == "-1"
            or afternoonRating == "1"
            then
                return true
            end

            event.target.alpha = 1            
            view.todayAfternoonThumbsDown.alpha = 0.5

            print("rating trip 3")
            
            --prepare data
            local url = "https://api.sammevei.no/api/1/users/current/transports/"
            ..afternoonTransportID
            .."/rating" 

            local headers = {}
            headers["Content-Type"] = "application/x-www-form-urlencoded"
            headers["Authorization"] = "Bearer "..appData.session.accessToken
              
            local params = {}
            params.headers = headers
            params.body = 'rating=1'

            -- send request
            network.request( url, "POST", ratingFinished, params)              
        end           
            
        return true
end

showRating = function()

    -- MORNING ----------------------------------------------
    if appData.status.morning == "finish" then

        -- print("running showRating - - - - - morning")
        -- handle morning components
        view.todayMorningStatus.text = ""
        view.todayMorningPeriod.alpha = 0
        view.todayMorningTime.alpha = 0
        view.todayMorningSwitch.alpha = 0
        view.todayMorningStatus.alpha = 0
        view.todayMorningMask.alpha = 1
        view.todayMorningPortrait.alpha = 1
        view.todayMorningRole.alpha = 1
        view.todayMorningName.alpha = 1
        view.todayMorningPhone.alpha = 0
        view.todayMorningChat.alpha = 0

        -- -------------------------------------------------

        if morningRating == "1" then
            view.todayMorningThumbsUp.alpha = 1
            view.todayMorningThumbsDown.alpha = 0.5
        elseif morningRating == "-1" then
            view.todayMorningThumbsDown.alpha = 1 
            view.todayMorningThumbsUp.alpha = 0.5 
        end 

        -- -------------------------------------------------   

        if view.todayMorningThumbsDown.alpha == 1 then
            view.todayMorningThumbsDown.alpha = 1
        else    
            view.todayMorningThumbsDown.alpha = 0.5
        end 

        if view.todayMorningThumbsUp.alpha == 1 then
            view.todayMorningThumbsUp.alpha = 1
        else    
            view.todayMorningThumbsUp.alpha = 0.5
        end 
    end
    
    -- AFTERNOON -------------------------------------------
    if appData.status.afternoon == "finish" then

        -- print("running showRating - - - - - afternoon")
        -- handle afternoon components
        view.todayAfternoonStatus.text = ""
        view.todayAfternoonPeriod.alpha = 0
        -- view.todayAfternoon.alpha = 0
        view.todayAfternoonTime.alpha = 0
        view.todayAfternoonSwitch.alpha = 0
        view.todayAfternoonStatus.alpha = 0
        view.todayAfternoonMask.alpha = 1
        view.todayAfternoonPortrait.alpha = 1
        view.todayAfternoonRole.alpha = 1
        view.todayAfternoonName.alpha = 1
        view.todayAfternoonPhone.alpha = 0
        view.todayAfternoonChat.alpha = 0

        -- -------------------------------------------------

        if afternoonRating == "1" then
            view.todayAfternoonThumbsUp.alpha = 1
            view.todayAfternoonThumbsDown.alpha = 0.5
        elseif afternoonRating == "-1" then
            view.todayAfternoonThumbsDown.alpha = 1 
            view.todayAfternoonThumbsUp.alpha = 0.5   
        end 

        -- -------------------------------------------------   

        if view.todayAfternoonThumbsDown.alpha == 1 then
            view.todayAfternoonThumbsDown.alpha = 1
        else    
            view.todayAfternoonThumbsDown.alpha = 0.5
        end 

        if view.todayAfternoonThumbsUp.alpha == 1 then
            view.todayAfternoonThumbsUp.alpha = 1
        else    
            view.todayAfternoonThumbsUp.alpha = 0.5
        end 
    end       
end

-- GPS ===================================================================

checkGPS = function()
    if (appData.myLocation.lt == "59.95") then
        if (system.getInfo( "environment" ) ~= "simulator") then 
            local alert = native.showAlert( "", "SammeVei trenger din posisjon. Slå på stedstjenester, takk!", { "OK", "" } )        
        end
    end    
end 

readyGPS = false
uploadGPS = function()
    if (appData.user.mode == "driver" and readyGPS == true ) then
        print("uploading GPS")

        -- prepare data
        local url = "https://api.sammevei.no/api/1/users/current/transports/"..
        appData.currentTransport..
        "/positions" 

        local params = {}

        -- HEADERS
        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        headers["Authorization"] = "Bearer "..appData.session.accessToken      
        params.headers = headers

        -- BODY

        local gps = appData.myLocation.ln..","..appData.myLocation.lt
        local heading = appData.myDirection
        local speed = appData.mySpeed

        params.body = 

            'position='..
             gps..
            '&'..
            'course='..
            '0'..
            '&'..
            'heading='..
             heading..
            '&'..
            'velocity='..
             speed..
            '&'..
            'altitude='..
            '20'..
            '&'..
            'floor='..
            '5'

        -- send request
        network.request( url, "POST", uploadedGPS, params) 
    end
end
-- Upload Driver's GPS Data
uploadedGPS = function(event)
    -- print("GPS "..event.response)mo
end

-- Countdowns ------------------------------------------------------------
-- Show the passenger when he will be picked up by the driver 
passengerCountdown = function ()

    if (view.passengerCountdown ~= nil) then

         -- gather time
        local temp

        if tonumber(os.date("%H")) >= 12 then
            temp = routines.UTCtoLocal(appData.match.afternoon.pick_up_at)        
        else
            temp = routines.UTCtoLocal(appData.match.morning.pick_up_at)  
        end 

        if temp ~= nil then
            local driverTime = 60*tonumber(os.date("%H"))+tonumber(os.date("%M")) -- minutes from midnight
            local passengerTime = 60*tonumber(temp.hour)+tonumber(temp.sec)/60 -- minutes from midnight

            -- calculate difference
            local difference = passengerTime - driverTime

            -- assemble time
            local countdownText

            if (difference < 0) then 
                countdownText = "Kommer nå!"
            else 
                countdownText = "Kommer om "..difference.." min."    
            end  
              
            -- update the text
            view.passengerCountdown.text = countdownText
        end    

    elseif (view.driverCountdown2 ~= nil ) then

         -- gather time
        local temp

        if tonumber(os.date("%H")) >= 12 then
            temp = routines.UTCtoLocal(appData.match.afternoon.pick_up_at)        
        else
            temp = routines.UTCtoLocal(appData.match.morning.pick_up_at)  
        end 

        if temp ~= nil then
            local driverTime = 60*tonumber(os.date("%H"))+tonumber(os.date("%M")) -- minutes from midnight
            local passengerTime = 60*tonumber(temp.hour)+tonumber(temp.sec)/60 -- minutes from midnight

            -- calculate difference
            local difference = passengerTime - driverTime

            -- assemble time
            local countdownText

            if (difference < 0) then 
                countdownText = "Kommer nå!"
            else 
                countdownText = "Ca. "..difference.." min. unna"    
            end  
              
            -- update the text 
            if (difference < 0) then 
                view.driverCountdown2.text = "Du er sent ute!"
            else      
                view.driverCountdown2.text = "Plukk opp i "..difference.." min."
            end 
        end        
    end
end

-- Show the driver when to pick up the passenger  
driverCountdown = function ()

    if (view.driverCountdown ~= nil) then

        -- gather time
        local temp
        local hour

        if tonumber(os.date("%H")) >= 12 
        and appData.match.afternoon.starting_at ~= nil
        then
            hour = string.sub(appData.match.afternoon.starting_at, 12, 16)
            temp = routines.UTCtoLocal(appData.match.afternoon.starting_at)       
        elseif appData.match.morning.starting_at ~= nil then
            hour = appData.match.morning.starting_at
            temp = routines.UTCtoLocal(appData.match.morning.starting_at, 12, 16)  
        end 

        if temp ~= nil then
            local driverTime = 60*tonumber(os.date("%H"))+tonumber(os.date("%M")) -- minutes from midnight
            local startTime = 60*tonumber(temp.hour)+tonumber(temp.sec)/60 -- minutes from midnight

            -- calculate difference
            local difference = startTime - driverTime
            -- print("DIFFERENCE = "..difference)

            -- assemble time
            local countdownText

            if (difference < 0) then 
                countdownText = "Start nå!"
            elseif difference < 300000 and difference > -60 then 
                countdownText = "Begynn å kjøre om "..difference.." minutt"
                view.startButton.alpha = 1  
            else  
                countdownText = "Begynn å kjøre kl. "..temp.hour..":"..temp.sec/60 
                view.startButton.alpha = 0              
            end

            view.driverCountdown.text = countdownText 
        end        
    end
end





















-- DRIVING ===============================================================
-- Open Google Maps App  -------------------------------------------------
startGoogleMaps = function(event)
    if ( event.phase == "began" ) then
        -- make icon half transparent 
        event.target.alpha = 0.5

    elseif ( event.phase == "ended" ) then
        -- make icon opaque
         event.target.alpha = 1

        -- prepare url
        -- print("STARTING NAVIGATION")

        local driverStart = {ln, tl}
        local passengerStart = {ln, tl} 
        local temp

        --[[
        -- DRIVER - this must be GPS data
        if ( tonumber(os.date("%H")) < 12) then
            temp = utils.split(appData.addresses.home.location, ",")
        else
            temp = utils.split(appData.addresses.work.location, ",")
        end 

        driverStart.ln = temp[1]
        driverStart.lt = temp[2]
        --]]

        driverStart.ln = appData.myLocation.ln
        driverStart.lt = appData.myLocation.lt

        -- print("LN = "..driverStart.ln)
        -- print("LT = "..driverStart.lt)

        -- PASSENGER
        if tonumber(os.date("%H")) <= 11 then  
            temp = appData.match.morning.pick_up_location.coordinates
        else
            temp = appData.match.afternoon.pick_up_location.coordinates
        end  

        passengerStart.ln = temp[1]
        passengerStart.lt = temp[2]

        local address = (
                    "https://www.google.com/maps/dir/?api=1&origin="..
                    driverStart.lt..
                    ","..
                    driverStart.ln..
                    "&destination="..
                    passengerStart.lt..
                    ","..
                    passengerStart.ln
                    )

        -- open navigation
        system.openURL(address)

        -- hide button
        -- view.startButton.alpha = 0

        return true
    end    
end

-- Close Route 
keepDriving = function() 
end

driveEnded = function(event)

    showingNextTrip = false
    view.showingStartDriving = false
    view.showingDrivingInfo = false
    view.showingDriverMap = false
    view.showingPickUp = false
    view.showingNextTrip = false
    appData.showingMap = true
    
    if tonumber(os.date("%H")) <= 13 then
        appData.status.morning="finish"
    else
        appData.status.afternoon="finish" 
    end       

    readyGPS = false

    downloadMatches() -- download matches to update everything immediately
    print(event.response)

    -- hide trip details
    -- view.transportView.alpha = 0
end    

closeDriving = function(event)
    if ( event.action == "clicked" ) then
        local i = event.index
        if ( i == 1 ) then
        else
            if view.transportView ~= nil then
                view.transportView.alpha = 0
            end  
            
            if view.startDrivingGroup ~= nil then  
                view.startDrivingGroup.alpha = 0
            end
            
            if view.drivingGroup ~= nil then     
                view.drivingGroup.alpha = 0
            end  
            
            if view.driverMap ~= nil then 
                view.driverMap.y = 3000
            end 
               
            view.scheduleSlide.alpha = 1 
            view.routeMap2.y = display.screenOriginY + 35
            view.routeMap2.height = appData.contentH - display.screenOriginY - 195

            -- view.routeMap1.x = 0
            view.routeMap1.y = display.screenOriginY + 35
            view.routeMap1.height = appData.contentH - display.screenOriginY - 195

            appData.showingMap = true
            view.showingDriverMap = false

            showingNextTrip = false
            view.showingStartDriving = false
            view.showingDrivingInfo = false
            view.showingDriverMap = false
            view.showingPickUp = false
            view.showingNextTrip = false
            appData.showingMap = true

            -- reload
            if view.routeMap2 ~= nil then

                -- show blank map (Route Map 2) -----------------------------

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

                params = lon1.."&"..lat1.."&"..lon2.."&"..lat2

                print("this is params: "..params)

                view.routeMap2:request( "map.html?"..params, system.DocumentsDirectory )
            end 

            -- End Transport -------------------------------------------------------
            -- prepare data
            local url = "https://api.sammevei.no/api/1/users/current/transports/"..
            appData.currentTransport..
            "/finish" 

            local params = {}

            -- HEADERS
            local headers = {}
            headers["Content-Type"] = "application/x-www-form-urlencoded"
            headers["Authorization"] = "Bearer "..appData.session.accessToken      
            params.headers = headers

            -- send request
            network.request( url, "PUT", driveEnded, params) 
        end
    end       
end

-- Close Driving Alert
closeDrivingAlert = function()
    local alert = native.showAlert( "Ønsker du å avslutte din tur?", "", { "NEI", "JA" }, closeDriving )
end

showRouteMap = function()
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

    params = lon1.."&"..lat1.."&"..lon2.."&"..lat2

    print("this is params: "..params)

    view.routeMap2:request( "map.html?"..params, system.DocumentsDirectory )    
end

-- Show Route ------------------------------------------------------------
showMyRoute = function()

    local myDeparture = {ln, tl}
    local myDestination = {ln, tl} 
    local mapCenter = {ln, tl} 

    local temp = utils.split(appData.addresses.home.location, ",")
    myDeparture.ln = temp[1]
    myDeparture.lt = temp[2]

    local temp = utils.split(appData.addresses.work.location, ",")
    myDestination.ln = temp[1]
    myDestination.lt = temp[2]

    mapCenter.ln = tostring((myDeparture.ln + myDestination.ln)/2)
    mapCenter.lt = tostring((myDeparture.lt + myDestination.lt)/2)

    -- print (mapCenter.ln)
    -- print (mapCenter.lt )

    routines.createMap(myDeparture.lt, myDeparture.ln, myDestination.lt, myDestination.ln)
    view.myRouteMap()
    showRouteMap()
end

showDirections = function()
    print("--------- DIRECTIONS -----------")
    -- ------------------------------------------------------------------------- --
    -- DRIVER
    -- ------------------------------------------------------------------------- --
    -- find out my role

    -- print("ENTITY="..appData.match.afternoon.transport_entity_type_id)

   if (appData.match.morning.transport_entity_type_id == 2) then 
        appData.user.mode = "passenger"
   else
        appData.user.mode = "driver"
   end
           
    --[[
    if tonumber(os.date("%H")) >= 12 then
       if (appData.match.afternoon.transport_entity_type_id == 2) then 
            appData.user.mode = "passenger"
       else
            appData.user.mode = "driver"
       end
    end 
    --]]
    -- show route
    if (appData.user.mode == "driver") then
        
        -- hide general map
        view.routeMap2.y = 3000
        view.routeMap1.y = 3000
        appData.showingMap = false

        -- prepare data
        local mapCenter = {ln, tl}
        local driverStart = {ln, tl}
        local passengerStart = {ln, tl} 
        local temp

        driverStart.ln = appData.myLocation.ln
        driverStart.lt = appData.myLocation.lt

        if tonumber(os.date("%H")) >= 25 then
            temp = appData.match.afternoon.pick_up_location.coordinates
        else
            temp = appData.match.morning.pick_up_location.coordinates
        end  

        passengerStart.ln = temp[1]
        passengerStart.lt = temp[2]

        mapCenter.ln = tostring((driverStart.ln + passengerStart.ln)/2)
        mapCenter.lt = tostring((driverStart.lt + passengerStart.lt)/2)
        
        -- create map
        print("--------------- making DriverMapMap")
        routines.createDriverMap(driverStart.lt, driverStart.ln, passengerStart.lt, passengerStart.ln)
        
        -- show map
        view.showDriverMap()

        view.showDrivingInfo()

        view.transportView.alpha = 1
        view.transportView:toFront()

        -- show driving info with countdown
        -- view.showStartDrivingInfo(address)

        -- assign listeners to driving info
        view.mapsButton:addEventListener( "touch", startGoogleMaps )
        view.cancelButton:addEventListener( "tap", closeDrivingAlert ) -- (3) ----------------
    
    -- ------------------------------------------------------------------------- --
    -- PASSENGER
    -- ------------------------------------------------------------------------- --
    
    elseif (appData.user.mode == "passenger") then

        -- hide general map
        view.routeMap2.y = 3000
        view.routeMap1.y = 3000

        -- prepare data
        local mapCenter = {ln, tl}
        local driverStart = {ln, tl}
        local passengerStart = {ln, tl} 
        local temp
        local transport_id

        temp[1] = 10.75
        temp[2] = 59.95

        passengerStart.ln = appData.myLocation.ln
        passengerStart.lt = appData.myLocation.lt

        if tonumber(os.date("%H")) >= 12 then
            temp = appData.match.afternoon.pick_up_location.coordinates
        else
            temp = appData.match.morning.pick_up_location.coordinates
        end  

        driverStart.ln = temp[1]
        driverStart.lt = temp[2]

        mapCenter.ln = tostring((driverStart.ln + passengerStart.ln)/2)
        mapCenter.lt = tostring((driverStart.lt + passengerStart.lt)/2)

        
        if tonumber(os.date("%H")) >= 12 then
            transport_id = appData.match.afternoon.transport_id
        else
            transport_id = appData.match.morning.transport_id
        end 
        
        -- create map
        routines.createPassengerMap(
            driverStart.lt, 
            driverStart.ln, 
            passengerStart.lt, 
            passengerStart.ln,
            transport_id, 
            "Bearer "..appData.session.accessToken
            )
       
        -- show map
        print("asking to show passenger map")
        -- view.showPassengerMap()

        -- show directions
        -- view.showDriverMap(address)

        -- =================================================
        -- show driving info with countdown
        view.showPickUpInfo(address)

        

        -- assign listeners to driving info
        -- view.startButton:addEventListener( "touch", startDriving )
        -- view.navigationButton:addEventListener( "touch", startGoogleMaps )
    end
end

-- Start Driving
driveStarted = function(event)
    readyGPS = true
    appData.showingMap = false
    print(event.response)
end

startDrive = function()
    -- print("STATUS MORNING =============> "..appData.status.morning)
    -- print("STATUS AFTERNOON =============> "..appData.status.morning)
    -- save status
    -- if tonumber(os.date("%H")) <= 11 then
    --     appData.status.morning = "start"
    -- else  
    --     appData.status.afternoon = "start"
    -- end    

      -- hide start driving info
      if view.startDrivingGroup ~= nil then
        view.startDrivingGroup.alpha = 0
      end  

      -- hide map
      view.routeMap2.y = 3000
      view.routeMap1.y = 3000
      appData.showingMap = false

      -- hide schedule
      view.scheduleSlide.alpha = 0 

      -- show driving map
      showDirections()

      -- start sending location
      -- readyGPS = true

      -- show actual transport
      view.transportView.alpha = 1

      -- update transport details
      -- MORNING --------------------------------------------------------------
      if tonumber(os.date("%H")) <= 25 then
        if (appData.user.mode == "passenger") then
            print("######### MORNING #########")

          view.transportRole.text = "Your driver"
          local localHour = string.sub(appData.match.morning.pick_up_at, 12, 13)
          localHour = tonumber(localHour) + os.date("%z")/100
          localHour = tostring(localHour)
          local localMinute = string.sub(appData.match.morning.pick_up_at, 15, 16)
          appData.pickupTime = localHour..":"..localMinute
          view.transportTime.text = "pick up time: "..appData.pickupTime
          view.transportName.text = appData.match.morning.person.firstname

        else

          view.transportRole.text = "Din passasjer"
          local localHour = string.sub(appData.match.morning.pick_up_at, 12, 13)
          localHour = tonumber(localHour) + os.date("%z")/100
          localHour = tostring(localHour)
          local localMinute = string.sub(appData.match.morning.pick_up_at, 15, 16)
          appData.pickupTime = localHour..":"..localMinute
          view.transportTime.text = "Plukk opp kl. "..appData.pickupTime
          view.transportName.text = appData.match.morning.person.firstname

        end  
      end

      -- AFTERNOON --------------------------------------------------------------

      if tonumber(os.date("%H")) >= 128 then
        print("######### AFTERNOON #########")

        -- update transport details
        if (appData.user.mode == "passenger") then

            view.transportRole.text = "Your driver"
            local localHour = string.sub(appData.match.afternoon.pick_up_at, 12, 13)
            localHour = tonumber(localHour) + os.date("%z")/100
            localHour = tostring(localHour)
            local localMinute = string.sub(appData.match.afternoon.pick_up_at, 15, 16)
            appData.pickupTime = localHour..":"..localMinute
            view.transportTime.text = "Plukk opp kl. "..appData.pickupTime

        else
            view.transportRole.text = "Din passasjer"
            local localHour = string.sub(appData.match.afternoon.pick_up_at, 12, 13)
            localHour = tonumber(localHour) + os.date("%z")/100
            localHour = tostring(localHour)
            local localMinute = string.sub(appData.match.afternoon.pick_up_at, 15, 16)
            appData.pickupTime = localHour..":"..localMinute
            view.transportTime.text = "Plukk opp kl. "..appData.pickupTime
        end  

        view.transportName.text = appData.match.afternoon.person.firstname

      end

        -- Start Transport -------------------------------------------------------
        -- change status
        if tonumber(os.date("%H")) <= 11 then
            appData.status.morning = "start"
        else
            appData.status.afternoon = "start"
        end

        -- prepare data
        local url = "https://api.sammevei.no/api/1/users/current/transports/"..
        appData.currentTransport..
        "/start" 

        local params = {}

        -- HEADERS
        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        headers["Authorization"] = "Bearer "..appData.session.accessToken      
        params.headers = headers

        -- send request
        network.request( url, "PUT", driveStarted, params) 

        print("STARTING DRIVE =====================================================")
        print(url)
        print("STARTING DRIVE =====================================================")
end


























-- TRIP CHANGE =============================================================

-- reset the map if double click
resetMap = function(event)
    -- print("-------------------------- + + + -----------------------------")
    -- print(view.routeMap1.x)
    -- print(changing)
    -- view.routeMap2.x = 3000

    if changing == false then
        view.routeMap1.x = 3000
    end  
end

-- used by maps
routeMap1 = function()
    print("routeMap1 1 ------------------- print routeMap1 1")
    
    if changing == true 
    and optionsVisible == false 
    and wheelVisible == false
    then
        view.routeMap1.x = 0
        transition.fadeIn( view.routeMap1, { delay = 0, time = 0 } )
        print("routeMap1 2 ------------------- print routeMap1 2")
    end    
end

webListener = function(event)
    view.routeMap1.x = 3000
    print(" web listener 1 ------------------- print web listener 1")
    if ( event.type == "loaded" and changing == true) then
        routeMap1() 
        print(" web listener 2 ------------------- print web listener 2")      
    end
end

-- save transport data when changed
setTransportData = function(event)
    -- view.tripChangeGroup.y = display.screenOriginY + 55
    view.departureField.y = 3
    view.destinationField.y = 47

    view.routeMap2.y = display.screenOriginY + 130 + 50 
    view.routeMap1.y = display.screenOriginY + 130 + 50
    
    -- set wheel not visible
    wheelVisible = false

    -- show trip map if changing
    if changing == true then
        routeMap1()
    end  

    print("JUMP")  
    transition.to( view.whiteBackground, { time = 25, alpha = 0 } )
    transition.to( view.wheelButton, { time = 25, alpha = 0 } )

    if view.transportTimeWheel.y ~= -3000 then
        transition.to( view.transportTimeWheel, { time = 25, y = -3000 } )
        local values = view.transportTimeWheel:getValues()
        view.tripTime.text = values[2].value..values[3].value..values[4].value
    end

    if view.transportToleranceWheel.y ~= -3000 then
        transition.to( view.transportToleranceWheel, { time = 25, y = -3000 } )
        local values = view.transportToleranceWheel:getValues()
        view.tripTolerance.text = values[2].value
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
    view.routeMap2.y = 3000
    view.routeMap1.y = 3000

    transition.to( view.transportRoleWheel, { time = 25, y = 125 } )
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
    view.routeMap2.y = 3000
    view.routeMap1.y = 3000

    transition.to( view.transportToleranceWheel, { time = 25, y = 125 } )
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
    view.tripTolerance.text = values[1].value

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
    view.routeMap2.y = 3000
    view.routeMap1.y = 3000

    transition.to( view.transportTimeWheel, { time = 25, y = 125 } )
    transition.to( view.whiteBackground, { time = 25, alpha = 1 } )
    transition.to( view.wheelButton, { time = 25, alpha = 1 } ) 

    if appData.period == "m" then
        view.transportTimeWheel:selectValue( 2, 3 )
    elseif appData.period == "a" then 
        view.transportTimeWheel:selectValue( 2, 8 ) 
    end

    return true       
end

-- Finish Downloading  Transports
saveTransports = function(event)
    print("downloading and saving transports! -----------------------------------") 
    model.createDummyTransports()  -- [1] create dummyTransports  
    appData.transports = appData.json.decode(event.response) -- [2] load transports from server
    model.updateDummyTransports() -- [3] update dummy tranpsorts
    model.saveTransports()
    appData.refreshTable = true
end

getTransports = function(event)   

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

-- Finish Updated Transport
transportUpdated = function(event)   
    print("--------------- TRANSPORT UPDATED ---------------")
    print("TRANSPORT: "..event.response)

    local data = appData.json.decode(event.response)

    if data == nil then
        local alert = native.showAlert( 
            "Ooops. Feil!", 
            'En feil skjedde oppdatering av turen. Vennligst prøv igjen.', 
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
                time_flex = string.sub(view.tripTolerance.text, 1, 2) -- TOLERANCE

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

    if event.target.id == 1 and tonumber(os.date("%H")) >= 21 then return true end
    if event.target.id == 2 and tonumber(os.date("%H")) >= 21 then return true end

    -- close change menu if opened
    onTripChangeEnd()

    print( "Start on: " .. event.target.id )
    if changeWasJustClosed == true then 
        changeWasJustClosed = false 
    elseif changing == false and changeWasJustClosed == false then

        local i = event.target.id
        changing = true

        appData.i = event.target.id
        print("the trip will change")

        -- hide info box
        if view.nextTripGroup ~= nil then
            view.nextTripGroup.alpha = 0
        end 

        if view.pickUpGroup ~= nil then
            view.pickUpGroup.alpha = 0
        end 

        if view.startDrivingGroup ~= nil then
            view.startDrivingGroup.alpha = 0
        end

        if view.drivingGroup ~= nil then
            view.drivingGroup.alpha = 0
        end

        -- move map down
        view.routeMap2.y = display.screenOriginY + 130 + 50
        view.routeMap2.height = appData.contentH - display.screenOriginY - 195 - 145

        view.routeMap1.y = display.screenOriginY + 130 + 50
        view.routeMap1.height = appData.contentH - display.screenOriginY - 195 - 145
        -- view.routeMap1.x = 0

        -- show the dot
        local integralPart, fractionalPart = math.modf( event.target.id/2 )

        if fractionalPart ~= 0 then
            i = integralPart + 1
            view.dots.morning[i].alpha = 1
            appData.period = "m"   
        else
            i = i/2
            view.dots.afternoon[i].alpha = 1
            appData.period = "a" 
        end    

        -- show the interface
        view.tripChangeGroup.y = display.screenOriginY + 55

        transition.to( view.departureFieldBackground, 
            { transition=easing.outSine, 
              delay = 100, 
              time = 50, 
              x = appData.contentW/2,
              alpha = 1 
              })

        transition.to( view.departureField, 
            { transition=easing.outSine, 
              delay = 100, 
              time = 50, 
              x = appData.contentW/2 + appData.margin,
              alpha = 1   
              })

        transition.to( view.destinationFieldBackground, 
            { transition=easing.outSine, 
              delay = 100, 
              time = 50, 
              x = appData.contentW/2,
              alpha = 1  
              })

        transition.to( view.destinationField, 
            { transition=easing.outSine, 
              delay = 100, 
              time = 50, 
              x = appData.contentW/2 + appData.margin*2,
              alpha = 1  
              })


        -- fill in the interface
        if appData.period == "m" then
            view.tripTime.text = view.hours.morning[i].text
        elseif appData.period == "a" then
            view.tripTime.text = view.hours.afternoon[i].text
        end
        
        i = event.target.id  -- reset i

        view.tripTolerance.text = tostring(tonumber(appData.dummyTransports[i].flexibility)/60)
                                .." min"

        if appData.dummyTransports[i].vehicle.id == nil
        or appData.dummyTransports[i].vehicle.id == 0
        or appData.dummyTransports[i].vehicle.id == "0"
        then 
            -- view.tripRole.text = "passenger"
            view.tripRole.text = "Passasjer"
        else 
            -- view.tripRole.text = "driver"
            view.tripRole.text = "Sjåfør"
        end   

        view.destinationField.text = ""
        view.destinationField.placeholder = ""
        view.departureField.text = ""
        view.departureField.placeholder = ""
        
        -- Fill In Address Fields
        view.departureField.text = tostring(appData.dummyTransports[i].route.from_address)
        view.destinationField.text = tostring(appData.dummyTransports[i].route.to_address)


        -- Change Map
        -- update route on the map
        -- print("--------------- will update map for change")
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

        changeWasJustClosed = false     
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
        view.routeMap2.x = 0 

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
                view.departureField.text = tostring(appData.dummyTransports[appData.i].route.from_address)           
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
    view.routeMap2.x = 0
    
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
        view.routeMap1.x = 3000
        view.routeMap2.x = 3000

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
        view.departureField.text = ""

        if view.destinationField.text == "" then         
            view.destinationField.placeholder = ""
            view.destinationField.text = tostring(appData.dummyTransports[appData.i].route.to_address)       
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
       view.routeMap2.x = 0 

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
                    view.destinationField.text = tostring(appData.dummyTransports[appData.i].route.to_address)                 
                end
            end
        else
               if destinationSet == false then
                    view.destinationField.text = tostring(appData.dummyTransports[appData.i].route.to_address)                 
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

    -- destinationSet = false 
end 

destinationGeoSearch = function(event)

    clicked = true

    view.routeMap2.x = 0

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
        view.routeMap1.x = 3000
        view.routeMap2.x = 3000

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
        view.destinationField.text = ""

        if view.departureField.text == "" then         
            view.departureField.placeholder = ""
            view.departureField.text = tostring(appData.dummyTransports[appData.i].route.from_address)       
        end 

        clicked = false
        appData.destinationAddress = false
    elseif ( event.phase == "editing" ) then
        destinationSearch(model.urlEncode(event.target.text))
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        timer.performWithDelay( 300, handleDestinationKeyboard, 1 )
    end
end






















-- COMMUNICATION =========================================================
-- sms -------------------------------------------------------------------
onTomorrowMorningChat = function(event)
    if ( event.phase == "began" ) then
        -- make icon half transparent 
        event.target.alpha = 0.5

        -- make icon opaque
         event.target.alpha = 1

        -- get phone number
        local phone
        if (appData.match.tomorrowMorning.person.mobile.number ~= nil) then
            phone = tostring(appData.match.tomorrowMorning.person.mobile.number)
            print(phone)
        end

        -- make options
        local options =
        {
           to = { phone },
           body = ""
        }

    -- sms
        native.showPopup( "sms", options )      
        return true
    end    
end

onTomorrowAfternoonChat = function(event)
    if ( event.phase == "began" ) then
        -- make icon half transparent 
        event.target.alpha = 0.5

        -- make icon opaque
         event.target.alpha = 1

        -- get phone number
        local phone
        if (appData.match.tomorrowAfternoon.person.mobile.number ~= nil) then
            phone = tostring(appData.match.tomorrowAfternoon.person.mobile.number)
            print(phone)
        end

        -- make options
        local options =
        {
           to = { phone },
           body = ""
        }

    -- sms
        native.showPopup( "sms", options )      
        return true
    end    
end

onMorningChat = function(event)
    if ( event.phase == "began" ) then
        -- make icon half transparent 
        event.target.alpha = 0.5

        -- make icon opaque
         event.target.alpha = 1

        -- get phone number
        local phone
        if (appData.match.morning.person.mobile.number ~= nil) then
            phone = tostring(appData.match.morning.person.mobile.number)
            print(phone)
        end

        -- make options
        local options =
        {
           to = { phone },
           body = ""
        }

    -- sms
        native.showPopup( "sms", options )      
        return true
    end    
end

onAfternoonChat = function(event)
    if ( event.phase == "began" ) then
        -- make icon half transparent 
        event.target.alpha = 0.5

        -- make icon opaque
         event.target.alpha = 1

        -- get phone number
        local phone
        if (appData.match.afternoon.person.mobile.number ~= nil) then
            phone = tostring(appData.match.afternoon.person.mobile.number)
            print(phone)
        end

        -- make options
        local options =
        {
           to = { phone },
           body = ""
        }

    -- sms
        native.showPopup( "sms", options )      
        return true
    end    
end

onTransportChat = function(event)
    if ( event.phase == "began" ) then
        -- make icon half transparent 
        event.target.alpha = 0.5

        -- make icon opaque
         event.target.alpha = 1

        -- get phone number
        local url
        if tonumber(os.date("%H")) >= 12 then
            if (appData.match.afternoon.person.mobile.number ~= nil) then
                phone = tostring(appData.match.afternoon.person.mobile.number)
                print(phone)
            end
        else
            if (appData.match.morning.person.mobile.number ~= nil) then
                phone = tostring(appData.match.morning.person.mobile.number)
                print(phone)
            end        
        end    

        -- make options
        local options =
        {
           to = { phone },
           body = ""
        }

    -- sms
        native.showPopup( "sms", options )      
        return true
    end    
end

onChat = function(event)

-- get phone number
local i = event.target.id

local phone
    if (appData.transports[i].matches[1].person.mobile.number ~= nil) then
        phone = tostring(appData.transports[i].matches[1].person.mobile.number)
        print(phone)
    end
       
    -- make options
    local options =
    {
       to = { phone },
       body = ""
    }

    -- sms
    native.showPopup( "sms", options )      
    return true
end

-- Call the partner  -----------------------------------------------------
onTomorrowMorningCall = function(event)
    if ( event.phase == "began" ) then
        -- make icon half transparent 
        event.target.alpha = 0.5

        -- make icon opaque
         event.target.alpha = 1

        -- get phone number
        local url
        if (appData.match.tomorrowMorning.person.mobile.number ~= nil) then
            url = "tel:"..tostring(appData.match.tomorrowMorning.person.mobile.number)
            print(url)
        end

        -- call
        system.openURL( url )        
        return true
    end    
end

onTomorrowAfternoonCall = function(event)
    if ( event.phase == "began" ) then
        -- make icon half transparent 
        event.target.alpha = 0.5

        -- make icon opaque
         event.target.alpha = 1

        -- get phone number
        local url
        if (appData.match.tomorrowAfternoon.person.mobile.number ~= nil) then
            url = "tel:"..tostring(appData.match.tomorrowAfternoon.person.mobile.number)
            print(url)
        end

        -- call
        system.openURL( url )        
        return true
    end    
end

onMorningCall = function(event)
    if ( event.phase == "began" ) then
        -- make icon half transparent 
        event.target.alpha = 0.5

        -- make icon opaque
         event.target.alpha = 1

        -- get phone number
        local url
        if (appData.match.morning.person.mobile.number ~= nil) then
            url = "tel:"..tostring(appData.match.morning.person.mobile.number)
            print(url)
        end

        -- call
        system.openURL( url )        
        return true
    end    
end

onAfternoonCall = function(event)
    if ( event.phase == "began" ) then
        -- make icon half transparent 
        event.target.alpha = 0.5

        -- make icon opaque
         event.target.alpha = 1

        -- get phone number
        local url
        if (appData.match.afternoon.person.mobile.number ~= nil) then
            url = "tel:"..tostring(appData.match.afternoon.person.mobile.number)
            print(url)
        end

        -- call
        system.openURL( url )        
        return true
    end    
end

onTransportCall = function(event)
    if ( event.phase == "began" ) then
        -- make icon half transparent 
        event.target.alpha = 0.5

        -- make icon opaque
         event.target.alpha = 1

        -- get phone number
        local url
        if tonumber(os.date("%H")) >= 12 then
            if (appData.match.afternoon.person.mobile.number ~= nil) then
                url = "tel:"..tostring(appData.match.afternoon.person.mobile.number)
                print(url)
            end
        else
            if (appData.match.morning.person.mobile.number ~= nil) then
                url = "tel:"..tostring(appData.match.morning.person.mobile.number)
                print(url)
            end        
        end 

        -- call
        system.openURL( url )        
        return true
    end    
end

onCall = function(event)

    -- get phone number
    local i = event.target.id

    local url
    if (appData.transports[i].matches[1].person.mobile.number ~= nil) then
        url = "tel:"..tostring(appData.transports[i].matches[1].person.mobile.number)
        print(url)
    end

    -- call
    system.openURL( url )        
    return true   
end























-- SCHEDULE ==============================================================
-- move schedule slide


local multiplier = 600

local arrayY = {}
local startY
local lastY
local endY
local targetY

local startTime
local endTime
local targetTime

local speed

moveScheduleSlide = function( event )

    local t = event.target
      
    local phase = event.phase
    if "began" == phase then

        yMin =  (appData.screenH - view.routeMap2.height - 30) - view.scheduleSlide.height 
        yMax = 0

        -- print("= = = = = = = = = = = = "..tostring(view.scheduleSlide.height))
        -- print("= = = = = = = = = = = = "..tostring(view.scheduleSlide.y))

        arrayY = {0, 0, 0}

        local parent = t.parent
        parent:insert( t )
        display.getCurrentStage():setFocus( t, event.id )
       
        t.isFocus = true 
        t.yStart = event.y - t.y

        startY = event.y            -- ===
        startTime=system.getTimer() -- ===

    elseif t.isFocus then
        if "moved" == phase then
                t.y = event.y - t.yStart
                if (t.y < yMin) then t.y = yMin end
                if (t.y > yMax) then t.y = yMax end 

                arrayY[#arrayY+1] = event.y 
              
 
        elseif "ended" == phase or "cancelled" == phase then
            display.getCurrentStage():setFocus( t, nil )
            t.isFocus = false 
            
            if #arrayY > 1 then
                lastY = arrayY[#arrayY-1]
            else 
                lastY = event.y
            end  

            endY = event.y 
            endTime=system.getTimer()                                        
            speed = (startY - endY) / (endTime - startTime)   -- ===

            -- print("= = = = = = = = = = = = "..tostring(lastY - endY))
 
            if math.abs(lastY - endY) > 2 then
                targetY = t.y - (speed * multiplier)
                if (targetY < yMin) then targetY = yMin end
                if (targetY > yMax) then targetY = yMax end 
                transition.to( view.scheduleSlide, { time = 1000, transition=easing.outCubic, y=targetY } )             
            end
        end
    end

    view.commutingGroup:toFront()
    view.tripChangeGroup:toFront()

    if view.drivingGroup ~= nil then
      view.drivingGroup:toFront()
    end

    if  view.pickUpGroup  ~= nil then
      view.pickUpGroup:toFront()
    end 
     
    if view.startDrivingGroup ~= nil then
      view.startDrivingGroup:toFront()
    end

    if view.nextTripGroup ~= nil then
        view.nextTripGroup:toFront()
    end    

    return true
end
-- Handle Today Fields  --------------------------------------------------
handleToday = function() 

    -- Time Control -----------------------------------------------------------------------------
    local myMorningDeparture = tonumber(appData.schedule[1].time_offset) -- time from local midnight in minutes
    local myAfternoonDeparture = tonumber(appData.schedule[2].time_offset)  -- time from local midnight in minutes
    local now = os.date("%H")*60 + os.date("%M") -- time from local midnight in minutes 

    if (appData.user.mode == "passenger") then

    elseif (appData.user.mode == "driver") then

    end  

    -- Before morning departure - show morning and afternoon rows for today
    -- if (now < myMorningDeparture) then
    if (tonumber(os.date("%H")) <= 11) then -- quick fix  
        -- move schedule lower
        view.scheduleView.y = appData.contentW + (view.headerHeight+view.rowHeight+view.rowHeight)
        -- print("--------- 1")

    -- After morning departure and before afternoon departure - show just afternoon for today
    elseif (tonumber(os.date("%H")) < 19) then
        -- print("--------- 2")

        view.scheduleView.y = appData.contentW + (view.headerHeight+view.rowHeight+view.rowHeight)
        
        --[[
        -- move schedule higher
        view.scheduleView.y = appData.contentW + (view.headerHeight+view.rowHeight)

        -- hide morning components
        view.todayMorning.alpha = 0
        view.todayMorningTime.alpha = 0
        view.todayMorningSwitch.alpha = 0
        view.todayMorningStatus.alpha = 0
        view.todayMorningMask.alpha = 0
        view.todayMorningPortrait.alpha = 0
        view.todayMorningRole.alpha = 0
        view.todayMorningName.alpha = 0
        view.todayMorningPhone.alpha = 0
        view.todayMorningChat.alpha = 0

        -- move header lower
        view.todayHeader.y = view.scheduleView.y - 498
        view.day.y = view.scheduleView.y - 490
        --]]
         
    -- After afternoondeparture -- don't show today
    else 
    -- print("--------- 3")
       -- hide today
       view.todayGroup.alpha = 0

       -- move schedule higher
       view.scheduleView.y = appData.contentW      
    end 
    -- -------------------------------------------------------------------------------------------
end

-- Set Switches  ---------------------------------------------------------
setSwitches = function()
    if appData.appIsRunning == true and appData.transports ~= nil then

        -- If no active trip ---------------------------------------------
        if #appData.transports == 0 then
            if view.todayMorningSwitch ~= nil then
                view.todayMorningSwitch:setState( { isOn=true } )
                view.todayMorningSwitch.alpha = 0
                view.todayMorningStatus.text = "Ingen tur om morgenen"
                view.todayMorningStatus.x = appData.contentW - appData.actionMargin
            end

            if view.todayAfternoonSwitch ~= nil then
                view.todayAfternoonSwitch:setState( { isOn=true } )
                view.todayAfternoonSwitch.alpha = 0
                view.todayAfternoonStatus.text = "Ingen tur om ettermiddagen"
                view.todayAfternoonStatus.x = appData.contentW - appData.actionMargin
            end 
        end    


        local viewRows = #appData.dummyTransports/2

        -- TODAY
            -- morning      
                -- calculate utc
                local dayShift = "0"
                local dayPart = "m"

                local utcTime = model.calculateUTC(dayShift, dayPart)

                -- search for the related transport in app.Data.transports
                for j=1, #appData.transports do
                    if (appData.transports[j].starting_at ~= nil) then
                        if (utcTime == appData.transports[j].starting_at) then
                            -- set the switch on
                            if view.todayMorningSwitch ~= nil then
                                view.todayMorningSwitch:setState( { isOn=true } )
                                view.todayMorningSwitch.alpha = 0
                                view.todayMorningStatus.text = "Ingen tur om morgenen"
                                view.todayMorningStatus.x = appData.contentW - appData.actionMargin
                            end
                            -- view.todayMorningTime.text = ""
                        else 
                            if view.todayMorningSwitch ~= nil then   
                                view.todayMorningSwitch.alpha = 0
                                view.todayMorningStatus.text = "Ingen tur om morgenen"
                                view.todayMorningStatus.x = appData.contentW - appData.actionMargin
                                -- view.todayMorningTime.text = ""
                            end    
                        end
                    else
                        if view.todayMorningSwitch ~= nil then
                            view.todayMorningSwitch.alpha = 0
                            view.todayMorningStatus.text = "Ingen tur om morgenen"
                            view.todayMorningStatus.x = appData.contentW - appData.actionMargin

                            -- view.todayMorningTime.text = ""
                        end    
                    end
                end    

            -- afternoon
                -- calculate utc
                local dayShift = "0"
                local dayPart = "a"

                local utcTime = model.calculateUTC(dayShift, dayPart)

                -- search for the related transport in app.Data.transports
                for j=1, #appData.transports do
                    if (appData.transports[j].starting_at ~= nil) then
                        if (utcTime == appData.transports[j].starting_at) then
                            -- set the switch on
                            if view.todayAfternoonSwitch ~= nil then
                                view.todayAfternoonSwitch:setState( { isOn=true } )
                                view.todayAfternoonSwitch.alpha = 0
                                view.todayAfternoonStatus.text = "Ingen tur om ettermiddagen"
                                view.todayAfternoonStatus.x = appData.contentW - appData.actionMargin
                                -- view.todayAfternoonTime.alpha = 1
                            end    
                        else 
                            if view.todayAfternoonSwitch ~= nil then   
                                view.todayAfternoonSwitch.alpha = 0
                                view.todayAfternoonStatus.text = "Ingen tur om ettermiddagen"
                                view.todayAfternoonStatus.x = appData.contentW - appData.actionMargin
                                -- view.todayAfternoonTime.alpha = 1
                            end     
                        end
                    else 
                        if view.todayAfternoonSwitch ~= nil then 
                            view.todayAfternoonSwitch.alpha = 0
                            view.todayAfternoonStatus.text = "Ingen tur om ettermiddagen"
                            view.todayAfternoonStatus.x = appData.contentW - appData.actionMargin

                            -- view.todayAfternoonTime.alpha = 1
                        end                       
                    end
                end 


        -- NEXT DAYS
        for i=1, viewRows do 
            -- MORNINGS ------------------------------------------------------------------       
                -- calculate utc
                local dayShift = tostring(i)
                local dayPart = "m"

                local k 

                if dayPart == "m" then 
                    k = dayShift*2 - 1
                elseif dayPart == "a" then 
                    k = dayShift*2
                end  

                local utcTime = model.calculateTransportUTC(dayShift, dayPart, k)     

                -- search for the related transport in app.Data.transports
                for j=1, #appData.dummyTransports do

                    -- ACTIVATION
                    --[[
                    if (appData.transports[j].starting_at ~= nil) then
                        if (utcTime == appData.transports[j].starting_at) then
                            
                            -- set the switch on
                            if view.switches.morning[i] ~= nil then
                                view.switches.morning[i]:setState( { isOn=true } )
                                view.status.morning[i].text = "Activated"
                                if i == 1 then view.hint.morning[i].text = "" end
                            end
                        else
                            -- set the switch off
                            -- view.switches.morning[i]:setState( { isOn=false } )
                            -- view.status.morning[i].text = "Trykk for å aktivere"                        
                        end
                    end
                    --]]

                    if (appData.dummyTransports[i*2-1].created_at ~= "") then
                        if view.switches.morning[i] ~= nil then
                            view.switches.morning[i]:setState( { isOn=true } )
                            view.status.morning[i].text = "Aktivert"
                            if i == 1 then view.hint.morning[i].text = "" end
                        end
                    end    


                    -- PROCESSING
                    if (i == 1) then

                        -- hide switch at 8
                        if (os.date("%H") == "21") then
                            if view.switches.morning[i] ~= nil then
                                view.switches.morning[i].alpha = 0
                                if i == 1 then view.hint.morning[i].text = "" end

                                if (view.switches.morning[i].isOn) then
                                    view.status.morning[i].text = "Søker..."
                                else
                                    view.status.morning[i].text = "Ingen tur"    
                                end
                            end    
                        end    
                
                    -- RESULT
                        -- show result
                        if (os.date("%H") > "21") then
                            if view.switches.morning[i] ~= nil then
                                view.switches.morning[i].alpha = 0
                                if i == 1 then  view.hint.morning[i].text = "" end

                                if (view.switches.morning[i].isOn and appData.match.person ~= nil) then
                                    view.status.morning[i].text = "Du har en tur!" 
                                else      
                                    view.status.morning[i].text = "Ingen tur" 
                                end
                            end           
                        end                     
                    end
                end    

            -- AFTERNOONS ------------------------------------------------------------------
                -- calculate utc
                local dayShift = tostring(i)
                local dayPart = "a"
                    
                local k 

                if dayPart == "m" then 
                    k = dayShift*2 - 1
                elseif dayPart == "a" then 
                    k = dayShift*2
                end  

                local utcTime = model.calculateTransportUTC(dayShift, dayPart, k)  

                -- search for the related transport in app.Data.transports
                for j=1, #appData.dummyTransports do

                    -- ACTIVATION
                    --[[
                    if (appData.transports[j].starting_at ~= nil) then
                        if (utcTime == appData.transports[j].starting_at) then

                            -- set the switch on
                            view.switches.afternoon[i]:setState( { isOn=true } )
                            view.status.afternoon[i].text = "Activated"
                            if i == 1 then  view.hint.afternoon[i].text = "" end
                        else
                            -- set the switch off
                            -- view.switches.afternoon[i]:setState( { isOn=false } )
                            -- view.status.afternoon[i].text = "Trykk for å aktivere"
                        end
                    end
                    --]]

                    if (appData.dummyTransports[i*2].created_at ~= "") then
                        if view.switches.afternoon[i] ~= nil then
                            view.switches.afternoon[i]:setState( { isOn=true } )
                            view.status.afternoon[i].text = "Aktivert"
                            if i == 1 then view.hint.afternoon[i].text = "" end
                        end
                    end

                    -- PROCESSING
                    if (i == 1) then

                        -- hide switch at 9pm                       
                        if (os.date("%H") == "21") then
                            if view.switches.afternoon[i] ~= nil then
 
                                view.switches.afternoon[i].alpha = 0
                                if i == 1 then  view.hint.afternoon[i].text = "" end

                                if (view.switches.afternoon[i].isOn) then
                                    view.status.afternoon[i].text = "Søker"
                                else
                                    view.status.afternoon[i].text = "Ingen tur"    
                                end
                            end    
                        end    
                
                    -- RESULT
                        -- show result
                            if (os.date("%H") > "21") then
                                if view.switches.afternoon[i] ~= nil then
                                    view.switches.afternoon[i].alpha = 0
                                    if i == 1 then  view.hint.afternoon[i].text = "" end

                                    if (view.switches.afternoon[i].isOn and appData.match.person ~= nil) then
                                        view.status.afternoon[i].text = "Du har en tur!" 
                                    else      
                                        view.status.afternoon[i].text = "Ingen tur" 
                                    end
                                end           
                            end
                        end
                end         
        end
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

-- Set Time --------------------------------------------------------------
onTime = function()
    local rows = #appData.dummyTransports/2
    local localTime
    local time

    for i = 1, rows do
        -- print(appData.dummyTransports[i*2-1].starting_at)
        -- morning
        localTime  = routines.UTCtoLocal(appData.dummyTransports[i*2-1].starting_at)

        -- print(localTime.hour)

        time = localTime.hour..":"..string.sub(appData.dummyTransports[i*2-1].starting_at, 15, 16)

        -- print("morning: "..time) 
        if view.phones.morning[i].alpha == 0 then           
            -- view.hours.morning[i].text = time
        end 
        
        -- afternoon
        localTime  = routines.UTCtoLocal(appData.dummyTransports[i*2].starting_at)

        time = localTime.hour..":"..string.sub(appData.dummyTransports[i*2].starting_at, 15, 16)

        -- print("afternoon: "..time) 
        if view.phones.afternoon[i].alpha == 0 then  
            -- view.hours.afternoon[i].text = time
        end
    end
end

-- Options  ---------------------------------------------------------------
optionsVisible = false

-- hide options 
onKeyEvent = function( event )
    -- If the "back" key was pressed on Android, prevent it from backing out of the app
    if ( event.keyName == "back" ) then
            print("BACK KEY 2")

            view.optionsIcon.alpha = 0.0

            if view.routeMap1 ~= nil then
                -- view.routeMap1.x = 0
            end 

            if view.routeMap2 ~= nil then
                view.routeMap2.x = 0
            end  

            if view.driverMap ~= nil then
                view.driverMap.x = 0
            end  
            
            if view.passengerMap ~= nil then
                view.passengerMap.x = 0
            end 

            -- adjust switch
            optionsVisible = false

            -- move trip change if applicable
            view.tripChangeGroup.x = 0

            -- create and update dummy transports
            model.saveSchedule(appData.schedule)
            model.createDummyTransports()  -- [1] create dummyTransports  
            model.updateDummyTransports() -- [3] update dummy tranpsorts
            model.saveTransports()


            -- update route on the map
            --[[
            print("--------------- will update map")
            if view.routeMap1 ~= nil then
                print("--------------- updated map")

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

                params = lon1.."&"..lat1.."&"..lon2.."&"..lat2

                print("this is params: "..params)

                view.routeMap1:request( "map.html?"..params, system.DocumentsDirectory )
            end 
            --]]

            -- set addresses
            setAddresses()
   
            -- hide options
            composer.hideOverlay( "fade", 100)
            print("HIDE-----------#") 
            appData.appIsRunning = true

            -- show trip map if changing
            if changing == true then
                routeMap1()
            end    

        return true
    end
    
 
    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return false
end

-- show options
showOptions = function(event)
    print("OPTIONS")
    if (optionsVisible) then 

            view.optionsIcon.alpha = 0.0

            if view.routeMap1 ~= nil then
                -- view.routeMap1.x = 0
            end

            if view.routeMap2 ~= nil then
                view.routeMap2.x = 0
            end  

            if view.driverMap ~= nil then
                view.driverMap.x = 0
            end  
            
            if view.passengerMap ~= nil then
                view.passengerMap.x = 0
            end 

            -- adjust switch
            optionsVisible = false

            -- show trip change if applicable
            view.tripChangeGroup.x = 0

            -- create and update dummy transports

            timer.performWithDelay( 600, model.createDummyTransports, 1)
            timer.performWithDelay( 700, model.updateDummyTransports, 1)  
     
            -- set addresses
            setAddresses()

            -- show trip map if changing
            if changing == true then
                routeMap1()
            end

            local options =
                {
                    isModal = false,
                    effect = "fromLeft",
                    time = 1500
                }

            composer.hideOverlay( "fade", 100 )
            -- composer.showOverlay("controller.EmptyController", options)
            -- composer.hideOverlay("controller.OptionsController", options)

            print("HIDE----------- -------------- ----------- -------------- ----------- --------------b") 
            appData.appIsRunning = true

            return true
    else  
            appData.appIsRunning = false

            print("1")
            view.optionsIcon.alpha = 0.9
            print("2")


            if view.routeMap1 ~= nil then
               view.routeMap1.x = 3000 
               print("route map"..view.routeMap1.x)
            end

            if view.routeMap2 ~= nil then
               view.routeMap2.x = 3000 
               print("route map"..view.routeMap2.x)
            end
            print("3")

            if view.driverMap ~= nil then
               view.driverMap.x = 3000 
               print("driver map"..view.driverMap.x)
            end
            print("4")

            if view.passengerMap ~= nil then
               view.passengerMap.x = 3000 
               print("passenger map"..view.passengerMap.x)
            end
            print("5")

            -- adjust switch
            optionsVisible = true
            print("6")

            -- show trip change if applicable
            if view.tripChangeGroup ~= nil then
                view.tripChangeGroup.x = 3000
            end    
            print("7")

            -- show options
            print("SHOW-----------")

            local options =
                {
                    isModal = false,
                    effect = "fromLeft",
                    time = 500
                }

            appData.composer.showOverlay( "controller.OptionsController", options ) 
            -- appData.composer.showOverlay( "controller.EmptyController" )
            return true    
    end    
end
















-- TRANSPORTS ============================================================
cancelMorningSwitch = function()
    view.switches.morning[appData.dayShift]:setState( { isOn=true } )
end  

cancelAfternoonSwitch = function() 
    view.switches.afternoon[appData.dayShift]:setState( { isOn=true } ) 
end

-- transports cancelled
transportCanceled = function(event)

    local data = appData.json.decode(event.response)

    if data == nil then
        local alert = native.showAlert( 
            "Ooops. Feil!", 
            'En feil skjedde deaktivering av turen. Vennligst prøv igjen.', 
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

setMorningSwitch = function()
    view.switches.morning[appData.dayShift]:setState( { isOn=false } )
end  

setAfternoonSwitch = function() 
    view.switches.afternoon[appData.dayShift]:setState( { isOn=false } ) 
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
                'En feil skjedde ved aktivering av turen. Vennligst prøv igjen.', 
                { "OK", "" }
                ) 

            if appData.dayPart == "m" then 
                view.switches.morning[appData.dayShift]:setState( { isOn=false } )
                view.status.morning[appData.dayShift].text = "Aktiver tur"
                timer.performWithDelay(1000, setMorningSwitch, 1) 
            elseif appData.dayPart == "a" then  
                view.switches.afternoon[appData.dayShift]:setState( { isOn=false } )
                view.status.afternoon[appData.dayShift].text = "Aktiver tur"
                timer.performWithDelay(1000, setAfternoonSwitch, 1) 
            end    

            return true
        end 

        if data.id == nil then
            local alert = native.showAlert( 
                "Ooops. Feil!", 
                'En feil skjedde ved aktivering av turen. Vennligst prøv igjen.', 
                { "OK", "" }
                )

            if appData.dayPart == "m" then 
                view.switches.morning[appData.dayShift]:setState( { isOn=false } )
                view.status.morning[appData.dayShift].text = "Aktiver tur"
            elseif appData.dayPart == "a" then  
                view.switches.afternoon[appData.dayShift]:setState( { isOn=false } )
                view.status.afternoon[appData.dayShift].text = "Aktiver tur"
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
        

        -- print("TRANSPORT CREATED: "..event.response) 
end

-- upload transport
uploadTransport = function(dayPart, utcTime, i)
   
    local dayShift = math.ceil((i)/2)
    local dayPart = dayPart



    -- check whether the driver has registered car
    if ( appData.user.mode == "driver" and appData.car.vehicle_id == "0" )
    or ( appData.user.mode == "driver" and appData.car.vehicle_id == nil ) 
    then

        if view.tripRole.text ~= "passenger" 
        and view.tripRole.text ~= "Passasjer"
        and appData.schedule[i].mode ~= "1" 
        then   

            if dayPart == "m" then
                 view.switches.morning[dayShift]:setState( { isOn=false } )
            elseif dayPart == "a" then
                 view.switches.afternoon[dayShift]:setState( { isOn=false } )
            end 

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
    local fromStreetAddress
    local toStreetAddress
    local flexibility
    local vehicle_id
    local mode

    if appData.schedule[i].mode == "1"    
    then 
        mode = "driver" 
        print("---------------- DRIVER")
    else 
        mode = "passenger" 
        print("---------------- PASSENGER")
    end  
    
    -- BODY
    -- from
    fromAddress = tostring(appData.dummyTransports[i].route.from_location.coordinates[1])

    if appData.dummyTransports[i].route.from_location.coordinates[2] ~= nil then
        fromAddress = fromAddress..
                    ","..
                    tostring(appData.dummyTransports[i].route.from_location.coordinates[2])
    end            

    fromStreetAddress=tostring(appData.dummyTransports[i].route.from_address)

    -- to
    toAddress = tostring(appData.dummyTransports[i].route.to_location.coordinates[1])

    if appData.dummyTransports[i].route.to_location.coordinates[2] ~= nil then
        toAddress = toAddress..
                  ","..
                  tostring(appData.dummyTransports[i].route.to_location.coordinates[2])
    end              

    toStreetAddress = tostring(appData.dummyTransports[i].route.to_address)

    -- flexibility
    flexibility = tostring(appData.dummyTransports[i].flexibility)

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

-- create or cancel transport
onSwitch = function(event)
    if (event.phase == "ended") then

        -- save data from the trip change if the menu is opened
        if changing == true then 

                -- save data from interface
                i = appData.i
                local hours = string.sub(view.tripTime.text, 1, 2)
                hours = tonumber(hours)
                local minutes = string.sub(view.tripTime.text, 4, 5)
                minutes = tonumber(minutes)
                minutes = hours*60 + minutes

                appData.schedule[i].time_offset = minutes -- OFFSET
                appData.schedule[i].time_flex = string.sub(view.tripTolerance.text, 1, 2) -- TOLERANCE

                if view.tripRole.text == "passenger"
                or view.tripRole.text == "Passasjer" 
                then 
                    appData.schedule[i].mode = 1
                elseif (view.tripRole.text == "driver" and appData.car.vehicle_id == "")
                or (view.tripRole.text == "Sjåfør" and appData.car.vehicle_id == nil) 
                then
                    appData.schedule[i].mode = 1
                    print(":::::::::::::::::::::::: alert 1")
                    local alert = native.showAlert( 
                        "", 
                        'For å endre innstillingen til "Sjåfør", vennligst legg inn informasjon om bilen din under "Mitt kjøretøy" først.', 
                        { "OK", "" }
                        ) 
                        return true               
                elseif view.tripRole.text == "Passasjer" then 
                    appData.schedule[i].mode = 1
                elseif (view.tripRole.text == "Sjåfør" and appData.car.vehicle_id == "")
                or (view.tripRole.text == "Sjåfør" and appData.car.vehicle_id == nil)
                then
                    appData.schedule[i].mode = 1
                    print(":::::::::::::::::::::::: alert 2")
                    local alert = native.showAlert( 
                        "", 
                        'For å endre innstillingen til "Sjåfør", vennligst legg inn informasjon om bilen din under "Mitt kjøretøy" først.', 
                        { "OK", "" }
                        ) 
                        return true               
                else    
                    appData.schedule[i].mode = 2
                end    

                -- save schedule
                model.saveSchedule(appData.schedule)

        else
                -- show info about trip
                -- onTripChangeStart()           
        end

        local id = event.target.id
        local dayShift = tonumber(string.sub( id, 2, 2 ))
        local dayPart = string.sub( id, 1, 1 )
        local utcTime
        local i 

        if dayPart == "m" then 
            i = dayShift*2 - 1
        elseif dayPart == "a" then 
            i = dayShift*2
        end    

        print ("THIS IS THE FIELD "..i)
        -- This is a bit tricky - we should ask whether the switch is on, but bc. of delays we ask otherwise
        
        -- CREATE TRANSPORT
        if (dayShift ~= 0) then

            if (dayPart == "m" and view.switches.morning[dayShift].isOn == false) then

                -- check whether driver is registered car
                if appData.schedule[i].mode == 2 and appData.car.vehicle_id == "" then
                    print(":::::::::::::::::::::::: alert 3")
                    local alert = native.showAlert( 
                        "", 
                        'For å endre innstillingen til "Sjåfør", vennligst legg inn informasjon om bilen din under "Mitt kjøretøy" først.', 
                        { "OK", "" }
                        )
                    return true    
                end 

                if appData.schedule[i].mode == 2 and appData.car.vehicle_id == nil then
                    print(":::::::::::::::::::::::: alert 4")
                    local alert = native.showAlert( 
                        "", 
                        'For å endre innstillingen til "Sjåfør", vennligst legg inn informasjon om bilen din under "Mitt kjøretøy" først.', 
                        { "OK", "" }
                        )
                    return true    
                end                      

                utcTime = appData.dummyTransports[i].starting_at               
                uploadTransport(dayPart, utcTime, i)
                view.status.morning[dayShift].text = "Aktiverer..."
                appData.dayShift = dayShift
                appData.dayPart = dayPart
                
            elseif (dayPart == "a" and view.switches.afternoon[dayShift].isOn == false) then 

                -- check whether driver is registered car
                if appData.schedule[i].mode == 2 and appData.car.vehicle_id == "" then
                    print(":::::::::::::::::::::::: alert 5")
                    local alert = native.showAlert( 
                        "", 
                        'For å endre innstillingen til "Sjåfør", vennligst legg inn informasjon om bilen din under "Mitt kjøretøy" først.', 
                        { "OK", "" }
                        )
                    return true    
                end 

                print("=================="..appData.schedule[i].mode)

                if appData.schedule[i].mode == 2 and appData.car.vehicle_id == nil then
                    print(":::::::::::::::::::::::: alert 6")
                    local alert = native.showAlert( 
                        "", 
                        'For å endre innstillingen til "Sjåfør", vennligst legg inn informasjon om bilen din under "Mitt kjøretøy" først.', 
                        { "OK", "" }
                        )
                    return true    
                end  

                utcTime = appData.dummyTransports[i].starting_at  
                uploadTransport(dayPart, utcTime, i)
                view.status.afternoon[dayShift].text = "Aktiverer..."
                appData.dayShift = dayShift
                appData.dayPart = dayPart
            
            -- CANCEL TRANSPORT
            appData.dayShift = dayShift
            appData.dayPart = dayPart

            elseif (dayPart == "m" and view.switches.morning[dayShift].isOn == true) then

                utcTime = appData.dummyTransports[i].starting_at 
                cancelTransport(utcTime)
                view.status.morning[dayShift].text = "Aktiver tur"
                if i == 1 then  view.hint.morning[dayShift].text = "Før 21:00 i dag " end

            elseif (dayPart == "a" and view.switches.afternoon[dayShift].isOn == true) then

                utcTime = appData.dummyTransports[i].starting_at 
                cancelTransport(utcTime)
                view.status.afternoon[dayShift].text = "Aktiver tur"
                if i == 2 then  view.hint.afternoon[dayShift].text = "Før 21:00 i dag" end

            end
        else
            if (dayPart == "m" and view.todayMorningSwitch.isOn == false) then 
                utcTime = appData.dummyTransports[i].starting_at 
                uploadTransport(dayPart, utcTime)
                view.todayMorningStatus.text = "Aktiverer..."
            elseif (dayPart == "a" and view.switches.afternoon[dayShift].isOn == false) then 
                utcTime = appData.dummyTransports[i].starting_at 
                uploadTransport(dayPart, utcTime)
                view.todayAfternoonStatus.text = "Aktiverer..."
            
            -- CANCEL TRANSPORT
            elseif (dayPart == "m" and view.todayAfternoonSwitch.isOn == true) then
                utcTime = appData.dummyTransports[i].starting_at 
                cancelTransport(utcTime)
                view.todayMorningStatus.text = "Aktiver tur"
            elseif (dayPart == "a" and view.switches.afternoon[dayShift].isOn == true) then 
                utcTime = appData.dummyTransports[i].starting_at 
                cancelTransport(utcTime)
                view.todayAfternoonStatus.text = "Aktiver tur" 
            end               
        end

        -- return true
    end    
end































-- ACTIVE TRANSPORTS =====================================================
-- Download Matches  -----------------------------------------------------
downloadMatches = function(event)

    getTransports()

    local dayShift = "0"
    local dayPart = "m"
    local utcTime   

    -- MORNING --------------------------------------------------------------
    
    -- calculate utc
    dayPart = "m"
    utcTime = model.calculateUTC(dayShift, dayPart)
    print("today morning UTC "..utcTime)

    if appData.transports == nil then
        print("++++++++++++++++++++++++++++++++++++++++++++++++++++")
        return true
    end    

    -- search for the related transport in app.Data.transports
    for j=1, #appData.transports do
        if appData.transports[j].starting_at ~= nil
        and appData.developerMode == false 
        and appData.transports[j].matches[1] ~= nil
        then

            local today = tonumber(os.date("%d"))
            local day = tonumber(string.sub(appData.transports[j].starting_at, 9, 10)) 
            local hour = tonumber(string.sub(appData.transports[j].starting_at, 12, 13))  

            hour = 10
            if (hour < 12) then

                -- prepare data
                local url = "https://api.sammevei.no/api/1/users/current/transports/"..
                appData.transports[j].transport_id

                -- HEADERS
                local params = {}
                local headers = {}
                headers["Authorization"] = "Bearer "..appData.session.accessToken      
                params.headers = headers             

                -- send request
                if tonumber(os.date("%H")) < 24 then
                  network.request( url, "GET", morningMatchDownloaded, params)
                  print("REQUESTING MORNING")
                  return true
                else
                    matches.morningMatch = true 
                end

            else
                matches.morningMatch = true     
            end
        else
            matches.morningMatch = true 
        end
    end    

    -- AFTERNOON ----------------------------------------------------------

    -- calculate utc
    local dayPart = "a"
    local utcTime = model.calculateUTC(dayShift, dayPart)
    print("today afternoon UTC "..utcTime)


    -- search for the related transport in app.Data.transports
    for j=1, #appData.transports do
        if appData.transports[j].starting_at ~= nil
        and appData.developerMode == false
        then

            local today = tonumber(os.date("%d"))
            local day = tonumber(string.sub(appData.transports[j].starting_at, 9, 10)) 
            local hour = tonumber(string.sub(appData.transports[j].starting_at, 12, 13))  

            if (hour >= 12) then

                -- prepare data
                local url = "https://api.sammevei.no/api/1/users/current/transports/"..
                appData.transports[j].transport_id

                -- HEADERS
                local params = {}
                local headers = {}
                headers["Authorization"] = "Bearer "..appData.session.accessToken      
                params.headers = headers             

                -- send request
                if tonumber(os.date("%H")) < 24 then
                    -- network.request( url, "GET", afternoonMatchDownloaded, params)
                    -- print("REQUESTING AFTERNOON")
                else
                    matches.afternoonMatch = true     
                end
            else 
                matches.afternoonMatch = true   
            end
        else
            matches.afternoonMatch = true 
        end
    end 

    -- TOMORROW MORNING --------------------------------------------------------------

    -- calculate utc
    local dayShift = "1"
    local dayPart = "m"
    local utcTime = model.calculateUTC(dayShift, dayPart)
    print("tomorrow morning UTC "..utcTime)

    -- search for the related transport in app.Data.transports
    for j=1, #appData.transports do
        if (appData.transports[j].starting_at ~= nil) then
            -- "starting_at": "2018-03-03T08:15:00.000Z",

            local tomorrow = tonumber(os.date("%d"))+1
            local day = tonumber(string.sub(appData.transports[j].starting_at, 9, 10)) 
            local hour = tonumber(string.sub(appData.transports[j].starting_at, 12, 13))  

            if (tomorrow == day and hour < 13)     
            then

                -- prepare data
                local url = "https://api.sammevei.no/api/1/users/current/transports/"..
                appData.transports[j].transport_id

                -- HEADERS
                local params = {}
                local headers = {}
                headers["Authorization"] = "Bearer "..appData.session.accessToken      
                params.headers = headers             

                -- send request
                if tonumber(os.date("%H")) > 19 
                or appData.developerMode == true    
                then
                    -- network.request( url, "GET", tomorrowMorningMatchDownloaded, params)
                    -- print("REQUESTING TOMORROW MORNING")
                else
                    matches.tomorrowMorningMatch = true     
                end
            else 
                matches.tomorrowMorningMatch = true   
            end
        else
            matches.tomorrowMorningMatch = true
        end
    end    

    -- TOMORROW AFTERNOON ----------------------------------------------------------

    -- calculate utc
    local dayShift = "1"
    local dayPart = "a"

    local utcTime = model.calculateUTC(dayShift, dayPart)
    print("tomorrow afternoon UTC "..utcTime)

    -- search for the related transport in app.Data.transports
    for j=1, #appData.transports do
        if (appData.transports[j].starting_at ~= nil) then

            local tomorrow = tonumber(os.date("%d"))+1
            local day = tonumber(string.sub(appData.transports[j].starting_at, 9, 10)) 
            local hour = tonumber(string.sub(appData.transports[j].starting_at, 12, 13))  

            if (tomorrow == day and hour >= 12)
            then

                -- prepare data
                local url = "https://api.sammevei.no/api/1/users/current/transports/"..
                appData.transports[j].transport_id

                -- HEADERS
                local params = {}
                local headers = {}
                headers["Authorization"] = "Bearer "..appData.session.accessToken      
                params.headers = headers             

                -- send request
                if tonumber(os.date("%H")) > 19 
                or appData.developerMode == true  
                then
                    -- network.request( url, "GET", tomorrowAfternoonMatchDownloaded, params)
                    -- print("REQUESTING TOMORROW AFTERNOON")
                else    
                    matches.tomorrowAfternoonMatch = true 
                end
            else 
                matches.tomorrowAfternoonMatch = true   
            end
        else
            matches.tomorrowAfternoonMatch = true
        end
    end 
end

morningMatchDownloaded = function(event)
    print("--------------- MORNING MATCH ---------------")
    print("--------------- MATCH DATA ---------------")
    print("MORNING MATCH "..event.response)
    matches.morningMatch = true

    local decoded = appData.json.decode(event.response)

    if decoded == nil then return true end

    appData.status.morning = decoded.status
    if appData.status.morning == "terminated" then appData.status.morning = "finish" end
    morningTransportID = decoded.transport_id

    print ("morning match 1 ------------------")
    if (decoded.matches ~= nil) then
        print ("morning match 2 ------------------")
        -- print ("morning match b ------------------"..tostring(decoded.matches[1].rating))
        -- print ("morning match c ------------------"..decoded.matches.rating)

        -- if decoded.matches[1] ~= nil then
        --    morningRating = tostring(decoded.matches[1].rating)
        -- end

        if (decoded.matches[1] ~= nil) then

            if decoded.matches[1].rating ~= nil then
                morningRating = tostring(decoded.matches[1].rating)
                print("MORNING RATING = "..morningRating)
            end 

           if (tonumber(os.date("%H")) <= 25) then -- quick fix 
                appData.currentTransport = decoded.transport_id
           end 

            if decoded.status == "finish" or decoded.status == "terminated" then
                matches.morningMatch = true 
                view.todayMorningName.text = decoded.matches[1].person.firstname

                if decoded.matches[1].transport_entity_type_id == 2 then
                    view.todayMorningRole.text = "Din sjåfør"
                else
                    view.todayMorningRole.text = "Din passasjer"
                end

                return true 
            end
            
            print ("morning match 3 ------------------")
            appData.match.morning = decoded.matches[1]
            -- print(appData.match.morning.rating.."- -- - -- --- -- - - - - - - -")
            print ("morning match 4 ------------------")
            
            -- fetch time
            local transportTime
            if (appData.match.morning.transport_entity_type_id == 2) then
                transportTime = appData.match.morning.pick_up_at
                appData.time.morning.myDeparture = routines.UTCtoSec(transportTime)
            else    
                transportTime = appData.match.morning.starting_at -- my trip utc time from server
                appData.time.morning.myDeparture = routines.UTCtoSec(transportTime)
            end

            -- fetch location
            appData.location.morning.departure.ln = decoded.route.from_location.coordinates[1]
            appData.location.morning.departure.lt = decoded.route.from_location.coordinates[2]
            appData.location.morning.destination.ln = decoded.route.to_location.coordinates[1]
            appData.location.morning.destination.lt = decoded.route.to_location.coordinates[2]
            appData.location.morning.pick_up.ln = appData.match.morning.pick_up_location.coordinates[1]
            appData.location.morning.pick_up.lt = appData.match.morning.pick_up_location.coordinates[2]

            -- fetch status
            appData.status.morning = decoded.status 
            print("=============== STATUS =================") 
            print(appData.status.morning)        

            print("MATCH! "..appData.match.morning.person.firstname)
            print(transportTime)

            -- Show next trip if it's in the future
            if appData.time.morning.myDeparture > os.time() - 3600*20 then
                timer.performWithDelay( 5000, nextTrip, 1)
                matches.morningMatch = false
            else
                matches.morningMatch = true     
            end  

            -- Save Match
            model.saveMatch(appData.match.morning)

            -- check TODAY ---------------------------------------------

                print (utcTime.." and "..transportTime.." are equal")
                print("MATCH at "..utcTime)

                -- show something
                view.todayMorningPortrait.alpha = 1
                view.todayMorningRole.alpha = 1
                view.todayMorningName.alpha = 1
                view.todayMorningPhone.alpha = 1
                view.todayMorningChat.alpha = 1

                if (appData.match.morning.transport_entity_type_id == 2) then
                  print("-----------------------oooooo-----------------------")

                    local localHour = string.sub(appData.match.morning.pick_up_at, 12, 13)
                    localHour = tonumber(localHour) + os.date("%z")/100
                    localHour = tostring(localHour)
                    local localMinute = string.sub(appData.match.morning.pick_up_at, 15, 16)
                    local pickupTime = localHour..":"..localMinute
                    
                    view.todayMorningTime.text = "Plukk opp kl. "..pickupTime
                    view.todayMorningRole.text = "Din sjåfør"

                    if tonumber(os.date("%H")) <= 11 then
                        view.transportTime.text = "Plukk opp kl. "..pickupTime
                        view.transportName.text = appData.match.morning.person.firstname
                        view.transportCar.text = appData.match.morning.vehicle.make..
                            " "..
                            appData.match.morning.vehicle.model..
                            ", "..
                            appData.match.morning.vehicle.color..
                            ", "..
                            appData.match.morning.vehicle.license_plate
                    end    

                else
                    print("-----------------------xxxxx---------------------morning")
                    local localHour = string.sub(appData.match.morning.pick_up_at, 12, 13)
                    localHour = tonumber(localHour) + os.date("%z")/100
                    localHour = tostring(localHour)
                    local localMinute = string.sub(appData.match.morning.pick_up_at, 15, 16)
                    local pickupTime = localHour..":"..localMinute
                    
                    view.todayMorningTime.text = "Plukk opp kl. "..pickupTime
                    view.todayMorningTime.alpha = 1
                    view.todayMorningRole.alpha = 1
                    view.todayMorningRole.text = "Din passasjer"

                    if tonumber(os.date("%H")) >= 12 then
                        view.transportTime.text = "Plukk opp kl. "..pickupTime
                        view.transportRole.text = "Din passasjer"
                        view.transportName.text = appData.match.morning.person.firstname
                    end

                    print("ALPHA "..view.todayMorningRole.alpha)
                end 

                view.todayMorningName.text = appData.match.morning.person.firstname
                
                -- hide something
                view.todayMorningStatus.alpha = 0
                view.todayMorningSwitch.alpha = 0
                view.todayMorningMask.alpha = 0
                view.todayMorningPeriod.alpha = 0  
        else
            print("NO MATCH!")
        end
    end    
end

afternoonMatchDownloaded = function(event)

    print("AFTERNOON MATCH "..event.response)
    matches.afternoonMatch = true

    print(" afternoon ----------- 1")
    local decoded = appData.json.decode(event.response)

    if decoded == nil then return true end

    appData.status.afternoon = decoded.status
    if appData.status.afternoon == "terminated" then appData.status.afternoon = "finish" end
    afternoonTransportID = decoded.transport_id

    if (decoded.matches ~= nil) then
        print(" afternoon ----------- 2")

        if (decoded.matches[1] ~= nil) then

            if decoded.matches[1].rating ~= nil then
                afternoonRating = tostring(decoded.matches[1].rating)
                print("AFTERNOON RATING = "..afternoonRating)
            end  

            if (tonumber(os.date("%H")) >= 12) then -- quick fix 
                appData.currentTransport = decoded.transport_id
            end 

            if decoded.status == "finish" or decoded.status == "terminated" then
                matches.afternoonMatch = true 
                view.todayAfternoonName.text = decoded.matches[1].person.firstname

                if decoded.matches[1].transport_entity_type_id == 2 then
                    view.todayAfternoonRole.text = "Din sjåfør"
                else
                    view.todayAfternoonRole.text = "Din passasjer"
                end

                return true 
            end 
               
            appData.match.afternoon = decoded.matches[1]
            appData.status.afternoon = decoded.status
            print(" afternoon ----------- 3")

            -- fetch time
            local transportTime
            if (appData.match.afternoon.transport_entity_type_id == 2) then
                transportTime = appData.match.afternoon.pick_up_at 
                appData.time.afternoon.myDeparture = routines.UTCtoSec(transportTime)
            else    
                transportTime = appData.match.afternoon.starting_at -- my trip utc time from server
                appData.time.afternoon.myDeparture = routines.UTCtoSec(transportTime)
            end

            -- fetch location
            appData.location.afternoon.departure.ln = decoded.route.from_location.coordinates[1]
            appData.location.afternoon.departure.lt = decoded.route.from_location.coordinates[2]
            appData.location.afternoon.destination.ln = decoded.route.to_location.coordinates[1]
            appData.location.afternoon.destination.lt = decoded.route.to_location.coordinates[2]
            appData.location.afternoon.pick_up.ln = appData.match.afternoon.pick_up_location.coordinates[1]
            appData.location.afternoon.pick_up.lt = appData.match.afternoon.pick_up_location.coordinates[2]  

            -- fetch status
            appData.status.afternoon = decoded.status 
            print("=============== AFTERNOON STATUS =================")  
            print(appData.status.afternoon)   

            print("MATCH! "..appData.match.afternoon.person.firstname)
            -- print(transportTime)
            print("Afternoon Departure"..appData.time.afternoon.myDeparture)
            print("OS Time"..tostring(os.time()))

            -- Show Info if it's in future

            if appData.time.afternoon.myDeparture > os.time() - 3600*200 then
                timer.performWithDelay( 5000, nextTrip, 1)
                matches.afternoonMatch = false
            else
                matches.afternoonMatch = true     
            end    

            -- Save Match
            model.saveMatch(appData.match.afternoon)

            local dayShift
            local dayPart
            local utcTime


            dayShift = 0
            dayPart = "a"
            utcTime = model.calculateUTC(dayShift, dayPart) -- my trip utc time

            print("this is the UTC: "..utcTime.." and this is the transport time: "..transportTime)


                print("MATCH at "..utcTime)
                print (utcTime.." and "..transportTime.." are equal")
                print("MATCH at "..utcTime)

                -- show something
                view.todayAfternoonPortrait.alpha = 1
                view.todayAfternoonRole.alpha = 1
                view.todayAfternoonName.alpha = 1
                view.todayAfternoonPhone.alpha = 1
                view.todayAfternoonRole.alpha = 1
                view.todayAfternoonChat.alpha = 1
                

                -- if (appData.user.mode == "passenger") then
                if (appData.match.afternoon.transport_entity_type_id == 2) then

                    local localHour = string.sub(appData.match.afternoon.pick_up_at, 12, 13)
                    localHour = tonumber(localHour) + os.date("%z")/100
                    localHour = tostring(localHour)
                    local localMinute = string.sub(appData.match.afternoon.pick_up_at, 15, 16)
                    local pickupTime = localHour..":"..localMinute
                    
                    view.todayAfternoonTime.text = "Plukk opp kl. "..pickupTime
                    view.todayAfternoonRole.text = "Din sjåfør"
                    
                    if tonumber(os.date("%H")) >= 12 then
                        view.transportTime.text = "Plukk opp kl. "..pickupTime
                        view.transportRole.text = "Din sjåfør"
                        view.transportName.text = appData.match.afternoon.person.firstname
                        view.transportCar.text = appData.match.afternoon.vehicle.make..
                            " "..
                            appData.match.afternoon.vehicle.model..
                            ", "..
                            appData.match.afternoon.vehicle.color..
                            ", "..
                            appData.match.afternoon.vehicle.license_plate
                    end        

                else
                    local localHour = string.sub(appData.match.afternoon.pick_up_at, 12, 13)
                    localHour = tonumber(localHour) + os.date("%z")/100
                    localHour = tostring(localHour)
                    local localMinute = string.sub(appData.match.afternoon.pick_up_at, 15, 16)
                    local pickupTime = localHour..":"..localMinute
                    
                    view.todayAfternoonTime.text = "Plukk opp kl. "..pickupTime
                    view.todayAfternoonRole.text = "Din passasjer"

                    if tonumber(os.date("%H")) >= 12 then
                        print("------------===============-----------------")
                        view.transportTime.text = "Plukk opp kl. "..pickupTime
                        view.transportRole.text = "Din passasjer"
                        view.transportName.text = appData.match.afternoon.person.firstname
                    end    
                end 

                view.todayAfternoonName.text = appData.match.afternoon.person.firstname
                

                -- hide something
                view.todayAfternoonStatus.alpha = 0
                view.todayAfternoonSwitch.alpha = 0
                view.todayAfternoonMask.alpha = 0
                view.todayAfternoonPeriod.alpha = 0
        else
            print("NO MATCH!")
        end
    end    
end

tomorrowMorningMatchDownloaded = function(event)
    -- print("--------------- TOMORROW MORNING MATCH ---------------")
    -- print("--------------- MATCH DATA ---------------")
    -- print("MATCH "..event.response)

    matches.tomorrowMorningMatch = true

    local decoded = appData.json.decode(event.response)

    if decoded == nil then return true end

    if (decoded.matches ~= nil) then
        if (decoded.matches[1] ~= nil) then
            appData.currentTransport = decoded.transport_id
            appData.match.tomorrowMorning = decoded.matches[1]

            if appData.developerMode == true then
                appData.status.morning = decoded.status -- should be tomorrow morning
            end

            -- fetch time
            local transportTime

            if (appData.match.tomorrowMorning.transport_entity_type_id == 2) then
                transportTime = appData.match.tomorrowMorning.pick_up_at
                appData.time.morning.myDeparture = routines.UTCtoSec(transportTime)
            else    
                transportTime = appData.match.tomorrowMorning.starting_at -- my trip utc time from server
                appData.time.morning.myDeparture = routines.UTCtoSec(transportTime)
            end

            -- fetch location
            appData.location.morning.departure.ln = decoded.route.from_location.coordinates[1]
            appData.location.morning.departure.lt = decoded.route.from_location.coordinates[2]
            appData.location.morning.destination.ln = decoded.route.to_location.coordinates[1]
            appData.location.morning.destination.lt = decoded.route.to_location.coordinates[2]
            appData.location.morning.pick_up.ln = appData.match.tomorrowMorning.pick_up_location.coordinates[1]
            appData.location.morning.pick_up.lt = appData.match.tomorrowMorning.pick_up_location.coordinates[2]            

            print("MATCH! "..appData.match.tomorrowMorning.person.firstname)
            print(transportTime)

            -- Show Info if it's in future
            if appData.time.morning.myDeparture > os.time() then
                timer.performWithDelay( 5000, nextTrip, 1)
                matches.tomorrowMorningMatch = false 
            else
                matches.tomorrowMorningMatch = true    
            end 

            -- Save Match
            model.saveMatch(appData.match.tomorrowMorning)

            print("-- MATCH at "..utcTime.." field "..i)

            -- show something
            view.portraits.morning[1].alpha = 1
            view.roles.morning[1].alpha = 1
            view.names.morning[1].alpha = 1
            view.phones.morning[1].alpha = 1
            view.chats.morning[1].alpha = 1
            view.names.morning[1].text = appData.match.tomorrowMorning.person.firstname

            local localHour = string.sub(appData.match.tomorrowMorning.pick_up_at, 12, 13)
            localHour = tonumber(localHour) + os.date("%z")/100
            localHour = tostring(localHour)
            local localMinute = string.sub(appData.match.tomorrowMorning.pick_up_at, 15, 16)
            local pickupTime = localHour..":"..localMinute
            -- view.hours.morning[1].text = "Plukk opp kl. "..pickupTime
        
            if (appData.match.tomorrowMorning.transport_entity_type_id == 2) then
                view.roles.morning[1].text = "Din sjåfør"
            else
                view.roles.morning[1].text = "Din passasjer"
            end

            -- hide something
            view.status.morning[1].alpha = 0
            view.switches.morning[1].alpha = 0
            view.masks.morning[1].alpha = 0
            view.periods.morning[1].alpha = 0
    
        else
            print("NO MATCH!")
        end
    end    
end

tomorrowAfternoonMatchDownloaded = function(event)
    -- print("--------------- TOMORROW AFTERNOON MATCH ---------------")
    -- print("--------------- MATCH DATA ---------------")
    -- print("MATCH "..event.response)

    matches.tomorrowAfternoonMatch = true

    local decoded = appData.json.decode(event.response)

    if decoded == nil then return true end

    if (decoded.matches ~= nil) then
        if (decoded.matches[1] ~= nil) then
            appData.currentTransport = decoded.transport_id
            appData.match.tomorrowAfternoon = decoded.matches[1]
            
            -- DEVELOPER MODE -------------------------------------------------------
            if appData.developerMode == true then
                appData.status.afternoon = decoded.status -- should be tomorrow morning
            end
            -- ----------------------------------------------------------------------

            -- fetch time
            local transportTime = appData.match.tomorrowAfternoon.pick_up_at

            if (appData.match.tomorrowAfternoon.transport_entity_type_id == 2) then
                transportTime = appData.match.tomorrowAfternoon.pick_up_at 
                appData.time.afternoon.myDeparture = routines.UTCtoSec(transportTime)
            else    
                transportTime = appData.match.tomorrowAfternoon.starting_at -- my trip utc time from server
                appData.time.afternoon.myDeparture = routines.UTCtoSec(transportTime)
            end

            -- fetch location
            appData.location.afternoon.departure.ln = decoded.route.from_location.coordinates[1]
            appData.location.afternoon.departure.lt = decoded.route.from_location.coordinates[2]
            appData.location.afternoon.destination.ln = decoded.route.to_location.coordinates[1]
            appData.location.afternoon.destination.lt = decoded.route.to_location.coordinates[2]
            appData.location.afternoon.pick_up.ln = appData.match.tomorrowAfternoon.pick_up_location.coordinates[1]
            appData.location.afternoon.pick_up.lt = appData.match.tomorrowAfternoon.pick_up_location.coordinates[2]  

            print("MATCH! "..appData.match.tomorrowAfternoon.person.firstname)
            print(transportTime)

            -- Show Info if it's in future
            if appData.time.afternoon.myDeparture > os.time() then
                timer.performWithDelay( 5000, nextTrip, 1) 
                matches.tomorrowAfternoonMatch = false
            else
                matches.tomorrowAfternoonMatch = true    
            end             

            -- Save Match
            model.saveMatch(appData.match.tomorrowAfternoon)

            print("MATCH at afternoon "..utcTime.." field "..i)

            -- show something
            view.portraits.afternoon[1].alpha = 1
            view.roles.afternoon[1].alpha = 1
            view.names.afternoon[1].alpha = 1
            view.phones.afternoon[1].alpha = 1
            view.chats.afternoon[1].alpha = 1
            view.names.afternoon[1].text = appData.match.tomorrowAfternoon.person.firstname

            local localHour = string.sub(appData.match.tomorrowAfternoon.pick_up_at, 12, 13)
            localHour = tonumber(localHour) + os.date("%z")/100
            localHour = tostring(localHour)
            local localMinute = string.sub(appData.match.tomorrowAfternoon.pick_up_at, 15, 16)
            local pickupTime = localHour..":"..localMinute
            -- view.hours.afternoon[1].text = "Plukk opp kl. "..pickupTime
             
            if (appData.match.tomorrowAfternoon.transport_entity_type_id == 2) then
                view.roles.afternoon[1].text = "Din sjåfør" 
            else
                view.roles.afternoon[1].text = "Din passasjer"
            end

            -- hide something
            view.status.afternoon[1].alpha = 0
            view.switches.afternoon[1].alpha = 0
            view.masks.afternoon[1].alpha = 0
            view.periods.afternoon[1].alpha = 0
            view.hint.afternoon[1].alpha = 0
        else
            print("NO MATCH!")
        end
    end    
end

-- Enable Transports  ----------------------------------------------------

morningTransportEnabled = false
enableMorningTransport = function()
    -- print(" - - - - - - - - - - - - - - - -  enabling morning transport 1")

    -- print(appData.match.morning.person)
    -- print(tostring(morningTransportEnabled))
    -- print(tonumber(os.date("%H")))

    -- DEVELOPER MODE ------------------------------------------------------------
    if appData.developerMode then
        appData.match.morning = appData.match.tomorrowMorning
    end 
    -- ---------------------------------------------------------------------------  

    if appData.match.morning.person ~= nil and morningTransportEnabled == false then
        
        -- print(" - - - - - - - - - - - - - - - -   enabling morning transport 2")

        -- calculate times
        appData.time.morning.now = routines.calculateNow()
        appData.time.morning.otherDeparture = routines.UTCtoSec(appData.match.morning.pick_up_at)
        local limit = 60*60*1 -- 60 minutes before departure time
        -- limit = 60*60*10-- 48 hours for testing

        -- print("MY DEPARTURE - LIMIT: "..appData.time.morning.myDeparture - limit)
        -- print("NOW: "..appData.time.morning.now)
        -- print("OTHER DEPARTURE + LIMIT: "..appData.time.morning.otherDeparture + limit)
        -- print("----------------")
        -- print("MY DEPARTURE: "..appData.time.morning.myDeparture)
        -- print("OTHER DEPARTURE: "..appData.time.morning.otherDeparture)
    
        if ((appData.time.morning.myDeparture - limit) < appData.time.morning.now)
        and (appData.time.morning.now < (appData.time.morning.otherDeparture + limit))
        and (appData.match.morning.status ~= "finish")
        then
           

            print(" - - - - - - - - - - - - - - - -   enabling morning transport 3")
            -- set flags
            morningTransportEnabled = true
            -- readyGPS = true

            -- Show Info
            
            if (appData.match.morning.transport_entity_type_id == 2) then 
                appData.user.mode = "passenger"
            else
                appData.user.mode = "driver"
            end
                      
            if appData.user.mode == "driver" then

        -- ------------------------------------------------------------------
        -- generate new map 
        -- LOCATION ================================================================

                local myDeparture = {ln, tl}
                local myDestination = {ln, tl} 

           
                if appData.match.tomorrowAfternoon.id ~= nil then 
                    myDeparture.ln = appData.location.afternoon.departure.ln
                    myDeparture.lt = appData.location.afternoon.departure.lt
                    myDestination.ln = appData.location.afternoon.pick_up.ln
                    myDestination.lt = appData.location.afternoon.pick_up.lt
                    print("------ 11")   
                end  

                if appData.match.tomorrowMorning.id ~= nil then
                    myDeparture.ln = appData.location.morning.departure.ln
                    myDeparture.lt = appData.location.morning.departure.lt
                    myDestination.ln = appData.location.morning.pick_up.ln
                    myDestination.lt = appData.location.morning.pick_up.lt
                    print("------ 12")
                end  

                if appData.match.afternoon.id ~= nil then 
                    myDeparture.ln = appData.location.afternoon.departure.ln
                    myDeparture.lt = appData.location.afternoon.departure.lt
                    myDestination.ln = appData.location.afternoon.pick_up.ln
                    myDestination.lt = appData.location.afternoon.pick_up.lt
                    print("------ 13")
                end 

                if appData.match.morning.id ~= nil then 
                    myDeparture.ln = appData.location.morning.departure.ln
                    myDeparture.lt = appData.location.morning.departure.lt
                    myDestination.ln = appData.location.morning.pick_up.ln
                    myDestination.lt = appData.location.morning.pick_up.lt
                    print("------ 14")
                end

                -- MAP =========================================================================================
                -- create
                print("CREATING DRIVER INFO MAP 2")
                routines.createDriverInfoMap(myDeparture.lt, myDeparture.ln, myDestination.lt, myDestination.ln)

                -- reload
                if view.routeMap2 ~= nil then
                    view.routeMap2:request( "driverinfomap.html", system.DocumentsDirectory )
                end 

                if view.routeMap1 ~= nil then
                    view.routeMap1:request( "driverinfomap.html", system.DocumentsDirectory )
                    -- view.routeMap1.x = 0
                end 


                -- ------------------------------------------------------------------
                
                print("STATUS MORNING =================> ")
                print(appData.status.morning)

                if appData.status.morning == "start" or appData.status.afternoon == "start" then
                    -- if status is start, show driving info and map
                    startDrive() 
                elseif appData.status.morning == "finish" or appData.status.afternoon == "finish" then
                    -- if the status is finish, do nothing
                else
                    -- is the status is nil, show start driving info
                    view.showStartDrivingInfo()
                    view.startButton:addEventListener( "tap", startDrive )

                    -- move maps down
                    view.routeMap2.y = display.screenOriginY + 130 + 50
                    view.routeMap2.height = appData.contentH - display.screenOriginY - 195 - 145

                    view.routeMap1.y = display.screenOriginY + 130 + 50
                    view.routeMap1.height = appData.contentH - display.screenOriginY - 195 - 145
                    -- view.routeMap1.x = 0

                end    
            else    
                view.showPickUpInfo()
            end     

            -- Move Map Down
            view.routeMap2.y = display.screenOriginY + 130
            view.routeMap2.height = appData.contentH - display.screenOriginY - 195 - 95

            view.routeMap1.y = display.screenOriginY + 130
            view.routeMap1.height = appData.contentH - display.screenOriginY - 195 - 95
            -- view.routeMap1.x = 0
        else
        --[[ 
            view.transportView.alpha = 0
            view.scheduleSlide.alpha = 1

            if view.startDrivingGroup ~= nil then
                view.startDrivingGroup.alpha = 0
            end 
            --]]     
            -- print("...........3")
        end
    else
        -- view.transportView.alpha = 0
        -- view.startDrivingGroup.alpha = 0
        -- view.scheduleSlide.alpha = 1 
        -- view.routeMap2.y = display.screenOriginY + 35
    end     
end

afternoonTransportEnabled = false
enableAfternoonTransport = function()
    -- print("afternoon transport enabled 1")

    -- print(appData.match.morning.person)
    -- print(tostring(morningTransportEnabled))
    -- print(tonumber(os.date("%H")))

    -- DEVELOPER MODE ------------------------------------------------------------
    if appData.developerMode then
        appData.match.afternoon = appData.match.tomorrowAfternoon
    end 
    -- ---------------------------------------------------------------------------     

    if (appData.match.afternoon.person ~= nil and 
        afternoonTransportEnabled == false and
        tonumber(os.date("%H")) >= 12) then
        -- print("afternoon transport enabled 2")

        -- calculate times
        appData.time.now = routines.calculateNow()
        appData.time.afternoon.otherDeparture = routines.UTCtoSec(appData.match.afternoon.pick_up_at)
        local limit = 60*60*1 -- 60 minutes before departure time

        -- DEVELOPER MODE ------------------------------------------------------------
        if appData.developerMode == true then limit = 60*60*200 end
        -- ---------------------------------------------------------------------------     

        -- print("MY DEPARTURE - LIMIT: "..appData.time.afternoon.myDeparture  - limit)
        -- print("NOW: "..appData.time.now)
        -- print("OTHER DEPARTURE + LIMIT: "..appData.time.afternoon.otherDeparture + limit)
        -- print("----------------")
        -- print("MY DEPARTURE: "..appData.time.afternoon.myDeparture)
        -- print("OTHER DEPARTURE: "..appData.time.afternoon.otherDeparture)
    
        if ((appData.time.afternoon.myDeparture - limit) < appData.time.now)and
            (appData.time.now < (appData.time.afternoon.otherDeparture + limit))and
            appData.status.afternoon ~= "finish"
        then

            -- print("------- afternoon transport enabled 3")
            -- print(appData.match.afternoon.status)
           
            -- set flags
            afternoonTransportEnabled = true
            -- readyGPS = true

            -- Show Info
            if tonumber(os.date("%H")) <= 11 then
               if (appData.match.morning.transport_entity_type_id == 2) then 
                    appData.user.mode = "passenger"
               else
                    appData.user.mode = "driver"
               end
            end           


            if tonumber(os.date("%H")) >= 12 then
               if (appData.match.afternoon.transport_entity_type_id == 2) then 
                    appData.user.mode = "passenger"
               else
                    appData.user.mode = "driver"
               end
            end 

            -- print("afternoon transport enabled 3")
            -- print("mode="..appData.user.mode)

            if appData.user.mode == "driver" then

                -- ----------------------------------------------------------------------------------
                -- generate new map 
                -- LOCATION ================================================================

                local myDeparture = {ln, tl}
                local myDestination = {ln, tl} 

           
                if appData.match.tomorrowAfternoon.id ~= nil then 
                    myDeparture.ln = appData.location.afternoon.departure.ln
                    myDeparture.lt = appData.location.afternoon.departure.lt
                    myDestination.ln = appData.location.afternoon.pick_up.ln
                    myDestination.lt = appData.location.afternoon.pick_up.lt
                    print("------ 11")   
                end  

                if appData.match.tomorrowMorning.id ~= nil then
                    myDeparture.ln = appData.location.morning.departure.ln
                    myDeparture.lt = appData.location.morning.departure.lt
                    myDestination.ln = appData.location.morning.pick_up.ln
                    myDestination.lt = appData.location.morning.pick_up.lt
                    print("------ 12")
                end  

                if appData.match.afternoon.id ~= nil then 
                    myDeparture.ln = appData.location.afternoon.departure.ln
                    myDeparture.lt = appData.location.afternoon.departure.lt
                    myDestination.ln = appData.location.afternoon.pick_up.ln
                    myDestination.lt = appData.location.afternoon.pick_up.lt
                    print("------ 13")
                end 

                if appData.match.morning.id ~= nil then 
                    myDeparture.ln = appData.location.morning.departure.ln
                    myDeparture.lt = appData.location.morning.departure.lt
                    myDestination.ln = appData.location.morning.pick_up.ln
                    myDestination.lt = appData.location.morning.pick_up.lt
                    print("------ 14")
                end

                -- MAP =========================================================================================
                -- create
                routines.createDriverInfoMap(myDeparture.lt, myDeparture.ln, myDestination.lt, myDestination.ln)

                -- reload
                if view.routeMap2 ~= nil then
                    view.routeMap2:request( "driverinfomap.html", system.DocumentsDirectory )
                end 

                if view.routeMap1 ~= nil then
                    view.routeMap1:request( "driverinfomap.html", system.DocumentsDirectory )
                    -- view.routeMap1.x = 0
                end 

                -- ----------------------------------------------------------------------------------
                -- ------------------------------------------------------------------
                
                print("STATUS AFTERNOON =================> ")
                print("MORNING: "..tostring(appData.status.morning))
                print("AFTERNOON: "..tostring(appData.status.afternoon))


                if appData.status.afternoon == "start" then
                    -- if status is start, show driving info and map
                    startDrive() 
                elseif appData.status.afternoon == "finish" then
                    print("NOTHING")
                    -- if the status is finish, do nothing
                else
                    -- is the status is nil, show start driving info
                    print("showing driving info ---------- ---------- ---------")
                    view.showStartDrivingInfo()
                    view.startButton:addEventListener( "tap", startDrive )

                    -- move map down
                    view.routeMap2.y = display.screenOriginY + 130
                    view.routeMap2.height = appData.contentH - display.screenOriginY - 195 - 90

                    view.routeMap1.y = display.screenOriginY + 130
                    view.routeMap1.height = appData.contentH - display.screenOriginY - 195 - 90
                    -- view.routeMap1.x = 0
                end 
        
            else 
                print("SHOWING PICK UP") 

                -- show info  
                view.showPickUpInfo()

                -- move maps down
                view.routeMap2.y = display.screenOriginY + 130
                view.routeMap2.height = appData.contentH - display.screenOriginY - 195 - 95

                view.routeMap1.y = display.screenOriginY + 130
                view.routeMap1.height = appData.contentH - display.screenOriginY - 195 - 95
                -- view.routeMap1.x = 0

                -- show pickup point for passenger
                print("--------------- will update map")
                if view.routeMap1 ~= nil then
                    print("--------------- updated map")

                    local myDeparture = {ln, tl}
                    local myDestination = {ln, tl} 

                    myDeparture.ln = appData.location.afternoon.pick_up.ln
                    myDeparture.lt = appData.location.afternoon.pick_up.lt
                    myDestination.ln = appData.location.afternoon.pick_up.ln
                    myDestination.lt = appData.location.afternoon.pick_up.lt

                    local lon1 = "lon1="..myDeparture.ln
                    local lat1 = "lat1="..myDeparture.lt
                    local lon2 = "lon2="..myDestination.ln
                    local lat2 = "lat2="..myDestination.lt

                    params = lon1.."&"..lat1.."&"..lon2.."&"..lat2

                    print("this is params: "..params)

                    view.routeMap2:request( "map.html?"..params, system.DocumentsDirectory )
                    view.routeMap2.x = 0
                end                 

            end 

            -- Move Map Down
            if appData.status.afternoon == "finish" then
                view.routeMap2.y = display.screenOriginY + 35
                view.routeMap2.height = appData.contentH - display.screenOriginY - 195
            end

            if appData.status.afternoon == "finish" then
                view.routeMap1.y = display.screenOriginY + 35
                view.routeMap1.height = appData.contentH - display.screenOriginY - 195
                -- view.routeMap1.x = 0
            end
            -- show actual transport
        else 
            --[[
            view.transportView.alpha = 0
            view.scheduleSlide.alpha = 1

            if view.startDrivingGroup ~= nil then
                view.startDrivingGroup.alpha = 0
            end 

            -- set flags
            afternoonTransportEnabled = false
            readyGPS = false

            -- Move Map Down
            view.routeMap2.y = display.screenOriginY + 35
            view.routeMap2.height = appData.contentH - display.screenOriginY - 195     
            print("afternoon...........3")
            --]]
        end
    else
        -- view.transportView.alpha = 0
        -- view.startDrivingGroup.alpha = 0
        -- view.scheduleSlide.alpha = 1 
        -- view.routeMap2.y = display.screenOriginY + 35
    end     
end

-- Next Trip ------- ------------------------------------------------------
showingNextTrip = false
nextTrip = function()

    -- find my role
    if (appData.match.afternoon.transport_entity_type_id ~= nil) then
        if (appData.match.afternoon.transport_entity_type_id == 2) then 
            appData.user.mode = "passenger"
        else
            appData.user.mode = "driver"
        end    
    end

    if (appData.match.morning.transport_entity_type_id ~= nil) then
        if (appData.match.morning.transport_entity_type_id == 2) then 
            appData.user.mode = "passenger"
        else
            appData.user.mode = "driver"
        end    
     end

    print("view.showingStartDriving="..tostring(view.showingStartDriving))
    print("view.showingPickUp="..tostring(view.showingPickUp))
    print("appData.status.morning="..tostring(appData.status.morning))
    print("appData.status.afternoon="..tostring(appData.status.afternoon))
    print("showingNextTrip="..tostring(showingNextTrip))

    if (appData.user.mode == "passenger" 
        and view.showingStartDriving == false) 
        -- and appData.status.afternoon ~= "finish")
        -- and appData.status.afternoon ~= "terminated"        
        -- and showingNextTrip == false)


        or 
        
        (appData.user.mode == "driver" 
        and view.showingStartDriving == false
        and view.showingDrivingInfo == false)
        -- and appData.status.afternoon ~= "finish"
        -- and appData.status.afternoon ~= "terminated"
        -- and appData.status.morning ~= "start"
        -- and appData.status.afternoon ~= "start"
        -- and showingNextTrip == false)

        then
            -- and view.showingPickUp == false
            -- and appData.status.morning ~= "start"
             -- passenger
            print("============== view.showingStartDriving = "..tostring(view.showingStartDriving) )

            print("======================== NEXT TRIP! =========================")
            print("======================== NEXT TRIP! =========================")
            print("======================== NEXT TRIP! =========================")
            print("======================== NEXT TRIP! =========================")
            print("======================== NEXT TRIP! =========================")

            -- move map down
            view.routeMap2.y = display.screenOriginY + 130
            view.routeMap2.height = appData.contentH - display.screenOriginY - 195 - 95

            view.routeMap1.x = 0
            view.routeMap1.y = display.screenOriginY + 130
            view.routeMap1.height = appData.contentH - display.screenOriginY - 195 - 95

            -- show tab
            view.showNextTripInfo()
            view.nextTrip.alpha = 1
            view.nextTripGroup.alpha = 1

            -- set flag
            showingNextTrip = true


            -- ROLE ==========================================================================================

            -- find my role
            if (appData.match.afternoon.transport_entity_type_id ~= nil) then
                if (appData.match.afternoon.transport_entity_type_id == 2) then 
                    appData.user.mode = "passenger"
                else
                    appData.user.mode = "driver"
                end    
            end

            if (appData.match.morning.transport_entity_type_id ~= nil) then
                if (appData.match.morning.transport_entity_type_id == 2) then 
                    appData.user.mode = "passenger"
                else
                    appData.user.mode = "driver"
                end    
             end

            -- TIME ==========================================================================================
            local time = 0 

            print("*****************************************************")
            print(appData.time.morning.myDeparture)
            print(os.time())

            if appData.match.tomorrowAfternoon.id ~= nil and appData.time.afternoon.myDeparture > os.time() - 3600*2 then 
                time = appData.time.afternoon.myDeparture
                print("#------ 1       "..time) 
            end  

            if appData.match.tomorrowMorning.id ~= nil and appData.time.morning.myDeparture > os.time() - 3600*2 then
                time = appData.time.morning.myDeparture
                print("#------ 2        "..time)
            end  

            if appData.match.afternoon.id ~= nil 
            and appData.time.afternoon.myDeparture+3600 > os.time() - 3600*2 
            then 
                print("****************"..appData.time.afternoon.myDeparture)
                time = appData.time.afternoon.myDeparture 
                print("#------ 3       "..time)
            end 

            if appData.match.morning.id ~= nil 
            and appData.time.morning.myDeparture+3600 > os.time() - 3600*2 
            and appData.status.morning ~= "finish"
            then 
                time = appData.time.morning.myDeparture
                print("#------ 4       "..time)
            end

            local timeTable; local h; local m; local d;

            timeTable = os.date("*t", time)
            d = tostring(timeTable.day)
            if (string.len( d ) < 2 ) then d = "0"..d end
            m = tostring(timeTable.month)
            if (string.len( m ) < 2 ) then m = "0"..m end

            local dateValue = d.."."..m..".".." "

            if appData.user.mode == "driver" then 
                h = tostring(timeTable.hour + os.date("%z")/100 )
            else
                h = tostring(timeTable.hour + os.date("%z")/100 )
            end    
            m = tostring(timeTable.min)
            if (string.len( m ) < 2 ) then m = "0"..m end

            local timeValue = h..":"..m     

            -- show the info
            if (appData.user.mode == "driver" and time ~= 0) then
                view.timeInfo.text = "Begynn å kjøre "..dateValue.." kl. ".. timeValue
            elseif (appData.user.mode == "passenger" and time ~= 0) then  
                view.timeInfo.text = "Plukk opp "..dateValue.." kl. ".. timeValue
            elseif (appData.user.mode == "driver" and time == 0) then
                view.timeInfo.text = "Begynn å kjøre nå!"
            elseif (appData.user.mode == "passenger" and time == 0) then  
                view.timeInfo.text = "Plukk opp nå!"
            end   

            -- generate new map 
            -- LOCATION ================================================================

            if (appData.user.mode == "driver") then
                local myDeparture = {ln, tl}
                local myDestination = {ln, tl} 

           
                if appData.match.tomorrowAfternoon.id ~= nil and appData.time.afternoon.myDeparture+3600*2 > os.time() then  
                    myDeparture.ln = appData.location.afternoon.departure.ln
                    myDeparture.lt = appData.location.afternoon.departure.lt
                    myDestination.ln = appData.location.afternoon.pick_up.ln
                    myDestination.lt = appData.location.afternoon.pick_up.lt
                    print("------ 11")   
                end  

                if appData.match.tomorrowMorning.id ~= nil and appData.time.morning.myDeparture+3600*2 > os.time() then 
                    myDeparture.ln = appData.location.morning.departure.ln
                    myDeparture.lt = appData.location.morning.departure.lt
                    myDestination.ln = appData.location.morning.pick_up.ln
                    myDestination.lt = appData.location.morning.pick_up.lt
                    print("------ 12")
                end  

                if appData.match.afternoon.id ~= nil 
                and appData.time.afternoon.myDeparture > os.time() - 3600*20
                and appData.status.afternoon ~= "finish" 
                -- and appData.status.afternoon ~= "terminated" 
                then 
                    myDeparture.ln = appData.location.afternoon.departure.ln
                    myDeparture.lt = appData.location.afternoon.departure.lt
                    myDestination.ln = appData.location.afternoon.pick_up.ln
                    myDestination.lt = appData.location.afternoon.pick_up.lt
                    print("------ 13")
                end 

                if appData.match.morning.id ~= nil 
                and appData.time.morning.myDeparture > os.time() - 3600*20
                and appData.status.morning ~= "finish" 
                -- and appData.status.morning ~= "terminated" 
                then 
                    myDeparture.ln = appData.location.morning.departure.ln
                    myDeparture.lt = appData.location.morning.departure.lt
                    myDestination.ln = appData.location.morning.pick_up.ln
                    myDestination.lt = appData.location.morning.pick_up.lt
                    print("------ 14")
                end

                -- MAP =========================================================================================
                -- create
                routines.createDriverInfoMap(myDeparture.lt, myDeparture.ln, myDestination.lt, myDestination.ln)

                -- reload
                if view.routeMap2 ~= nil then
                    view.routeMap2:request( "driverinfomap.html", system.DocumentsDirectory )
                end

                if view.routeMap1 ~= nil then
                    view.routeMap1.x = 0
                    view.routeMap1:request( "driverinfomap.html", system.DocumentsDirectory )
                end

            elseif (appData.user.mode == "passenger") then

                local myDeparture = {ln, tl}
                local myDestination = {ln, lt} 

                if appData.match.tomorrowAfternoon.id ~= nil and appData.time.afternoon.myDeparture+3600*2 > os.time() then  
                    myDeparture.ln = appData.location.afternoon.pick_up.ln
                    myDeparture.lt = appData.location.afternoon.pick_up.lt
                    myDestination.ln = appData.location.afternoon.pick_up.ln
                    myDestination.lt = appData.location.afternoon.pick_up.lt
                    print("------ 111")   
                end  

                if appData.match.tomorrowMorning.id ~= nil and appData.time.morning.myDeparture+3600*2 > os.time() then 
                    myDeparture.ln = appData.location.morning.pick_up.ln
                    myDeparture.lt = appData.location.morning.pick_up.lt
                    myDestination.ln = appData.location.morning.pick_up.ln
                    myDestination.lt = appData.location.morning.pick_up.lt
                    print("------ 112")
                end  

                if appData.match.afternoon.id ~= nil 
                and appData.time.afternoon.myDeparture+3600 > os.time() - 3600*2 
                then 
                    myDeparture.ln = appData.location.afternoon.pick_up.ln
                    myDeparture.lt = appData.location.afternoon.pick_up.lt
                    myDestination.ln = appData.location.afternoon.pick_up.ln
                    myDestination.lt = appData.location.afternoon.pick_up.lt
                    print("------ 113")
                end 

                if appData.match.morning.id ~= nil 
                and appData.time.morning.myDeparture > os.time() - 3600*20
                and appData.status.morning ~= "finish"
                then 
                    myDeparture.ln = appData.location.morning.pick_up.ln
                    myDeparture.lt = appData.location.morning.pick_up.lt
                    myDestination.ln = appData.location.morning.pick_up.ln
                    myDestination.lt = appData.location.morning.pick_up.lt
                    print("------ 114")
                end

                if view.routeMap2 ~= nil then
                    local lon1 = "lon1="..myDeparture.ln
                    local lat1 = "lat1="..myDeparture.lt
                    local lon2 = "lon2="..myDestination.ln
                    local lat2 = "lat2="..myDestination.lt

                    params = lon1.."&"..lat1.."&"..lon2.."&"..lat2

                    print("this is params: "..params)

                    view.routeMap2:request( "map.html?"..params, system.DocumentsDirectory )
                    -- view.routeMap1:request( "map.html?"..params, system.DocumentsDirectory )
                    view.routeMap1.x = 3000
                end    
            end
            
            -- overlay Next Trip by Pick Up info if applicable
            if view.showingPickUp == true then
                view.pickUpGroup:toFront()
            end    
    else

    end  
end 

-- Hide Trip
hiddenMorning = false
hiddenAfternoon = false
local hideTrip = function()
    -- MORNING
    -- hide info box if the morning trip was finished & no afternoon match
    if appData.status.morning == "finish"
    -- and appData.time.afternoon.myDeparture == nil
    and hiddenMorning == false 
    then
        print("++++++++++++++ hiding morning")
        hiddenMorning = true
      
        -- hide the info box --------------------------------------------
        if view.nextTripGroup ~= nil then
            view.nextTripGroup.alpha = 0
        end 

        if view.pickUpGroup ~= nil then
            view.pickUpGroup.alpha = 0
        end 

        if view.startDrivingGroup ~= nil then
            view.startDrivingGroup.alpha = 0
        end

        if view.drivingGroup ~= nil then
            view.drivingGroup.alpha = 0
        end  

        -- view.drivingGroup.alpha = 0

        -- adjust the map -----------------------------------------------    
        view.routeMap2.y = display.screenOriginY + 35
        view.routeMap2.height = appData.contentH - display.screenOriginY - 195

        view.routeMap1.y = display.screenOriginY + 35
        view.routeMap1.height = appData.contentH - display.screenOriginY - 195
        view.routeMap1.x = 3000        
    
        -- show empty map -----------------------------------------------
        if view.routeMap2 ~= nil then

            -- show blank map (Route Map 2) -----------------------------

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

            params = lon1.."&"..lat1.."&"..lon2.."&"..lat2

            print("this is params: "..params)

            view.routeMap2:request( "map.html?"..params, system.DocumentsDirectory )
        end

        -- set flags
        showingNextTrip = false
        view.showingNextTrip = false
        view.showingPickUp = false
        view.showingStartDriving = false

        -- downloads matches
        downloadMatches()
        -- view.showingDrivingInfo = false
    end


    -- AFTERNOON
    -- hide info box if afternoon trip was finished
    if appData.status.afternoon == "finish"
    and hiddenAfternoon == false 
    then
        print("++++++++++++++ hiding afternoon")
        hiddenAfternoon = true 

       -- hide info box ----------------------------------------------------------
        if view.nextTripGroup ~= nil then
            view.nextTripGroup.alpha = 0
        end 

        if view.pickUpGroup ~= nil then
            view.pickUpGroup.alpha = 0
        end 

        if view.startDrivingGroup ~= nil then
            view.startDrivingGroup.alpha = 0
        end

        if view.drivingGroup ~= nil then
            view.drivingGroup.alpha = 0
        end

        -- adjust the map --------------------------------------------------------    
        view.routeMap2.y = display.screenOriginY + 35
        view.routeMap2.height = appData.contentH - display.screenOriginY - 195

        view.routeMap1.y = display.screenOriginY + 35
        view.routeMap1.height = appData.contentH - display.screenOriginY - 195
        view.routeMap1.x = 3000        

        -- show empty map -------------------------------------------------------
        if view.routeMap2 ~= nil then

            -- show blank map (Route Map 2) -----------------------------

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

            params = lon1.."&"..lat1.."&"..lon2.."&"..lat2

            print("this is params: "..params)

            view.routeMap2:request( "map.html?"..params, system.DocumentsDirectory )
        end
  
        -- set flags --------------------------------------------------------
        showingNextTrip = false
        view.showingNextTrip = false
        view.showingPickUp = false
        view.showingStartDriving = false
        view.showingDrivingInfo = false 

        -- download matches
        downloadMatches()       
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

    appData.background = display.newImageRect( 
        "images/Default.png", 
        appData.screenW, 
        appData.screenW*2.16533333333333 )
    appData.background.x = 160
    appData.background.y = 240

    -- Create Dummy Transports
    model.createDummyTransports()

    -- Update Dummy Transports
    model.updateDummyTransports()
 
    -- Show Background
    view.showBackground()

    -- Show Schedule and Transport
    view.showSchedule() 

    -- Show Bar
    view.showBar()

    -- Show Transports
    view.showTransports()

    -- Show Navi Bar
    view.showFooter()

    -- Set Switches and statuses
    setSwitches()

    -- Reset Address ID's
    resetAddressID()

    -- Save Schedule
    model.saveSchedule(appData.schedule)

    -- Show Transport Before It Happens 
    view.showTransport() 

    -- show trip change menu
    view.showTripChange()

    -- showPicker Wheels
    view.showWheels()


    print("THE SCENE WAS CREATED")

end
 
-- show()
function scene:show( event )
 
    view.sceneGroup = self.view
    local phase = event.phase

     print("THE SCENE WAS SHOWN 1")
 
    if ( phase == "will" ) then

        -- Code here runs when the scene is still off screen 
        -- (but is about to come on screen)
        
        -- Show Departure Search Results
        -- view.showDepartureSearchResults()

        -- Show Destination Search Results
        -- view.showDestinationSearchResults()

        -- Show Map
        -- view.showWebView()

        -- Show or Hide Transport
        -- enableTransport()

        -- Create General Map
        showMyRoute()
  
        -- Assign Listeners -------------------------------------------------------------------
        view.optionsIcon:addEventListener( "tap", showOptions)
        view.settingsButton:addEventListener( "tap", showOptions) 
        view.scheduleSlide:addEventListener( "touch", moveScheduleSlide )

        view.todayMorningMask:addEventListener( "tap", onSwitch )    
        view.todayAfternoonMask:addEventListener( "tap", onSwitch )

        view.todayMorningPhone:addEventListener( "touch", onMorningCall )
        view.todayAfternoonPhone:addEventListener( "touch", onAfternoonCall )
        view.transportPhone:addEventListener( "touch", onTransportCall )

        view.todayMorningChat:addEventListener( "touch", onMorningChat )
        view.todayAfternoonChat:addEventListener( "touch", onAfternoonChat )
        view.transportChat:addEventListener( "touch", onTransportChat )

        view.todayMorningThumbsDown:addEventListener( "tap", rateTrip )
        view.todayMorningThumbsUp:addEventListener( "tap", rateTrip )
        view.todayAfternoonThumbsDown:addEventListener( "tap", rateTrip )
        view.todayAfternoonThumbsUp:addEventListener( "tap", rateTrip )

        view.whiteBackground:addEventListener( "tap", catcher )
        view.wheelButton:addEventListener( "tap", setTransportData )

        view.tripTimeBackground:addEventListener( "tap", showTransportTimeWheel )
        view.tripToleranceBackground:addEventListener( "tap", showTransportToleranceWheel )
        view.tripRoleBackground:addEventListener( "tap", showTransportRoleWheel )

        view.departureField:addEventListener( "userInput", departureFieldListener )
        view.destinationField:addEventListener( "userInput", destinationFieldListener )

        view.topBar:addEventListener( "tap", catcher )
        view.topBar:addEventListener( "touch", catcher )

        view.transportBackground:addEventListener( "tap", catcher )
        view.transportBackground:addEventListener( "touch", catcher )

        view.routeMap1:addEventListener( "urlRequest", webListener )

        -- 

    for i=1, 7 do     
        view.masks.morning[i]:addEventListener( "touch", onSwitch )
        view.masks.afternoon[i]:addEventListener( "touch", onSwitch )

        view.phones.morning[i]:addEventListener( "touch", onTomorrowMorningCall )
        view.phones.afternoon[i]:addEventListener( "touch", onTomorrowAfternoonCall )

        view.chats.morning[i]:addEventListener( "touch", onTomorrowMorningChat )
        view.chats.afternoon[i]:addEventListener( "touch", onTomorrowAfternoonChat )

        view.mornings[i]:addEventListener( "tap", onTripChangeStart )
        view.afternoons[i]:addEventListener( "tap", onTripChangeStart )
    end

--[[
    for i = 1, #appData.transports do
        if appData.transports[i].matches[1] ~= nil then
            print("_____ ______ ______ ______ _____ "..i)
            view.transportPhones[i]:addEventListener( "touch", onCall )  
        end    
    end    
--]]

    -- transports
    --transportBarListeners()
    view.addTransportButton:addEventListener( "touch", addTransport )
    view.plusButton:addEventListener( "touch", addTransport )    
 
    elseif ( phase == "did" ) then

        -- Run Timers
        t1 = timer.performWithDelay( 1000, onTime, -1)
        t2 = timer.performWithDelay( 120000, downloadMatches, -1 )
        t3 = timer.performWithDelay( 1000, downloadMatches, 1)  
        t4 = timer.performWithDelay( 3000, setSwitches, -1 )
        t5 = timer.performWithDelay( 1000, enableMorningTransport, -1 )
        t6 = timer.performWithDelay( 1000, enableAfternoonTransport, -1 )        
        t7 = timer.performWithDelay( 200, handleToday, -1) 
        t8 = timer.performWithDelay( 60, driverCountdown, -1 ) -- move this to the better place
        t9 = timer.performWithDelay( 60, passengerCountdown, -1 ) -- move this to the better place
        t10 = timer.performWithDelay( 1000, uploadGPS, -1) 
        t11 = timer.performWithDelay( 500000, refreshToken, -1) 
        t12 = timer.performWithDelay( 10000, checkGPS, 1) 
        t13 = timer.performWithDelay( 2000, showScene, -1)
        t14 = timer.performWithDelay( 200, showRating, -1)
        t15 = timer.performWithDelay( 200, hideTrip, -1)
        t16 = timer.performWithDelay( 2000, showProposal, -1) 

        if appData.transports[1] == nil then 
            -- view.showFirstTransport()
            -- view.firstButton:addEventListener( "touch", addTransport )
        end     
    end 

    view.sceneGroup.x = 3000
    view.transportsGroup.x = 0
    view.scheduleView.x = 3000

    appData.appIsRunning = true

    Runtime:addEventListener( "enterFrame", refreshTable )
    Runtime:addEventListener( "enterFrame", showMap )
end
 
-- hide()
function scene:hide( event )
 
    view.sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        appData.appIsRunning = false

        -- Cancel Timers
        timer.cancel( t1 )
        timer.cancel( t2 )
        timer.cancel( t3 )
        timer.cancel( t4 )
        timer.cancel( t5 )
        timer.cancel( t6 )
        timer.cancel( t7 )
        timer.cancel( t8 )
        timer.cancel( t9 )
        timer.cancel( t10 )
        timer.cancel( t11 )
        timer.cancel( t12 )
        timer.cancel( t13 )
        timer.cancel( t14 )
        timer.cancel( t15 )
        timer.cancel( t16 )
        print("THE SCENE WILL HIDE")
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        print("THE SCENE WAS HIDDEN")
 
    end
end
 
-- destroy()
function scene:destroy( event )
 
    view.sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    appData.appIsRunning = false
    view.showingStartDriving = false
    view.showingPickUp = false
    showingNextTrip=false


    -- Cancel Timers
    timer.cancel( t1 )
    timer.cancel( t2 )
    timer.cancel( t3 )
    timer.cancel( t4 )
    timer.cancel( t5 )
    timer.cancel( t6 )
    timer.cancel( t7 )
    timer.cancel( t8 )
    timer.cancel( t9 )
    timer.cancel( t10 )
    timer.cancel( t11 )
    timer.cancel( t12 )
    timer.cancel( t13 )
    timer.cancel( t14 )

    print("THE SCENE WAS DESTROYED")
end

-- ------------------------------------------------------------------------
-- Scene event function listeners
-- ------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
Runtime:addEventListener( "key", onKeyEvent )
-- ------------------------------------------------------------------------
 
return scene