local sceneName = DatesController

-- Include
local view = require("view.TransportDetailsView")
local model = require("model.TransportDetailsModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )
local routines = require( "misc.appRoutines" )

-- -----------------------------------------------------------------------------------
-- Scene Variables
-- -----------------------------------------------------------------------------------
local i 

-- -----------------------------------------------------------------------------------
-- Scene Functions
-- -----------------------------------------------------------------------------------

local onKeyEvent = function( event )
    if ( event.keyName == "back" ) then
        appData.transportDetails = 0
        appData.appIsRunning = true
        appData.composer.hideOverlay()
        return true
    end  
end  

local hideTransportDetails = function(event)
    appData.showingMap = true
    appData.transportDetails = 0
    appData.appIsRunning = true
    appData.composer.hideOverlay()
end

-- TRANSPORTS ============================================================

-- Finish Downloading  Transports
saveTransports = function(event)
    print("downloading and saving transports! -----------------------------------") 
    appData.transports = appData.json.decode(event.response) -- [2] load transports from server
    appData.refreshTable = true
    appData.showingMap = true
    appData.transportDetails = 0
    appData.appIsRunning = true
    appData.composer.hideOverlay()
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

    -- get transport id
    local transport_id = view.transport_id

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

-- -----------------------------------------------------------------------------------
-- Scene components
-- -----------------------------------------------------------------------------------
local scene = composer.newScene()

-- create()
function scene:create( event )
    
    print("TRANSPORT DETAILS CREATED")
    -- print(appData.composer.getVariable("i"))

    i = appData.composer.getVariable("i")
    view.sceneGroup = self.view
    view.showBackground()

    if appData.transports[i].matches[1] == nil then
        view.showFooter(false)     
    else
        view.showFooter(true)
    end 
 
    view.showDetails(appData.composer.getVariable("i"))
    view.showMap(i)
end
 
-- show()
function scene:show( event )

    print("TRANSPORT DETAILS SHOW")
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 

    elseif ( phase == "did" ) then
        view.backButton:addEventListener( "tap", hideTransportDetails )
        view.deleteButton:addEventListener( "tap", cancelTransport )
    end
end
 
-- hide()
function scene:hide( event )

    print("TRANSPORT DETAILS HIDE")
 
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

    print("TRANSPORT DETAILS DESTROY")
 
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
Runtime:addEventListener( "key", onKeyEvent )
-- -----------------------------------------------------------------------------------
 
return scene