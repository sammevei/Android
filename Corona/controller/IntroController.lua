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
local internetAccessible = false
local showAlert
local networkError
local refreshToken
local tokenRefreshed
local t1

-- -------------------------------------------------------------------
-- NOTIFICATIONS
-- -------------------------------------------------------------------

local firebaseRegistered = function(event)
    if appData.useNotifications == true then
        print(event.response)
        print("=============== CLIENT REGISTERED ====================")
    end
end

-- -------------------------------------------------------------------

local iterations = 0
local goFurther = function()
    print("GOING FURTHER ================== INTRO =============== GOING FURTHER")

    if appData.car.vehicle_id == "" then appData.car.vehicle_id = nil end


    -- if it's getting too long, try request again
    if iterations == 10 or iterations == 20 then
        refreshToken()
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
            appData.composer.removeScene( "controller.IntroController" )
            appData.composer.gotoScene( "controller.PhoneController" )
            timer.cancel( t1 )
            return true
        elseif (appData.addresses.work.location == ""
        or appData.addresses.home.location == "" )
        then
            appData.composer.removeScene( "controller.IntroController" )
            appData.composer.gotoScene( "controller.PlacesController" )
            timer.cancel( t1 )
            return true
        elseif (appData.addresses.work.location == ""
        or appData.addresses.home.location == "" )
        then
            appData.composer.removeScene( "controller.IntroController" )
            appData.composer.gotoScene( "controller.DatesController" )
            timer.cancel( t1 )
            return true
        elseif (appData.user.mode == "" or appData.user.mode == nil)
        then
            appData.composer.removeScene( "controller.IntroController" )
            appData.composer.gotoScene( "controller.DateController" )
            timer.cancel( t1 )
            return true
        elseif appData.schedule[1] == nil then
            appData.composer.removeScene( "controller.IntroController" )
            appData.composer.gotoScene( "controller.PlacesController" )
            timer.cancel( t1 )
            return true
        elseif appData.schedule[1].time_offset == "" then
            appData.composer.removeScene( "controller.IntroController" )
            appData.composer.gotoScene( "controller.PlacesController" )
            timer.cancel( t1 )
            return true
        elseif appData.schedule[1].time_offset == nil then
            appData.composer.removeScene( "controller.IntroController" )
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

    if appData.schedule[1] == nil then
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

    or  appData.addresses.work.location ~= ""
        and appData.addresses.home.location ~= ""
        and appData.schedule[1].time_offset ~= nil
    then

        -- cancel timer
        timer.cancel( t1 )

        --Prepare Data
        local url = "https://api.sammevei.no/api/1/clients/current/token"

        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        headers["Authorization"] = "Bearer "..appData.session.accessToken

        local params = {}
        params.headers = headers
        params.body =
            'type='..utils.urlEncode(appData.system.phoneType)..'&'..
            'version='..appData.system.appVersion..'&'..
            'build='..utils.urlEncode(appData.system.appBuild)..'&'..
            'locale='..utils.urlEncode(appData.system.userLocale)..'&'..
            'timezone='..utils.urlEncode(appData.system.userTimezone)..'&'..
            'model='..utils.urlEncode(appData.system.phoneModel)..'&'..
            'os_name='..utils.urlEncode(appData.system.osName)..'&'..
            'os_version='..utils.urlEncode(appData.system.osVersion)

        if (appData.useNotifications == true ) then

            -- appData.firebaseToken = appData.notifications.getDeviceToken()
            --
            -- params.body = params.body..'&token='..appData.firebaseToken
            -- print(params.body)
            -- network.request( url, "POST", firebaseRegistered, params)
        end

        -- go to schedule
        local options = {
            effect = "fade",
            time = 1200
        }

        appData.composer.removeScene( "controller.IntroController" )
        appData.composer.gotoScene( "controller.GreetingController", options )
    else
        iterations = iterations + 1
        print("ITERATION: "..iterations)
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
    print("--------------- SCHEDULE DOWNLOADED --------------- intro")
    print(event.response)

    -- decode
    local temporarySchedule = appData.json.decode( event.response )
    appData.schedule = appData.json.decode( event.response )

    if temporarySchedule[1] == nil then
        print(" =================== SCHEDULE EMPTY =====================")
        appData.ready.schedule = true
        return true
    else
        appData.schedule = temporarySchedule
    end

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

    print("uploading schedule in intro")

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

-- ------------------------------------------------------------------------------------------ --
-- ALERTS
-- ------------------------------------------------------------------------------------------ --
networkError = function(event)
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

-- ------------------------------------------------------------------------------------------ --
-- DOWNLOAD DATA
-- ------------------------------------------------------------------------------------------ --

-- TRANSPORTS
local saveTransports = function(event)
    print( event.response )
    appData.transports = appData.json.decode( event.response )
    appData.ready.transports = true
    print("----------------------- TRANSPORTS SET")
end

