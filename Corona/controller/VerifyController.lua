local sceneName = RegisterController

-- Include
local view = require("view.VerifyView")
local model = require("model.VerifyModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )


-- New Variables
-- 



-- verify field
local verifyFieldListener = function(event)
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- appData.user.email = event.target.text
        -- appData.user.username = event.target.text
    end
end

--Alert Listener
local function onAlertComplete( event )
    if ( event.action == "clicked" ) then
        local i = event.index
        if ( i == 1 ) then
            -- Go to back phone screen
            composer.removeScene("controller.VerifyController") 
            composer.gotoScene("controller.PhoneController")

        elseif ( i == 2 ) then
            -- Do nothing
        end
    end
end


-- finishAuth
local phoneVerified = function( event )
    print("-------- P H O N E V E R I F I E D -------")
    print(event.response)

    local result = appData.json.decode(event.response)

    if result.success == true then

        -- verify field
        if view.verificationField ~= nil then
          display.remove( view.verificationField )
          view.verificationField = nil
        end

        -- go to next scene
        composer.removeScene("controller.VerifyController") 
        composer.gotoScene("controller.PlacesController")

    else 
        local alert = native.showAlert( "", "That was not the right PIN. Try again, please.", { "OK", "" }, onAlertComplete )        
    end    
end

-- update user
local verifyPhone = function( event )
    if ( event.phase == "ended" ) then

        --prepare data
        local url = "https://api.sammevei.no/api/1/users/current/mobiles/verify" 

        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        headers["Authorization"] = "Bearer "..appData.session.accessToken
          
        local params = {}
        params.headers = headers
        params.body = 
            'country='..
            utils.urlEncode(appData.user.country)..
            '&'..
            'number='..
            utils.urlEncode(appData.user.phoneNumber)..
            '&'..
            'code='..
            utils.urlEncode(view.verificationField.text)

        -- send request
        network.request( url, "PUT", phoneVerified, params)
    end    
end
-- -----------------------------------------------------------------------------------
-- Scene components
-- -----------------------------------------------------------------------------------
local scene = composer.newScene()

-- create()
function scene:create( event )
    appData.restart = false
 
    view.sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Show background
    view.showBackground()

    -- Show Fields
    view.showFields()

    -- Register Button
    view.showVerifyButton()

    -- Add Listeners
    view.verificationField:addEventListener( "userInput", verifyFieldListener )
    view.verifyButton:addEventListener( "touch", verifyPhone )

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
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

    if view.verificationField ~= nil then
      display.remove( view.verificationField )
      view.verificationField = nil
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