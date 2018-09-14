local sceneName = MainController

-- Include
local view = require("view.PlacesView")
local model = require("model.PlacesModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )

-- Create Journey and Ride objects
-- model.createJourney()

-- Google Places
local places
local rows = {}

-- Close Alert
local onAlert = function(event)
end

-- finish setting addreses
local addressesSet = function(event)
  -- abandoned
end

-- set home address
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

    local id = appData.json.decode(event.response)
    id = id.id

    -- update home address
    model.updateAdressID("from", id)

    -- save home address
    model.saveAddresses() 

    -- set addresses
    timer.performWithDelay(1000, setAddresses, 1)  
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
        timer.performWithDelay(1000, setAddresses, 1) 
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

-- Forward
local nextPress= function(event)

    if appData.addresses.home.location ~= "" 
    and appData.addresses.work.location ~= "" 
    then
        if ( event.phase == "began" ) then
            event.target = 0.5
            uploadHomeAddress()
            uploadWorkAddress()

            if view.departureField ~= nil then
              display.remove( view.departureField )
              view.departureField = nil
            end

            if view.destinationField ~= nil then
              display.remove( view.destinationField )
              view.destinationField = nil
            end

            composer.removeScene( "controller.PlacesController", appData.transitionLeftOptions )
            composer.gotoScene( "controller.DatesController", appData.transitionLeftOptions )

        elseif ( event.phase == "ended" ) then
            event.target.alpha = 1
        end
    else
        local alert = native.showAlert( "ERROR!", "Pick home and work addresses, please.", { "OK", "" }, onAlert )    
    end 
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
    -- view.destinationField.x = 3000

    if places[1] ~= nil then
        view.showDepartureSearchResults(places)

        -- Add touch listener to table view rows
        for i = 1, 5 do
            rows[i] = view.departureSearchResults:getRowAtIndex( i )
            rows[i]:addEventListener( "tap", departureGeoSearch )
        end

        -- view.departureField.x = 3000
    else
        -- departureSearchEnd()
    end    
end

local departureSearch = function(place)
    print("departureSearch")

    local requestString = 
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
        .."key="..appData.googlePlaces.APIkey        
        .."&input="..place
        .."&location=59.9419591,10.7169925.7"
        .."&radius=90000"
        .."&language=NO" 
        .."&components=country:no"

    network.request( requestString, "GET", departureSearchAutocomplete )
end

local departureFieldListener = function(event)
    if ( event.phase == "began" ) then
        clicked = false
        view.departureField.text = ""
    elseif ( event.phase == "editing" ) then
        print("- - - - - - - -departureFieldListener")
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
        print("- - - - - - - - - - - destination search")
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        timer.performWithDelay( 300, handleDestinationKeyboard, 1 )  
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

    view.showJourneyMenu()
    view.showTitle()
    view.showCircle()
    view.showButtons()

    -- Add listeners to objects located in the view
    view.departureField:addEventListener( "userInput", departureFieldListener )
    view.destinationField:addEventListener( "userInput", destinationFieldListener )
    view.nextButton:addEventListener( "touch", nextPress )
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
       transition.to(view.departureField, 
            {transition=easing.outSine, delay = 350, time = 350, alpha = 1}) 

       transition.to(view.destinationField, 
            {transition=easing.outSine, delay = 350, time = 350, alpha = 1}) 

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
    if view.departureField ~= nil then
      display.remove( view.departureField )
      view.departureField = nil
    end

    if view.destinationField ~= nil then
      display.remove( view.destinationField )
      view.destinationField = nil
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