-- SCHEDULE
local saveSchedule = function(event)
    print(" =================== SCHEDULE DOWNLOADED =====================")
    print(event.response)

    -- decode
    local temporarySchedule = appData.json.decode( event.response )
    appData.schedule = appData.json.decode( event.response )

    if temporarySchedule[1] == nil then
        print(" =================== SCHEDULE EMPTY =====================")
        appData.ready.schedule = true
        return true
    else
        appData.schedule = temporarySchedule
    end

    -- sort
    appData.schedule = model.sortSchedule(appData.schedule)

    -- save
    model.saveSchedule(appData.schedule)

    -- update user
    appData.user.morningFlexibility = tostring(tonumber(appData.schedule[1].time_flex)*60)
    appData.user.afternoonFlexibility = tostring(tonumber(appData.schedule[2].time_flex)*60)

    local morningTime = tonumber(appData.schedule[1].time_offset)
    local morningHours, morningMinutes = math.modf( morningTime/60 )
    morningHours = tostring(morningHours)
    morningMinutes = tostring(morningTime - morningHours*60)
    if #morningHours < 2 then morningHours = "0"..morningHours end
    if #morningMinutes < 2 then morningMinutes = morningMinutes.."0" end
    morningTime = tostring(morningHours)..":"..morningMinutes


    local afternoonTime = tonumber(appData.schedule[2].time_offset)
    local afternoonHours, afternoonMinutes = math.modf( afternoonTime/60 )
    afternoonHours = tostring(afternoonHours)
    afternoonMinutes = tostring(afternoonTime - afternoonHours*60)
    if #afternoonHours < 2 then afternoonHours = "0"..afternoonHours end
    if #afternoonMinutes < 2 then afternoonMinutes = afternoonMinutes.."0" end
    afternoonTime = tostring(afternoonHours)..":"..afternoonMinutes

    appData.user.morningTime = morningTime
    appData.user.afternoonTime = afternoonTime

    print("----------------------- SCHEDULE SET")
    print(appData.user.morningTime)
    print(appData.user.afternoonTime)
    print(appData.user.morningFlexibility)
    print(appData.user.afternoonFlexibility)

    appData.ready.schedule = true
end

-- CAR
local saveCar = function(event)

    local data = appData.json.decode(event.response)
    print(event.response)


    print("[1]")
    if data[1] ~= nil then
        appData.car.license_plate = data[1].license_plate
        appData.car.make = data[1].make
        appData.car.model = data[1].model
        appData.car.year = data[1].year
        appData.car.color = data[1].color
        appData.car.seats = data[1].seats
        appData.car.vehicle_type_id = data[1].vehicle_type_id
        appData.car.vehicle_engine_type_id = data[1].engine
        appData.car.vehicle_id = data[1].vehicle_id
        appData.car.id = data[1].id

        print("----------------------- CAR SET")
        appData.ready.car = true
    end
end

-- ADDRESSES
local saveAddresses = function(event)

    local data = appData.json.decode(event.response)
    print("doing addresses --------------- doing addresses")
    print(event.response)

    if data[1] ~= nil then
        -- update home address
        for i=1, #data, 1 do
            if data[i].code == "a" then
                appData.user.home = data[i].location.coordinates[1]..","..data[i].location.coordinates[2]
                appData.user.homeAddress = data[i].address

                appData.addresses.home.address = data[i].address
                appData.addresses.home.location = data[i].location.coordinates[1]..","..data[i].location.coordinates[2]
                appData.addresses.home.address_id = data[i].id
                appData.addresses.home.name = data[i].name
                appData.addresses.home.number = data[i].street_number
                appData.addresses.home.place = data[i].place
                appData.addresses.home.postcode = data[i].postcode
                appData.addresses.home.region = data[i].region
                appData.addresses.home.country = data[i].country
            end
        end

        -- update work address
        for i=1, #data, 1 do
            if data[i].code == "b" then
                appData.user.work = data[i].location.coordinates[1]..","..data[i].location.coordinates[2]
                appData.user.workAddress = data[i].address

                appData.addresses.work.address = data[i].address
                appData.addresses.work.location = data[i].location.coordinates[1]..","..data[i].location.coordinates[2]
                appData.addresses.work.address_id = data[i].id
                appData.addresses.work.name = data[i].name
                appData.addresses.work.number = data[i].street_number
                appData.addresses.work.place = data[i].place
                appData.addresses.work.postcode = data[i].postcode
                appData.addresses.work.region = data[i].region
                appData.addresses.work.country = data[i].country
            end
        end



        print("----------------------- ADDRESSES SET")
        appData.ready.addresses = true
    end
end

-- USER
local updateUser = function(event)

    -- print("----------------------- SETTING USER")
    print(event.response)

    local data = appData.json.decode(event.response)

    -- update user
    appData.user.eMail = data.email
    appData.user.country = data.mobile.country
    appData.user.phoneNumber = data.mobile.number

    appData.user.userName = data.email
    appData.user.firstName = data.firstname
    appData.user.middleName = data.middlename
    appData.user.lastName = data.lastname
    appData.user.userID = data.user_id

    if data.settings.predominant == 1 then
        appData.user.mode = "passenger"
        appData.mode = "passenger"
    elseif data.settings.predominant == 2 then
        appData.user.mode = "driver"
        appData.mode = "driver"
    end

    print("----------------------- USER SET")

    print(event.response)
    appData.ready.user = true

