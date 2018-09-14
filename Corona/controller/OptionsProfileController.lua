local sceneName = OptionsController

-- Include
local view = require("view.OptionsProfileView")
local model = require("model.OptionsProfileModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )

-- -----------------------------------------------------------------------------------
-- Scene Functions
-- -----------------------------------------------------------------------------------
local onOptions = function(event)
    print("--------------->")   
end

local onBackground = function(event)
    return true
end

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

    -- go further
    timer.performWithDelay( 500, goFurther, 1 )
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



-- USER MODE
local modeUploaded = function(event)
    print("mode uploaded")
    print(event.response)
end

local uploadMode = function()
        print("uploading mode")

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

            params.body = "token "..appData.session.refreshToken 

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
    local alert = native.showAlert( "", "Do you want to log out?", { "NO", "YES" }, logoutNow )        
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

-- set home address
local setAddresses = function()
    print("setting addresses")

    --prepare data
    local url = "https://api.sammevei.no/api/1/addresses" 

    local headers = {}
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Authorization"] = "Bearer "..appData.session.accessToken
      
    local params = {}
    params.headers = headers
    params.body = 
        'a='..
        utils.urlEncode(tostring(appData.addresses.home.address_id))..
        -- utils.urlEncode(appData.addresses.home.address_id)..
        '&'..
        'b='..
        utils.urlEncode(tostring(appData.addresses.work.address_id))
        -- utils.urlEncode(appData.addresses.work.address_id)

    -- send request
    print(params.body)
    -- network.request( url, "POST", addressesSet, params)  
end    

-- finish home address upload
local homeAddressUploaded = function( event )
    print("--------------- HOME ADDRESS UPLOADED ---------------")
    print(event.response)

    local id = appData.json.decode(event.response)
    id = id.id

    -- update home address
    model.updateAdressID("from", id)

    -- save home address
    model.saveAddresses() 

    -- set addresses
    -- timer.performWithDelay(6000, setAddresses, 1)  
end

-- finish work address upload
local workAddressUploaded = function( event )
    print("--------------- WORK ADDRESS UPLOADED ---------------")
    print(event.response)

    local id = appData.json.decode(event.response)
        if (id ~= nil) then
        id = id.id

        -- update work address
        model.updateAdressID("to", id)

        -- save work address
        model.saveAddresses() 

        -- set addresses
        timer.performWithDelay(6000, setAddresses, 1) 
    end
end

-- upload home address
local uploadHomeAddress = function()
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
local uploadWorkAddress = function()
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
end

local handleDepartureKeyboard = function()

    if clicked == false then

        listNumber = 1
        
        -- Take 1st place from the list if available
        if places ~= nil then
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
                view.departureField.text = ""  
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
        for i = 1, 3 do
            rows[i] = view.departureSearchResults:getRowAtIndex( i )
            rows[i]:addEventListener( "tap", departureGeoSearch )
        end
    else
        departureSearchEnd()
    end    
end

local departureSearch = function(place)
    print("departureSearch")

    local requestString = 
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="..
        place..
        "&location=59,10.7&radius=50000"..
        "&language=NO"..
        "&components=country:no"..
        "&types=geocode&key="..
        appData.googlePlaces.APIkey

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
end

local handleDestinationKeyboard = function()
    if clicked == false then

        view.destinationField.x = appData.contentW/2 
        listNumber = 1
        
        -- Take 1st place from the list if available
        if places ~= nil then
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
                view.destinationField.text = ""  
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
        for i = 1, 3 do
            rows[i] = view.destinationSearchResults:getRowAtIndex( i )
            rows[i]:addEventListener( "tap", destinationGeoSearch )
        end
    else
        destinationSearchEnd()
    end    
end

local destinationSearch = function(place)

    local requestString = 
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="..
        place..
        "&location=59,10.7&radius=50000"..
        "&language=NO"..
        "&components=country:no"..
        "&types=geocode&key="..
        appData.googlePlaces.APIkey

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
        view.sceneGroup.y = view.sceneGroup.y - 100
    elseif ( event.phase == "editing" ) then

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        view.sceneGroup.y = view.sceneGroup.y + 100
    end
end

-- Car Plate
local plateFieldListener = function(event)
    if ( event.phase == "began" ) then
        view.sceneGroup.y = view.sceneGroup.y - 100
    elseif ( event.phase == "editing" ) then
        
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        view.sceneGroup.y = view.sceneGroup.y + 100
    end
end

-- -----------------------------------------------------------------------------------
-- WHEELS
-- -----------------------------------------------------------------------------------
local setData = function(event)
 
    view.departureField.y = 5
    view.destinationField.y = 50

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
            native.showAlert( "Advice", "Register a car first to be able to switch to driver, please." ,  { "OK", "" } )
        end
    end    

    return true
end

-- Show Morning Time Wheel --------------------------------------------------
local showMorningTimeWheel = function(event)

    -- move menu out of sight
    view.departureField.y = 3000
    view.destinationField.y = 3000

    transition.to( view.morningTimeWheel, { time = 25, y = 0 } )
    transition.to( view.whiteBackground, { time = 25, alpha = 1 } )
    transition.to( view.wheelButton, { time = 25, alpha = 1 } ) 
    view.morningTimeWheel:selectValue( 2, 3 )

    return true       
end

-- Show Morning Tolerance Wheel --------------------------------------------------
local showMorningToleranceWheel = function(event)

    -- move menu out of sight
    view.departureField.y = 3000
    view.destinationField.y = 3000

    transition.to( view.morningToleranceWheel, { time = 25, y = 0 } )
    transition.to( view.whiteBackground, { time = 25, alpha = 1 } )
    transition.to( view.wheelButton, { time = 25, alpha = 1 } ) 
    view.morningToleranceWheel:selectValue( 2, 5 )

    return true       
end

-- Show Afternoon Time Wheel --------------------------------------------------
local showAfternoonTimeWheel = function(event)

    -- move menu out of sight
    view.departureField.y = 3000
    view.destinationField.y = 3000

    transition.to( view.afternoonTimeWheel, { time = 25, y = 0 } )
    transition.to( view.whiteBackground, { time = 25, alpha = 1 } )
    transition.to( view.wheelButton, { time = 25, alpha = 1 } ) 
    view.afternoonTimeWheel:selectValue( 2, 3 )

    return true       
end

-- Show Afternoon Tolerance Wheel --------------------------------------------------
local showAfternoonToleranceWheel = function(event)

    -- move menu out of sight
    view.departureField.y = 3000
    view.destinationField.y = 3000

    transition.to( view.afternoonToleranceWheel, { time = 25, y = 0 } )
    transition.to( view.whiteBackground, { time = 25, alpha = 1 } )
    transition.to( view.wheelButton, { time = 25, alpha = 1 } ) 
    view.afternoonToleranceWheel:selectValue( 2, 5 )

    return true       
end

-- Show Role Wheel --------------------------------------------------
local showRoleWheel = function(event)

    -- move menu out of sight
    view.departureField.y = 3000
    view.destinationField.y = 3000

    transition.to( view.roleWheel, { time = 25, y = 0 } )
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

local onCar = function(event)

    if event.phase == "began" then
        event.target.alpha = 0.7
    elseif event.phase == "ended" then 
        event.target.alpha = 1 

        -- hide logout
        view.logoutTab.alpha = 0

        -- hide settings
        if view.settingsGroup ~= nil then
            view.settingsGroup.x = 400   
        end         

        -- create forms
        if view.factoryField == nil then
            view.showCarMenu()
            view.carGroup.x = 400

            -- asign listeners
            view.factoryField:addEventListener( "userInput", factoryFieldListener )
            view.modelField:addEventListener( "userInput", modelFieldListener )
            view.colorField:addEventListener( "userInput", colorFieldListener )
            view.plateField:addEventListener( "userInput", plateFieldListener )
        end    

        if view.carGroup.x ~= 0 then
            -- show car
            view.carGroup.x = 0

            -- hide login
            view.logoutTab.alpha = 0
        else
            -- show login
            view.logoutTab.alpha = 1

            -- hide car
            view.carGroup.x = 400

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
        end         
    end   
end  

local onSettings = function(event)
    print("---------- settings")
    if event.phase == "began" then
        event.target.alpha = 0.7
    elseif event.phase == "ended" then 
        event.target.alpha = 1 
        view.logoutTab.alpha = 0

        -- create forms if they don't exist
        if view.settingsGroup == nil then
            print("................")
            view.showSettingsMenu()
            view.showWheels()

            view.departureField:addEventListener( "userInput", departureFieldListener )
            view.destinationField:addEventListener( "userInput", destinationFieldListener )

            view.morningTimeBackground:addEventListener( "tap", showMorningTimeWheel )
            view.morningToleranceBackground:addEventListener( "tap", showMorningToleranceWheel )

            view.afternoonTimeBackground:addEventListener( "tap", showAfternoonTimeWheel )
            view.afternoonToleranceBackground:addEventListener( "tap", showAfternoonToleranceWheel )

            view.roleBackground:addEventListener( "tap", showRoleWheel )

            view.wheelButton:addEventListener( "tap", setData )

            view.settingsGroup.x = 400
        end 

        -- move settings
        if view.settingsGroup.x ~= 0 then
            view.settingsGroup.x = 0
            view.logoutTab.alpha = 0 
        else
            view.settingsGroup.x = 400 
            view.logoutTab.alpha = 1 
        end 

        -- hide car
        if view.carGroup ~= nil then
            view.carGroup.x = 400
        end 
    end   
end  

-- -----------------------------------------------------------------------------------
-- Scene components
-- -----------------------------------------------------------------------------------
local scene = composer.newScene()

-- create()
function scene:create( event )

    
    view.sceneGroup = self.view
   
    -- -------------------------------------------------------------------------------
    -- Create components
    -- -------------------------------------------------------------------------------

    -- Show Background
    view.showBackground()

    -- Show Settings
    view.showLogout()

    -- Show User
    view.showUser()

    -- Show Addresses
    view.showSettings()

    -- Show Settings
    view.showCar()

    -- Show Buttons
    view.showButtons()

    -- Show App Info
    view.showBottomMenu()

end
 
function scene:show( event )
 
    view.sceneGroup = self.view
    -- view.sceneGroup.x = 0 - view.sceneGroup.width

    local phase = event.phase
 
    if ( phase == "will" ) then

        -- ---------------------------------------------------------------------------
        -- Add listeners
        -- ---------------------------------------------------------------------------

        view.carTab:addEventListener( "touch", onCar )
        view.settingsTab:addEventListener( "touch", onSettings )
        view.background:addEventListener( "touch", onBackground )
        view.background:addEventListener( "tap", onBackground )
        view.optionsIcon:addEventListener( "tap", onOptions ) 
        view.logoutTab:addEventListener( "tap", onLogout )

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

        if view.settingsGroup ~= nil then
            
            appData.user.mode = view.role.text
            appData.user.morningTime = view.morningTime.text
            appData.user.afternoonTime = view.afternoonTime.text
            appData.user.morningFlexibility = tonumber(string.sub(view.morningTolerance.text, 1, 3))*60
            appData.user.afternoonFlexibility = tonumber(string.sub(view.afternoonTolerance.text, 1, 3))*60
        
            -- model.saveUser()
        end 

        uploadMode()

        -- -----------------------------------------------------------------------
        -- CAR 
        -- -----------------------------------------------------------------------
        
        -- PROCESS ===============================================================

        -- update car
        if view.factoryField ~= nil then
            if (view.petrolSwitch.isOn) then engineType = "1"
            elseif (view.dieselSwitch.isOn) then engineType = "2"
            elseif (view.electricSwitch.isOn) then engineType = "5"
            end 

            model.updateCar1(view.factoryField.text, view.modelField.text)
            model.updateCar2(view.colorField.text, view.plateField.text)
            model.updateCar3(engineType)

            -- save car
            model.saveCar()
        end    

        -- check whether vehicle_id exist
        if appData.car.vehicle_id == "" and view.factoryField ~= nil and view.plateField.text ~= "" then
            -- REGISTER ==========================================================
            -- register a new car
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

                print("car"..params.body)

            -- send request
            network.request( url, "POST", carUploaded, params)  

        elseif view.factoryField ~= nil and view.plateField.text ~= "" then
            -- UPDATE ============================================================
            print("updating car")

            -- get vehicle_id
            local vehicle_id = appData.car.vehicle_id

            --prepare data
            local url = "https://api.sammevei.no/api/1/users/current/vehicles/"..vehicle_id 

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

                print("car2"..params.body)

            -- send request
            network.request( url, "PUT", carUpdated, params) 
        end  

        -- ------------------------------------------------------------
        -- SCHEDULE
        -- ------------------------------------------------------------
        model.updateSchedule() 
        uploadSchedule()
        -- model.saveSchedule(appData.schedule)

 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        if view.factoryField ~= nil then
            view.factoryField:removeSelf()
            view.factoryField = nil
        end

        if view.modelField ~= nil then
            view.modelField:removeSelf()
            view.modelField = nil
        end

        if view.colorField ~= nil then
            view.colorField:removeSelf()
            view.colorField = nil
        end

        if view.plateField ~= nil then
            view.plateField:removeSelf()
            view.plateField = nil
        end

        if view.settingsGroup ~= nil then
            view.settingsGroup:removeSelf()
            view.settingsGroup = nil
        end    
    end
end

-- destroy()
function scene:destroy( event )
 
    view.sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

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