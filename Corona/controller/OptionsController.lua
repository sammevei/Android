local sceneName = OptionsController

-- Include
local view = require("view.OptionsView")
local model = require("model.OptionsModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )

-- -----------------------------------------------------------------------------------
-- Variables
-- -----------------------------------------------------------------------------------
local places
local rows = {}
local departureSet = false
local destinationSet = false
local clicked = false
local t1
local t2
local t3
local pictureGroup
local menuOpened = false

-- -----------------------------------------------------------------------------------
-- Scene Functions
-- -----------------------------------------------------------------------------------
local uploadHomeAddress
local uploadWorkAddress

local onPhoto
local onComplete
local onPhotoCatch
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
    utils.urlEncode(tostring(appData.schedule[1].time_flex))..
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
    utils.urlEncode(tostring(appData.schedule[2].time_flex))..
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
    utils.urlEncode(tostring(appData.schedule[3].time_flex))..
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
    utils.urlEncode(tostring(appData.schedule[4].time_flex))..
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
    utils.urlEncode(tostring(appData.schedule[5].time_flex))..
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
    utils.urlEncode(tostring(appData.schedule[6].time_flex))..
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
    utils.urlEncode(tostring(appData.schedule[7].time_flex))..
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
    utils.urlEncode(tostring(appData.schedule[8].time_flex))..
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
    utils.urlEncode(tostring(appData.schedule[9].time_flex))..
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
    utils.urlEncode(tostring(appData.schedule[10].time_flex))..
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
    utils.urlEncode(tostring(appData.schedule[11].time_flex))..
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
    utils.urlEncode(tostring(appData.schedule[12].time_flex))..
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
    utils.urlEncode(tostring(appData.schedule[13].time_flex))..
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
    utils.urlEncode(tostring(appData.schedule[14].time_flex))
    
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


-- PHOTO
local showNewImage = function()

    -- delete old image
    if view.portrait ~= nil then
       view.portrait:removeSelf()
       view.portrait = nil
       print("----- removed")
    end

    -- show new image
    -- view.portrait = display.newImage( "portrait.png", system.DocumentsDirectory )
    view.portrait = display.capture( pictureGroup, { saveToPhotoLibrary=false, captureOffscreenArea=false } )

    if view.portrait ~= nil then
        appData.portraitRatio = view.portrait.width/view.portrait.height

        if appData.portraitRatio > 1 then
            view.portrait.height = 50
            view.portrait.width = 50*appData.portraitRatio                                 
        else
            view.portrait.width = 50
            view.portrait.height = 50/appData.portraitRatio        
        end 

        view.portrait.anchorX = 0.5
        view.portrait.anchorY = 0.5
        view.portrait.x = display.screenOriginX + appData.margin*2 + 25
        view.portrait.y = 10 + 25
        view.userTab:insert(view.portrait)
        view.portrait:toFront()

        -- view.portrait.alpha = 0.5

        -- set mask
        view.portraitMask = graphics.newMask( "images/portraitMask.png" )
        view.portrait:setMask( view.portraitMask )
        view.portrait.maskScaleX = 0.245
        view.portrait.maskScaleY = 0.245

        -- assign listeners
        view.portrait:addEventListener( "tap", onPhoto)
        view.portrait:addEventListener( "touch",onPhotoCatch )
        print("----- finished")
    end
end    

--

onComplete = function( event )

    pictureGroup = display.newGroup()
    pictureGroup:toBack()
    
    if appData.photo ~= nil then
        appData.photo:removeSelf( )
        appData.photo = nil
    end

    appData.photo = event.target

    if appData.photo ~= nil then
        -- adjust image
        pictureGroup:insert( appData.photo )

        appData.photo.anchorX = 0
        appData.photo.anchorY = 0
        appData.photo.x = 0
        appData.photo.y = 0

        appData.portraitRatio = appData.photo.width/appData.photo.height

        if appData.portraitRatio > 1 then
            appData.photo.width = appData.contentW/4
            appData.photo.height = (appData.contentW/appData.portraitRatio)/4
        else
            appData.photo.height = appData.contentW/4
            appData.photo.width = (appData.contentW*appData.portraitRatio)/4       
        end  

        print(appData.portraitRatio)
        
        -- save image to temp directory
        os.remove( system.pathForFile( "portrait.png", system.DocumentsDirectory ) )
        display.save( pictureGroup, "portrait.png", system.DocumentsDirectory )
        display.save( pictureGroup, "portrait.png", system.DocumentsDirectory )
        display.save( pictureGroup, "portrait.png", system.DocumentsDirectory )

        timer.performWithDelay(1000, showNewImage, 1)
        print("----- saved")
    end    
end

local photoOpened = false
onPhoto = function(event)

    if media.hasSource( media.PhotoLibrary ) then
       media.selectPhoto( { mediaSource=media.PhotoLibrary, listener=onComplete } )
    else
       native.showAlert( "", "This device does not have a photo library.", { "OK" } )
    end

    return true
end

onPhotoCatch = function(event)

    if ( event.phase == "began" ) then
        return true
    elseif ( event.phase == "ended" ) then
        return true      
    end  
 
    return true
end

-- USER MODE
local modeUploaded = function(event)
    print("mode uploaded")
    print(event.response)
end

local uploadMode = function()
        print("uploading mode")

        appData.user.mode = appData.mode

        --prepare data
        local url = "https://api.sammevei.no/api/1/users/current/settings" 

        local predominant 
        
        if appData.user.mode == "passenger" then
            predominant = "1"
        elseif  appData.user.mode == "driver" then   
            predominant = "2"
        elseif appData.user.mode == "both" then
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

-- SETTINGS
local showingAlert = false
local alertClosed = function(event)
    if ( event.action == "clicked" ) then
        showingAlert = false
        view.driverSwitch:setState( { isOn=false } )
        view.passengerSwitch:setState( { isOn=true } )
        print("CLICKED")
    end   
end

local handleDriverSwitch2 = function()
    print(view.driverSwitch.isOn)
    print(appData.car.vehicle_id)
    print("1 +++++++++++++++++++++++++++++++++++")
    if view.driverSwitch.isOn and appData.car.vehicle_id == "" then 
        
        appData.mode = "passenger" 
        appData.user.mode = "passenger" 
        view.driverSwitch:setState( { isOn=false } )
        view.passengerSwitch:setState( { isOn=true } )
        print("+++++++++++++++++++++++++++++++++++")

        if showingAlert == false then
            local alert = native.showAlert( 
                "", 
                'For å endre innstillingen til "Sjåfør", vennligst legg inn informasjon om bilen din under "Mitt kjøretøy" først.', 
                { "OK", "" },
                alertClosed 
                )
            showingAlert = true 
        end
    elseif view.driverSwitch.isOn and appData.car.vehicle_id == nil then
        appData.mode = "passenger" 
        appData.user.mode = "passenger" 
        view.driverSwitch:setState( { isOn=false } )
        view.passengerSwitch:setState( { isOn=true } )
        print("+++++++++++++++++++++++++++++++++++")

        if showingAlert == false then
            local alert = native.showAlert( 
                "", 
                'For å endre innstillingen til "Sjåfør", vennligst legg inn informasjon om bilen din under "Mitt kjøretøy" først.', 
                { "OK", "" },
                alertClosed 
                )
            showingAlert = true 
        end                        
    end    
end 

local handleDriverSwitch1 = function()
    print("0 +++++++++++++++++++++++++++++++++++")
    timer.performWithDelay(600, handleDriverSwitch2, 1)
end   

local settingsUpdated = function()
    print("--------------- SETTINGS UPDATED ---------------")
    print(event.response)
end  

local updateSettings = function()

    if (view.driverSwitch.isOn)
    and appData.car.vehicle_id ~= ""        
    then appData.mode = "driver"

    elseif (view.driverSwitch.isOn)
    and appData.car.vehicle_id ~= nil        
    then appData.mode = "driver"

    elseif (view.passengerSwitch.isOn) 
    then appData.mode = "passenger"
    
    else 
        appData.mode = "passenger" 
        view.driverSwitch:setState( { isOn=false } )
        view.passengerSwitch:setState( { isOn=true } )        
    end

    appData.user.morningTime = view.morningTime.text
    appData.user.afternoonTime = view.afternoonTime.text
    appData.user.morningFlexibility = tonumber(string.sub(view.morningTolerance.text, 1, 3))*60
    appData.user.afternoonFlexibility = tonumber(string.sub(view.afternoonTolerance.text, 1, 3))*60

    model.saveUser()
    uploadMode()
    model.updateSchedule() 
    uploadSchedule()
end    

-- CAR
-- finish car update
local carUpdated = function( event )
    print("--------------- CAR UPDATED ---------------")
    print(event.response)
end

-- finish car upload
local carUploaded = function( event )
    print("--------------- CAR UPLOADED ---------------")
    print(event.response)

    local vehicle_id = appData.json.decode(event.response)
    appData.car.vehicle_id = vehicle_id.vehicle_id
end

-- upload car 
local uploadCar = function()
    if appData.car.vehicle_id == "" or appData.car.vehicle_id == nil then
        print("uploading car")
   
       -- update car
        if view.factoryField ~= nil then
  
            model.updateCar1(view.factoryField.text, view.modelField.text)
            model.updateCar2(view.colorField.text, view.plateField.text)
            model.updateCar3(engineType)

            -- save car
            model.saveCar()
        end 

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
            'vehicle_engine_type_id=1'

            print(params.body)

        -- send request
        network.request( url, "POST", carUploaded, params)  
    else
        print("updating car")
   
       -- update car
        if view.factoryField ~= nil then
  
            model.updateCar1(view.factoryField.text, view.modelField.text)
            model.updateCar2(view.colorField.text, view.plateField.text)
            model.updateCar3(engineType)

            -- save car
            model.saveCar()
        end 

        --prepare data
        local url = "https://api.sammevei.no/api/1/users/current/vehicles/"..appData.car.vehicle_id

        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        headers["Authorization"] = "Bearer "..appData.session.accessToken
          
        local params = {}
        params.headers = headers
        params.body = 'vehicle_engine_type_id=1'

        if appData.car.license_plate ~= nil and appData.car.license_plate ~= "" then
            params.body = params.body
            ..'&license_plate='
            ..utils.urlEncode(appData.car.license_plate)
        end   
        
        if appData.car.make ~= nil and appData.car.make ~= "" then
            params.body = params.body
            ..'&make='
            ..utils.urlEncode(appData.car.make)
        end    

        if appData.car.model ~= nil and appData.car.model ~= "" then
            params.body = params.body
            ..'&model='
            ..utils.urlEncode(appData.car.model)
        end

        if appData.car.year ~= nil and appData.car.year ~= "" then 
            params.body = params.body       
            ..'&year='
            ..utils.urlEncode(appData.car.year)
        end

        if appData.car.color ~= nil and appData.car.color ~= "" then
            params.body = params.body
            ..'&color='
            ..utils.urlEncode(appData.car.color)
        end

        if appData.car.seats ~= nil and appData.car.seats ~= "" then
            params.body = params.body
            ..'&seats='
            ..utils.urlEncode(appData.car.seats)
        end

        if appData.car.vehicle_type_id ~= nil and appData.car.vehicle_type_id ~= "" then
            params.body = params.body 
            ..'&vehicle_type_id='
            ..utils.urlEncode(appData.car.vehicle_type_id)
        end        

        print(params.body)

        -- send request
        network.request( url, "PUT", carUpdated, params)     
    end     
end  

-- USER 
local phoneUpdated = function(event)
    print("----------- phone updated -------------")
    print(event.response)
end    

-- update user
local updatePhone = function()

    if appData.user.phoneNumber ~= view.phoneField.text then

        print("updating phone")
        appData.user.phoneNumber = view.phoneField.text
        
        --prepare data
        local url = "https://api.sammevei.no/api/1/users/current/mobiles" 

        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        headers["Authorization"] = "Bearer "..appData.session.accessToken
          
        local params = {}
        params.headers = headers
        params.body = 
            'country='..
            utils.urlEncode("+47")..
            '&'..
            'number='..
            utils.urlEncode(appData.user.phoneNumber)    

        -- send request
        network.request( url, "POST", phoneUpdated, params)
    else  
        print("not updating phone")  
    end           
end

local firstnameFieldListener = function(event)
    if ( event.phase == "began" ) then
         print("BEGAN")
         -- view.profileMenuGroup.y = view.profileMenuGroup.y - 115
         local newPos = display.screenOriginY - 60
         transition.to( view.profileMenuGroup, { y = newPos, time = 350, transition=easing.inOutSine } )
    elseif ( event.phase == "editing" ) then
         local newPos = display.screenOriginY - 60
         transition.to( view.profileMenuGroup, { y = newPos, time = 350, transition=easing.inOutSine } )
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
         print("ENDED")
         native.setKeyboardFocus( nil )
         local oldPos = display.screenOriginY
         transition.to( view.profileMenuGroup, { y = oldPos, time = 350, transition=easing.inOutSine } )         
    end 
end 

local middlenameFieldListener = function(event)
    if ( event.phase == "began" ) then
         print("BEGAN")
         -- view.profileMenuGroup.y = view.profileMenuGroup.y - 115
         local newPos = display.screenOriginY - 115
         transition.to( view.profileMenuGroup, { y = newPos, time = 350, transition=easing.inOutSine } )
    elseif ( event.phase == "editing" ) then
         local newPos = display.screenOriginY - 115
         transition.to( view.profileMenuGroup, { y = newPos, time = 350, transition=easing.inOutSine } )
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
         print("ENDED")
         native.setKeyboardFocus( nil )
         local oldPos = display.screenOriginY
         transition.to( view.profileMenuGroup, { y = oldPos, time = 350, transition=easing.inOutSine } )         
    end     
end 

local lastnameFieldListener = function(event)
    if ( event.phase == "began" ) then
         print("BEGAN")
         -- view.profileMenuGroup.y = view.profileMenuGroup.y - 115
         local newPos = display.screenOriginY - 115
         transition.to( view.profileMenuGroup, { y = newPos, time = 350, transition=easing.inOutSine } )
    elseif ( event.phase == "editing" ) then
         local newPos = display.screenOriginY - 115
         transition.to( view.profileMenuGroup, { y = newPos, time = 350, transition=easing.inOutSine } )
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
         print("ENDED")
         native.setKeyboardFocus( nil )
         local oldPos = display.screenOriginY
         transition.to( view.profileMenuGroup, { y = oldPos, time = 350, transition=easing.inOutSine } )         
    end     
end 

local emailFieldListener = function(event)
    if ( event.phase == "began" ) then
         print("BEGAN")
         -- view.profileMenuGroup.y = view.profileMenuGroup.y - 115
         local newPos = display.screenOriginY - 115
         transition.to( view.profileMenuGroup, { y = newPos, time = 350, transition=easing.inOutSine } )
    elseif ( event.phase == "editing" ) then
         local newPos = display.screenOriginY - 115
         transition.to( view.profileMenuGroup, { y = newPos, time = 350, transition=easing.inOutSine } )
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
         print("ENDED")
         native.setKeyboardFocus( nil )
         local oldPos = display.screenOriginY
         transition.to( view.profileMenuGroup, { y = oldPos, time = 350, transition=easing.inOutSine } )         
    end     
end 

local phoneFieldListener = function(event)
    if ( event.phase == "began" ) then
         print("BEGAN")
         -- view.profileMenuGroup.y = view.profileMenuGroup.y - 115
         local newPos = display.screenOriginY - 115
         transition.to( view.profileMenuGroup, { y = newPos, time = 350, transition=easing.inOutSine } )
    elseif ( event.phase == "editing" ) then
         local newPos = display.screenOriginY - 115
         transition.to( view.profileMenuGroup, { y = newPos, time = 350, transition=easing.inOutSine } )
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
         print("ENDED")
         native.setKeyboardFocus( nil )
         local oldPos = display.screenOriginY
         transition.to( view.profileMenuGroup, { y = oldPos, time = 350, transition=easing.inOutSine } )         
    end     
end    


local phoneFieldListener = function(event)
    if ( event.phase == "began" ) then
         print("BEGAN")
         -- view.profileMenuGroup.y = view.profileMenuGroup.y - 115
         local newPos = display.screenOriginY - 115
         transition.to( view.profileMenuGroup, { y = newPos, time = 350, transition=easing.inOutSine } )
    elseif ( event.phase == "editing" ) then
         local newPos = display.screenOriginY - 115
         transition.to( view.profileMenuGroup, { y = newPos, time = 350, transition=easing.inOutSine } )
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
         print("ENDED")
         native.setKeyboardFocus( nil )
         local oldPos = display.screenOriginY
         transition.to( view.profileMenuGroup, { y = oldPos, time = 350, transition=easing.inOutSine } )         
    end    
end    

local userUpdated = function( event )
    print("----------- user updated -------------")
    print(event.response)
end

-- update user
local updateUser = function()

    -- send user data to server
    print("updating user")
    model.addNames(view.firstnameField.text, view.middlenameField.text, view.lastnameField.text)
    appData.user.eMail = view.emailField.text
    
    --prepare data
    local url = "https://api.sammevei.no/api/1/users/current" 

    local headers = {}
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Authorization"] = "Bearer "..appData.session.accessToken
      
    local params = {}
    params.headers = headers
    params.body = 
        'firstname='..
        utils.urlEncode(appData.user.firstName)..
        '&'..
        'middlename='..
        utils.urlEncode(appData.user.middleName)..
        '&'..
        'lastname='..
        utils.urlEncode(appData.user.lastName)..
        '&'..
        'email='..
        utils.urlEncode(appData.user.eMail)

    print("* ================================= *") 
    print(appData.user.eMail)     

    -- send request
    network.request( url, "PUT", userUpdated, params)       
end

-- -----------------------------------------------------------------------------------
local handleProfileButton = function(event)
    if view.firstnameField.text == "" or view.firstnameField.text == "nil"
    or view.lastnameField.text ==  "" or view.lastnameField.text == "nil"
    or view.emailField.text ==  "" or view.emailField.text == "nil"
    or view.phoneField.text ==  "" or view.phoneField.text == "nil" 
    then
        view.profileButton.alpha = 0.25 
    else
        view.profileButton.alpha = 1 
    end   
end    

local onProfileButton = function(event)
    if event.target.alpha < 0.5 then
        return true
    else    
        transition.to( event.target, { time = 250, alpha = 0.1 })
        transition.to( event.target, { delay = 1000, time = 500, alpha = 1 } )
        native.setKeyboardFocus( nil )
        updateUser()
        updatePhone()
        return true
    end
end

local profileSlide = function()
    -- change user name in header
    local userName = "" 

    if appData.user.firstName ~= nil and appData.user.firstName ~= "" then
        userName = userName..appData.user.firstName
    end 
       
    if appData.user.lastName ~= nil and appData.user.lastName ~= "" then
        userName = userName.."\n"..appData.user.lastName   
    end

    if userName == "" then
        userName = "Welcome"
    end 

    view.nameText.text = userName
    print("-------- name updated")

    transition.to( view.profileMenuGroup, { transition=easing.outSine, delay = 100, time = 350, x = -350 })
    transition.to(view.firstnameField, {transition=easing.outSine, time = 200, alpha = 0}) 
    transition.to(view.middlenameField, {transition=easing.outSine, time = 200, alpha = 0}) 
    transition.to(view.lastnameField, {transition=easing.outSine, time = 200, alpha = 0}) 
    transition.to(view.emailField, {transition=easing.outSine, time = 200, alpha = 0}) 
    transition.to(view.phoneField, {transition=easing.outSine, time = 200, alpha = 0}) 

    native.setKeyboardFocus( nil )
    menuOpened = false
    return true
end

local handleCarButton = function(event)
    if view.factoryField.text == "" or view.factoryField.text == "nil"
    or view.modelField.text ==  "" or view.modelField.text == "nil"
    or view.colorField.text ==  "" or view.colorField.text == "nil"
    or view.plateField.text ==  "" or view.plateField.text == "nil" 
    then
        view.carButton.alpha = 0.25 
    else
        view.carButton.alpha = 1 
    end   
end

local onCarButton = function(event)
    if event.target.alpha < 0.5 then
        return true
    else    
        transition.to( event.target, { time = 250, alpha = 0.1 })
        transition.to( event.target, { delay = 500, time = 500, alpha = 1 } )
        native.setKeyboardFocus( nil )
        uploadCar()
        print("WILL UPDATE CAR")
        return true
    end
end

local carSlide = function()
    transition.to( view.carMenuGroup, { transition=easing.outSine, time = 350, x = -350 })
    
    transition.to(view.factoryField, {transition=easing.outSine, time = 200, alpha = 0}) 
    transition.to(view.modelField, {transition=easing.outSine, time = 200, alpha = 0}) 
    transition.to(view.colorField, {transition=easing.outSine, time = 200, alpha = 0}) 
    transition.to(view.plateField, {transition=easing.outSine, time = 200, alpha = 0}) 

    native.setKeyboardFocus( nil )
    menuOpened = false
    return true
end

local onSettingsMenuButton = function(event)
    transition.to( event.target, { time = 250, alpha = 0.1 })
    transition.to( event.target, { delay = 500, time = 500, alpha = 1 } )
    native.setKeyboardFocus( nil )
    updateSettings()
    print("WILL UPDATE SETTINGS")
    return true
end

local settingsSlide = function()
    transition.to( view.settingsMenuGroup, 
        { transition=easing.outSine, time = 350, x = -350 })
    native.setKeyboardFocus( nil )
    menuOpened = false
    return true
end


local onAddressButton = function(event)
    transition.to( event.target, { time = 250, alpha = 0.1 })
    transition.to( event.target, { delay = 500, time = 500, alpha = 1 } )
    native.setKeyboardFocus( nil )
    print("WILL UPLOAD ADDRESSES")
    uploadHomeAddress()
    uploadWorkAddress()
    return true
end

local addressesSlide = function()
    transition.to( view.addressesMenuGroup, { transition=easing.outSine, time = 350, x = -350 })
    transition.to(view.destinationField, {transition=easing.outSine, time = 200, alpha = 0}) 
    transition.to(view.departureField, {transition=easing.outSine, time = 200, alpha = 0}) 
    native.setKeyboardFocus( nil )
    menuOpened = false
    return true
end

local onOptions = function(event)
    print("--------------->")   
end

local onBackground = function(event)
    print("--------------->>")
    if event.phase == "began" then
        return true
    elseif event.phase == "ended" then
        return true
    end
    return true
end

local onTouch = function(event)
    print("================>>")
    if event.phase == "began" then
        native.setKeyboardFocus( nil )
        return true
    elseif event.phase == "ended" then
        return true
    end
end

local onTap = function(event)
    print("<<================")
    native.setKeyboardFocus( nil )
    return true
end


-- CAR
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

-- finsh car update
local carUpdated = function(event)
    print(event.response)
end 

-- logout
local logoutFinished = function(event)
    print("============================")
    print("============================")
    print("============================")
    print("============================")
    print("============================")
    print(event.response)

    -- delete all the data


    -- unregister with FCM
    if appData.useNotifications == true then
        -- appData.notifications.deleteDeviceToken()
        -- print("......................................................................OK")
    end    

    local lfs = require "lfs";
 
    local doc_dir = system.DocumentsDirectory;
    local doc_path = system.pathForFile("", doc_dir);
    local resultOK, errorMsg;
     
    for file in lfs.dir(doc_path) do
        local theFile = system.pathForFile(file, doc_dir);
     
        if (lfs.attributes(theFile, "mode") ~= "directory") then
            resultOK, errorMsg = os.remove(theFile);
     
            if (resultOK) then
                print(file.." removed");
            else
                print("Error removing file: "..file..":"..errorMsg);
            end
        end
    end

    -- ----------------------------------------------------------------

    local doc_dir = system.TemporaryDirectory;
    local doc_path = system.pathForFile("", doc_dir);
     
    for file in lfs.dir(doc_path) do
        local theFile = system.pathForFile(file, doc_dir);
     
        if (lfs.attributes(theFile, "mode") ~= "directory") then
            resultOK, errorMsg = os.remove(theFile);
     
            if (resultOK) then
                print(file.." removed");
            else
                print("Error removing file: "..file..":"..errorMsg);
            end
        end
    end

    -- ----------------------------------------------------------------

    local doc_dir = system.CachesDirectory;
    local doc_path = system.pathForFile("", doc_dir);
     
    for file in lfs.dir(doc_path) do
        local theFile = system.pathForFile(file, doc_dir);
     
        if (lfs.attributes(theFile, "mode") ~= "directory") then
            resultOK, errorMsg = os.remove(theFile);
     
            if (resultOK) then
                print(file.." removed");
            else
                print("Error removing file: "..file..":"..errorMsg);
            end
        end
    end

    -- ----------------------------------------------------------------
--[[
    local doc_dir = system.ApplicationSupportDirectory;
    local doc_path = system.pathForFile("", doc_dir);
     
    for file in lfs.dir(doc_path) do
        local theFile = system.pathForFile(file, doc_dir);
     
        if (lfs.attributes(theFile, "mode") ~= "directory") then
            resultOK, errorMsg = os.remove(theFile);
     
            if (resultOK) then
                print(file.." removed");
            else
                print("Error removing file: "..file..":"..errorMsg);
            end
        end
    end
--]]
    -- -----------------------------------------------------------------
    model.resetVariables()           
end

local logoutNow = function(event)
    if ( event.action == "clicked" ) then
        local i = event.index
        if ( i == 1 ) then
            -- Do nothing; dialog will simply dismiss
        elseif ( i == 2 ) then

            -- logout
            --prepare data
            local url = "https://api.sammevei.no/api/1/auth/logout" 

            local headers = {}
            headers["Content-Type"] = "application/x-www-form-urlencoded"
            -- headers["Authorization"] = "Bearer "..appData.session.accessToken
              
            local params = {}
            params.headers = headers
            params.body = "token="..appData.session.refreshToken 

            -- send request
            network.request( url, "POST", logoutFinished, params)                

            -- delete refresh token and user
            local destDir = system.DocumentsDirectory  -- Location where the file is stored
            local result, reason

            result, reason = os.remove( system.pathForFile( "refreshToken.txt", destDir ) )
            result, reason = os.remove( system.pathForFile( "user.txt", destDir ) )
            result, reason = os.remove( system.pathForFile( "firebase.txt", destDir ) )

            -- go to intro
            composer.removeScene( "controller.ScheduleController" )
            composer.removeScene( "controller.OptionsController" )   
            composer.gotoScene("controller.IntroController")
        end
    end   
end


local onLogout = function(event) 
    local alert = native.showAlert( "", "Vil du logge deg ut?", { "NEI", "JA" }, logoutNow )        
end  

-- -----------------------------------------------------------------------------------
-- GOOGLE PLACES
-- -----------------------------------------------------------------------------------
-- GEO SEARCH + Addresses ===================================================
-- Google Places
local places
local rows = {}

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

-- finish home address upload
local homeAddressUploaded = function( event )
    print("--------------- HOME ADDRESS UPLOADED ---------------")
    print(event.response)

    local data = appData.json.decode(event.response)
    if data.success == true then
        id = data.id

        -- update home address
        model.updateAdressID("from", id)

        -- save home address
        model.saveAddresses()
        print("home address was saved")
    else
        print("home address was not saved")
    end     

    -- set addresses
    -- timer.performWithDelay(6000, setAddresses, 1)  
end

-- finish work address upload
local workAddressUploaded = function( event )
    print("--------------- WORK ADDRESS UPLOADED ---------------")
    print(event.response)

    local data = appData.json.decode(event.response)
    if data.success == true then
        if (data ~= nil) then
        id = data.id

        -- update work address
        model.updateAdressID("to", id)

        -- save work address
        model.saveAddresses() 
        print("work address was saved")

        -- set addresses
        timer.performWithDelay(6000, setAddresses, 1) 
        end
    else
        print("work address was not saved")    
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

    local name = utils.split(appData.addresses.home.name, ",")
    name = name[1]

    params.body = 
        'name='..
        utils.urlEncode(name)..
        '&'..                    
        'location='..
        utils.urlEncode(appData.addresses.home.location)..
        '&'..
        'address='..
        utils.urlEncode(appData.addresses.home.address)..
        '&'..
        'street_number='..
        utils.urlEncode(appData.addresses.home.number)..
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

    -- check
    print("********************************************************************")
    print(params.body) 
    print("********************************************************************")     

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

    local name = utils.split(appData.addresses.work.name, ",")
    name = name[1]

    params.body = 
        'name='..
        utils.urlEncode(name)..
        '&'..                    
        'location='..
        utils.urlEncode(appData.addresses.work.location)..
        '&'..
        'address='..
        utils.urlEncode(appData.addresses.work.address)..
        '&'..
        'street_number='..
        utils.urlEncode(appData.addresses.work.number)..
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
local departureGeoSearchListener = function(event)
    print("departureGeoSearchListener")

    local spot = appData.json.decode(event.response)
    spot = spot.result

     -- update addresses
     model.updateAdresses(
        "from",
        spot.geometry.location.lat,
        spot.geometry.location.lng, 
        view.departureField.text
        ) 



    -- reset address array
    appData.addresses.home.number = ""
    appData.addresses.home.address = ""
    appData.addresses.home.place = ""
    appData.addresses.home.region = ""
    appData.addresses.home.country = ""
    appData.addresses.home.postcode = ""

    -- fill in address array
    local data = appData.json.decode(event.response)

    for i = 1, #data.result.address_components, 1 do

        if data.result.address_components[i].types[1] == "street_number" then
             appData.addresses.home.number = data.result.address_components[i].short_name
        elseif data.result.address_components[i].types[1] == "route" then
             appData.addresses.home.address = data.result.address_components[i].short_name
        elseif data.result.address_components[i].types[1] == "locality" then
             appData.addresses.home.place = data.result.address_components[i].short_name
        elseif data.result.address_components[i].types[1] == "postal_town" then
             appData.addresses.home.place = data.result.address_components[i].short_name
        elseif data.result.address_components[i].types[1] == "administrative_area_level_1" then
             appData.addresses.home.region = data.result.address_components[i].short_name
        elseif data.result.address_components[i].types[1] == "country" then
             appData.addresses.home.country = data.result.address_components[i].short_name
        elseif data.result.address_components[i].types[1] == "postal_code" then
             appData.addresses.home.postcode = data.result.address_components[i].short_name
        end
    end
    

    appData.addresses.home.name = appData.addresses.home.address

    if appData.addresses.home.number ~= "" then
        appData.addresses.home.name = appData.addresses.home.name..", "..appData.addresses.home.number
    end

    if appData.addresses.home.place ~= "" then
        appData.addresses.home.name = appData.addresses.home.name..", "..appData.addresses.home.place
    end

    appData.addresses.home.name = view.departureField.text 

    uploadHomeAddress()
    model.saveAddresses()
    departureSet = true
end

local handleDepartureKeyboard = function()

    if clicked == false then

        listNumber = 1
        
        -- Take 1st place from the list if available
        if appData.places == nil then appData.places = {} end

        if appData.places[listNumber] ~= nil then
            if appData.places[listNumber].place_id ~= nil then
                view.departureField.text = appData.places[listNumber].description

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
                if departureSet == false then
                    view.departureField.text = appData.addresses.home.name                
                end
            end
        else
           if departureSet == false then
                view.departureField.text = appData.addresses.home.name                  
           end
        end 

        -- Enable Destination Field
        view.destinationField.x = appData.contentW/2 

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
end 

local departureGeoSearch = function(event)

    clicked = true
    view.destinationField.x = appData.contentW/2 
    print("departureGeoSearch")
    
    listNumber = event.target.index
    view.departureField.text = appData.places[listNumber].description

    local place_id = appData.places[listNumber].place_id

    -- Make Geo Search String
    local requestString = 
        "https://maps.googleapis.com/maps/api/place/details/json?placeid="..
        place_id..
        "&key="..
        appData.googlePlaces.APIkey

    -- Geo Search
    network.request( requestString, "GET", departureGeoSearchListener )

    -- Hide Departure Search Results
    if view.departureSearchResults ~= nil then
        view.departureSearchResults:removeSelf()
        view.departureSearchResults = nil
        native.setKeyboardFocus( nil )
    end
    return true  
end

local departureSearchEnd = function(event)
    print("departureSearchEnd")
    view.destinationField.x = appData.contentW/2 

    if view.departureSearchResults ~= nil then
        view.departureSearchResults:removeSelf()
        view.departureSearchResults = nil
    end  
end

local departureSearchAutocomplete = function(event)
    print("departureSearchAutocomplete")
    places = appData.json.decode(event.response)
    places = places.predictions

    if places[1] ~= nil then
        view.showDepartureSearchResults(places)

        -- Add touch listener to table view rows
        for i = 1, 5 do
            rows[i] = view.departureSearchResults:getRowAtIndex( i )
            rows[i]:addEventListener( "tap", departureGeoSearch )
        end
    else
        -- departureSearchEnd()
    end    
end

local departureSearch = function(place)
    print("departureSearch")

    local requestString = 
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
        -- "https://maps.googleapis.com/maps/api/place/queryautocomplete/json?"
        -- "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        .."key="..appData.googlePlaces.APIkey        
        .."&input="..place
        .."&location=59.9419591,10.7169925.7"
        .."&radius=9000"
        .."&language=NO"
        .."&components=country:no"

    network.request( requestString, "GET", departureSearchAutocomplete )
end

local departureFieldListener = function(event)
    if ( event.phase == "began" ) then
        clicked = false
        view.departureField.text = ""
    elseif ( event.phase == "editing" ) then
        print("departureFieldListener")
        departureSearch(model.urlEncode(event.target.text))
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        timer.performWithDelay( 300, handleDepartureKeyboard, 1 )
    end
end



-- DESTINATION
local destinationGeoSearchListener = function(event)

    local spot = appData.json.decode(event.response)
    spot = spot.result

     -- update transport
    model.updateAdresses(
        "to", 
        spot.geometry.location.lat, 
        spot.geometry.location.lng,
        view.destinationField.text
        ) 

    local data = appData.json.decode(event.response)

    -- reset address array
    appData.addresses.work.number = ""
    appData.addresses.work.address = ""
    appData.addresses.work.place = ""
    appData.addresses.work.region = ""
    appData.addresses.work.country = ""
    appData.addresses.work.postcode = ""

    -- fill in address array
    for i = 1, #data.result.address_components, 1 do

        if data.result.address_components[i].types[1] == "street_number" then
             appData.addresses.work.number = data.result.address_components[i].short_name
        elseif data.result.address_components[i].types[1] == "route" then
             appData.addresses.work.address = data.result.address_components[i].short_name
        elseif data.result.address_components[i].types[1] == "locality" then
             appData.addresses.work.place = data.result.address_components[i].short_name
        elseif data.result.address_components[i].types[1] == "postal_town" then
             appData.addresses.work.place = data.result.address_components[i].short_name
        elseif data.result.address_components[i].types[1] == "administrative_area_level_1" then
             appData.addresses.work.region = data.result.address_components[i].short_name
        elseif data.result.address_components[i].types[1] == "country" then
             appData.addresses.work.country = data.result.address_components[i].short_name
        elseif data.result.address_components[i].types[1] == "postal_code" then
             appData.addresses.work.postcode = data.result.address_components[i].short_name
        end
    end
 

    appData.addresses.work.name = appData.addresses.work.address

    if appData.addresses.work.number ~= "" then
        appData.addresses.work.name = appData.addresses.work.name..", "..appData.addresses.work.number
    end

    if appData.addresses.work.place ~= "" then
        appData.addresses.work.name = appData.addresses.work.name..", "..appData.addresses.work.place
    end 

    appData.addresses.work.name = view.destinationField.text





    uploadWorkAddress()
    -- save addresses
    model.saveAddresses()
    destinationSet = true 
end

local handleDestinationKeyboard = function()
    if clicked == false then

        view.destinationField.x = appData.contentW/2 
        listNumber = 1
        if appData.places == nil then appData.places = {} end
        
        -- Take 1st place from the list if available

        if appData.places[listNumber] ~= nil then
            if appData.places[listNumber].place_id ~= nil then
                view.destinationField.text = appData.places[listNumber].description

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
                    view.destinationField.text = appData.addresses.work.name                
                end
            end
        else
           if destinationSet == false then
                view.destinationField.text = appData.addresses.work.name                  
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
end  

local destinationGeoSearch = function(event)

    clicked = true

    listNumber = event.target.index
    view.destinationField.text = appData.places[listNumber].description

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

local destinationSearchEnd = function(event)
    view.destinationField.x = appData.contentW/2 

    if view.destinationSearchResults ~= nil then
        view.destinationSearchResults:removeSelf()
        view.destinationSearchResults = nil
    end      
end

local destinationSearchAutocomplete = function(event)

    places = appData.json.decode(event.response)
    places = places.predictions

    if places[1] ~= nil then
        view.showDestinationSearchResults(places)

        -- Add touch listener to table view rows
        for i = 1, 5 do
            rows[i] = view.destinationSearchResults:getRowAtIndex( i )
            rows[i]:addEventListener( "tap", destinationGeoSearch )
        end
    else
        -- destinationSearchEnd()
    end    
end

local destinationSearch = function(place)

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
        clicked = false
        view.destinationField.text = ""
    elseif ( event.phase == "editing" ) then 
        destinationSearch(model.urlEncode(event.target.text))
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        timer.performWithDelay( 300, handleDestinationKeyboard, 1 )  
    end
end








-- -----------------------------------------------------------------------------------
-- CAR BRAND & MODEL
-- -----------------------------------------------------------------------------------

-- Car Factory
local factoryFieldListener = function(event)
    if ( event.phase == "editing" ) then
        print(view.factoryField.text)

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
-- CAR COLOR & PLATE
-- -----------------------------------------------------------------------------------

-- Car Color
local colorFieldListener = function(event)
    if ( event.phase == "began" ) then
        -- view.sceneGroup.y = view.sceneGroup.y - 100
    elseif ( event.phase == "editing" ) then

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- view.sceneGroup.y = view.sceneGroup.y + 100
    end
end

-- Car Plate
local plateFieldListener = function(event)
    if ( event.phase == "began" ) then
        -- view.sceneGroup.y = view.sceneGroup.y - 100
    elseif ( event.phase == "editing" ) then
        
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- view.sceneGroup.y = view.sceneGroup.y + 100
    end
end

-- -----------------------------------------------------------------------------------
-- WHEELS
-- -----------------------------------------------------------------------------------
local setData = function(event)
 
    -- view.departureField.y = 5
    -- view.destinationField.y = 50

    transition.to( view.whiteBackground, { time = 25, alpha = 0 } )
    transition.to( view.wheelButton, { time = 25, alpha = 0 } ) 

    if view.morningTimeWheel.y ~= -3000 then
        transition.to( view.morningTimeWheel, { time = 25, y = -3000 } )
        local values = view.morningTimeWheel:getValues()
        view.morningTime.text = values[2].value..values[3].value..values[4].value
    end

    if view.morningToleranceWheel.y ~= -3000 then
        transition.to( view.morningToleranceWheel, { time = 25, y = -3000 } )
        local values = view.morningToleranceWheel:getValues()
        view.morningTolerance.text = values[2].value
    end    

    if view.afternoonTimeWheel.y ~= -3000 then
        transition.to( view.afternoonTimeWheel, { time = 25, y = -3000 } )
        local values = view.afternoonTimeWheel:getValues()
        view.afternoonTime.text = values[2].value..values[3].value..values[4].value
    end

    if view.afternoonToleranceWheel.y ~= -3000 then
        transition.to( view.afternoonToleranceWheel, { time = 25, y = -3000 } )
        local values = view.afternoonToleranceWheel:getValues()
        view.afternoonTolerance.text = values[2].value
    end 

    if view.roleWheel.y ~= -3000 then
        transition.to( view.roleWheel, { time = 25, y = -3000 } )
        local values = view.roleWheel:getValues()

        view.role.text = values[2].value

        if view.role.text == "driver" and appData.car.vehicle_id == "" then
            view.role.text = "passenger"
            native.showAlert( "Advice", "Register a car first to be able to switch to driver, please." ,  { "", "OK" }, onRegistration )
        end
    end    

    return true
end

-- Show Morning Time Wheel --------------------------------------------------
local showMorningTimeWheel = function(event)

    -- move menu out of sight
    -- view.departureField.y = 3000
    -- view.destinationField.y = 3000

    transition.to( view.morningTimeWheel, { time = 25, y = appData.contentH/2 } )
    transition.to( view.whiteBackground, { time = 25, alpha = 1 } )
    transition.to( view.wheelButton, { time = 25, alpha = 1 } ) 
    view.morningTimeWheel:selectValue( 2, 3 )

    return true       
end

-- Show Morning Tolerance Wheel --------------------------------------------------
local showMorningToleranceWheel = function(event)

    -- move menu out of sight
    -- view.departureField.y = 3000
    -- view.destinationField.y = 3000

    transition.to( view.morningToleranceWheel, { time = 25, y = appData.contentH/2 } )
    transition.to( view.whiteBackground, { time = 25, alpha = 1 } )
    transition.to( view.wheelButton, { time = 25, alpha = 1 } ) 
    view.morningToleranceWheel:selectValue( 2, 5 )

    return true       
end

-- Show Afternoon Time Wheel --------------------------------------------------
local showAfternoonTimeWheel = function(event)

    -- move menu out of sight
    -- view.departureField.y = 3000
    -- view.destinationField.y = 3000

    transition.to( view.afternoonTimeWheel, { time = 25, y = appData.contentH/2 } )
    transition.to( view.whiteBackground, { time = 25, alpha = 1 } )
    transition.to( view.wheelButton, { time = 25, alpha = 1 } ) 
    view.afternoonTimeWheel:selectValue( 2, 3 )

    return true       
end

-- Show Afternoon Tolerance Wheel --------------------------------------------------
local showAfternoonToleranceWheel = function(event)

    -- move menu out of sight
    -- view.departureField.y = 3000
    -- view.destinationField.y = 3000

    transition.to( view.afternoonToleranceWheel, { time = 25, y = appData.contentH/2 } )
    transition.to( view.whiteBackground, { time = 25, alpha = 1 } )
    transition.to( view.wheelButton, { time = 25, alpha = 1 } ) 
    view.afternoonToleranceWheel:selectValue( 2, 5 )

    return true       
end

-- Show Role Wheel --------------------------------------------------
local showRoleWheel = function(event)

    -- move menu out of sight
    -- view.departureField.y = 3000
    -- view.destinationField.y = 3000

    transition.to( view.roleWheel, { time = 25, y = appData.contentH/2 } )
    transition.to( view.whiteBackground, { time = 25, alpha = 1 } )
    transition.to( view.wheelButton, { time = 25, alpha = 1 } )
    if appData.user.mode == "passenger" then
        view.roleWheel:selectValue( 2, 1 )
    else   
        view.roleWheel:selectValue( 2, 2 )
    end 

    return true       
end
-- -----------------------------------------------------------------------------------
-- UTILITIES
-- -----------------------------------------------------------------------------------

local onProfile = function(event)

    print("---------- profile")
    if event.phase == "began" then
        event.target.alpha = 0.7

    elseif event.phase == "ended" and menuOpened == false then

        menuOpened = true 

        view.firstnameField.x = appData.contentW/2
        view.firstnameField.text = appData.user.firstName
        view.middlenameField.x = appData.contentW/2
        view.middlenameField.text = appData.user.middleName
        view.lastnameField.x = appData.contentW/2
        view.lastnameField.text = appData.user.lastName
        view.emailField.x = appData.contentW/2
        view.emailField.text = appData.user.eMail
        view.phoneField.x = appData.contentW/2
        view.phoneField.text = appData.user.phoneNumber
        transition.to(view.profileMenuGroup, {transition=easing.outSine, time = 350, x = 0})
        transition.to(view.firstnameField, {transition=easing.outSine, delay = 350,time = 350, alpha = 1}) 
        transition.to(view.middlenameField, {transition=easing.outSine, delay = 350,time = 350, alpha = 1}) 
        transition.to(view.lastnameField, {transition=easing.outSine, delay = 350,time = 350, alpha = 1}) 
        transition.to(view.emailField, {transition=easing.outSine, delay = 350,time = 350, alpha = 1}) 
        transition.to(view.phoneField, {transition=easing.outSine, delay = 350,time = 350, alpha = 1}) 
        event.target.alpha = 1

        return true
    end  
end 

local onAddresses = function(event)

    print("---------- addresses")
    if event.phase == "began" then
        event.target.alpha = 0.7
    elseif event.phase == "ended" and menuOpened == false then

        menuOpened = true 

        view.departureField.x = appData.contentW/2
        view.destinationField.x = appData.contentW/2        
        transition.to(view.addressesMenuGroup, {transition=easing.outSine, time = 350, x = 0})
        transition.to(view.departureField, {transition=easing.outSine, delay = 350,time = 350, alpha = 1}) 
        transition.to(view.destinationField, {transition=easing.outSine, delay = 350,time = 350, alpha = 1}) 
        event.target.alpha = 1
        return true
    end 
end  

local onCar = function(event)

    print("-------------- car")
    if event.phase == "began" then
        event.target.alpha = 0.7
    elseif event.phase == "ended" and menuOpened == false then

        menuOpened = true 

        view.factoryField.x = appData.contentW/2
        view.factoryField.text = appData.car.make
        view.modelField.x = appData.contentW/2
        view.modelField.text = appData.car.model
        view.colorField.x = appData.contentW/2
        view.colorField.text = appData.car.color
        view.plateField.x = appData.contentW/2
        view.plateField.text = appData.car.license_plate

        transition.to(view.factoryField, {transition=easing.outSine, delay = 350,time = 350, alpha = 1}) 
        transition.to(view.modelField, {transition=easing.outSine, delay = 350,time = 350, alpha = 1}) 
        transition.to(view.colorField, {transition=easing.outSine, delay = 350,time = 350, alpha = 1}) 
        transition.to(view.plateField, {transition=easing.outSine, delay = 350,time = 350, alpha = 1}) 

        transition.to(view.carMenuGroup, {transition=easing.outSine, time = 350, x = 0})
        event.target.alpha = 1 
        
        --[[
        -- update car
        if (view.petrolSwitch.isOn) then engineType = "1"
        elseif (view.dieselSwitch.isOn) then engineType = "2"
        elseif (view.electricSwitch.isOn) then engineType = "5"
        end 

        if view.plateField.text ~= nil and view.plateField.text ~= "" then

            model.updateCar1(view.factoryField.text, view.modelField.text)
            model.updateCar2(view.colorField.text, view.plateField.text)
            model.updateCar3(engineType)
        
            -- save car
            model.saveCar()
        end 
        --]]           
    end      
end  

local onSettings = function(event)

    print("-------------- settings")
    if event.phase == "began" then
        print("-------------- settings")
        event.target.alpha = 0.7
    elseif event.phase == "ended" and menuOpened == false then

        menuOpened = true 

        -- set user mode
        local driverSwitchState = false
        local passengerSwitchState = false
        local bothSwitchState = false

        if (appData.user.mode == "driver") then driverSwitchState = true
        elseif (appData.user.mode == "passenger") then passengerSwitchState = true     
        elseif (appData.user.mode == "both") then bothSwitchState = true 
        end

        view.driverSwitch:setState( { isOn=driverSwitchState } )
        view.passengerSwitch:setState( { isOn=passengerSwitchState } )

        -- set morning time and flex
        view.morningTime.text = appData.user.morningTime
        view.morningTolerance.text = tostring(appData.user.morningFlexibility/60).." min"

        -- set afternoon time and flex
        view.afternoonTime.text = appData.user.afternoonTime
        view.afternoonTolerance.text = tostring(appData.user.afternoonFlexibility/60).." min"

        transition.to(view.settingsMenuGroup, {transition=easing.outSine, time = 350, x = 0})
        event.target.alpha = 1           
    end     
end 

local onHelp = function(event)
    print("-------------- settings")
    if event.phase == "began" then
        print("-------------- help 1")
        event.target.alpha = 0.7
    elseif event.phase == "ended" then 
        print("-------------- help 2")
        system.openURL( "http://www.sammevei.no/hjelp" )
        event.target.alpha = 1           
    end   
end 

-- -----------------------------------------------------------------------------------
-- Scene components
-- -----------------------------------------------------------------------------------
local scene = composer.newScene()

-- create()
function scene:create( event )  
    view.sceneGroup = self.view
end
 
function scene:show( event )
 
    view.sceneGroup = self.view
        -- view.sceneGroup.x = 0 - view.sceneGroup.width

        local phase = event.phase
     
        if ( phase == "will" ) then
        -- -------------------------------------------------------------------------------
        -- Create components
        -- -------------------------------------------------------------------------------

        -- SHOW MAIN SCREEN --------------------------------------------------------------
        view.showBackground()
        view.showButtons()
        view.showUser()
        view.showProfile()
        -- view.showAddresses()
        view.showCar()
        -- view.showSettings()
        view.showHelp()
        view.showBottomMenu()      

        -- SHOW MENUS ----------------------------------------------------------------------
        view.showProfileMenu()
        view.showAddressesMenu()
        view.showCarMenu()
        view.showSettingsMenu() 

        -- ---------------------------------------------------------------------------
        -- Add listeners
        -- ---------------------------------------------------------------------------

        view.optionsIcon:addEventListener( "tap", onOptions )
        -- view.portrait:addEventListener( "tap", onPhoto)
        view.portrait:addEventListener( "touch",onPhotoCatch )
        view.profileTab:addEventListener( "touch", onProfile)
        -- view.addressesTab:addEventListener( "touch", onAddresses )
        view.carTab:addEventListener( "touch", onCar )
        -- view.settingsTab:addEventListener( "touch", onSettings )
        view.helpTab:addEventListener( "touch", onHelp )
        view.userBackground:addEventListener( "touch", onProfile )

        view.background:addEventListener( "touch", onBackground )
        view.background:addEventListener( "tap", onBackground )
        

        -- MENUS ----------------------------------------------------------------------

        -- profile
        view.profileMenuBackground:addEventListener( "touch", onTouch )
        view.profileMenuBackground:addEventListener( "tap", onTap )
        view.profileButton:addEventListener( "tap", onProfileButton )
        view.optionsProfileIcon:addEventListener( "tap", profileSlide )
        view.logoutButton:addEventListener( "tap", onLogout ) 
        
        view.firstnameField:addEventListener( "userInput", firstnameFieldListener )
        view.middlenameField:addEventListener( "userInput", middlenameFieldListener )
        view.lastnameField:addEventListener( "userInput", lastnameFieldListener )
        view.emailField:addEventListener( "userInput", emailFieldListener )
        view.phoneField:addEventListener( "userInput", phoneFieldListener )

        -- addresses
        -- view.addressesBackground:addEventListener( "touch", onTouch )
        -- view.addressesBackground:addEventListener( "tap", onTap )  
        -- view.departureField:addEventListener( "userInput", departureFieldListener )
        -- view.destinationField:addEventListener( "userInput", destinationFieldListener )
        -- view.optionsAddressesIcon:addEventListener( "tap", addressesSlide ) 
        -- view.addressesButton:addEventListener( "tap", onAddressButton ) 

        -- car
        view.carMenuBackground:addEventListener( "touch", onTouch )
        view.carMenuBackground:addEventListener( "tap", onTap )          
        view.factoryField:addEventListener( "userInput", factoryFieldListener )
        view.modelField:addEventListener( "userInput", modelFieldListener )
        view.colorField:addEventListener( "userInput", colorFieldListener )
        view.plateField:addEventListener( "userInput", plateFieldListener )
        view.carButton:addEventListener( "tap", onCarButton )
        view.optionsCarIcon:addEventListener( "tap", carSlide ) 

        -- settings
        -- view.settingsMenuBgg:addEventListener( "touch", onTouch )
        -- view.settingsMenuBgg:addEventListener( "tap", onTap ) 
        -- view.settingsMenuIcon:addEventListener( "tap", settingsSlide ) 
        -- view.settingsMenuButton:addEventListener( "tap", onSettingsMenuButton ) 

        -- view.morningTimeBackground:addEventListener( "tap", showMorningTimeWheel )
        -- view.morningToleranceBackground:addEventListener( "tap", showMorningToleranceWheel )
        -- view.afternoonTimeBackground:addEventListener( "tap", showAfternoonTimeWheel )
        -- view.afternoonToleranceBackground:addEventListener( "tap", showAfternoonToleranceWheel )
        -- view.roleBackground:addEventListener( "tap", showRoleWheel )
        view.wheelButton:addEventListener( "tap", setData ) 
        view.whiteBackground:addEventListener( "touch", onTouch ) 
        view.whiteBackground:addEventListener( "tap", onTap )

        -- view.passengerSwitch:addEventListener( "touch", handlePassengerSwitch )
        -- view.driverSwitch:addEventListener( "tap", handleDriverSwitch1 )

        -- Run timers
        t1 = timer.performWithDelay(20, handleProfileButton, -1)
        t2 = timer.performWithDelay(20, handleCarButton, -1)
        -- t3 = timer.performWithDelay(20, handleSwitches, -1)               

    elseif ( phase == "did" ) then

    end
end
 
-- hide()
function scene:hide( event )
 
    view.sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        print("------------ it will hide ----------------")

        if appData.refreshing == true then
            -- -----------------------------------------------------------------------
            -- LOCATIONS
            -- -----------------------------------------------------------------------
            if appData.addresses.home.location ~= "" then 
                -- uploadHomeAddress()
            end

            if appData.addresses.home.location ~= "" then
                -- uploadWorkAddress()
            end

            -- -----------------------------------------------------------------------
            -- USER 
            -- -----------------------------------------------------------------------

            -- if view.settingsGroup ~= nil then
                
            -- -----------------------------------------------------------------------
            -- CAR 
            -- -----------------------------------------------------------------------
            
            -- PROCESS ===============================================================

            -- update car
            -- if view.factoryField ~= nil then
      

            -- end    

     
            -- ------------------------------------------------------------
            -- SCHEDULE
            -- ------------------------------------------------------------
            model.updateSchedule() 
            uploadSchedule()
            model.saveSchedule(appData.schedule)

            appData.refreshing = false
        end    

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen   
    end
end

-- destroy()
function scene:destroy( event )
 
    view.sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    timer.cancel(t1)
    timer.cancel(t2)
    -- timer.cancel(t3)

    if view.emailField ~= nil then
      display.remove( view.emailField )
      view.emailField = nil
    end

    if view.passwordField1 ~= nil then
      display.remove( view.passwordField1 )
      view.passwordField1 = nil
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