end

-- DATA
local downloadData = function()
    if appData.session.accessToken ~= nil and appData.session.accessToken ~= "" then
        -- USER --------------------------------------------------------------------
        -- prepare data
        local url = "https://api.sammevei.no/api/1/users/current"

        local params = {}

        -- headers
        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        headers["Authorization"] = "Bearer "..appData.session.accessToken
        params.headers = headers


        -- send request
        network.request( url, "GET", updateUser, params)
        print("downloading user!")

        -- ADDRESSES ---------------------------------------------------------------
        -- prepare data
        local url = "https://api.sammevei.no/api/1/users/current/addresses"

        local params = {}

        -- headers
        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        headers["Authorization"] = "Bearer "..appData.session.accessToken
        params.headers = headers


        -- send request
        network.request( url, "GET", saveAddresses, params)
        print("downloading addresses!")

        -- CAR ---------------------------------------------------------------------

        -- prepare data
        local url = "https://api.sammevei.no/api/1/users/current/vehicles"

        local params = {}

        -- headers
        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        headers["Authorization"] = "Bearer "..appData.session.accessToken
        params.headers = headers


        -- send request
        network.request( url, "GET", saveCar, params)
        print("downloading car!")

        -- SCHEDULE ----------------------------------------------------------------

        --prepare data
        local url = "https://api.sammevei.no/api/1/users/current/schedules"

        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        headers["Authorization"] = "Bearer "..appData.session.accessToken

        local params = {}
        params.headers = headers

        -- send request
        network.request( url, "GET", saveSchedule, params)
        print("downloading schedule!")

        -- TRANSPORTS --------------------------------------------------------------
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
end

-- ------------------------------------------------------------------------------------------ --
-- LOG IN
-- ------------------------------------------------------------------------------------------ --

-- AUTH
-- Finish Auth
local finishAuth = function( event )
    -- print("------ login response ------")
    -- print(event.response)

    if event.response == nil then
        local alert = native.showAlert(
            "",
            "There seems to be some connection problem. Enable Internet in your phone settings and restart the app, please!",
            { "OK", "" },
            networkError
            )

        print("- - - - - - - going to register 2")
        appData.composer.removeScene( "controller.IntroController" )
        appData.composer.gotoScene( "controller.WelcomeController" )
    else
        local data = appData.json.decode(event.response)

        if data == nil then
            local alert = native.showAlert(
                "",
                "There seems to be some connection problem. Enable Internet in your phone settings and restart the app, please!",
                { "OK", "" },
                networkError
                )

            print("- - - - - - - going to register 3")
            appData.composer.removeScene( "controller.IntroController" )
            appData.composer.gotoScene( "controller.WelcomeController" )
        else
            -- store tokens
            appData.session.accessToken = data.token.accessToken
            appData.session.refreshToken = data.token.refreshToken

            -- set commuting addresses every time the user starts the app just to be sure
            -- setAddresses()

            -- download all the data from server
            downloadData()
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

    -- print("logging user!")
end

-- ------------------------------------------------------------------------------------------ --
-- REFRESH TOKEN
-- ------------------------------------------------------------------------------------------ --

-- Refresh Token
tokenRefreshed = function(event)
    local data = appData.json.decode(event.response)

    if data ~= nil then
        if data.token.accessToken ~= nil then

            -- store access token
            appData.session.accessToken = data.token.accessToken

            -- download all the data from server
            downloadData()
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

    -- set all the flags to false
    local userRegistered = false
    local carRegistered = false
    local addressesRegistered = false
    local tokenFound = false
    local userFound = false
    appData.appIsRunning = true

    -- check whether refresh token is stored
    if (tokenFound == false) then
        tokenFound = model.openRefreshToken()
    end

    -- check whether user data is stored
    if (userFound == false) then
        userFound = model.openUser()
    end

    -- if not data is stored, let user to register/login
    if (tokenFound ~= false) then
        refreshToken()
        t1 = timer.performWithDelay( 1000, goFurther, -1 )
    elseif (userFound ~= false) then
        autoLoginUser()
        t1 = timer.performWithDelay( 1000, goFurther, -1 )
    else
        print("- - - - - - - - - - going to register 1")
        composer.removeScene("controller.IntroController")
        appData.composer.gotoScene( "controller.WelcomeController" )
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
    result, reason = os.remove( system.pathForFile( "driverinfomap.html", destDir ) )
    result, reason = os.remove( system.pathForFile( "passengermap.html", destDir ) )

    if result then
       -- print( "File removed" )
    else
       -- print( "File does not exist", reason )  --> File does not exist    apple.txt: No such file or directory
    end

    appData.firebaseToken = model.openFirebaseToken()
    print("FB Token Found ==========")
    print(appData.firebaseToken)

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
